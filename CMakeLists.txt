cmake_minimum_required(VERSION 3.6)
project(uu_spdr C CXX)

set(CMAKE_CXX_STANDARD 11)

IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    SET(PLAT_SOURCE_FILE src/spdr_osx_unit.c)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    SET(PLAT_SOURCE_FILE src/spdr_linux_unit.c)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    SET(PLAT_SOURCE_FILE src/spdr_win32_unit.c)
    # SET(PLAT_SOURCE_FILE src/spdr_win64_unit.c)
ENDIF()

include_directories(include)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DTRACING_ENABLED=1")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DTRACING_ENABLED=1")

set(EXAMPLE_FILES
        examples/test-full.c
        examples/test-mt.c
        examples/test-scope.c
        examples/perf-test.c
        examples/test-cxx.cc
        )

foreach(example_file ${EXAMPLE_FILES})
    get_filename_component(exec_name ${example_file} NAME_WE)
    add_executable(${exec_name} ${example_file} ${PLAT_SOURCE_FILE})
endforeach(example_file)

add_executable(testc examples/test.c ${PLAT_SOURCE_FILE})