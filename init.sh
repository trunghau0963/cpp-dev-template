#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
#                    C++ WORKSPACE INITIALIZATION
# ═══════════════════════════════════════════════════════════════════════════════
# Script để khởi tạo workspace structure nhanh (không install tools)
# Usage: chmod +x init.sh && ./init.sh
# ═══════════════════════════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_header "Initializing C++ Workspace"

# ═══════════════════════════════════════════════════════════════════════════════
# CREATE DIRECTORIES
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "Creating directory structure..."
mkdir -p build/{preprocessed,assembly,objects,bin,deps,cmake}
mkdir -p src include lib tests docs third_party .vscode

# Create .gitkeep for empty dirs
touch lib/.gitkeep third_party/.gitkeep tests/.gitkeep

print_success "Directories created"

# ═══════════════════════════════════════════════════════════════════════════════
# CREATE SAMPLE SOURCE FILES
# ═══════════════════════════════════════════════════════════════════════════════

if [ ! -f "src/main.cpp" ]; then
    echo ""
    echo "Creating src/main.cpp..."
    cat > src/main.cpp << 'EOF'
/**
 * @file main.cpp
 * @brief Main entry point
 */

#include <iostream>
#include <vector>
#include <string>
#include "config.hpp"

int main() {
    config::printBuildInfo();
    
    std::cout << "\n🚀 Hello, C++ World!\n" << std::endl;
    
    // Demo modern C++
    std::vector<std::string> messages = {
        "Welcome to C++ development!",
        "Edit src/main.cpp to get started",
        "Press Ctrl+Shift+B to build"
    };
    
    for (const auto& msg : messages) {
        std::cout << "  ► " << msg << std::endl;
    }
    
    return 0;
}
EOF
    print_success "Created src/main.cpp"
fi

if [ ! -f "include/config.hpp" ]; then
    echo "Creating include/config.hpp..."
    cat > include/config.hpp << 'EOF'
#ifndef CONFIG_HPP
#define CONFIG_HPP

#include <iostream>
#include <string>

namespace config {

// Version info
constexpr const char* PROJECT_NAME = "cpp_project";
constexpr const char* VERSION = "1.0.0";

// Build type detection
#ifdef DEBUG
    constexpr bool IS_DEBUG = true;
    constexpr const char* BUILD_TYPE = "Debug";
#else
    constexpr bool IS_DEBUG = false;
    constexpr const char* BUILD_TYPE = "Release";
#endif

// Platform detection
#if defined(__linux__)
    constexpr const char* PLATFORM = "Linux";
#elif defined(__APPLE__)
    constexpr const char* PLATFORM = "macOS";
#elif defined(_WIN32)
    constexpr const char* PLATFORM = "Windows";
#else
    constexpr const char* PLATFORM = "Unknown";
#endif

// Print build info
inline void printBuildInfo() {
    std::cout << "═══════════════════════════════════════════════════════════\n";
    std::cout << "  " << PROJECT_NAME << " v" << VERSION << "\n";
    std::cout << "═══════════════════════════════════════════════════════════\n";
    std::cout << "  Build Type: " << BUILD_TYPE << "\n";
    std::cout << "  Platform:   " << PLATFORM << "\n";
    std::cout << "═══════════════════════════════════════════════════════════\n";
}

}  // namespace config

#endif  // CONFIG_HPP
EOF
    print_success "Created include/config.hpp"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CREATE .gitignore
# ═══════════════════════════════════════════════════════════════════════════════

if [ ! -f ".gitignore" ]; then
    echo "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Build outputs
build/
*.o
*.i
*.s
*.exe
*.out
*.app

# VS Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/c_cpp_properties.json
!.vscode/extensions.json

# CMake
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
compile_commands.json

# System
.DS_Store
*~
*.swp
*.log
EOF
    print_success "Created .gitignore"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CREATE README
# ═══════════════════════════════════════════════════════════════════════════════

if [ ! -f "README.md" ]; then
    echo "Creating README.md..."
    cat > README.md << 'EOF'
# C++ Project Template

Professional C++ development environment for VS Code.

## 🚀 Quick Start

```bash
# Build project
make

# Run
make run

# Debug in VS Code
Press F5
```

## 📖 Documentation

- **[Usage Guide](docs/USAGE_GUIDE.md)** - Chi tiết cách sử dụng
- **[Cheatsheet](docs/CHEATSHEET.md)** - Lệnh thường dùng

## 📦 Build Commands

```bash
make                    # Build debug
make release            # Build release
make clean              # Clean
make help               # Show all targets
```

## 🔨 Project Structure

```
project/
├── src/                # Source files
├── include/            # Header files
├── build/              # Build outputs
│   ├── preprocessed/  # .i files
│   ├── assembly/      # .s files
│   ├── objects/       # .o files
│   └── bin/           # executables
└── .vscode/           # VS Code config
```
EOF
    print_success "Created README.md"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════

print_header "Initialization Complete!"

echo ""
echo "  📁 Workspace structure created"
echo "  📝 Sample files created:"
echo "     • src/main.cpp"
echo "     • include/config.hpp"
echo "     • README.md"
echo "     • .gitignore"
echo ""
echo "  🎯 Next steps:"
echo "     1. Open this folder in VS Code"
echo "     2. Install recommended extensions"
echo "     3. Build: Ctrl+Shift+B → 'Build Current File (Debug)'"
echo "     4. Run: Press F5 to debug"
echo ""
echo "  📚 Files you may want to create:"
echo "     • Makefile (for make commands)"
echo "     • CMakeLists.txt (for CMake)"
echo "     • .vscode/tasks.json (build tasks)"
echo "     • .vscode/launch.json (debug config)"
echo ""
echo "  💡 Tip: Check existing files in this template for examples!"
echo ""

# Check if git initialized
if [ ! -d ".git" ]; then
    echo "  ⚠️  Git not initialized. Run: git init"
fi

echo ""
