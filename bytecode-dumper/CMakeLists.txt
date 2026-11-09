cmake_minimum_required(VERSION 3.16)
project(bytecode-dumper LANGUAGES C CXX)

set(LAMA_VM_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../Lama/virtual_machine")

add_library(lama-disasm STATIC
    "${LAMA_VM_DIR}/bytecode.c"
    "${LAMA_VM_DIR}/disasm.c"
    "${LAMA_VM_DIR}/memory.c"
    "${LAMA_VM_DIR}/opcodes.c"
)
target_include_directories(lama-disasm PUBLIC "${LAMA_VM_DIR}")
set_target_properties(lama-disasm PROPERTIES
    C_STANDARD 99
    C_STANDARD_REQUIRED YES
    C_EXTENSIONS NO
)

add_executable(bytecode-dumper main.cpp)
target_link_libraries(bytecode-dumper PRIVATE lama-disasm)
set_target_properties(bytecode-dumper PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)
