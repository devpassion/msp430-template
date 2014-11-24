set( CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/msp430.cmake )
project(msp430-exercices-3)
cmake_minimum_required(VERSION 2.8)

################################################ 
## 
## Configuration
## =============

# target processor configuration
# =============
set(CONF_FREQUENCY_IN_HZ "1000000UL" CACHE STRING "CPU frequency used")

# Executable version
# =============
set (msp430-exercices-3_MAJOR 1)
set (msp430-exercices-3_MINOR 0)
# =============

# Other variables
# =============
set(CMAKE_EXECUTABLE_SUFFIX ".elf" )
set( MSP430_EXECUTABLE_NAME ${CMAKE_PROJECT_NAME})
# =============

# Compiler Settings
# =============
add_definitions("-Wall -Wextra -DF_CPU=${CONF_FREQUENCY_IN_HZ}")
# =============
################################################



################################################
################################################
## 
## Implementation - do not modify for normal usage
## =============

# 
# Filter files
# =============
configure_file (
  "${PROJECT_SOURCE_DIR}/includes/config.h.in"
  "${PROJECT_BINARY_DIR}/includes/config.h"
  )
# =============

# MSP430Lib
add_subdirectory(msp430lib)

# Sources
add_subdirectory(src)

# Includes files
# =============
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/includes)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/msp430lib/includes)
# =============

# executable linked to msp430Lib
# =============
add_executable(
  ${MSP430_EXECUTABLE_NAME}
    main.cpp ${SRC_FILES}
)
target_link_libraries(
  ${MSP430_EXECUTABLE_NAME}
    msp430lib
)
# =============


# copy to hex file and dispay size
# =============
add_objcopy_target()
add_objsize_target()
add_objdump_target()

                        

