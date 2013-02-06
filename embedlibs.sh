#!/bin/sh

mkdir -p .tempobjs
cd .tempobjs

ar x ../../xomb/user/c/lib/cbindings.a
cp ../local/x86_64-pc-xomb/lib/libc.a ../local/x86_64-pc-xomb/lib/libc-base.a
ar d ../local/x86_64-pc-xomb/lib/libc-base.a crt0.o
ar -rs ../local/x86_64-pc-xomb/lib/libc-base.a *.o

ar x ../../xomb/runtimes/mindrt/drt0.a
ar x ../../xomb/runtimes/mindrt/mindrt.a
ar -rs ../local/x86_64-pc-xomb/lib/libc.a *.o

cd ..
rm -r .tempobjs
