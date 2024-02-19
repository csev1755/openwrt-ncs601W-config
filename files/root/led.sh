#!/bin/sh

while :
do
        cat /sys/class/gpio/gpio7/value > /sys/class/gpio/gpio8/value
        sleep 1
done