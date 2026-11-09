#include <cstdio>
#include <format>
#include <iostream>
#include <memory>
#include <string_view>

extern "C" {
#include "disasm.h"
}

int main(int argc, char* argv[]) {
  if (argc == 2 && (std::string_view(argv[1]) == "--help" ||
                    std::string_view(argv[1]) == "-h")) {
    std::cout << std::format("Usage: {} <file.bc>\n", argv[0]);
    return 0;
  }

  if (argc != 2) {
    std::cerr << std::format("Usage: {} <file.bc>\n", argv[0]);
    return 1;
  }

  const std::unique_ptr<bytecode, decltype(&bytecode_free)> bc(
      bytecode_load(argv[1]), &bytecode_free);

  if (!bc) {
    std::cerr << std::format("Failed to load bytecode: {}\n", argv[1]);
    return 1;
  }

  dump_bytecode(stdout, bc.get());
  if (std::fflush(stdout) == EOF || std::ferror(stdout)) {
    std::cerr << "Failed to write bytecode dump\n";
    return 1;
  }

  return 0;
}
