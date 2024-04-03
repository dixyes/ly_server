if(BUILD_SERVER)

message(STATUS "Building server")

project(server LANGUAGES C CXX)

# server requires common
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

find_package(JSONC REQUIRED)
include_directories(${JSONC_INCLUDE_DIR})
message(STATUS "json-c: ${JSONC_INCLUDE_DIR}")

find_package(CURL REQUIRED)
include_directories(${CURL_INCLUDE_DIRS})

include_directories(${CMAKE_CURRENT_BINARY_DIR}/../common)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/../lib)

find_package(Protobuf REQUIRED)
include_directories(${Protobuf_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(server_link_libs
    ${cppdb_LIBRARIES}
    ${cgicc_LIBRARIES}
    ${Boost_LIBRARIES}
    ${JSONC_LIBRARIES}
    ${CURL_LIBRARIES}
    ${Protobuf_LIBRARIES}
)

message(STATUS "server_link_libs: ${server_link_libs}")

set(server_SRCS dbc.cpp)

add_executable(
    feature
    ${server_SRCS}
    feature.cpp
)

add_executable(
    event_feature
    ${server_SRCS}
    event_feature.cpp
)

add_executable(
    mo
    ${server_SRCS}
    mo.cpp
)

add_executable(
    internalip
    ${server_SRCS}
    internalip.cpp
)

add_executable(
    event
    ${server_SRCS}
    event.cpp
)

# add_executable(
#     asset
#     ${server_SRCS}
#     asset.cpp
# )

add_executable(
    config
    ${server_SRCS}
    config.cpp
)

add_executable(
    auth
    ${server_SRCS}
    auth.cpp
)

add_executable(
    sctl
    ${server_SRCS}
    sctl.cpp
)

add_executable(
    locinfo
    ${server_SRCS}
    locinfo.cpp
)

add_executable(
    geoinfo
    ${server_SRCS}
    geoinfo.cpp
)

add_executable(
    portinfo
    ${server_SRCS}
    portinfo.cpp
)

add_executable(
    ipinfo
    ${server_SRCS}
    ipinfo.cpp
)

add_executable(
    bwlist
    ${server_SRCS}
    bwlist.cpp
)
set_target_properties(bwlist PROPERTIES DEPENDS config_bwlist)

add_executable(
    threatinfo
    ${server_SRCS}
    threatinfo.cpp
)

add_executable(
    threatinfopro
    ${server_SRCS}
    threatinfopro.cpp
)

add_executable(
    evidence
    ${server_SRCS}
    evidence.cpp
)

set(server_CGI_EXECUTABLES 
    feature
    event_feature
    mo
    internalip
    event
    # asset
    config
    auth
    sctl
    locinfo
    geoinfo
    portinfo
    ipinfo
    bwlist
    threatinfo
    threatinfopro
    evidence
)

if(Protobuf_VERSION VERSION_GREATER_EQUAL 4)
    find_package(absl REQUIRED)

    list(APPEND server_link_libs absl::log_internal_check_op)
endif ()
foreach(EXEC ${server_CGI_EXECUTABLES})
    target_link_libraries(${EXEC} common ${server_link_libs})
    set_target_properties(${EXEC} PROPERTIES
        BUILD_WITH_INSTALL_RPATH TRUE
        # INSTALL_RPATH_USE_LINK_PATH TRUE
        BUILD_RPATH "\${ORIGIN}/../common"
        INSTALL_RPATH "\${ORIGIN}/../../common"
    )
endforeach()

message(STATUS "SERVER_WORK_DIR ${SERVER_WORK_DIR}")

install(TARGETS ${server_CGI_EXECUTABLES}
    RUNTIME DESTINATION ${SERVER_WORK_DIR}/www/d
)

add_executable(
    config_pusher
    ${server_SRCS}
    config_pusher.cpp
)

add_executable(
    gen_event
    ${server_SRCS}
    gen_event.cpp
    syslog_sender.cpp
)

set(
    server_BIN_EXECUTABLES
    config_pusher
    gen_event
)

foreach(EXEC ${server_BIN_EXECUTABLES})
    target_link_libraries(${EXEC} common ${server_link_libs})
    set_target_properties(${EXEC} PROPERTIES
        BUILD_WITH_INSTALL_RPATH TRUE
        BUILD_RPATH "\${ORIGIN}/../common"
        INSTALL_RPATH "\${ORIGIN}/../common"
    )
endforeach()

install(TARGETS
    config_pusher
    gen_event
    RUNTIME DESTINATION ${SERVER_WORK_DIR}/bin
)

endif()
