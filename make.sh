#!/bin/sh

# concatenate every prg file into one new prg
cat prg/globals.prg prg/functions.prg prg/functions-debug.prg prg/scroll.prg > tilescroll.prg

# build the test program
cd 'test/'
bgdc 'test.prg'
#bgdi 'test.dcb'
