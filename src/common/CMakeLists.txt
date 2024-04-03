if(BUILD_COMMON)

message(STATUS "Building common")

project(common LANGUAGES C CXX)

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
    common_PROTO_SRCS
    cache.proto
    config.proto
    ctl.proto
    domaininfo.proto
    event.proto
    event_feature.proto
    evidence.proto
    feature.proto
    mo.proto
    policy.proto
    topn.proto
)

message(STATUS "Generating protobuf files ${common_PROTO_SRCS}")

find_package(Protobuf REQUIRED)
include_directories(${Protobuf_INCLUDE_DIRS})
# link_libraries(${Protobuf_LIBRARIES})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR}/baseline)
protobuf_generate_cpp(common_PROTO_CXX_SRCS common_PROTO_CXX_HDRS ${common_PROTO_SRCS})
protobuf_generate_cpp(common_baseline_PROTO_CXX_SRCS common_baseline_PROTO_CXX_HDRS "baseline/baseline.proto") # for baseline proto

set(
    common_CXX_SRCS
    strings.cpp
    log.cpp
    ip.cpp
    datetime.cpp
    topn_req.cpp
    sha256.cpp
    http.cpp
    file.cpp
    ini.cpp
    config.cpp
    mo_req.cpp
    md5.cpp
    cJSON.cpp
    slice.cpp
    stringutil.cpp
    scoped_mmap.cpp
    mmapped_file.cpp
    event_req.cpp
    feature_req.cpp
    topn_param.cpp
    CMyINI.cpp
    asset.cpp
    ctl_req.cpp
    tic.cpp
    evidence_req.cpp
    event_feature_req.cpp
)
list(APPEND common_CXX_SRCS ${common_PROTO_CXX_SRCS})
list(APPEND common_CXX_SRCS ${common_baseline_PROTO_CXX_SRCS}) # for baseline proto

# configure_file (
#   "${PROJECT_SOURCE_DIR}/config.h.in"
#   "${PROJECT_BINARY_DIR}/config.h"
#   )
if(BUILD_SHARED_LIBS)
    add_library(common SHARED ${common_CXX_SRCS})
else()
    add_library(common STATIC ${common_CXX_SRCS})
endif()

set(common_link_libs ${CURL_LIBRARIES} ${cppdb_LIBRARIES} ${cgicc_LIBRARIES} ${Boost_LIBRARIES} protobuf::libprotobuf)
target_link_libraries(common PRIVATE ${common_link_libs})
# set_target_properties(common PROPERTIES
#     SKIP_BUILD_RPATH TRUE
#     BUILD_WITH_INSTALL_RPATH TRUE
#     # INSTALL_RPATH_USE_LINK_PATH FALSE
#     BUILD_RPATH "${ORIGIN}/../common"
#     INSTALL_RPATH "${ORIGIN}/../common"
#     LINK_FLAGS "-Wl,-rpath,${ORIGIN}/../common"
# )

install(TARGETS common EXPORT liuying LIBRARY DESTINATION ${SERVER_WORK_DIR}/common)
# install(RUNTIME_DEPENDENCIES ${common_link_libs})

export(TARGETS common NAMESPACE liuying:: FILE ${CMAKE_BINARY_DIR}/common/commonConfig.cmake)

file(WRITE ${CMAKE_BINARY_DIR}/common/commonConfig.cmake "")

endif()
