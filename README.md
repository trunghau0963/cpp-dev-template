# 🚀 Professional C++ Development Environment

Môi trường phát triển C++ chuyên nghiệp cho VS Code với cấu trúc build rõ ràng, thể hiện đầy đủ 4 bước biên dịch và handle error hiệu quả.

## � Quick Links

- **[📖 USAGE GUIDE](docs/USAGE_GUIDE.md)** - Hướng dẫn chi tiết sử dụng workspace
- **[⚡ CHEATSHEET](docs/CHEATSHEET.md)** - Quick reference commands

## 📑 Mục lục

- [Tổng quan](#-tổng-quan)
- [Cấu trúc Project](#-cấu-trúc-project)
- [Quick Start](#-quick-start)
- [Cài đặt](#-cài-đặt)
- [Quy trình biên dịch C++](#-quy-trình-biên-dịch-c)
- [Cách sử dụng](#-cách-sử-dụng)
- [VS Code Tasks](#-vs-code-tasks)
- [Debugging](#-debugging)
- [Xử lý lỗi](#-xử-lý-lỗi)
- [Best Practices](#-best-practices)

---

## 🎯 Tổng quan

Môi trường này cung cấp:

| Feature | Mô tả |
|---------|-------|
| ✅ **Cấu trúc build rõ ràng** | Mỗi bước biên dịch có thư mục riêng |
| ✅ **IntelliSense** | Auto-complete, error detection, go to definition |
| ✅ **Debugging tích hợp** | GDB debugger với breakpoints, watch, call stack |
| ✅ **Code formatting** | Clang-format tự động format code |
| ✅ **Build automation** | Tasks cho build, run, debug |
| ✅ **Error handling** | Problem matcher hiển thị lỗi trong VS Code |

---

## 📁 Cấu trúc Project

```
cpp-dev-template/
├── 📁 .vscode/                    # VS Code configuration
│   ├── tasks.json                # Build tasks
│   ├── launch.json               # Debug configuration
│   ├── c_cpp_properties.json     # IntelliSense settings
│   ├── settings.json             # Editor settings
│   └── extensions.json           # Recommended extensions
│
├── 📁 src/                        # Source files (.cpp)
│   └── main.cpp
│
├── 📁 include/                    # Header files (.h, .hpp)
│   ├── utils.hpp
│   └── config.hpp
│
├── 📁 lib/                        # External libraries
│
├── 📁 tests/                      # Unit tests
│
├── 📁 docs/                       # Documentation
│
├── 📁 third_party/                # Third-party dependencies
│
├── 📁 build/                      # ⭐ BUILD OUTPUT (4 bước biên dịch)
│   ├── 📁 preprocessed/          # Step 1: .i files (preprocessor output)
│   ├── 📁 assembly/              # Step 2: .s files (assembly code)
│   ├── 📁 objects/               # Step 3: .o files (machine code)
│   ├── 📁 bin/                   # Step 4: executables
│   ├── 📁 deps/                  # Dependency files (.d)
│   └── 📁 cmake/                 # CMake build files
│
├── .clang-format                  # Code formatting rules
├── .gitignore                     # Git ignore rules
├── CMakeLists.txt                 # CMake configuration
├── Makefile                       # Make configuration
├── setup.sh                       # Setup script
└── README.md                      # This file
```

### Giải thích thư mục `build/`

| Thư mục | Bước | Extension | Mô tả |
|---------|------|-----------|-------|
| `preprocessed/` | Step 1 | `.i` | Output của preprocessor (macro expanded, includes merged) |
| `assembly/` | Step 2 | `.s` | Assembly code (human-readable machine instructions) |
| `objects/` | Step 3 | `.o` | Object files (machine code, chưa link) |
| `bin/` | Step 4 | executable | Final executable (đã link) |

---

## ⚙️ Cài đặt

### Yêu cầu tối thiểu

- **Linux** (Ubuntu/Debian/Fedora/Arch)
- **VS Code** với C/C++ extension
- **GCC 11+** hoặc **Clang 12+**

### Bước 1: Chạy script cài đặt

```bash
# Cấp quyền execute
chmod +x setup.sh

# Chạy script
./setup.sh
```

Script sẽ cài đặt:
- GCC/G++ (compiler)
- Clang/LLVM (alternative compiler)
- CMake (build system)
- GDB (debugger)
- Valgrind (memory checker)
- Clang-format (code formatter)

### Bước 2: Cài VS Code Extensions

Mở VS Code, nó sẽ tự động suggest các extensions cần thiết. Hoặc cài manual:

```bash
# Required
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cmake-tools

# Recommended
code --install-extension xaver.clang-format
code --install-extension formulahendry.code-runner
```

### Bước 3: Tạo build directories

```bash
# Tạo thư mục cho từng bước biên dịch
mkdir -p build/{preprocessed,assembly,objects,bin,deps,cmake}
```

---

## 🔄 Quy trình biên dịch C++

### Tổng quan 4 bước

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      C++ COMPILATION PIPELINE                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────┐    ┌──────────────┐    ┌───────────┐    ┌────────────┐    │
│  │  .cpp   │ -> │ Preprocessor │ -> │  Compiler │ -> │  Assembler │    │
│  │  .h     │    │              │    │           │    │            │    │
│  └─────────┘    └──────────────┘    └───────────┘    └────────────┘    │
│                        │                  │                 │           │
│                        ▼                  ▼                 ▼           │
│                   ┌────────┐         ┌────────┐        ┌────────┐      │
│                   │  .i    │         │  .s    │        │  .o    │      │
│                   │ file   │         │ file   │        │ file   │      │
│                   └────────┘         └────────┘        └────────┘      │
│                                                              │          │
│                                                              ▼          │
│                                                        ┌──────────┐    │
│                                                        │  Linker  │    │
│                                                        └──────────┘    │
│                                                              │          │
│                                                              ▼          │
│                                                        ┌──────────┐    │
│                                                        │ .exe/.out│    │
│                                                        │executable│    │
│                                                        └──────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Chi tiết từng bước

#### Step 1: Preprocessing (`.cpp` → `.i`)

```bash
g++ -E -P main.cpp -o build/preprocessed/main.i -I include
```

| Flag | Ý nghĩa |
|------|---------|
| `-E` | Chỉ chạy preprocessor |
| `-P` | Không in line markers |
| `-I` | Thêm include path |

**Preprocessor làm gì?**
- Xử lý `#include` - chèn nội dung header files
- Mở rộng `#define` macros
- Xử lý `#ifdef`, `#ifndef`, `#endif` - conditional compilation
- Xử lý `#pragma` directives

**Lỗi thường gặp:**
```
fatal error: myheader.h: No such file or directory
```
→ Thiếu header file hoặc sai include path

#### Step 2: Compilation (`.cpp` → `.s`)

```bash
g++ -S -fverbose-asm -masm=intel main.cpp -o build/assembly/main.s -I include -std=c++20
```

| Flag | Ý nghĩa |
|------|---------|
| `-S` | Output assembly code |
| `-fverbose-asm` | Assembly có comments |
| `-masm=intel` | Intel syntax (dễ đọc) |

**Compiler làm gì?**
- Phân tích cú pháp (syntax analysis)
- Kiểm tra ngữ nghĩa (semantic analysis)
- Tối ưu hóa code
- Chuyển thành assembly instructions

**Lỗi thường gặp:**
```cpp
error: 'x' was not declared in this scope
error: expected ';' before '}' token
error: no matching function for call to 'foo(int, int)'
```

#### Step 3: Assembly (`.s` → `.o`)

```bash
g++ -c main.cpp -o build/objects/main.o -I include -std=c++20 -g
```

| Flag | Ý nghĩa |
|------|---------|
| `-c` | Compile và assemble, không link |
| `-g` | Thêm debug symbols |

**Assembler làm gì?**
- Chuyển assembly thành machine code
- Tạo object file với relocatable addresses
- Tạo symbol table

**Lỗi thường gặp:**
- Rất hiếm có lỗi ở bước này
- Nếu có thường là lỗi internal compiler error

#### Step 4: Linking (`.o` → executable)

```bash
g++ build/objects/*.o -o build/bin/myapp -L lib
```

| Flag | Ý nghĩa |
|------|---------|
| `-L` | Đường dẫn tìm libraries |
| `-l` | Link với library (vd: `-lpthread`) |

**Linker làm gì?**
- Kết hợp nhiều object files
- Resolve external symbols
- Link với libraries
- Tạo executable cuối cùng

**Lỗi thường gặp:**
```
undefined reference to 'foo()'
multiple definition of 'bar'
cannot find -lmylib
```

---

## 💻 Cách sử dụng

### Quick Build (Ctrl+Shift+B)

```
┌─────────────────────────────────────────────────────────────┐
│  VS Code Tasks (Ctrl+Shift+B)                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🔨 Build Current File (Debug)     ← Default, Recommended  │
│  🚀 Build Current File (Release)                           │
│  📦 Build Project (Make)                                    │
│  🔄 Full Build Pipeline            ← Shows all 4 steps     │
│  🧹 Clean Build                                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Sử dụng Makefile

```bash
# Build nhanh (default)
make all

# Build với debug flags + sanitizers
make debug

# Build với optimization
make release

# Chạy đầy đủ 4 bước
make full-pipeline

# Chạy từng bước riêng
make preprocess    # Step 1: .cpp → .i
make assembly      # Step 2: .cpp → .s
make objects       # Step 3: .cpp → .o

# Build và chạy
make run

# Xem symbols trong object files
make show-symbols

# Disassemble executable
make disassemble

# Xóa build files
make clean

# Xem help
make help
```

### Sử dụng CMake

```bash
# Configure (chỉ cần chạy 1 lần)
cmake -B build/cmake -DCMAKE_BUILD_TYPE=Debug .

# Build
cmake --build build/cmake

# Chạy
./build/cmake/bin/cpp_project

# Xem full pipeline
cmake --build build/cmake --target full_pipeline
```

---

## 🔧 VS Code Tasks

### Task có sẵn

| Task | Keyboard | Mô tả |
|------|----------|-------|
| Build Current File (Debug) | `Ctrl+Shift+B` | Build file hiện tại với debug symbols |
| Build Current File (Release) | - | Build với optimization |
| Full Build Pipeline | - | Chạy đầy đủ 4 bước |
| Build and Run | - | Build và chạy ngay |
| Clean Build | - | Xóa tất cả build files |

### Các step riêng lẻ

| Task | Output |
|------|--------|
| 1. Preprocess | `build/preprocessed/*.i` |
| 2. Compile to Assembly | `build/assembly/*.s` |
| 3. Assemble to Object | `build/objects/*.o` |
| 4. Link | `build/bin/executable` |

### Analysis Tasks

| Task | Mô tả |
|------|-------|
| Check Syntax Only | Kiểm tra syntax không compile |
| View Preprocessor Output | Xem output preprocessor |
| Show Symbols (nm) | Hiển thị symbols trong .o |
| Disassemble (objdump) | Disassemble executable |

---

## 🐛 Debugging

### Bắt đầu Debug

1. Đặt breakpoint (click trái cạnh số dòng hoặc `F9`)
2. Press `F5` để start debugging
3. Sử dụng Debug toolbar:

```
┌───────────────────────────────────────────────────────────┐
│  ▶️ Continue (F5)   ⏸️ Pause   🔄 Restart   ⏹️ Stop       │
│  ⏭️ Step Over (F10)  ⏬ Step Into (F11)  ⏫ Step Out       │
└───────────────────────────────────────────────────────────┘
```

### Debug Configurations

| Configuration | Mô tả |
|--------------|-------|
| Debug Current File | Debug file đang mở |
| Debug with Arguments | Debug với command line args |
| Attach to Process | Attach vào process đang chạy |
| Debug with Valgrind | Memory leak detection |

### Valgrind (Memory Check)

```bash
# Check memory leaks
valgrind --leak-check=full ./build/bin/myapp

# Track memory origins
valgrind --track-origins=yes ./build/bin/myapp
```

---

## 🚨 Xử lý lỗi

### Lỗi hiển thị trong VS Code

VS Code sẽ tự động parse lỗi từ compiler và hiển thị:
- 🔴 **Error** - trong Problems panel
- 🟡 **Warning** - trong Problems panel
- Squiggles dưới code

### Bảng lỗi thường gặp

#### Preprocessor Errors (Step 1)

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| `No such file or directory` | Thiếu header | Kiểm tra include path |
| `macro "X" requires Y arguments` | Sai số tham số macro | Sửa macro call |

#### Compilation Errors (Step 2)

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| `was not declared` | Biến/function chưa khai báo | Khai báo hoặc include header |
| `expected ';'` | Thiếu semicolon | Thêm `;` |
| `no matching function` | Sai signature | Kiểm tra parameters |
| `cannot convert` | Type mismatch | Cast hoặc sửa type |

#### Linker Errors (Step 4)

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| `undefined reference` | Function chưa implement | Implement hoặc link library |
| `multiple definition` | Define nhiều lần | Dùng `inline` hoặc tách .cpp |
| `cannot find -l` | Thiếu library | Cài library hoặc sửa path |

### Debug Strategy

```
┌────────────────────────────────────────────────────────────┐
│                    DEBUG WORKFLOW                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  1. Đọc error message từ đầu đến cuối                     │
│     ↓                                                      │
│  2. Xác định file và line number                          │
│     ↓                                                      │
│  3. Xác định bước nào bị lỗi (preprocess/compile/link)    │
│     ↓                                                      │
│  4. Kiểm tra context xung quanh line đó                   │
│     ↓                                                      │
│  5. Nếu là link error → kiểm tra tất cả .cpp files       │
│     ↓                                                      │
│  6. Google error message nếu cần                          │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## 📚 Best Practices

### Code Organization

```cpp
// ✅ Good: Header guards
#ifndef MY_HEADER_HPP
#define MY_HEADER_HPP
// ... code ...
#endif

// ✅ Better: #pragma once (modern)
#pragma once
// ... code ...
```

### Include Order

```cpp
// 1. Corresponding header (for .cpp files)
#include "myclass.hpp"

// 2. C system headers
#include <cstdlib>
#include <cstring>

// 3. C++ standard library
#include <iostream>
#include <vector>
#include <string>

// 4. Other libraries
#include <boost/asio.hpp>

// 5. Project headers
#include "utils.hpp"
#include "config.hpp"
```

### Compiler Warnings

```bash
# Bật nhiều warnings
g++ -Wall -Wextra -Wpedantic -Werror

# Recommended flags
-Wshadow          # Variable shadowing
-Wconversion      # Type conversion warnings
-Wsign-conversion # Signed/unsigned conversion
-Wnull-dereference
-Wdouble-promotion
```

### Sanitizers (Debug builds)

```bash
# Address Sanitizer - detect memory errors
g++ -fsanitize=address -fno-omit-frame-pointer

# Undefined Behavior Sanitizer
g++ -fsanitize=undefined

# Both
g++ -fsanitize=address,undefined
```

---

## 🎹 Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+B` | Build |
| `F5` | Start/Continue debugging |
| `Shift+F5` | Stop debugging |
| `F9` | Toggle breakpoint |
| `F10` | Step over |
| `F11` | Step into |
| `Shift+F11` | Step out |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+`` ` | Toggle terminal |
| `Ctrl+.` | Quick fix suggestions |

---

## 📖 Tài liệu tham khảo

- [GCC Documentation](https://gcc.gnu.org/onlinedocs/)
- [Clang Documentation](https://clang.llvm.org/docs/)
- [CMake Documentation](https://cmake.org/documentation/)
- [VS Code C++ Documentation](https://code.visualstudio.com/docs/languages/cpp)
- [GDB Manual](https://sourceware.org/gdb/current/onlinedocs/gdb/)

---

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

---

**Happy Coding! 🚀**

---

## 🎓 HƯỚNG DẪN SỬ DỤNG

### ⚡ Quick Start
```bash
# Build project
make

# Run
make run

# Debug trong VS Code
# Press F5
```

### 📖 Chi Tiết
Xem hướng dẫn đầy đủ tại:
- **[docs/USAGE_GUIDE.md](docs/USAGE_GUIDE.md)** - Hướng dẫn từng bước
- **[docs/CHEATSHEET.md](docs/CHEATSHEET.md)** - Lệnh thường dùng

### 🔨 Build Commands
```bash
make                    # Build debug
make release            # Build release  
make clean              # Clean artifacts
make run                # Build và run
make help               # Xem tất cả targets
```

### 🔍 Xem File Trung Gian
```bash
make preprocess         # .cpp → .i
make assembly           # .cpp → .s
make objects            # .cpp → .o

# Xem file
cat build/preprocessed/main.i | less
cat build/assembly/main.s | less
nm -C build/objects/main.o
```

### 🐛 Debug
```bash
# VS Code (Recommended)
F5                      # Start debugging
F9                      # Toggle breakpoint

# Terminal
gdb build/bin/app
```

---
