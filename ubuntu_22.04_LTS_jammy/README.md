# Hardening script

## Run

Copy the whole content to the target system and execute the script with sudo.

`$ sh hardening_ubuntu_server_22_04_LTS.sh`

## Distro details

**Distributor ID:** Ubuntu

**Description:** Ubuntu 22.04.3 LTS

**Release:** 22.04

**Codename:** jammy

## Audit

Audited with [lynis](https://github.com/CISOfy/lynis.git) over a clean install and directories `/var` and `/home` and `/tmp` at diferent partitions. 

**Score before:** 64

**Score after:** 84

## Notes:

- Before runing this script, we recomend to read it and understand it in order to know what are you doing.
- Script based/inspired on Jesús Amorós from the course content [Hardening en Sistemas Linux](https://academiadehackers.es) and [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks).

