#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
#                    C++ DEVELOPMENT ENVIRONMENT SETUP
# ═══════════════════════════════════════════════════════════════════════════════
# Script này cài đặt tất cả tools cần thiết cho C++ development trên Linux
# Usage: chmod +x setup.sh && ./setup.sh
# ═══════════════════════════════════════════════════════════════════════════════

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Detect package manager
detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt-get install -y"
        PKG_UPDATE="sudo apt-get update"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
        PKG_UPDATE="sudo dnf check-update"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        PKG_UPDATE="sudo pacman -Syu --noconfirm"
    else
        print_error "No supported package manager found!"
        exit 1
    fi
    print_success "Detected package manager: $PKG_MANAGER"
}

# ═══════════════════════════════════════════════════════════════════════════════
# INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

install_build_essentials() {
    print_header "Installing Build Essentials"
    
    case $PKG_MANAGER in
        apt)
            $PKG_UPDATE
            $PKG_INSTALL build-essential
            ;;
        dnf)
            $PKG_INSTALL gcc gcc-c++ make
            ;;
        pacman)
            $PKG_INSTALL base-devel
            ;;
    esac
    print_success "Build essentials installed"
}

install_gcc() {
    print_header "Installing GCC/G++"
    
    case $PKG_MANAGER in
        apt)
            $PKG_INSTALL gcc g++ gcc-12 g++-12
            # Set GCC 12 as default
            sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100
            sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100
            ;;
        dnf)
            $PKG_INSTALL gcc gcc-c++
            ;;
        pacman)
            $PKG_INSTALL gcc
            ;;
    esac
    
    echo -e "  GCC version: $(gcc --version | head -n1)"
    echo -e "  G++ version: $(g++ --version | head -n1)"
    print_success "GCC/G++ installed"
}

install_clang() {
    print_header "Installing Clang/LLVM"
    
    case $PKG_MANAGER in
        apt)
            $PKG_INSTALL clang clang-format clang-tidy lldb
            ;;
        dnf)
            $PKG_INSTALL clang clang-tools-extra lldb
            ;;
        pacman)
            $PKG_INSTALL clang lldb
            ;;
    esac
    
    if command -v clang++ &> /dev/null; then
        echo -e "  Clang version: $(clang++ --version | head -n1)"
        print_success "Clang/LLVM installed"
    fi
}

install_cmake() {
    print_header "Installing CMake"
    
    case $PKG_MANAGER in
        apt)
            $PKG_INSTALL cmake cmake-curses-gui
            ;;
        dnf)
            $PKG_INSTALL cmake cmake-gui
            ;;
        pacman)
            $PKG_INSTALL cmake
            ;;
    esac
    
    echo -e "  CMake version: $(cmake --version | head -n1)"
    print_success "CMake installed"
}

install_debugging_tools() {
    print_header "Installing Debugging & Profiling Tools"
    
    case $PKG_MANAGER in
        apt)
            $PKG_INSTALL gdb valgrind strace ltrace linux-tools-generic
            ;;
        dnf)
            $PKG_INSTALL gdb valgrind strace ltrace perf
            ;;
        pacman)
            $PKG_INSTALL gdb valgrind strace ltrace perf
            ;;
    esac
    
    echo -e "  GDB version: $(gdb --version | head -n1)"
    echo -e "  Valgrind version: $(valgrind --version)"
    print_success "Debugging tools installed"
}

install_analysis_tools() {
    print_header "Installing Analysis Tools"
    
    case $PKG_MANAGER in
        apt)
            $PKG_INSTALL binutils cppcheck
            ;;
        dnf)
            $PKG_INSTALL binutils cppcheck
            ;;
        pacman)
            $PKG_INSTALL binutils cppcheck
            ;;
    esac
    
    print_success "Analysis tools installed (nm, objdump, cppcheck)"
}

