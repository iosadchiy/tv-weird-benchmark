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
time ./weird 1     # UP
time ./weird 2     # SMP
```

Run the test in the VM:

```
time vagrant ssh -c "/vagrant/weird 1"
time vagrant ssh -c "/vagrant/weird 2"
```

You can assess the distribution of execution time of `vagrant ssh` by running `vagrant ssh ""` and calculating mean/stddev
