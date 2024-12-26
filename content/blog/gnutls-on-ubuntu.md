---
title: "GnuTLS on Ubuntu"
author: "Caleb Callaway"
date: 2024-12-26T11:03:57-08:00
draft: false
---

[replicated from https://help.ubuntu.com/community/GnuTLS because the Ubuntu wiki service has suffered outages recently including OpenID errors from the login system. My revisions can be seen [here](https://help.ubuntu.com/community/GnuTLS?action=info)]

# Introduction

GnuTLS (http://www.gnu.org/software/gnutls/) is an LGPL-licensed implementation of Transport Layer Security, the successor to SSL. Using GnuTLS avoids the licensing issues that can arise from employing the more common OpenSSL package. For this reason, certain packages such as OpenLDAP are compiled with support for GnuTLS instead of OpenSSL in recent releases of Ubuntu.

This guide provides information on using the GnuTLS tools to generate certificates for the verification of host identity and the encryption of client/server communications. Before reading this guide, the reader should be familiar on the concepts behind SSL/TLS. The Ubuntu Server Guide has a decent explanation: https://help.ubuntu.com/9.04/serverguide/C/certificates-and-security.html.


# Preparation
The tools to generate certificates and debug connections are available in the `gnutls-bin` package. Install it with the following command:

```
$ sudo apt-get install gnutls-bin
```

More information on the gnutls toolkit can be found here: http://www.gnu.org/software/gnutls/manual/html_node/


# Key and Certificate Naming
Management of multiple keys and certificates becomes difficult without a coherent naming scheme. The following naming scheme is one possibility.

Private keys named after the servers or services, plus the domain name, plus a .key suffix. For instance, the private key for an LDAP server running on ldap.example.com would be named ldap.example.com.key.

Certificates named after the servers or services they will be used for with a `.cert` suffix. For instance, the certificate for an LDAP server running on `ldap.example.com` would be named `ldap.example.com.cert`.

Certificate Authorities can be a service, so a CA keyname would take the form `ca.example.com.key` and the certificate name would be `ca.example.com.cert`

This naming scheme is for identification purposes only: the functionality of keys and certificates remains the same, regardless of filename.


# Fully Qualified Domain Names
The Fully Qualified Domain Name to which clients connect must match the FQDN in the server certificate's `DNSname` attribute. If the FQDN of the certificate does not match the FQDN of the server to which the client is connecting, the client software should refuse to connect. This means DNS services must be available on the network, and an appropriate FQDN assigned to the server before TLS is deployed.


# Generating Private Keys
To generate a certificate, a private key is required. The private key is the secret that the server or service will use to identify itself to clients. The entire change of trust depends on the private key remaining a secret known only to the key's owner, so _access to the key must be controlled carefully_.

1. Use the GnuTLS utility `certtool` to generate the private key as indicated below. Pick a descriptive name to use in place of <keyname> (see the Naming section). Other options for private key generation exist, and are detailed in the certtool documentation.

    ```
    $ certtool --generate-privkey --bits 4096 --outfile <keyname>
    Generating a 4096 bit RSA private key...
    ```

    Generating the key can take 15-30 minutes depending on computer usage. This is not caused by lengthly, intensive computations, but rather the need for highly random numbers. If the key generation process is not satisfied with the randomness of the numbers it has generated for the key, it will continue to get more random numbers until it finds something suitably random. Create more randomness by using the computer while the key is generated.
2. Once the key is generated, lock down its file permissions:

    ```
    $ chmod 600 <keyname>
    $ chown <trusted_user> <keyname>
    ```

    This will prevent unauthorized parties from reading the private key and using it to impersonate the key's owner.

# Generating Certificates
There are three paths to acquiring the necessary keys and certificates:

* Generate a self-signed certificate. This is the easiest method, but it is not very secure or scalable.
* Get a certificate from a Certificate Authority (CA). This method is more secure and easy to deploy, but can cost money.
* Be your own CA. This method is secure and easy to scale, but requires more work initially and more long-term maintainance.
Each method has a section dedicated to it below.


## Self-Signing
To generate a self-signed certificate, create a service certificate template as described in the "Certificate Templates" and save it in a convenient location. Then, feed the generated information to certtool:

```
$ certtool --generate-self-signed --load-privkey <keyname> --template <templatename> --outfile <certificatename>
```

Replace <keyname> with the name of the private key file from the Generating a Private Key section. <templatename> is the filename of template file (see Certificate Templates section). Pick a descriptive name to use in place of <certificatename> (see Naming section).


## Using a Certificate Authority

1. Generate a private key (see the Generating a Private Key section).
2. Generate a Certificate Signing Request (CSR):

    ```
    $ certtool --generate-request --load-privkey <keyname> --outfile <csrname>
    ```

    `<keyname>` must be the name of the private key file. Pick a descriptive name to use in place of `<csrname>`. The FQDN of the server plus the extension ".csr" is recommended.
3. Send the CSR and other relevant information to the Certificate Authority for verification. The details of this process vary and are beyond the scope of this tutorial. When the CA has completed its verification process, it will digitally sign the CSR using the CA's private key and return the signed request to you.
4. Create a service certificate template as described in the "Certificate Templates" and save it in a convenient location.
5. Generate a certificate:

    ```
    $ certtool --generate-certificate --load-request <signedcsrname> \
        --load-ca-certificate <cacert> --load-ca-privkey <caprivkey>
        --template <templatename> --outfile <certificate>
    ```

    Replace `<keyname>` with the name of the private key file from the Generating a Private Key section. `<templatename>` is the filename of the server's template file (see Certificate Templates section). Using a template is optional, but very convenient, particularly if many certificates must be generated. Pick a descriptive name to use in place of `<certificatename>` (see Naming section).
6. Follow the steps in the Deploying the Certificate section to deploy the certificate.

## Being a Certificate Authority
1. Generate a private key (see Generating a Private Key) and a self-signed certificate (see Self-Signing section) for the Certificate Authority. Be sure to clearly identify the key and certificate as belonging to the Certificate Authority, not a server.
Note: Be very careful to secure the CA's private key--if it is compromised, the entire chain of trust is compromised!

2. Generate a private key for the service or server.
3. Generate a CSR (see Using a Certificate Authority section)
4. Use the CSR together with the CA's key and certificate to generate a certificate for the server:
    ```
    $ certtool --generate-certificate --load-request <csrpath> \
      --load-ca-certificate <cacertpath> --load-ca-privkey <cakeypath> \
      [--template <templatepath>] --outfile <certificatepath>
    ```
    Replace <csrpath> with the path to the CSR. <templatename> is the filename of the server's template file (see Certificate Templates section). Using a template is optional, but very convenient, particularly if many certificates must be generated. Pick a descriptive name to use in place of <certificatename> (see Naming section).

5. Follow the steps in the Deploying the Certificate section to deploy the certificate.

## Verifying the Certificate
Verify the contents of the certificate by listing its contents:

```
certtool --certificate-info --infile /path/to/certificate
```

# Certificate Templates
The properties of a certificate can be specified with a template file. The following sections contain simple certificate templates for services and certificate authorities, with some descriptive comments, mostly lifted from the certtool documentation. Optional statements are commented out by default. Be sure to replace all placeholders with the appropriate values.

A full description of the template options are available in the certtool documentation.

NOTE: the templates below are the required options as understood by this guide's author(s). DO NOT deploy certificates generated with these options without understanding their purpose and verifying their correctness.


## Service Certificates

```
# X.509 Certificate options
#
# DN options

# The organization of the subject.
organization = "Example Inc."

# The organizational unit of the subject.
#unit = "sleeping dept."

# The state of the certificate owner.
state = "Example"

# The country of the subject. Two letter code.
country = EX

# The common name of the certificate owner.
cn = "Sally Certowner"

# A user id of the certificate owner.
#uid = "scertowner"

# The serial number of the certificate. Should be incremented each time a new certificate is generated.
serial = 007

# In how many days, counting from today, this certificate will expire.
expiration_days = 365

# X.509 v3 extensions

# DNS name(s) of the server
dns_name = "server.example.com"
#dns_name = "server_alias.example.com"

# (Optional) Server IP address
#ip_address = "192.168.1.1"

# Whether this certificate will be used for a TLS server
tls_www_server

# Whether this certificate will be used to encrypt data (needed
# in TLS RSA ciphersuites). Note that it is preferred to use different
# keys for encryption and signing.
encryption_key
```

## Certificate Authority Certificates

```
# X.509 Certificate options
#
# DN options

# The organization of the subject.
organization = "Example Inc."

# The organizational unit of the subject.
#unit = "sleeping dept."

# The state of the certificate owner.
state = "Example"

# The country of the subject. Two letter code.
country = EX

# The common name of the certificate owner.
cn = "Example CA"

# The serial number of the certificate. Should be incremented each time a new certificate is generated.
serial = 007

# In how many days, counting from today, this certificate will expire.
expiration_days = 365

# Whether this is a CA certificate or not
ca

# Whether this key will be used to sign other certificates.
cert_signing_key

# Whether this key will be used to sign CRLs.
crl_signing_key
```

# Deploying the Certificates
Now that the keys and certificates are created, they must be made accessible to programs and services. The default directory for certificates is `/etc/ssl/certs/`

1. Move the certificates there and set the permissions to 755:

    ```
    $ mv *.cert /etc/ssl/certs
    $ chmod 755 /etc/ssl/certs/<certname
    ```
2. Set the owner and group to root and ssl respectively:
    ```
    $ chown root:ssl /etc/ssl/certs/<certname>
    ```

    By default, private keys are placed in `/etc/ssl/private/`. This practice can be inflexible, particularly when managing access control for multiple keys. I recommend placing private keys in the relevant subdirectory of `/etc/`. For example, a private key for LDAP would be placed in `/etc/ldap/`, and the private key for an Apache 2 Web server in `/etc/apache2/`.
3. Change the permissions on the private key so only the owner can read/write:

    ```
    $ chmod 600 <keyname>
    ```

    If the key must be accessed by another user in the same group, loosen the permissions to allow group members to read the file:

    ```
    $ chmod 640 <keyname>
    ```

    It is recommended to assign file ownership to root and set the group to the daemon user's group. For instance, a private key for Apache would belong to the www-data group since the Apache daemon is executed as a user in this group.

4. Configure services to use the key and certificate. Details of this configuration vary; consult the program documentation for more information.

## Apache Web Server
Take the following additional steps to deploy GnuTLS certificates on the Apache webserver.

1. Ensure the OpenSSL module is disabled:

    ```
    $ sudo a2dismod ssl
    ```

2. Install the GnuTLS Apache module:

    ```
    $ sudo apt-get install libapache2-mod-gnutls
    ```

3. Make sure the GnuTLS Apache module is enabled:

    ```
    $ sudo a2enmod gnutls
    ```

4. Add the following lines to the server or virtual host configuration (borrowed from the Gentoo wiki):

    ```
    GnuTLSEnable on
    GnuTLSPriorities NORMAL:!DHE-RSA:!DHE-DSS:!AES-256-CBC:%COMPAT

    GnuTLSCertificateFile /path/to/certificate
    GnuTLSKeyFile /path/to/keyfile
    ```

5. Verify there are no remaining references to mod_ssl:

    ```
    $ grep -r "mod_ssl" /etc/apache2/sites-enabled/
    ```

6. Change mod_ssl to mod_gnutls if necessary.

7. Restart apache:

    ```
    $ sudo service apache restart
    ```

## AppArmor
Various services have access controls set by AppArmor. Make sure to properly configure AppArmor to allow services to access the appropriate files.


## Client-side Deployment
For self-signed certificates, clients should have a copy of the server's self-signed certificate in their /etc/ssl/certs/ directory. For certificates signed by a Certificate Authority, use a copy of the Certificate Authority's certificate instead.


## Web Browsers
Web browsers typically maintain their own certificate store. If you are self-signing or using your own Certificate Authority, it will be necessary to import the certificate (or CA certificate) into the browser's certificate store. In Firefox, the certificate store is accessible on the Advanced tab of the Preferences dialog.


# References
* certtool documentation
* http://www.outoforder.cc/projects/apache/mod_gnutls/docs/
* http://en.gentoo-wiki.com/wiki/Apache2/SSL_and_Name_Based_Virtual_Hosts