install_documentation_tools() {
    print_header "Installing Documentation Tools"
    
    case $PKG_MANAGER in
        apt)
            $PKG_INSTALL doxygen graphviz
            ;;
        dnf)
            $PKG_INSTALL doxygen graphviz
            ;;
        pacman)
            $PKG_INSTALL doxygen graphviz
            ;;
    esac
    
    print_success "Documentation tools installed"
}

create_directory_structure() {
    print_header "Creating Project Directory Structure"
    
    # Create build directories
    mkdir -p build/{preprocessed,assembly,objects,bin,deps,cmake}
    mkdir -p src
    mkdir -p include
    mkdir -p lib
    mkdir -p tests
    mkdir -p docs
    mkdir -p third_party
    mkdir -p .vscode
    
    # Create .gitkeep files to preserve empty directories
    touch lib/.gitkeep
    touch third_party/.gitkeep
    touch tests/.gitkeep
    
    print_success "Directory structure created"
    
    echo ""
    echo "  Project Structure:"
    echo "  ├── src/                  # Source files (.cpp)"
    echo "  ├── include/              # Header files (.h/.hpp)"
    echo "  ├── lib/                  # External libraries"
    echo "  ├── tests/                # Test files"
    echo "  ├── docs/                 # Documentation"
    echo "  ├── third_party/          # Third-party dependencies"
    echo "  ├── .vscode/              # VS Code configuration"
    echo "  └── build/"
    echo "      ├── preprocessed/     # Step 1: .i files"
    echo "      ├── assembly/         # Step 2: .s files"
    echo "      ├── objects/          # Step 3: .o files"
    echo "      ├── bin/              # Step 4: executables"
    echo "      ├── deps/             # Dependency files (.d)"
    echo "      └── cmake/            # CMake build files"
}

create_sample_files() {
    print_header "Creating Sample Files"
    
    # Sample main.cpp nếu chưa có
    if [ ! -f "src/main.cpp" ]; then
        cat > src/main.cpp << 'EOF'
#include <iostream>
#include "config.hpp"

int main() {
    config::printBuildInfo();
    std::cout << "Hello, C++ World!" << std::endl;
    return 0;
}
EOF
        print_success "Created src/main.cpp"
    fi
    
    # Sample config.hpp nếu chưa có
    if [ ! -f "include/config.hpp" ]; then
        cat > include/config.hpp << 'EOF'
#ifndef CONFIG_HPP
#define CONFIG_HPP
#include <iostream>

namespace config {
constexpr const char* PROJECT_NAME = "cpp_project";
constexpr const char* VERSION = "1.0.0";

#ifdef DEBUG
    constexpr bool IS_DEBUG = true;
    constexpr const char* BUILD_TYPE = "Debug";
#else
    constexpr bool IS_DEBUG = false;
    constexpr const char* BUILD_TYPE = "Release";
#endif

inline void printBuildInfo() {
    std::cout << "Project: " << PROJECT_NAME << " v" << VERSION << "\n";
    std::cout << "Build: " << BUILD_TYPE << "\n";
}
}  // namespace config
#endif
EOF
        print_success "Created include/config.hpp"
    fi
    
    # README.md nếu chưa có
    if [ ! -f "README.md" ]; then
        cat > README.md << 'EOF'
# C++ Project Template

Professional C++ development environment for VS Code.

## Quick Start

```bash
# Build
make

# Run
make run

# Debug in VS Code
Press F5
```

## Documentation

- [Usage Guide](docs/USAGE_GUIDE.md)
- [Cheatsheet](docs/CHEATSHEET.md)
EOF
        print_success "Created README.md"
    fi
    
    echo ""
    echo "  ✅ Sample files created"
    echo "  📝 Edit src/main.cpp to start coding"
}

