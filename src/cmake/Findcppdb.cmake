# find cppdb

find_path(cppdb_INCLUDE_DIR cppdb/defs.h
  HINTS
    ENV CPPDB_DIR
  PATH_SUFFIXES include
)

find_library(cppdb_mysql_LIBRARY
  NAMES cppdb_mysql
  NAMES_PER_DIR
  HINTS
    ENV CPPDB_DIR
  PATH_SUFFIXES lib lib64
)

find_library(cppdb_postgresql_LIBRARY
  NAMES cppdb_postgresql
  NAMES_PER_DIR
  HINTS
    ENV CPPDB_DIR
  PATH_SUFFIXES lib lib64
)

find_library(cppdb_sqlite3_LIBRARY
  NAMES cppdb_sqlite3
  NAMES_PER_DIR
  HINTS
    ENV CPPDB_DIR
  PATH_SUFFIXES lib lib64
)

find_library(cppdb_LIBRARY
  NAMES cppdb
  NAMES_PER_DIR
  HINTS
    ENV CPPDB_DIR
  PATH_SUFFIXES lib lib64
)

set(cppdb_LIBRARIES ${cppdb_LIBRARY} ${cppdb_mysql_LIBRARY} ${cppdb_postgresql_LIBRARY} ${cppdb_sqlite3_LIBRARY})

# check version using compiling
if(cppdb_INCLUDE_DIR AND NOT CMAKE_CROSSCOMPILING)
    set(_cppdb_VERSION_SOURCE
      "
      #include <stdio.h>
      #include <cppdb/frontend.h>
      int main() {
        printf(\"%06d\\n\", cppdb::version_number());
        return 0;
      }
      "
    )
    set(_cppdb_BIN_FILE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/cppdb_version_check)

    try_compile(_cppdb_VERSION_OK
      SOURCE_FROM_VAR "+cppdb_version_check.cc" _cppdb_VERSION_SOURCE
      LOG_DESCRIPTION "Checking cppdb version"
      OUTPUT_VARIABLE _cppdb_VERSION_OUTPUT
      LINK_LIBRARIES ${cppdb_LIBRARIES}
      COMPILE_DEFINITIONS "-I${cppdb_INCLUDE_DIR}"
      COPY_FILE "${_cppdb_BIN_FILE}"
    )
    
    execute_process(COMMAND ${_cppdb_BIN_FILE}
      OUTPUT_VARIABLE _cppdb_VERSION
    )
    
    # vesion should be maj*10000 + min*100 + patch
    if(_cppdb_VERSION_OK AND _cppdb_VERSION)
      string(REGEX MATCH "([0-9][0-9])([0-9][0-9])([0-9][0-9])" _cppdb_VERSION ${_cppdb_VERSION})
      if (CMAKE_MATCH_COUNT GREATER 0)
        math(EXPR cppdb_VERSION_ID "${CMAKE_MATCH_1}*10000 + ${CMAKE_MATCH_2}*100 + ${CMAKE_MATCH_3}")
        math(EXPR cppdb_VERSION_MAJOR "${CMAKE_MATCH_1}")
        math(EXPR cppdb_VERSION_MINOR "${CMAKE_MATCH_2}")
        math(EXPR cppdb_VERSION_PATCH "${CMAKE_MATCH_3}")
        set(cppdb_VERSION_STRING "${cppdb_VERSION_MAJOR}.${cppdb_VERSION_MINOR}.${cppdb_VERSION_PATCH}")
        message(STATUS "Found cppdb: ${cppdb_VERSION_STRING}")
      endif()
    endif()
endif()
