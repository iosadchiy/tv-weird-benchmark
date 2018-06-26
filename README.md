Depends on vagrant and virtualbox

Run the VM:

```
vagrant up
```

The generic/arch box 1.8.12 does not load vboxsf module, thus:

```
vagrant provision
vagrant reload
```

Compile:

```
gcc -pthread -o weird weird.c
```

Run the test on the metal:

```
time ./weird 1000000 up
time ./weird 1000000 smp
```

Run the test in the VM:

```
time vagrant ssh -c "/vagrant/weird 1000000 up"
time vagrant ssh -c "/vagrant/weird 1000000 smp"
```

You can assess the distribution of execution time of `vagrant ssh` by running `vagrant ssh ""` and calculating mean/stddev

Or use the harness (requires running VM):

```
bash bench.sh bm up && bash bench.sh vm up
```
