cmake_minimum_required(VERSION 3.13)

project(liuying LANGUAGES C CXX)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

option(BUILD_COMMON "Builds liuying libcommon" ON)
option(BUILD_LIBS "Builds liuying server libraries" ON)
option(BUILD_SERVER "Builds liuying server cgi" ON)

set(SERVER_WORK_DIR "/Server" CACHE STRING "Server work directory")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -fPIC -std=c++17")
if(CMAKE_BUILD_TYPE EQUAL "Release")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
endif()

add_subdirectory(common)
add_subdirectory(lib)
add_subdirectory(server)

SET(CMAKE_BUILD_RPATH_USE_ORIGIN TRUE)
