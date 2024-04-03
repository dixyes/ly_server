if(BUILD_LIBS)

message(STATUS "Building libs")

project(libs LANGUAGES C CXX)

# libs requires common
set(common_DIR "${CMAKE_BINARY_DIR}/common")
find_package(common CONFIG REQUIRED)

find_package(PkgConfig REQUIRED)

find_package(cppdb REQUIRED)
include_directories(${cppdb_INCLUDE_DIR})
# link_libraries(${cppdb_LIBRARIES})

pkg_check_modules(cgicc REQUIRED cgicc)
include_directories(${cgicc_INCLUDE_DIRS})
# link_libraries(${cgicc_LIBRARIES})

find_package(Boost REQUIRED COMPONENTS system filesystem regex thread)
include_directories(${Boost_INCLUDE_DIRS})
# link_libraries(${Boost_LIBRARIES})

find_package(CURL REQUIRED)
include_directories(${CURL_INCLUDE_DIRS})
# link_libraries(${CURL_LIBRARIES})

set(
    libs_PROTO_SRCS
    config_agent.proto
    config_bwlist.proto
    config_device.proto
    config_event.proto
    config_user.proto
)

message(STATUS "Generating protobuf files ${libs_PROTO_SRCS}")

find_package(Protobuf REQUIRED)
include_directories(${Protobuf_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR}/../common)
protobuf_generate_cpp(libs_PROTO_CXX_SRCS libs_PROTO_CXX_HDRS ${libs_PROTO_SRCS})

if(BUILD_SHARED_LIBS)
    set(IS_SHARED SHARED)
else()
    set(IS_SHARED STATIC)
endif()

set(libs_link_libs ${Boost_LIBRARIES} ${CURL_LIBRARIES} ${Protobuf_LIBRARIES} ${cppdb_LIBRARIES} ${cgicc_LIBRARIES})

function(add_lib)
    set(NAME ${ARGV0})
    list(REMOVE_AT ARGV 0)
    add_library(
        ${NAME} ${IS_SHARED} ${ARGV}
    )
    target_link_libraries(${NAME} ${libs_link_libs})

    if(BUILD_SHARED_LIBS)
        set_target_properties(
            ${NAME} PROPERTIES
            NO_SONAME TRUE
            PREFIX ""
            DEPENDS common
        )
    endif()

    install(TARGETS ${NAME} LIBRARY DESTINATION ${SERVER_WORK_DIR}/lib)
endfunction()

add_lib(
    config_event
    config_class.cpp
    config_event.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/config_event.pb.cc
)

add_lib(
    config_mo
    config_class.cpp
    config_mo.cpp
)

add_lib(
    config_internalip
    config_class.cpp
    config_internalip.cpp
)

add_lib(
    config_internalsrv
    config_class.cpp
    config_internalsrv.cpp
)

add_lib(
    config_agent
    config_class.cpp
    config_agent.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/config_agent.pb.cc
)

add_lib(
    config_bwlist
    config_class.cpp
    config_bwlist.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/config_bwlist.pb.cc
)

add_lib(
    config_user
    config_class.cpp
    config_user.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/config_user.pb.cc
)

endif()
