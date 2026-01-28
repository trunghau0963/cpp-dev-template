#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
#                    WORKSPACE VERIFICATION SCRIPT
# ═══════════════════════════════════════════════════════════════════════════════
# Kiểm tra workspace có đầy đủ files và folders chưa
# Usage: ./verify.sh
# ═══════════════════════════════════════════════════════════════════════════════

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

check_exists() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1 ${YELLOW}(missing)${NC}"
        return 1
    fi
}

check_optional() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${YELLOW}○${NC} $1 ${YELLOW}(optional)${NC}"
    fi
}

print_header "Verifying C++ Workspace Structure"

MISSING=0

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK REQUIRED DIRECTORIES
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "📁 Required Directories:"
check_exists "src" || ((MISSING++))
check_exists "include" || ((MISSING++))
check_exists "build" || ((MISSING++))
check_exists "build/preprocessed" || ((MISSING++))
check_exists "build/assembly" || ((MISSING++))
check_exists "build/objects" || ((MISSING++))
check_exists "build/bin" || ((MISSING++))
check_exists "build/deps" || ((MISSING++))

echo ""
echo "📁 Optional Directories:"
check_optional "lib"
check_optional "tests"
check_optional "docs"
check_optional "third_party"
check_optional ".vscode"
check_optional "build/cmake"

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK SOURCE FILES
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "📝 Source Files:"
check_exists "src/main.cpp" || ((MISSING++))

echo ""
echo "📝 Header Files:"
check_optional "include/config.hpp"
check_optional "include/utils.hpp"

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK BUILD CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "⚙️  Build Configuration:"
check_optional "Makefile"
check_optional "CMakeLists.txt"

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK VS CODE CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "⚙️  VS Code Configuration:"
check_optional ".vscode/tasks.json"
check_optional ".vscode/launch.json"
check_optional ".vscode/c_cpp_properties.json"
check_optional ".vscode/settings.json"
check_optional ".vscode/extensions.json"

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK PROJECT FILES
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "📄 Project Files:"
check_optional "README.md"
check_optional ".gitignore"
check_optional ".clang-format"

echo ""
echo "📚 Documentation:"
check_optional "docs/USAGE_GUIDE.md"
check_optional "docs/CHEATSHEET.md"

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK TOOLS
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "🔧 Development Tools:"

check_tool() {
    if command -v $1 &> /dev/null; then
        VERSION=$($1 --version 2>&1 | head -n1)
        echo -e "${GREEN}✓${NC} $1 - $VERSION"
    else
        echo -e "${RED}✗${NC} $1 ${YELLOW}(not installed)${NC}"
    fi
}

check_tool "g++"
check_tool "gcc"
check_tool "make"
check_tool "cmake"
check_tool "gdb"
check_tool "valgrind"

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK GIT
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "📦 Version Control:"
if [ -d ".git" ]; then
    echo -e "${GREEN}✓${NC} Git repository initialized"
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "  Current branch: $BRANCH"
else
    echo -e "${YELLOW}○${NC} Git not initialized (run: git init)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK BUILD ARTIFACTS
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "🏗️  Build Artifacts:"

count_files() {
    local count=$(find "$1" -type f 2>/dev/null | wc -l)
    echo "$count"
}

PREPROC_COUNT=$(count_files "build/preprocessed")
ASM_COUNT=$(count_files "build/assembly")
OBJ_COUNT=$(count_files "build/objects")
BIN_COUNT=$(count_files "build/bin")

echo "  • Preprocessed files (.i): $PREPROC_COUNT"
echo "  • Assembly files (.s): $ASM_COUNT"
echo "  • Object files (.o): $OBJ_COUNT"
echo "  • Executables: $BIN_COUNT"

# ═══════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════

print_header "Verification Summary"

echo ""
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✅ All required files and directories exist!${NC}"
else
    echo -e "${RED}⚠️  $MISSING required items are missing${NC}"
fi

echo ""
echo "📊 Workspace Statistics:"
CPP_COUNT=$(find src -name "*.cpp" 2>/dev/null | wc -l)
HPP_COUNT=$(find include -name "*.h*" 2>/dev/null | wc -l)
echo "  • C++ source files: $CPP_COUNT"
echo "  • Header files: $HPP_COUNT"
echo "  • Build artifacts: $((PREPROC_COUNT + ASM_COUNT + OBJ_COUNT + BIN_COUNT))"

# Disk usage
if command -v du &> /dev/null; then
    BUILD_SIZE=$(du -sh build 2>/dev/null | cut -f1)
    echo "  • Build directory size: $BUILD_SIZE"
fi

echo ""
echo "💡 Next Steps:"
if [ $MISSING -gt 0 ]; then
    echo "  1. Run ./init.sh to create missing files"
    echo "  2. Or run ./setup.sh to install tools and create structure"
fi
echo "  • Build: make or Ctrl+Shift+B in VS Code"
echo "  • Run: make run or F5 in VS Code"
echo "  • Read: docs/USAGE_GUIDE.md for detailed guide"
echo ""

exit $MISSING
