# Idempotent for cached ExternalProject checkouts. Fail on incompatible upstream changes.
find_package(Git REQUIRED)
execute_process(COMMAND "${GIT_EXECUTABLE}" apply --reverse --check "${PATCH_FILE}"
    WORKING_DIRECTORY "${SOURCE_DIR}" RESULT_VARIABLE already_applied
    OUTPUT_QUIET ERROR_QUIET)
if(already_applied EQUAL 0)
    return()
endif()
execute_process(COMMAND "${GIT_EXECUTABLE}" apply --check "${PATCH_FILE}"
    WORKING_DIRECTORY "${SOURCE_DIR}" RESULT_VARIABLE check_result)
if(NOT check_result EQUAL 0)
    message(FATAL_ERROR "PNG density patch does not match this libcaesium version")
endif()
execute_process(COMMAND "${GIT_EXECUTABLE}" apply "${PATCH_FILE}"
    WORKING_DIRECTORY "${SOURCE_DIR}" RESULT_VARIABLE apply_result)
if(NOT apply_result EQUAL 0)
    message(FATAL_ERROR "Could not apply PNG density preservation patch")
endif()
