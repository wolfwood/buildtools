# --- Fetch and extract each package ---

setphase "FETCH BINUTILS"
wget $WFLAGS http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2
tar -xf binutils-${BINUTILS_VER}.tar.bz2

setphase "FETCH GCC"
wget $WFLAGS http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz
tar -xf gcc-${GCC_VER}.tar.gz

setphase "FETCH GMP"

wget $WFLAGS ftp://ftp.gmplib.org/pub/gmp-${GMP_VER}/gmp-${GMP_VER}.tar.bz2
tar -xf gmp-${GMP_VER}.tar.bz2

setphase "FETCH MPFR"
wget $WFLAGS http://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.gz
tar -xf mpfr-${MPFR_VER}.tar.gz

setphase "FETCH MPC"
wget $WFLAGS http://www.multiprecision.org/mpc/download/mpc-${MPC_VER}.tar.gz
tar -xf mpc-${MPC_VER}.tar.gz

setphase "FETCH NEWLIB"
wget $WFLAGS  ftp://sourceware.org/pub/newlib/newlib-${NEWLIB_VER}.tar.gz
tar -xf newlib-${NEWLIB_VER}.tar.gz

if [ $EXTRAS -eq 1 ]; then
setphase "FETCH PPL"
wget $WFLAGS ftp://ftp.cs.unipr.it/pub/ppl/releases/${PPL_VER}/ppl-${PPL_VER}.tar.bz2
tar -xf ppl-${PPL_VER}.tar.bz2

setphase "FETCH CLooG"
wget $WFLAGS http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-${CLOOG_VER}.tar.gz -O cloog-${CLOOG_VER}.tar.gz
tar -xf cloog-${CLOOG_VER}.tar.gz
fi

setphase "FETCH AUTOCONF"
wget $WFLAGS ftp://ftp.gnu.org/gnu/autoconf/autoconf-${AUTOCONF_VER}.tar.gz -O autoconf-${AUTOCONF_VER}.tar.gz
tar -xf autoconf-${AUTOCONF_VER}.tar.gz

setphase "FETCH AUTOMAKE"
wget $WFLAGS ftp://ftp.gnu.org/gnu/automake/automake-${AUTOMAKE_VER}.tar.gz -O automake-${AUTOMAKE_VER}.tar.gz
tar -xf automake-${AUTOMAKE_VER}.tar.gz


# --- Patch and push new code into each package ---

# Fix patches with osname
#PERLCMD="s/{{OSNAME}}/${OSNAME}/g"
#perl -pi -e $PERLCMD *.patch
#perl -pi -e $PERLCMD gcc-files/gcc/config/os.h

# diff -rupN


#doPatch binutils
setphase "PATCH BINUTILS"
patch -p1 -d binutils-${BINUTILS_VER} < ../patches/binutils.patch
cp ../binutils-files/ld/emulparams/os_x86_64.sh binutils-${BINUTILS_VER}/ld/emulparams/${OSNAME}_x86_64.sh

setphase "PATCH GMP"
patch -p1 -d gmp-${GMP_VER} < ../patches/gmp.patch || exit

doPatch mpfr
doPatch mpc
if [ $EXTRAS -eq 1 ]; then
doPatch ppl
doPatch cloog
fi

doPatch gcc
cp ../gcc-files/gcc/config/os.h gcc-${GCC_VER}/gcc/config/${OSNAME}.h

doPatch newlib
mkdir -p newlib-${NEWLIB_VER}/newlib/libc/sys/${OSNAME}
cp -r ../newlib-files/* newlib-${NEWLIB_VER}/newlib/libc/sys/${OSNAME}/.
cp ../newlib-files/vanilla-syscalls.c newlib-${NEWLIB_VER}/newlib/libc/sys/${OSNAME}/syscalls.c
