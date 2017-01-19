#!/bin/sh

# build the test program
bgdc 'test.prg'

# invert output status of bgdc
if [ $? -eq 1 ]
then
  exit 0
else
  exit 1
fi
