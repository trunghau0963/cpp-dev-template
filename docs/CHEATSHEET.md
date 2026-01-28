# 🚀 C++ BUILD CHEATSHEET

## ⚡ QUICK REFERENCE

### Build Commands
```bash
# VS Code
Ctrl+Shift+B              → Chọn build task

# Makefile
make                      → Build debug
make release              → Build release với -O3
make run                  → Build và chạy
make clean                → Xóa build artifacts
make help                 → Xem tất cả targets

# Manual g++
g++ -g -std=c++20 -I include src/main.cpp -o build/bin/main
./build/bin/main
```

### 4 Bước Biên Dịch
```bash
make preprocess          → .cpp → .i  (preprocessor)
make assembly            → .cpp → .s  (assembly)
make objects             → .cpp → .o  (object code)
make link                → .o   → exe (linking)
```

### Xem File Trung Gian
```bash
# Preprocessed (.i)
cat build/preprocessed/main.i | less
wc -l build/preprocessed/main.i                 # Đếm số dòng
tail -100 build/preprocessed/main.i             # 100 dòng cuối

# Assembly (.s)  
cat build/assembly/main.s | less
grep -n "^main:" build/assembly/main.s          # Tìm hàm main
sed -n '/^main:/,/^\.LFE/p' build/assembly/main.s | less  # Xem hàm main

# Object (.o)
nm -C build/objects/main.o                      # Xem symbols
nm -C build/objects/main.o | grep " T "         # Chỉ functions defined
objdump -d -C build/objects/main.o | less       # Disassemble
objdump -h build/objects/main.o                 # Xem sections
```

### Kiểm Tra Lỗi
```bash
# Verbose compile
g++ -v -std=c++20 -I include src/main.cpp 2>&1 | less

# Check preprocessor
g++ -E -I include src/main.cpp > /tmp/preprocessed.i

# Check includes
g++ -std=c++20 -I include -H src/main.cpp 2>&1 | grep include

# Syntax check only (không compile)
g++ -fsyntax-only -std=c++20 -I include src/main.cpp
```

### Debug
```bash
# Build với debug symbols
make debug

# VS Code
F5                        → Start debugging
F9                        → Toggle breakpoint
F10                       → Step over
F11                       → Step into

# GDB Terminal
gdb build/bin/app
(gdb) break main          # Breakpoint
(gdb) run                 # Start
(gdb) next                # Step over
(gdb) print x             # Print variable
(gdb) backtrace           # Stack trace
(gdb) quit                # Exit

# Valgrind (memory leak)
valgrind --leak-check=full ./build/bin/app
```

### Analysis Tools
```bash
# Symbols
nm -C file.o              → List symbols
nm -C file.o | grep " T " → Functions only

# Disassemble  
objdump -d file.o         → Disassemble
objdump -d -M intel file.o → Intel syntax
objdump -S file.o         → With source code

# Dependencies
ldd executable            → Show shared libraries
file executable           → File type info
size executable           → Section sizes
strings executable        → Extract strings

# Performance
time ./program            → Execution time
perf stat ./program       → Performance counters
```

### Compiler Flags

#### Debug Flags
```bash
-g                        # Debug symbols
-g3                       # Max debug info
-O0                       # No optimization
-DDEBUG                   # Define DEBUG macro
-Wall -Wextra             # All warnings
```

#### Release Flags
```bash
-O2                       # Standard optimization
-O3                       # Aggressive optimization
-DNDEBUG                  # Define NDEBUG (disable asserts)
-march=native             # Optimize for current CPU
-flto                     # Link-time optimization
```

#### Sanitizer Flags
```bash
-fsanitize=address        # Memory errors
-fsanitize=undefined      # Undefined behavior
-fsanitize=thread         # Data races
```

### Makefile Patterns

#### Basic Rule
```makefile
target: dependencies
	command
```

#### Pattern Rule
```makefile
%.o: %.cpp
	$(CXX) -c $< -o $@
```

