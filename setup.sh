#!/bin/bash

## You need to modify this as per your system, 
## This should be the interface of your system connecting 
## to internet. 
DEFAULT_IFC=enp0s1 


# These are the configuration files that you may modify
IP4_SUBNET=192.168
IP4_PREFIX_SIZE=24 # Size of assigned prefixes
IP4_FULL_PREFIX_SIZE=16 # Size of IP4_SUBNET



# Don't modify below this line
NEEDED_TOOLS="ip ping iptables top debootstrap sha256sum"
IMAGEDIR="$(dirname "$0")/.images"
CONTAINERDIR="$(dirname "$0")/.containers"
CACHEDIR="$(dirname "$0")/.cache"
SETUP_SCRIPT="$(dirname "$0")/conductor.sh"
IP4_PREFIX=
PORT=
INNER_PORT=
OUTER_PORT=
INTERNET=0
EXPOSE=0

declare -A BASE_MIRRORS=(
    [debian]="https://deb.debian.org/debian"
    [ubuntu]="http://de.archive.ubuntu.com/ubuntu"
)

declare -A BASE_SUITES=(
    [debian:bookworm]="bookworm"
    [ubuntu:focal]="focal"
    [ubuntu:jammy]="jammy"
)


EXTRADIR="$(dirname "$0")/extras"

