#!/bin/bash

# script to compile legacy version of intel-compute-runtime for Fedora 42.

set -e

TAG=24.35.30872.36
cores=$(cat /proc/cpuinfo | grep processor | wc -l)
# cores=16

# Check out the giut repo
rm -rf compute-runtime || true

git clone https://github.com/intel/compute-runtime.git
cd compute-runtime
git checkout "$TAG"

# GCC fixes
sed -i -e '/-Werror/d' CMakeLists.txt
sed -i -e '1i #include <cstdint>' \
    shared/generate_cpp_array/source/generate_cpp_array.cpp \
    shared/source/os_interface/linux/local/dg1/drm_tip_helper.cpp

sed -i -e '/#pragma once/a #include <cstdint>' \
    shared/offline_compiler/source/decoder/iga_wrapper.h \
    shared/offline_compiler/source/ocloc_arg_helper.h \
    shared/source/debugger/debugger.h \
    shared/source/gmm_helper/gmm_helper.h \
    shared/source/os_interface/device_factory.h \
    shared/source/os_interface/os_memory.h \
    shared/source/os_interface/os_time.h \
    shared/source/program/program_info.h \
    shared/source/utilities/software_tags.h


# Build the application
mkdir -p build
cd build

cmake .. -DSKIP_UNIT_TESTS=TRUE -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON 
make -j ${cores}


# Generate installable files
cd ../..
mkdir -p installable
cd installable
cp ../compute-runtime/build/bin/libigdrcl.so ./
echo "/usr/local/lib64/intel-opencl-legacy/libigdrcl.so" > intel-legacy.icd

cat > install.sh << EOF
#!/bin/bash

# Script to install legacy version of intel-opencl into Fedora 42 system

set -e

install -m 0755 -d /etc/OpenCL
install -m 0755 -d /etc/OpenCL/vendors
install -m 0644 intel-legacy.icd /etc/OpenCL/vendors/

install -m 0755 -d /usr/local/lib64/intel-opencl-legacy/
install -m 0755 libigdrcl.so /usr/local/lib64/intel-opencl-legacy/

EOF
chmod +x install.sh

cat > uninstall.sh << EOF
#!/bin/bash

# Script to remove legacy version of intel-opencl from Fedora 42 system

set -e

rm /etc/OpenCL/vendors/intel-legacy.icd
rm -rf /usr/local/lib64/intel-opencl-legacy

EOF
chmod +x uninstall.sh

tar -czvf ../intel-opencl-legacy_${TAG}-fedora42.tar.gz *
