# 📖 HƯỚNG DẪN SỬ DỤNG C++ WORKSPACE

## 🎯 MỤC LỤC
1. [Build Project](#1-build-project)
2. [Đọc File Trung Gian](#2-đọc-file-trung-gian)
3. [Kiểm tra Lỗi](#3-kiểm-tra-lỗi)
4. [Hiểu Makefile](#4-hiểu-makefile)
5. [Hiểu CMakeLists.txt](#5-hiểu-cmakeliststxt)
6. [Debug](#6-debug)

---

## 1. BUILD PROJECT

### 🔨 Cách 1: VS Code Tasks (Recommended)

**Trong VS Code:**
```
Ctrl+Shift+B → Chọn task
```

**Available Tasks:**
- `Build Current File (Debug)` - Build nhanh với debug symbols
- `Build Current File (Release)` - Build với optimization
- `Build Project (Make)` - Build toàn bộ với Makefile
- `Build Project (CMake)` - Build với CMake
- `Full Build Pipeline (All Steps)` - Chạy đầy đủ 4 bước

### 🔨 Cách 2: Makefile

```bash
# Build debug (default)
make

# Build release với optimization
make release

# Build và chạy
make run

# Xem tất cả targets
make help
```

**Makefile Targets Quan Trọng:**

| Command | Mục đích |
|---------|----------|
| `make all` | Build toàn bộ project |
| `make preprocess` | Chỉ chạy bước 1: .cpp → .i |
| `make assembly` | Chỉ chạy bước 2: .cpp → .s |
| `make objects` | Chỉ chạy bước 3: .cpp → .o |
| `make clean` | Xóa tất cả build artifacts |
| `make run` | Build và chạy program |

### 🔨 Cách 3: CMake

```bash
# Configure project
cmake -S . -B build/cmake -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build/cmake

# Run
./build/cmake/cpp_project
```

### 🔨 Cách 4: Trực tiếp với g++

```bash
# Debug build
g++ -g -O0 -std=c++20 -Wall -Wextra -I include src/main.cpp -o build/bin/main

# Release build
g++ -O3 -DNDEBUG -std=c++20 -Wall -I include src/main.cpp -o build/bin/main

# Chạy
./build/bin/main
```

---

## 2. ĐỌC FILE TRUNG GIAN

### 📄 STEP 1: Preprocessed File (.i)

**Tạo file .i:**
```bash
make preprocess
```

**Xem file .i:**
```bash
# Xem toàn bộ
cat build/preprocessed/main.i

# Xem số dòng
wc -l build/preprocessed/main.i

# Tìm code của mình (ở cuối file)
tail -100 build/preprocessed/main.i

# Tìm namespace
grep -n "namespace utils" build/preprocessed/main.i
```

**File .i chứa gì?**
- Tất cả `#include` đã được mở rộng
- Tất cả macro đã được thay thế
- Tất cả `#ifdef`, `#ifndef` đã được xử lý
- File gốc ~100 dòng → file .i có thể ~70,000 dòng!

**Ví dụ:**
```cpp
// main.cpp (gốc)
#include <iostream>
#define PI 3.14

int main() {
    double r = PI * 2;
}

// main.i (preprocessed)
// ... 50,000 dòng từ iostream ...

int main() {
    double r = 3.14 * 2;  // PI đã được thay thế
}
```

### 📄 STEP 2: Assembly File (.s)

**Tạo file .s:**
```bash
make assembly
```

**Xem file .s:**
```bash
# Xem toàn bộ
cat build/assembly/main.s

# Tìm hàm main
grep -n "^main:" build/assembly/main.s

# Xem hàm main
sed -n '/^main:/,/^\.LFE/p' build/assembly/main.s | less

# Đếm instructions
grep -c "^\s*[a-z]" build/assembly/main.s
```

**File .s chứa gì?**
- Assembly code (Intel syntax)
- CPU instructions: `mov`, `push`, `pop`, `call`, `ret`
- Labels và jumps
- Debug information

**Ví dụ đọc Assembly:**
```asm
main:
    push    rbp              # Save base pointer
    mov     rbp, rsp         # Set up stack frame
    sub     rsp, 16          # Allocate 16 bytes on stack
    
    mov     DWORD PTR [rbp-4], 5    # int x = 5
    mov     eax, DWORD PTR [rbp-4]  # Load x into eax
    
    call    printf           # Call printf
    
    mov     eax, 0           # return 0
    leave                    # Restore stack
    ret                      # Return
```

**Hiểu Assembly:**
- `mov dest, src` - Copy src → dest
- `push reg` - Đẩy register lên stack
- `pop reg` - Lấy giá trị từ stack
- `call func` - Gọi function
- `ret` - Return từ function

### 📄 STEP 3: Object File (.o)

**File .o đã được tạo khi:**
```bash
make objects
```

**Xem symbols trong .o:**
```bash
# List all symbols
nm -C build/objects/main.o

# Chỉ xem functions của mình
nm -C build/objects/main.o | grep -E "main|utils|config"

# Xem defined symbols (T, W)
nm -C build/objects/main.o | grep " T "
```

**Symbol types:**
- `T` - Text (code) section - function defined
- `U` - Undefined - function cần link
- `W` - Weak symbol - inline/template
- `D` - Data section - global variables
- `R` - Read-only data - constants

**Xem cấu trúc file .o:**
```bash
# File header
objdump -f build/objects/main.o

# All headers
objdump -h build/objects/main.o

# Disassemble
objdump -d -C build/objects/main.o | less

# Disassemble chỉ hàm main
objdump -d -C build/objects/main.o | sed -n '/<main>:/,/^$/p'
```

**Sections trong .o file:**
- `.text` - Code (instructions)
- `.data` - Initialized global variables
- `.bss` - Uninitialized global variables
- `.rodata` - Read-only data (string literals, const)
- `.debug_info` - Debug symbols

---

## 3. KIỂM TRA LỖI

### 🐛 Các loại lỗi thường gặp

#### **Compile-time errors:**

**Syntax Error:**
```cpp
int x = 5  // ❌ Thiếu semicolon
```
```
error: expected ',' or ';' before 'std'
```

**Undeclared Identifier:**
```cpp
std::cout << y << std::endl;  // ❌ y chưa khai báo
```
```
error: 'y' was not declared in this scope
```

**Type Mismatch:**
```cpp
int x = "hello";  // ❌ String vào int
```
```
error: invalid conversion from 'const char*' to 'int'
```

**Missing Include:**
```cpp
std::vector<int> v;  // ❌ Chưa #include <vector>
```
```
error: 'vector' is not a member of 'std'
```

#### **Link-time errors:**

**Undefined Reference:**
```cpp
// header.hpp
void myFunction();

// main.cpp
int main() {
    myFunction();  // ❌ Function declared nhưng chưa defined
}
```
```
undefined reference to `myFunction()'
```

**Multiple Definitions:**
```cpp
// Định nghĩa function trong header mà không dùng inline
// header.hpp
void func() { }  // ❌ Nếu include ở nhiều file → duplicate

// ✅ Fix:
inline void func() { }
```
```
multiple definition of `func()'
```

### 🔍 Debug Build Errors

**1. Đọc lỗi từ dưới lên:**
```
In file included from /usr/include/c++/13/bits/stl_algobase.h:71,
                 from /usr/include/c++/13/vector:60,
                 from src/main.cpp:12:
src/main.cpp:25:5: error: 'y' was not declared in this scope
   25 |     cout << y << endl;
      |             ^
```
Lỗi thực sự ở dòng cuối: `'y' was not declared`

**2. Fix từng lỗi một:**
- Compile lại sau mỗi fix
- Một lỗi có thể gây ra nhiều lỗi khác

**3. Dùng -v để verbose:**
```bash
g++ -v -std=c++20 -I include src/main.cpp 2>&1 | less
```

**4. Dùng -E để kiểm tra preprocessor:**
```bash
g++ -E -I include src/main.cpp > /tmp/preprocessed.i
less /tmp/preprocessed.i  # Xem macro có expand đúng không
```

**5. Check include paths:**
```bash
g++ -std=c++20 -I include -H src/main.cpp 2>&1 | grep "include"
```

---

## 4. HIỂU MAKEFILE

### 📖 Cấu trúc Makefile

```makefile
# ───────────────────────────────────────
# VARIABLES
# ───────────────────────────────────────
CXX       := g++                    # Compiler
CXXFLAGS  := -std=c++20 -Wall       # Compiler flags
SRC_DIR   := src                    # Source directory
SRCS      := $(wildcard $(SRC_DIR)/*.cpp)  # All .cpp files
OBJS      := $(SRCS:.cpp=.o)        # Replace .cpp → .o

# ───────────────────────────────────────
# RULES
# ───────────────────────────────────────
# Format: target: dependencies
#         command

all: $(TARGET)                      # Default target

$(TARGET): $(OBJS)                  # Executable depends on .o files
	$(CXX) $(OBJS) -o $@        # $@ = target name

%.o: %.cpp                          # Pattern rule: .cpp → .o
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:                              # Clean target
	rm -f $(OBJS) $(TARGET)
```

### 🎓 Makefile Concepts

**Variables:**
```makefile
VAR := value          # Simple assignment
VAR = value           # Recursive assignment
VAR += more           # Append

# Use: $(VAR)
```

**Automatic Variables:**
- `$@` - Target name
- `$<` - First dependency
- `$^` - All dependencies
- `$*` - Stem (pattern match)

**Functions:**
```makefile
SRCS := $(wildcard src/*.cpp)              # Find files
OBJS := $(patsubst %.cpp,%.o,$(SRCS))      # Pattern substitute
DIRS := $(dir $(SRCS))                     # Get directory
```

**Pattern Rules:**
```makefile
%.o: %.cpp
	$(CXX) -c $< -o $@
# Matches: main.cpp → main.o
```

**Phony Targets:**
```makefile
.PHONY: clean all run
# Tells make these are not real files
```

### 📋 Example: Đọc Rule trong Makefile

```makefile
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "  Compiling $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@
```

**Giải thích:**
1. **Target:** `build/objects/main.o`
2. **Dependency:** `src/main.cpp`
3. **$<** = `src/main.cpp` (first dependency)
4. **$@** = `build/objects/main.o` (target)
5. **@echo** - @ ẩn command, chỉ show output

**Khi chạy `make`:**
```bash
# make sẽ check:
# - main.o có tồn tại không?
# - main.cpp có mới hơn main.o không?
# → Nếu CẦN rebuild → chạy command
```

---

## 5. HIỂU CMakeLists.txt

### 📖 Cấu trúc CMakeLists.txt

```cmake
# ───────────────────────────────────────
# PROJECT SETUP
# ───────────────────────────────────────
cmake_minimum_required(VERSION 3.16)
project(MyProject VERSION 1.0.0)

# ───────────────────────────────────────
# COMPILER SETTINGS
# ───────────────────────────────────────
set(CMAKE_CXX_STANDARD 20)              # C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # For IntelliSense

# ───────────────────────────────────────
# DIRECTORIES
# ───────────────────────────────────────
include_directories(${CMAKE_SOURCE_DIR}/include)

# ───────────────────────────────────────
# FIND SOURCE FILES
# ───────────────────────────────────────
file(GLOB_RECURSE SOURCES 
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
)

# ───────────────────────────────────────
# CREATE EXECUTABLE
# ───────────────────────────────────────
add_executable(${PROJECT_NAME} ${SOURCES})

# ───────────────────────────────────────
# COMPILER FLAGS
# ───────────────────────────────────────
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-g -O0 -Wall)
else()
    add_compile_options(-O3 -DNDEBUG)
endif()
```

### 🎓 CMake Concepts

**Variables:**
```cmake
set(MY_VAR "value")              # Set variable
message(STATUS "${MY_VAR}")      # Print variable

# Built-in variables:
# ${CMAKE_SOURCE_DIR}  - Root directory
# ${CMAKE_BINARY_DIR}  - Build directory
# ${PROJECT_NAME}      - Project name
```

**Lists:**
```cmake
set(SOURCES main.cpp utils.cpp)  # Create list
list(APPEND SOURCES test.cpp)    # Add item
```

**Find Files:**
```cmake
file(GLOB SOURCES "src/*.cpp")           # Non-recursive
file(GLOB_RECURSE SOURCES "src/**/*.cpp") # Recursive
```

**Targets:**
```cmake
add_executable(app main.cpp)      # Executable
add_library(mylib utils.cpp)      # Library

target_link_libraries(app mylib)  # Link library to app
```

**Conditionals:**
```cmake
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-g)
endif()
```

### 🏗️ CMake Workflow

```bash
# 1. Configure (generate Makefile)
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug

# What happens:
# - Reads CMakeLists.txt
# - Checks compiler
# - Generates build/Makefile
# - Creates compile_commands.json

# 2. Build
cmake --build build

# Equivalent to:
# cd build && make

# 3. Run
./build/myapp
```

### 📋 CMake vs Makefile

| | CMake | Makefile |
|---|-------|----------|
| **Platform** | Cross-platform | Unix/Linux only |
| **Syntax** | High-level, easier | Low-level, explicit |
| **Dependencies** | Auto-detect | Manual |
| **IDE support** | Excellent | Limited |
| **Use case** | Large projects | Small projects |

---

## 6. DEBUG

### 🐞 Debug với GDB

**Trong VS Code:**
- `F5` - Start debugging
- `F9` - Toggle breakpoint
- `F10` - Step over
- `F11` - Step into
- `Shift+F11` - Step out

**Trong terminal:**
```bash
# Build với debug symbols
g++ -g -O0 src/main.cpp -o build/bin/main

# Run GDB
gdb build/bin/main

# GDB commands:
(gdb) break main          # Breakpoint at main
(gdb) run                 # Start program
(gdb) next                # Step over
(gdb) step                # Step into
(gdb) print x             # Print variable
(gdb) backtrace           # Call stack
(gdb) quit                # Exit
```

### 🔍 Memory Check với Valgrind

```bash
# Build với debug symbols
make debug

# Run valgrind
valgrind --leak-check=full ./build/bin/app

# Output:
# ==1234== HEAP SUMMARY:
# ==1234==     in use at exit: 0 bytes in 0 blocks
# ==1234==   total heap usage: 10 allocs, 10 frees
```

---

## 📚 TÓM TẮT LỆNH THƯỜNG DÙNG

### Build Commands
```bash
make                    # Build debug
make release            # Build release
make clean              # Clean
make run                # Build và run
```

### Inspection Commands
```bash
nm -C file.o            # Xem symbols
objdump -d file.o       # Disassemble
ldd executable          # Xem dependencies
file executable         # File info
size executable         # Section sizes
```

### Debug Commands
```bash
gdb ./program           # Debug
valgrind ./program      # Memory check
strace ./program        # Trace syscalls
```

### Git Commands (Bonus)
```bash
git add .
git commit -m "message"
git push
```

---

## 🎯 WORKFLOW THỰC TẾ

### 1. Coding Phase
```bash
# Edit code
code src/main.cpp

# Build (Ctrl+Shift+B in VS Code)
make

# Run
make run
```

### 2. If Build Fails
```bash
# Đọc error message
# Fix code
# Build lại
make clean && make
```

### 3. Inspect Compilation
```bash
# Xem preprocessed
make preprocess
cat build/preprocessed/main.i

# Xem assembly
make assembly
less build/assembly/main.s

# Xem symbols
nm -C build/objects/main.o
```

### 4. Debug
```bash
# Build debug
make debug

# Debug in VS Code (F5)
# Or use GDB
gdb build/bin/app
```

### 5. Release
```bash
# Build optimized
make release

# Test
./build/bin/app
```

---

Tài liệu này giúp bạn hiểu đầy đủ quy trình build C++ project mà không cần IDE! 🚀
