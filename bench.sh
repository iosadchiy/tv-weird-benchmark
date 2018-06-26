#!/usr/bin/zsh

# Usage:
# bench.sh <bm|vm> <up|smp>

N_TESTS=100
N_CYCLES=1000000

for i in {1..$N_TESTS}
do
  { time ./weird $N_CYCLES up } 2>&1 | awk '{print $10}'
done \
  | R -q -e 'd<-scan("stdin", quiet=TRUE); cat(sprintf("%f, %f / %f, %f\n", signif(min(d),2), signif(mean(d),2), signif(sd(d),2), signif(max(d),2)))' \
  | perl -p -e 's/^>.*\n$//' | perl -p -e 's/0+([^\d.])/\1/g'
