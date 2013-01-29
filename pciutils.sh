
source scripts/functions.sh

# --- Variables ---

source scripts/nativevars.sh

# --- idk why newlib doesn't install header files that live in sub-directories ---
cp -r newlib-files/asm local/x86_64-pc-xomb/include/

# --- Directory creation ---

mkdir -p build
mkdir -p $PREFIX
cd build

setphase "MAKE OBJECT DIRECTORIES"
mkdir -p pciutils-obj

PCIUTILS_VER=3.1.9

# --- Fetch and extract each package ---
wget $WFLAGS ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/pciutils-${PCIUTILS_VER}.tar.gz
tar -xf pciutils-${PCIUTILS_VER}.tar.gz

doPatch pciutils

# --- Compile all packages ---

setphase "COMPILE PCIUTILS"
cd pciutils-obj
cp -R ../pciutils-${PCIUTILS_VER}/* . || exit

FLAGS="ZLIB=no DNS=no SHARED=no PREFIX=$PREFIX HOST=$TARGET CROSS_COMPILE=${TARGET}-"

CMD="make -j$NCPU $FLAGS"
echo ${CMD}
${CMD} LDFLAGS="-g -T../../../xomb/app/build/elf.ld" || exit
setphase "INSTALL PCIUTILS"
make install $FLAGS LDFLAGS="${LDFLAGS}" || exit
make install-lib $FLAGS LDFLAGS="${LDFLAGS}" || exit
cd ..
