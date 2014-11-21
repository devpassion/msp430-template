file( GLOB SRC_LIB_FILES src/* )

include_directories( includes )

add_library( msp430lib ${SRC_LIB_FILES} )