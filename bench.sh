#!/bin/bash

# Usage:
# bench.sh <bm|vm> <up|smp>

N_TESTS=100
N_CYCLES=1000000
TARGET=$1
MODE=$2

if [ $TARGET == bm ]
then
  for i in `seq 1 $N_TESTS`
  do
    { time ./weird $N_CYCLES $MODE ; } 2>&1 | awk '/^real/ {print $2}' | perl -p -e 's/^.*m([0-9.]+)s.*$/\1/'
  done
else
  [[ $TARGET == vm ]] && vagrant ssh -c "for i in {1..$N_TESTS}; do { time /vagrant/weird $N_CYCLES $MODE ; } 2>&1 | awk '/^real/ {print \$2}' | perl -p -e 's/^.*m([0-9.]+)s.*$/\1/'; done" 2> /dev/null
fi \
  | R -q -e 'd<-scan("stdin", quiet=TRUE); cat(sprintf("%f, %f / %f, %f\n", signif(min(d),2), signif(mean(d),2), signif(sd(d),2), signif(max(d),2)))' \
  | perl -p -e 's/^>.*\n$//' | perl -p -e 's/0+([^\d.])/\1/g'