verify_installation() {
    print_header "Verifying Installation"
    
    echo ""
    echo "  Checking installed tools:"
    echo ""
    
    # GCC
    if command -v g++ &> /dev/null; then
        print_success "g++: $(g++ --version | head -n1)"
    else
        print_error "g++ not found"
    fi
    
    # Clang
    if command -v clang++ &> /dev/null; then
        print_success "clang++: $(clang++ --version | head -n1)"
    else
        print_warning "clang++ not found (optional)"
    fi
    
    # CMake
    if command -v cmake &> /dev/null; then
        print_success "cmake: $(cmake --version | head -n1)"
    else
        print_error "cmake not found"
    fi
    
    # Make
    if command -v make &> /dev/null; then
        print_success "make: $(make --version | head -n1)"
    else
        print_error "make not found"
    fi
    
    # GDB
    if command -v gdb &> /dev/null; then
        print_success "gdb: $(gdb --version | head -n1)"
    else
        print_warning "gdb not found"
    fi
    
    # Valgrind
    if command -v valgrind &> /dev/null; then
        print_success "valgrind: $(valgrind --version)"
    else
        print_warning "valgrind not found"
    fi
    
    # clang-format
    if command -v clang-format &> /dev/null; then
        print_success "clang-format: $(clang-format --version)"
    else
        print_warning "clang-format not found"
    fi
}

print_usage_guide() {
    print_header "Usage Guide"
    
    echo ""
    echo "  QUICK START:"
    echo "  ─────────────────────────────────────────────────────────────"
    echo "  1. Open this folder in VS Code:"
    echo "     code ."
    echo ""
    echo "  2. Install recommended extensions (VS Code will prompt)"
    echo ""
    echo "  3. Build and run:"
    echo "     - Press Ctrl+Shift+B → Select 'Build Current File (Debug)'"
    echo "     - Press F5 to debug"
    echo ""
    echo "  MAKEFILE COMMANDS:"
    echo "  ─────────────────────────────────────────────────────────────"
    echo "  make all            - Build project"
    echo "  make debug          - Build with debug flags"
    echo "  make release        - Build with optimizations"
    echo "  make run            - Build and run"
    echo "  make clean          - Clean build files"
    echo "  make full-pipeline  - Run all 4 compilation steps"
    echo "  make help           - Show all available commands"
    echo ""
    echo "  CMAKE COMMANDS:"
    echo "  ─────────────────────────────────────────────────────────────"
    echo "  cmake -B build/cmake -DCMAKE_BUILD_TYPE=Debug ."
    echo "  cmake --build build/cmake"
    echo "  ./build/cmake/bin/cpp_project"
    echo ""
    echo "  KEYBOARD SHORTCUTS (VS Code):"
    echo "  ─────────────────────────────────────────────────────────────"
    echo "  Ctrl+Shift+B    - Build"
    echo "  F5              - Start debugging"
    echo "  F9              - Toggle breakpoint"
    echo "  F10             - Step over"
    echo "  F11             - Step into"
    echo "  Shift+F11       - Step out"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

main() {
    print_header "C++ Development Environment Setup"
    
    echo ""
    echo "  This script will install:"
    echo "  • GCC/G++ (C++ compiler)"
    echo "  • Clang/LLVM (alternative compiler)"
    echo "  • CMake (build system)"
    echo "  • GDB, Valgrind (debugging & profiling)"
    echo "  • Analysis tools (nm, objdump, cppcheck)"
    echo ""
    
    read -p "  Continue? [Y/n] " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z $REPLY ]]; then
        echo "Aborted."
        exit 1
    fi
    
    detect_package_manager
    install_build_essentials
    install_gcc
    install_clang
    install_cmake
    install_debugging_tools
    install_analysis_tools
    install_documentation_tools
    create_directory_structure
    create_sample_files
    verify_installation
    print_usage_guide
    
    print_header "Setup Complete!"
    echo ""
    echo "  Your C++ development environment is ready!"
    echo "  Open this folder in VS Code and start coding."
    echo ""
}

# Run main function
main "$@"
