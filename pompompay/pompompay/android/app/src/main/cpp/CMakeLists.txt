cmake_minimum_required(VERSION 3.10.2)
project(native_lib)

# Set the Android NDK linker flags to use 16KB page alignment
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,max-page-size=16384")

# Add your source files (replace with actual .cpp files)
add_library(native-lib SHARED native-lib.cpp)

find_library(log-lib log)

target_link_libraries(native-lib ${log-lib})

# 16 KB page alignment for arm64-v8a
if(CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
    set_target_properties(native-lib PROPERTIES ANDROID_ARM64_LIBRARY_PAGE_SIZE 0x4000)
endif()
