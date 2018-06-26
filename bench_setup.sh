#!/bin/bash
# Disable all but 2 cores
# Make sure those left are not the same physical core. It's system-specific
sudo bash -c 'for i in {2..7}; do echo 0 > /sys/devices/system/cpu/cpu$i/online; done'
