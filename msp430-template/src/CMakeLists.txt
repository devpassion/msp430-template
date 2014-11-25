include_directories( /usr/msp430/include )
file( GLOB_RECURSE SRC_FILES_LOCAL * )
set( SRC_FILES ${SRC_FILES_LOCAL} PARENT_SCOPE )
