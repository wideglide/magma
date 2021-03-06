#!/bin/bash -e

##
# Pre-requirements:
# - $1: path to test case
# - env FUZZER: path to fuzzer work dir
# - env TARGET: path to target work dir
# - env OUT: path to directory where artifacts are stored
# - env SHARED: path to directory shared with host (to store results)
# - env PROGRAM: name of program to run (should be found in $OUT)
# - env ARGS: extra arguments to pass to the program
##

export TIMELIMIT=0.1s
export MEMLIMIT_MB=50

run_limited()
{
    set -e
    ulimit -Sv $[MEMLIMIT_MB << 10];
    ${@:1}
}
export -f run_limited

args="${ARGS/@@/"'$1'"}"
if [ -z "$args" ]; then
    args="'$1'"
fi

export LLVM_PROFILE_FILE="$SHARED/$PROGRAM-$(basename $1).rawprof"
timeout -s KILL --preserve-status $TIMELIMIT bash -c \
    "run_limited '$OUT/$PROGRAM' $args"
