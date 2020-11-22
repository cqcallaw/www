#!/usr/bin/env python3
"""
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.
This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

This Python script signs all files in a directory in parallel, utilizing all available CPU threads.

Naive use of the multiprocessing module won't work; see https://lists.gnupg.org/pipermail/gnupg-users/2020-November/064346.html
"""

import os
import fnmatch
import subprocess
import multiprocessing
import distutils.dir_util
import shutil
import stat
import argparse


def get_fileset(path: str):
    for root, _, files in os.walk(os.path.expanduser(path)):
        for item in fnmatch.filter(files, "*"):
            path = os.path.join(root, item)
            yield path


def create_worker_dirs(working_dir: str, pool_size: int):
    for i in range(1, pool_size + 1):
        dest = os.path.join(working_dir, "ForkPoolWorker-" + str(i))
        print("Generating worker dir", dest)
        os.makedirs(dest, exist_ok=True)
        for f in ['pubring.gpg', 'trustdb.gpg', 'gpg.conf', 'gpa.conf']:
            shutil.copyfile(
                os.path.join(pg_src, f),
                os.path.join(dest, f)
            )
        os.symlink(
            os.path.join(pg_src, 'private-keys-v1.d'),
            os.path.join(dest, 'private-keys-v1.d')
        )

        # fix permissions
        for r, _, f in os.walk(dest):
            os.chmod(r, stat.S_IREAD | stat.S_IWRITE | stat.S_IEXEC)


def sign_file(path: str, working_dir: str):
    worker = multiprocessing.current_process().name
    print(worker, "signing", path)
    worker_working_dir = os.path.join(working_dir, worker)
    r = subprocess.run(['gpg', '--homedir', worker_working_dir,
                        '--quiet', '--batch', '--yes', '--detach-sig', path])
    if r.returncode != 0:
        print("Error signing file", path)
        print(r.stderr)
        return False

    return True


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("dir", help="The directory to sign.", type=str)
    parser.add_argument(
        "pool_size", nargs='?', help="The number of workers to launch. Defaults to the number of available CPU threads.", type=int, default=-1)
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    files = get_fileset(args.dir)
    pool_size = args.pool_size if args.pool_size != -1 else multiprocessing.cpu_count()

    pg_src = os.path.expanduser('~/.gnupg')
    working_dir = os.path.join(os.path.dirname(
        os.path.realpath(__file__)), 'gnupg-tmp')
    os.makedirs(working_dir, exist_ok=True)
    create_worker_dirs(working_dir, pool_size)

    with multiprocessing.Pool(processes=pool_size) as pool:
        results = [pool.apply_async(
            sign_file, (file, working_dir)) for file in files]
        if all([result.get(timeout=10) for result in results]):
            print("Signing completed successfully.")
        else:
            print("Signing error!")

    shutil.rmtree(working_dir)
