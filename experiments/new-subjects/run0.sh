#!/bin/bash

WINMUT_LOG_DIR='winmut-log-dir'
if [ -z ${WINMUT_BASE_DIR+x} ]; then
	WINMUT_BASE_DIR="$(pwd)/../../cmake-build-release/"
fi

load_config() {
	if [ ! -f "../config.sh" ]; then
		echo "Config file not found for subject \"${SUBJECT}\""
		helpmsg
	fi
	source "../config.sh"

	# custom settings:
	# BUILD_COMMAND
	# RUN_COMMAND
	# CFLAGS: extra CFLAGS

	if [ -z "${BUILD_COMMAND}" ]; then
		BUILD_COMMAND="make distclean; ./configure; make clean; make all -j 1"
	fi
	if [ -z "${RUN_COMMAND}" ]; then
		RUN_COMMAND="make check"
	fi
}

build() {
	export CC="${WINMUT_BASE_DIR}/bin/clang ${CFLAGS}"
	export CXX="${WINMUT_BASE_DIR}/bin/clang++"
	export LD_PRELOAD="${WINMUT_BASE_DIR}/lib/libLLVMWinMutRuntime.so"
	export WINMUT_DISABLED=YES

	load_config

	bash -c "${BUILD_COMMAND}"
}

run() {
	export CC="${WINMUT_BASE_DIR}/bin/clang ${CFLAGS} -g0"
	export CXX="${WINMUT_BASE_DIR}/bin/clang++"
	ulimit -s 102400
	export LD_PRELOAD="${WINMUT_BASE_DIR}/lib/libLLVMWinMutRuntime.so"

	load_config

	rm ${WINMUT_LOG_DIR} -rf
	mkdir ${WINMUT_LOG_DIR}
	export WINMUT_LOG_FILE_PREFIX="$(pwd)/${WINMUT_LOG_DIR}"

	if [ "${ALGO}" = "timing" ]; then
		echo "Time limit is ${TIMELIMIT}"
		timeout ${TIMELIMIT} bash -c "${RUN_COMMAND}"
	else
		echo "At most execute ${WINMUT_MAX_RUN_CASES} test cases"
		export WINMUT_MAX_RUN_CASES
		bash -c "${RUN_COMMAND}"
	fi
}

collect-result() {
	CURR_TIME=`date +%Y-%m-%d-%H-%M-%S`
	BASEDIR="../../result/${SUBJECT}"
	if [ ! -d ${BASEDIR} ]; then
		mkdir -p "${BASEDIR}"
	fi
	cp -r ${WINMUT_LOG_DIR} "${BASEDIR}/${ALGO}-${CURR_TIME}"
}

helpmsg() {
	echo "${FILENAME} subject-name <build/run> <WinMut/WinMutNo/AccMut/AccMutNo/timing/validate> [time-limit/process-limit]"
	exit -1
}

FILENAME="${0}"
SUBJECT="${1}"
TASK="${2}"
ALGO="${3}"

if [ $# -gt 3 ]; then
	TIMELIMIT=${4}
	WINMUT_MAX_RUN_CASES=${4}
else
	TIMELIMIT="1000000s"
	WINMUT_MAX_RUN_CASES=10000000
fi

if [ $# -gt 4 ]; then
	MAX_BB_SIZE=${5}
	export CFLAGS="-mut-maxBBSize=$MAX_BB_SIZE ${CFLAGS}"
fi

case ${ALGO} in
	AccMut)
		export CFLAGS="-accmut  ${CFLAGS}"
		;;
	AccMutNo)
		export CFLAGS="-O2 -accmut -winmut-no-opt  ${CFLAGS}"
		;;
	WinMut)
		export CFLAGS="-winmut  ${CFLAGS}"
		;;
	WinMutNo)
		export CFLAGS="-winmut -winmut-no-opt  ${CFLAGS}"
		;;
	validate)
		export WINMUT_MEASURE_COUNT=2
		export CFLAGS="-winmut-runtime  ${CFLAGS}"
		;;
	timing)
		export CFLAGS="-winmut-time  ${CFLAGS}"
		;;
	*)
		helpmsg
		;;
esac
cd ${SUBJECT}/${ALGO}
case ${TASK} in
	run)
		run
		collect-result
		;;
	build)
		build
		;;
	collect-result)
		collect-result
		;;
	*)
		helpmsg
		;;
esac




