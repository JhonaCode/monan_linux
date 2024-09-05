# make.sh

make clean CORE=atmosphere \
make -j 4 gfortran CORE=atmosphere OPENMP=true USE_PIO2=false PRECISION=single 2>&1 | tee make.output

mkdir -p ${MONAN_SRC_DIR}/bin \
mv ${MONAN_SRC_DIR}/atmosphere_model ${MONAN_SRC_DIR}/bin/ \
mv ${MONAN_SRC_DIR}/build_tables ${MONAN_SRC_DIR}/bin/ \
make clean CORE=atmosphere \
cp -f ${MONAN_SRC_DIR}/bin/atmosphere_model      ${MONAN_EXE_DIR}/exec/ \
cp -f ${MONAN_SRC_DIR}/bin/build_tables          ${MONAN_EXE_DIR}/exec/ 

make clean CORE=init_atmosphere \
make -j 4 gfortran CORE=init_atmosphere OPENMP=true USE_PIO2=false PRECISION=single 2>&1 | tee make.output \

mv ${MONAN_SRC_DIR}/init_atmosphere_model ${MONAN_SRC_DIR}/bin/ \
make clean CORE=init_atmosphere

# Makefile

gfortran:   # BUILDTARGET GNU Fortran, C, and C++ compilers \
	( $(MAKE) all \ \
	"FC_PARALLEL = mpif90" \ \
	"CC_PARALLEL = mpicc" \ \
	"CXX_PARALLEL = mpicxx" \ \
	"FC_SERIAL = gfortran" \ \
	"CC_SERIAL = gcc" \ \
	"CXX_SERIAL = g++" \ \
	"FFLAGS_PROMOTION = -fdefault-real-8 -fdefault-double-8" \ \
	"FFLAGS_OPT = -O3 -ffree-line-length-none -fconvert=big-endian -ffree-form" \ \
	"CFLAGS_OPT = -O3" \ \
	"CXXFLAGS_OPT = -O3" \ \
	"LDFLAGS_OPT = -O3" \ \
	"FFLAGS_DEBUG = -g -ffree-line-length-none -fconvert=big-endian -ffree-form -fcheck=all -fbacktrace -ffpe-trap=invalid,zero,overflow" \ \
	"CFLAGS_DEBUG = -g" \ \
	"CXXFLAGS_DEBUG = -g" \ \
	"LDFLAGS_DEBUG = -g" \ \
	"FFLAGS_OMP = -fopenmp" \ \
	"CFLAGS_OMP = -fopenmp" \ \
	"FFLAGS_ACC =" \ \
	"CFLAGS_ACC =" \  \
	"PICFLAG = -fPIC" \ \
	"BUILD_TARGET = $(@)" \ \
	"CORE = $(CORE)" \ \
	"DEBUG = $(DEBUG)" \ \
	"USE_PAPI = $(USE_PAPI)" \ \
	"OPENMP = $(OPENMP)" \ \
	"OPENACC = $(OPENACC)" \ \
	"CPPFLAGS = $(MODEL_FORMULATION) -D_MPI" )
