cmake_minimum_required(VERSION 3.16)

# ═══════════════════════════════════════════════════════════════════════════════
# PROJECT CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
project(cpp_project
    VERSION 1.0.0
    DESCRIPTION "Professional C++ Project Template"
    LANGUAGES CXX
)

# ═══════════════════════════════════════════════════════════════════════════════
# C++ STANDARD
# ═══════════════════════════════════════════════════════════════════════════════
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Export compile commands for IDE support
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ═══════════════════════════════════════════════════════════════════════════════
# BUILD TYPE
# ═══════════════════════════════════════════════════════════════════════════════
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

# ═══════════════════════════════════════════════════════════════════════════════
# COMPILER FLAGS
# ═══════════════════════════════════════════════════════════════════════════════
# Warning flags
set(WARNING_FLAGS
    -Wall
    -Wextra
    -Wpedantic
    -Wshadow
    -Wconversion
    -Wsign-conversion
    -Wnull-dereference
    -Wdouble-promotion
    -Wformat=2
    -Wcast-align
    -Wunused
    -Wnon-virtual-dtor
    -Woverloaded-virtual
)

# Debug flags
set(DEBUG_FLAGS
    -g3
    -O0
    -DDEBUG
    -fno-omit-frame-pointer
)

# Sanitizer flags (optional, enable with -DENABLE_SANITIZERS=ON)
option(ENABLE_SANITIZERS "Enable AddressSanitizer and UBSan" ON)
if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(SANITIZER_FLAGS
        -fsanitize=address,undefined
        -fno-omit-frame-pointer
    )
endif()

# Release flags
set(RELEASE_FLAGS
    -O3
    -DNDEBUG
    -march=native
    -flto
)

# Apply flags based on build type
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(${WARNING_FLAGS} ${DEBUG_FLAGS} ${SANITIZER_FLAGS})
    add_link_options(${SANITIZER_FLAGS})
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_options(${WARNING_FLAGS} ${RELEASE_FLAGS})
endif()

# ═══════════════════════════════════════════════════════════════════════════════
# DIRECTORIES
# ═══════════════════════════════════════════════════════════════════════════════
set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
set(LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
set(TEST_DIR ${CMAKE_SOURCE_DIR}/tests)

# Include directories
include_directories(${INCLUDE_DIR})
include_directories(${SOURCE_DIR})

# ═══════════════════════════════════════════════════════════════════════════════
# SOURCE FILES
# ═══════════════════════════════════════════════════════════════════════════════
# Find all source files
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    "${SOURCE_DIR}/*.cpp"
    "${SOURCE_DIR}/*.cc"
    "${SOURCE_DIR}/*.cxx"
)

# Find all header files (for IDE support)
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS
    "${INCLUDE_DIR}/*.h"
    "${INCLUDE_DIR}/*.hpp"
    "${SOURCE_DIR}/*.h"
    "${SOURCE_DIR}/*.hpp"
)

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN EXECUTABLE
# ═══════════════════════════════════════════════════════════════════════════════
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

# Link libraries
target_link_libraries(${PROJECT_NAME}
    PRIVATE
        pthread
)

# ═══════════════════════════════════════════════════════════════════════════════
# OUTPUT DIRECTORIES - Thể hiện cấu trúc build
# ═══════════════════════════════════════════════════════════════════════════════
# Nơi chứa executable
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
# Nơi chứa static libraries (.a)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
# Nơi chứa shared libraries (.so)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM TARGETS - Để xem từng bước biên dịch
# ═══════════════════════════════════════════════════════════════════════════════

# Custom target để tạo preprocessed files
add_custom_target(preprocess
    COMMENT "Generating preprocessed files (.i)"
)

# Custom target để tạo assembly files
add_custom_target(assembly
    COMMENT "Generating assembly files (.s)"
)

