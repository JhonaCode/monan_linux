# make.sh

make clean CORE=atmosphere \
make -j 4 intel-mpi CORE=atmosphere OPENMP=true USE_PIO2=false PRECISION=single 2>&1 | tee make.output 

mkdir -p ${MONAN_SRC_DIR}/bin \
mv ${MONAN_SRC_DIR}/atmosphere_model ${MONAN_SRC_DIR}/bin/ \
mv ${MONAN_SRC_DIR}/build_tables     ${MONAN_SRC_DIR}/bin/ \
make clean CORE=atmosphere \
cp -f ${MONAN_SRC_DIR}/bin/atmosphere_model      ${MONAN_EXE_DIR}/exec/ \
cp -f ${MONAN_SRC_DIR}/bin/build_tables          ${MONAN_EXE_DIR}/exec/ 

make clean CORE=init_atmosphere \
make -j 4 intel-mpi CORE=init_atmosphere OPENMP=true USE_PIO2=false PRECISION=single 2>&1 | tee make.output 

mv ${MONAN_SRC_DIR}/init_atmosphere_model ${MONAN_SRC_DIR}/bin/ \
make clean CORE=init_atmosphere


# Makefile

intel-mpi:   # BUILDTARGET Intel compiler suite with Intel MPI library \
	( $(MAKE) all \ \
	"FC_PARALLEL = mpiifort -f90=ifx" \ \
	"CC_PARALLEL = mpiicc -cc=icx" \ \
	"CXX_PARALLEL = mpiicpc -cxx=icpx" \ \
	"FC_SERIAL = ifx" \ \
	"CC_SERIAL = icx" \ \
	"CXX_SERIAL = icpx" \ \
	"FFLAGS_PROMOTION = -real-size 64" \ \
	"FFLAGS_OPT = -O3 -convert big_endian -free -align array64byte" \ \
	"CFLAGS_OPT = -O3" \ \
	"CXXFLAGS_OPT = -O3" \ \
	"LDFLAGS_OPT = -O3" \ \
	"FFLAGS_DEBUG = -g -convert big_endian -free -CU -CB -check all -fpe0 -traceback" \ \
	"CFLAGS_DEBUG = -g -traceback" \ \
	"CXXFLAGS_DEBUG = -g -traceback" \ \
	"LDFLAGS_DEBUG = -g -fpe0 -traceback" \ \
	"FFLAGS_OMP = -qopenmp" \ \
	"CFLAGS_OMP = -qopenmp" \ \
	"PICFLAG = -fpic" \ \
	"BUILD_TARGET = $(@)" \ \
	"CORE = $(CORE)" \ \
	"DEBUG = $(DEBUG)" \ \
	"USE_PAPI = $(USE_PAPI)" \ \
	"OPENMP = $(OPENMP)" \ \
	"CPPFLAGS = $(MODEL_FORMULATION) -D_MPI" )
