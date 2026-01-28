# 📜 SCRIPTS OVERVIEW

Quick guide cho các script utilities trong project này.

## Available Scripts

### 🔧 setup.sh - Full Environment Setup
```bash
./setup.sh
```
- Cài đặt **tất cả development tools** (GCC, CMake, GDB, Valgrind, etc.)
- Tạo **directory structure**
- Tạo **sample files**
- **Yêu cầu:** sudo privileges, internet
- **Thời gian:** ~5-10 phút

### ⚡ init.sh - Quick Workspace Init
```bash
./init.sh
```
- Tạo **directory structure** only
- Tạo **sample files** (main.cpp, config.hpp, README.md, .gitignore)
- **KHÔNG** cài tools
- **Thời gian:** < 1 giây
- **Use case:** Clone project về, init nhanh

### ✅ verify.sh - Verification
```bash
./verify.sh
```
- Kiểm tra **workspace structure**
- List **missing files/directories**
- Check **installed tools**
- Show **statistics**
- **Exit code:** 0 = OK, >0 = số items missing

## Quick Start

### Máy mới (chưa có tools):
```bash
./setup.sh
make
```

### Máy đã có tools:
```bash
./init.sh
make
```

### Kiểm tra workspace:
```bash
./verify.sh
```

## Documentation

Xem chi tiết tại [docs/SCRIPTS_GUIDE.md](docs/SCRIPTS_GUIDE.md)