#### Variables
```makefile
SRCS := $(wildcard src/*.cpp)          # Find files
OBJS := $(SRCS:.cpp=.o)                # Replace extension
OBJS := $(patsubst %.cpp,%.o,$(SRCS))  # Pattern substitute
```

#### Automatic Variables
```makefile
$@    # Target name
$<    # First dependency
$^    # All dependencies
$*    # Stem (pattern match)
```

### File Extensions

| Extension | Ý nghĩa | Tạo bằng |
|-----------|---------|----------|
| `.cpp` | C++ source | Tự viết |
| `.hpp` | C++ header | Tự viết |
| `.i` | Preprocessed | `g++ -E` |
| `.s` | Assembly | `g++ -S` |
| `.o` | Object (machine code) | `g++ -c` |
| (none) | Executable | `g++ *.o` |
| `.d` | Dependencies | `g++ -MMD` |
| `.a` | Static library | `ar` |
| `.so` | Shared library | `g++ -shared` |

### GCC/G++ Options Reference

```bash
# Compilation Stages
-E                        # Preprocess only → .i
-S                        # Compile only → .s
-c                        # Assemble only → .o
(none)                    # Full compilation → executable

# Include & Link
-I<dir>                   # Add include directory
-L<dir>                   # Add library directory
-l<name>                  # Link library (libname.a)

# Standards
-std=c++20                # C++20 standard
-std=c++17                # C++17 standard
-std=c++14                # C++14 standard

# Output
-o <file>                 # Output filename
-v                        # Verbose output
-H                        # Show include files

# Warnings
-Wall                     # All basic warnings
-Wextra                   # Extra warnings
-Wpedantic                # Pedantic warnings
-Werror                   # Treat warnings as errors

# Optimization
-O0                       # No optimization (debug)
-O1                       # Basic optimization
-O2                       # Standard optimization
-O3                       # Aggressive optimization
-Os                       # Optimize for size

# Debugging
-g                        # Debug symbols
-g3                       # Max debug info
-ggdb                     # GDB-specific debug info

# Code Generation
-fPIC                     # Position independent code
-shared                   # Create shared library
-static                   # Static linking
-march=native             # Optimize for CPU
```

### Common Error Messages

| Error | Meaning | Fix |
|-------|---------|-----|
| `expected ';'` | Thiếu dấu chấm phẩy | Thêm `;` vào dòng trước |
| `was not declared` | Biến/hàm chưa khai báo | Khai báo hoặc #include |
| `undefined reference` | Function không tìm thấy khi link | Thiếu source file hoặc library |
| `multiple definition` | Định nghĩa nhiều lần | Dùng `inline` hoặc move sang .cpp |
| `cannot open include file` | Không tìm thấy header | Check -I path |
| `invalid conversion` | Sai kiểu dữ liệu | Cast hoặc sửa type |

### Project Structure
```
project/
├── src/                  # Source .cpp files
├── include/              # Header .h/.hpp files
├── lib/                  # External libraries
├── build/                # Build outputs
│   ├── preprocessed/    # .i files
│   ├── assembly/        # .s files
│   ├── objects/         # .o files
│   └── bin/             # executables
├── .vscode/              # VS Code config
│   ├── tasks.json       # Build tasks
│   ├── launch.json      # Debug config
│   └── c_cpp_properties.json  # IntelliSense
├── Makefile              # Build automation
└── CMakeLists.txt        # CMake config
```

### Git Workflow
```bash
git status                # Check changes
git add .                 # Stage all
git commit -m "message"   # Commit
git push                  # Push to remote
git pull                  # Pull from remote
git log --oneline         # View history
```

---

## 📚 Tài Liệu Chi Tiết

Xem [docs/USAGE_GUIDE.md](USAGE_GUIDE.md) để biết thêm chi tiết!

---

**Quick Start:**
```bash
# Clone/Open project
cd cpp-dev-template

# Build
make

# Run
make run

# Debug (VS Code)
F5
```

🎯 **That's it! Happy Coding!** 🚀
