#!/usr/bin/env bash

# Update sources
sudo apt update

# Upgrade software
sudo apt upgrade -y

# Install needed software
for pkgname in "$@"; do
  case "$pkgname" in
    "7z") sudo apt install p7zip -y ;;
    "git") sudo apt install git -y ;;
    "wget") sudo apt install wget -y ;;
    "gcc") sudo apt install gcc -y ;;
    "g++") sudo apt install g++ -y ;;
    "libc") sudo apt install libc6 -y ;;
    "libstdc++") sudo apt install libstdc++6 -y ;;
    "binutils") sudo apt install binutils -y ;;
    "make") sudo apt install make -y ;;
  esac
done
