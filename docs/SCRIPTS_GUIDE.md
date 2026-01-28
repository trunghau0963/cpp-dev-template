# 🔧 SCRIPTS GUIDE

Hướng dẫn sử dụng các script trong workspace này.

## 📋 Danh Sách Scripts

| Script | Mục đích | Khi nào dùng |
|--------|----------|-------------|
| `setup.sh` | Cài đặt tools + khởi tạo workspace | Lần đầu setup trên máy mới |
| `init.sh` | Chỉ khởi tạo workspace structure | Clone project về, tạo cấu trúc nhanh |
| `verify.sh` | Kiểm tra workspace | Verify xem thiếu gì |

---

## 1️⃣ setup.sh - Full Setup

### Công dụng:
- Cài đặt tất cả development tools (GCC, CMake, GDB, etc.)
- Tạo directory structure
- Tạo sample files

### Khi nào dùng:
- **Máy mới**, chưa có tools
- Muốn setup môi trường hoàn chỉnh từ đầu

### Cách dùng:
```bash
chmod +x setup.sh
./setup.sh
```

### Script sẽ:
1. ✅ Detect package manager (apt/dnf/pacman)
2. ✅ Install GCC/G++ compiler
3. ✅ Install Clang/LLVM (optional)
4. ✅ Install CMake
5. ✅ Install GDB, Valgrind
6. ✅ Install analysis tools (nm, objdump, cppcheck)
7. ✅ Create directory structure
8. ✅ Create sample source files
9. ✅ Verify installation

### Yêu cầu:
- Quyền sudo (để install packages)
- Internet connection
- Ubuntu/Debian/Fedora/Arch Linux

---

## 2️⃣ init.sh - Quick Init

### Công dụng:
- Tạo directory structure
- Tạo sample files (main.cpp, config.hpp, README.md)
- **KHÔNG** cài đặt tools

### Khi nào dùng:
- Clone project về máy đã có tools
- Tạo workspace mới nhanh
- Reset workspace về trạng thái ban đầu

### Cách dùng:
```bash
chmod +x init.sh
./init.sh
```

### Script sẽ tạo:
```
project/
├── src/
│   └── main.cpp          ✅ Created
├── include/
│   └── config.hpp        ✅ Created
├── build/
│   ├── preprocessed/     ✅ Created
│   ├── assembly/         ✅ Created
│   ├── objects/          ✅ Created
│   ├── bin/              ✅ Created
│   ├── deps/             ✅ Created
│   └── cmake/            ✅ Created
├── lib/                  ✅ Created
├── tests/                ✅ Created
├── docs/                 ✅ Created
├── third_party/          ✅ Created
├── .vscode/              ✅ Created
├── README.md             ✅ Created
└── .gitignore            ✅ Created
```

### Lưu ý:
- Không overwrite files đã có
- Chỉ tạo files chưa tồn tại
- An toàn để chạy nhiều lần

---

## 3️⃣ verify.sh - Verification

### Công dụng:
- Kiểm tra workspace structure
- Liệt kê missing files
- Show statistics

### Khi nào dùng:
- Sau khi clone project
- Trước khi build
- Debug workspace issues

### Cách dùng:
```bash
./verify.sh
```

### Output ví dụ:
```
═══════════════════════════════════════════════════════════
  Verifying C++ Workspace Structure
═══════════════════════════════════════════════════════════

📁 Required Directories:
✓ src
✓ include
✓ build
✗ build/preprocessed (missing)

📝 Source Files:
✓ src/main.cpp

⚙️  Build Configuration:
✓ Makefile
○ CMakeLists.txt (optional)

🔧 Development Tools:
✓ g++ - g++ (Ubuntu 13.3.0) 13.3.0
✓ make - GNU Make 4.3
✗ cmake (not installed)

📦 Version Control:
✓ Git repository initialized

═══════════════════════════════════════════════════════════
  Verification Summary
═══════════════════════════════════════════════════════════

⚠️  1 required items are missing

💡 Next Steps:
  1. Run ./init.sh to create missing files
```

### Exit Code:
- `0` = All OK
- `> 0` = Number of missing required items

---

## 🔄 Workflow Thực Tế

### Scenario 1: Máy Mới (Chưa có tools)
```bash
# Bước 1: Clone repo
git clone <repo-url>
cd cpp-dev-template

# Bước 2: Run setup (install tools + create structure)
./setup.sh

# Bước 3: Verify
./verify.sh

# Bước 4: Build
make
```

### Scenario 2: Máy Đã Có Tools
```bash
# Bước 1: Clone repo
git clone <repo-url>
cd cpp-dev-template

# Bước 2: Quick init (chỉ tạo structure)
./init.sh

# Bước 3: Build
make
```

### Scenario 3: Reset Workspace
```bash
# Clean build
make clean

# Re-init (không xóa source files)
./init.sh

# Verify
./verify.sh
```

### Scenario 4: Template Cho Project Mới
```bash
# Bước 1: Copy template
cp -r cpp-dev-template my-new-project
cd my-new-project

# Bước 2: Remove old git
rm -rf .git

# Bước 3: Init structure
./init.sh

# Bước 4: Init new git
git init
git add .
git commit -m "Initial commit from template"

# Bước 5: Start coding
code src/main.cpp
```

---

## 📊 So Sánh Scripts

| Feature | setup.sh | init.sh | verify.sh |
|---------|----------|---------|-----------|
| **Install tools** | ✅ | ❌ | ❌ |
| **Create dirs** | ✅ | ✅ | ❌ |
| **Create files** | ✅ | ✅ | ❌ |
| **Check tools** | ✅ | ❌ | ✅ |
| **Check structure** | ❌ | ❌ | ✅ |
| **Needs sudo** | ✅ | ❌ | ❌ |
| **Time** | ~5-10 min | ~1 sec | ~1 sec |

---

## 🛠️ Troubleshooting

### "Permission denied"
```bash
chmod +x setup.sh init.sh verify.sh
```

### "Command not found" sau setup.sh
```bash
# Reload shell
source ~/.bashrc
# Hoặc
hash -r
```

### Script báo missing files nhưng files đã có
```bash
# Check file paths (case-sensitive)
ls -la src/
ls -la include/

# Re-run init
./init.sh
```

### Muốn xóa toàn bộ và start over
```bash
# CẢNH BÁO: Sẽ xóa toàn bộ build artifacts
make clean

# Hoặc xóa hoàn toàn
rm -rf build/*

# Re-init
./init.sh
```

---

## 💡 Tips & Best Practices

### 1. Luôn verify trước khi build
```bash
./verify.sh && make
```

### 2. Tạo alias cho convenience
```bash
# Thêm vào ~/.bashrc
alias cpp-verify='./verify.sh'
alias cpp-init='./init.sh'
alias cpp-build='make clean && make'
```

### 3. CI/CD Integration
```yaml
# .github/workflows/build.yml
steps:
  - name: Verify workspace
    run: ./verify.sh
    
  - name: Build
    run: make
```

### 4. Docker
```dockerfile
FROM ubuntu:24.04
WORKDIR /app
COPY . .
RUN ./setup.sh
RUN make
```

---

## 📚 Related Documentation

- [USAGE_GUIDE.md](USAGE_GUIDE.md) - Hướng dẫn build & debug
- [CHEATSHEET.md](CHEATSHEET.md) - Quick reference
- [README.md](../README.md) - Project overview

---

**Last Updated:** January 28, 2026