# Tạo rules cho mỗi source file
foreach(SOURCE_FILE ${SOURCES})
    # Lấy tên file không có extension
    get_filename_component(FILE_NAME ${SOURCE_FILE} NAME_WE)
    get_filename_component(FILE_DIR ${SOURCE_FILE} DIRECTORY)
    file(RELATIVE_PATH REL_DIR ${SOURCE_DIR} ${FILE_DIR})
    
    # Đường dẫn output
    set(PREPROC_OUTPUT ${CMAKE_BINARY_DIR}/preprocessed/${REL_DIR}/${FILE_NAME}.i)
    set(ASM_OUTPUT ${CMAKE_BINARY_DIR}/assembly/${REL_DIR}/${FILE_NAME}.s)
    
    # Tạo thư mục nếu cần
    get_filename_component(PREPROC_DIR ${PREPROC_OUTPUT} DIRECTORY)
    get_filename_component(ASM_DIR ${ASM_OUTPUT} DIRECTORY)
    
    # Custom command cho preprocessing
    add_custom_command(
        OUTPUT ${PREPROC_OUTPUT}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PREPROC_DIR}
        COMMAND ${CMAKE_CXX_COMPILER} -E -P -std=c++20 -I${INCLUDE_DIR} ${SOURCE_FILE} -o ${PREPROC_OUTPUT}
        DEPENDS ${SOURCE_FILE}
        COMMENT "Preprocessing ${FILE_NAME}.cpp -> ${FILE_NAME}.i"
        VERBATIM
    )
    
    # Custom command cho assembly
    add_custom_command(
        OUTPUT ${ASM_OUTPUT}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${ASM_DIR}
        COMMAND ${CMAKE_CXX_COMPILER} -S -fverbose-asm -masm=intel -std=c++20 -I${INCLUDE_DIR} ${SOURCE_FILE} -o ${ASM_OUTPUT}
        DEPENDS ${SOURCE_FILE}
        COMMENT "Compiling ${FILE_NAME}.cpp -> ${FILE_NAME}.s"
        VERBATIM
    )
    
    # Thêm vào custom targets
    add_custom_target(preprocess_${FILE_NAME} DEPENDS ${PREPROC_OUTPUT})
    add_custom_target(assembly_${FILE_NAME} DEPENDS ${ASM_OUTPUT})
    
    add_dependencies(preprocess preprocess_${FILE_NAME})
    add_dependencies(assembly assembly_${FILE_NAME})
endforeach()

# Full pipeline target
add_custom_target(full_pipeline
    DEPENDS preprocess assembly ${PROJECT_NAME}
    COMMENT "Running full build pipeline"
)

# ═══════════════════════════════════════════════════════════════════════════════
# TESTING (Optional - với Google Test)
# ═══════════════════════════════════════════════════════════════════════════════
option(BUILD_TESTS "Build tests" OFF)

if(BUILD_TESTS)
    enable_testing()
    
    # Thêm Google Test
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.14.0
    )
    FetchContent_MakeAvailable(googletest)
    
    # Tìm test files
    file(GLOB_RECURSE TEST_SOURCES "${TEST_DIR}/*.cpp")
    
    if(TEST_SOURCES)
        add_executable(tests ${TEST_SOURCES})
        target_link_libraries(tests
            PRIVATE
                GTest::gtest_main
                pthread
        )
        
        include(GoogleTest)
        gtest_discover_tests(tests)
    endif()
endif()

# ═══════════════════════════════════════════════════════════════════════════════
# INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════════
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY ${INCLUDE_DIR}/
    DESTINATION include
)

# ═══════════════════════════════════════════════════════════════════════════════
# PRINT CONFIGURATION SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════
message(STATUS "")
message(STATUS "═══════════════════════════════════════════════════════════")
message(STATUS "  ${PROJECT_NAME} v${PROJECT_VERSION} Configuration")
message(STATUS "═══════════════════════════════════════════════════════════")
message(STATUS "  Build type:        ${CMAKE_BUILD_TYPE}")
message(STATUS "  C++ Standard:      ${CMAKE_CXX_STANDARD}")
message(STATUS "  Compiler:          ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  Sanitizers:        ${ENABLE_SANITIZERS}")
message(STATUS "  Build tests:       ${BUILD_TESTS}")
message(STATUS "")
message(STATUS "  Output directories:")
message(STATUS "    Executables:     ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message(STATUS "    Libraries:       ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
message(STATUS "    Preprocessed:    ${CMAKE_BINARY_DIR}/preprocessed")
message(STATUS "    Assembly:        ${CMAKE_BINARY_DIR}/assembly")
message(STATUS "═══════════════════════════════════════════════════════════")
message(STATUS "")
