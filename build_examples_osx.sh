#!/usr/bin/env bash

##
# NOTE(nicolas): SPDR does not need to be built outside of your
# project.
#
# You only need two things to use SPDR:
# - import the `./include` directory
# - add one of its `_unit.c` source files to your project
# - include "spdr/spdr.h" (C) or "spdr/spdr.hh" (C++)
set -u

RELH="$(dirname "${0}")"
HERE="$(cd "${RELH}" && pwd)"

OUTPUT="${HERE}"/output
CXX=${CXX:-$(which "c++")}
CC=${CC:-$(which "cc")}
CFLAGS=${CFLAGS:-}

cflags=(${CFLAGS} -Wall -Wextra)
cflags=(${cflags[@]})

[ -d "${OUTPUT}" ] || mkdir -p "${OUTPUT}"
printf "INFO building into %s\n" "${OUTPUT}"

# just to print the timing information about builds
origin="$(date "+%s")"
printf "%s\n" "${origin}"
PS4='T $(($(date "+%s") - ${origin}))\011'
set -x

## <BUILD EXAMPLES..
set -o errexit

EXAMPLES="${HERE}"/examples

# here is all you need:
SPDR=(-I"${HERE}"/include "${HERE}"/src/spdr_osx_unit.c)

D="${OUTPUT}"/test
"${CC}" "${cflags[@]}" -DTRACING_ENABLED=1 -ansi "${EXAMPLES}"/test.c -lm "${SPDR[@]}" \
        -o "${D}"
printf "PROGRAM\t%s\n" "${D}"

D="${OUTPUT}"/test-scope
"${CC}" "${cflags[@]}" -DTRACING_ENABLED=1 "${EXAMPLES}"/test-scope.c -lm "${SPDR[@]}" \
        -o "${D}"
printf "PROGRAM\t%s\n" "${D}"

D="${OUTPUT}"/test-mt
"${CC}" "${cflags[@]}" -DTRACING_ENABLED=1 -ansi "${EXAMPLES}"/test-mt.c -lm "${SPDR[@]}" \
        -o "${D}"
printf "PROGRAM\t%s\n" "${D}"

D="${OUTPUT}"/test-full
"${CC}" "${cflags[@]}" -DTRACING_ENABLED=1 -ansi "${EXAMPLES}"/test-full.c -lm "${SPDR[@]}" \
        -o "${D}"
printf "PROGRAM\t%s\n" "${D}"

D="${OUTPUT}"/test-cxx
"${CXX}" "${cflags[@]}" -Wno-old-style-cast  -Wno-c++98-compat -stdlib=libc++ -std=c++11 \
         -DTRACING_ENABLED=1 \
         "${EXAMPLES}"/test-cxx.cc -lm "${SPDR[@]}" \
         -o "${D}"
printf "PROGRAM\t%s\n" "${D}"

D="${OUTPUT}"/perf-test
"${CC}" "${cflags[@]}" -DTRACING_ENABLED=1 "${EXAMPLES}"/perf-test.c -lm "${SPDR[@]}" \
         -o "${D}"
printf "PROGRAM\t%s\n" "${D}"

## ..BUILD EXAMPLES>

set +x
