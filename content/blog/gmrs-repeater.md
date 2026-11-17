---
title: "The Little Repeater That Couldn't, Or, Terrain's Triumph"
date: 2026-11-16T17:16:12-08:00
draft: false
author: "Caleb Callaway"
---

Without height advantage, a GRMS repeater does not meaningfully increase the range of handhelds in rolling foothill terrain. My signal has been stopped; sorry, Mr. Universe.

## The Gear

- Retevis RT-97S
- Retevis MA09 antenna ~40 ft. above ground
- Tuned XLT duplexer
- CTCSS tone code
- Narrowband
- KMR400 coax
- Neasured SWR of 1.01

improved effective HT range from ~1.25 miles to ~1.5 miles. Desired range was ~5 miles.

### Antenna

An Italian cypress is an excellent make-shift antenna mast. An arborealist's slingshot wasn't accurate enough; fishing line attached to a drone worked well. Sturdy, UV-resistant Dacron for the final line.

### Duplexer

The stock duplexer is fairly small and hadn't been tuned to my chosen frequency pair. The duplexer is reportedly the cause of the delta between the repeater's nominal 10W output and the measured 6.56W. The tuned XLT replacement increased output to ~7.78W.

### Tone Code

DCS has to decode a full bit pattern and drops out faster, while CTCSS just needs a tone above threshold.

### Narrowband

A 12.5 kHz receiver passband admits half the noise power of a 25 kHz one, so for the same audio quality you need about six DB less signal at the antenna.

## Signal Lost

My confidence in pursuing this project came from the Scadacore [RF line-of-sight tool](https://www.scadacore.com/tools/rf-path/rf-line-of-sight/) indicated the path to my desired destination was un-obstructed and my ability to hit far more distant repeaters. I've since concluded that the line-of-sight tool isn't very accurate and those other repeaters have a substantial height advantage.

Terrain: still undefeated.

### Also: BMS Good

An AI says: "over-discharging a sealed lead acid battery can lead to irreversible damage, making it unrecoverable. It's important to avoid draining the battery fully and to recharge it regularly to maintain its lifespan."

Can confirm. I repurposed a pair of 12V sealed lead acid gate opener batteries; those batteries are now dead. They were connected directly to the repeater with no battery management or over-discharge protection. Lesson learned.

