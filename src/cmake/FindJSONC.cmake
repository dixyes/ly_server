
find_package(PkgConfig)
pkg_check_modules(PC_JSONC json-c)

find_path(JSONC_INCLUDE_DIR NAMES json-c/json.h json/json.h)
find_library(JSONC_LIBRARY NAMES json-c)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JSONC DEFAULT_MSG
 JSONC_LIBRARY
 JSONC_INCLUDE_DIR
)

if(JSONC_FOUND)
  set(JSONC_LIBRARIES ${JSONC_LIBRARY})
  set(JSONC_INCLUDE_DIRS ${JSONC_INCLUDE_DIR}/json-c)
endif()

mark_as_advanced(
  JSONC_LIBRARY
  JSONC_INCLUDE_DIR
)