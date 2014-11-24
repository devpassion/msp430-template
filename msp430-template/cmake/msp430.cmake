# TOOLCHAIN FILE for MSP430
#
# Not yet tested with plain C stuff but with C++
#
# Usage:
# cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/msp430.cmake

if( DEFINED CMAKE_CROSSCOMPILING )
  # subsequent toolchain loading is not really needed
  return()
endif()

find_program(MSP430_CC msp430-gcc)
find_program(MSP430_CXX msp430-g++)
find_program(MSP430_OBJCOPY msp430-objcopy)
find_program(MSP430_SIZE_TOOL msp430-size)
find_program(MSP430_OBJDUMP msp430-objdump)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)
#SET(CMAKE_SYSTEM_PROCESSOR msp430g2553)
SET(CMAKE_FIND_ROOT_PATH /usr/msp430)

# Compiler & Linker Settings
include(CMakeForceCompiler)
CMAKE_FORCE_C_COMPILER(msp430-gcc GNU)
CMAKE_FORCE_CXX_COMPILER(msp430-g++ GNU)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)
if( _CMAKE_IN_TRY_COMPILE )
endif()

if(NOT MCU)
  message(STATUS "Setting default MCU type 'msp430g2553'")
  set(MCU "msp430g2553" CACHE STRING "MSP430 MCU TYPE")
else()
  message(STATUS "MCU defined as '${MCU}'")
endif()

set(CMAKE_CXX_FLAGS " -Wall -std=c++0x -mmcu=${MCU} -Os -ffunction-sections -fdata-sections" CACHE STRING "C++ Flags")
set(CMAKE_CXX_LINK_FLAGS "-Wl,-gc-sections" CACHE STRING "Linker Flags")

set(CMAKE_C_FLAGS "-Wall -mmcu=${MCU} -Os -ffunction-sections -fdata-sections" CACHE STRING "C Flags")
set(CMAKE_C_LINK_FLAGS "-Wl,-gc-sections" CACHE STRING "Linker Flags")

# Use GCC for linking executables to avoid linking to stdlibc++ _BUT_ get all the math libraries etc.
set(CMAKE_CXX_LINK_EXECUTABLE
  "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <LINK_LIBRARIES>")

  
  
macro(add_objcopy_target )
    add_custom_target( objcopy ALL 
                        COMMAND ${MSP430_OBJCOPY} -O ihex -R .eeprom  "${MSP430_EXECUTABLE_NAME}${CMAKE_EXECUTABLE_SUFFIX}"  "${MSP430_EXECUTABLE_NAME}.hex" 
                        DEPENDS "${MSP430_EXECUTABLE_NAME}"
                        COMMENT "copy elf to hex..." VERBATIM
                        )

endmacro(add_objcopy_target)


macro(add_objsize_target)
    add_custom_target( objsize ALL 
                        COMMAND ${MSP430_SIZE_TOOL} "${MSP430_EXECUTABLE_NAME}${CMAKE_EXECUTABLE_SUFFIX}"  "${MSP430_EXECUTABLE_NAME}.hex"
                        DEPENDS objcopy
                        COMMENT "Target size :" VERBATIM
                        )
endmacro(add_objsize_target)

# objdump -dSt leds.elf >leds.lst

macro(add_objdump_target)
#     add_custom_command( OUTPUT ${CMAKE_BINARY_DIR}/${MSP430_EXECUTABLE_NAME}.lst
#                         COMMAND ${MSP430_OBJDUMP_TOOL} -d St "${MSP430_EXECUTABLE_NAME}${CMAKE_EXECUTABLE_SUFFIX}"
#                         DEPENDS ${MSP430_EXECUTABLE_NAME})
    add_custom_target( objdump ALL 
                        COMMAND ${MSP430_OBJDUMP} -dSt "${MSP430_EXECUTABLE_NAME}${CMAKE_EXECUTABLE_SUFFIX}" > ${MSP430_EXECUTABLE_NAME}.lst
                        DEPENDS objcopy
                        COMMENT "Add code dump " VERBATIM)
endmacro(add_objdump_target)
  