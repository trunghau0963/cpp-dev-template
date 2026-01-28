# ═══════════════════════════════════════════════════════════════════════════════
#                         PROFESSIONAL C++ MAKEFILE
# ═══════════════════════════════════════════════════════════════════════════════
# Makefile này thể hiện rõ ràng 4 bước biên dịch C++:
# 1. Preprocessing: .cpp → .i
# 2. Compilation:   .cpp → .s (assembly)
# 3. Assembly:      .cpp → .o (object)
# 4. Linking:       .o   → executable
# ═══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# COMPILER SETTINGS
# ─────────────────────────────────────────────────────────────────────────────
CXX           := g++
CXXSTANDARD   := -std=c++20

# ─────────────────────────────────────────────────────────────────────────────
# DIRECTORIES
# ─────────────────────────────────────────────────────────────────────────────
SRC_DIR       := src
INC_DIR       := include
BUILD_DIR     := build
LIB_DIR       := lib

# Build subdirectories - Mỗi bước biên dịch có thư mục riêng
PREPROC_DIR   := $(BUILD_DIR)/preprocessed
ASM_DIR       := $(BUILD_DIR)/assembly
OBJ_DIR       := $(BUILD_DIR)/objects
BIN_DIR       := $(BUILD_DIR)/bin
DEP_DIR       := $(BUILD_DIR)/deps

# ─────────────────────────────────────────────────────────────────────────────
# SOURCE FILES
# ─────────────────────────────────────────────────────────────────────────────
SRCS          := $(wildcard $(SRC_DIR)/*.cpp)
OBJS          := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))
PREPROCS      := $(patsubst $(SRC_DIR)/%.cpp,$(PREPROC_DIR)/%.i,$(SRCS))
ASMS          := $(patsubst $(SRC_DIR)/%.cpp,$(ASM_DIR)/%.s,$(SRCS))
DEPS          := $(patsubst $(SRC_DIR)/%.cpp,$(DEP_DIR)/%.d,$(SRCS))

# ─────────────────────────────────────────────────────────────────────────────
# OUTPUT
# ─────────────────────────────────────────────────────────────────────────────
TARGET        := $(BIN_DIR)/app

# ─────────────────────────────────────────────────────────────────────────────
# COMPILER FLAGS
# ─────────────────────────────────────────────────────────────────────────────
INCLUDES      := -I$(INC_DIR) -I$(SRC_DIR)

WARNINGS      := -Wall -Wextra -Wpedantic \
                 -Wshadow -Wconversion -Wsign-conversion

DEBUG_FLAGS   := -g3 -O0 -DDEBUG

RELEASE_FLAGS := -O3 -DNDEBUG -march=native

COMMON_FLAGS  := $(CXXSTANDARD) $(INCLUDES) $(WARNINGS)

# Default: Debug mode
CXXFLAGS      := $(COMMON_FLAGS) $(DEBUG_FLAGS)

LDFLAGS       := -L$(LIB_DIR)
LDLIBS        := -lpthread

# ─────────────────────────────────────────────────────────────────────────────
# PHONY TARGETS
# ─────────────────────────────────────────────────────────────────────────────
.PHONY: all debug release clean help dirs \
        preprocess assembly objects link \
        full-pipeline run \
        show-preprocessed show-assembly show-symbols

# ─────────────────────────────────────────────────────────────────────────────
# DEFAULT TARGET
# ─────────────────────────────────────────────────────────────────────────────
all: dirs $(TARGET)
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  ✅ BUILD SUCCESSFUL!"
	@echo "  📁 Executable: $(TARGET)"
	@echo "═══════════════════════════════════════════════════════════"

debug: CXXFLAGS = $(COMMON_FLAGS) $(DEBUG_FLAGS)
debug: clean all
	@echo "  🔧 Debug build completed"

release: CXXFLAGS = $(COMMON_FLAGS) $(RELEASE_FLAGS)
release: clean all
	@echo "  🚀 Release build completed"

# ─────────────────────────────────────────────────────────────────────────────
# DIRECTORY CREATION
# ─────────────────────────────────────────────────────────────────────────────
dirs:
	@mkdir -p $(PREPROC_DIR) $(ASM_DIR) $(OBJ_DIR) $(BIN_DIR) $(DEP_DIR)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1: PREPROCESSING (.cpp → .i)
# ─────────────────────────────────────────────────────────────────────────────
preprocess: dirs $(PREPROCS)
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  ✅ PREPROCESSING COMPLETED"
	@echo "  📁 Output: $(PREPROC_DIR)/"
	@echo "═══════════════════════════════════════════════════════════"

$(PREPROC_DIR)/%.i: $(SRC_DIR)/%.cpp
	@echo ""
	@echo "  STEP 1: Preprocessing $<"
	$(CXX) -E -P $(INCLUDES) $(CXXSTANDARD) $< -o $@
	@echo "  ✓ Output: $@"

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2: COMPILATION (.cpp → .s)
# ─────────────────────────────────────────────────────────────────────────────
assembly: dirs $(ASMS)
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  ✅ COMPILATION TO ASSEMBLY COMPLETED"
	@echo "  📁 Output: $(ASM_DIR)/"
	@echo "═══════════════════════════════════════════════════════════"

$(ASM_DIR)/%.s: $(SRC_DIR)/%.cpp
	@echo ""
	@echo "  STEP 2: Compiling to Assembly $<"
	$(CXX) -S -fverbose-asm -masm=intel $(CXXFLAGS) $< -o $@
	@echo "  ✓ Output: $@"

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3: ASSEMBLY (.cpp → .o)
# ─────────────────────────────────────────────────────────────────────────────
objects: dirs $(OBJS)
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  ✅ ASSEMBLY TO OBJECTS COMPLETED"
	@echo "  📁 Output: $(OBJ_DIR)/"
	@echo "═══════════════════════════════════════════════════════════"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo ""
	@echo "  STEP 3: Assembling to Object $<"
	$(CXX) -c $(CXXFLAGS) -MMD -MF $(DEP_DIR)/$*.d $< -o $@
	@echo "  ✓ Output: $@"

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4: LINKING (.o → executable)
# ─────────────────────────────────────────────────────────────────────────────
link: dirs $(OBJS)
	@echo ""
	@echo "  STEP 4: Linking Objects → Executable"
	$(CXX) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $(TARGET)
	@echo "  ✓ Output: $(TARGET)"

$(TARGET): $(OBJS)
	@echo ""
	@echo "  STEP 4: Linking Objects → Executable"
	$(CXX) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@
	@echo "  ✓ Output: $@"

# ─────────────────────────────────────────────────────────────────────────────
# FULL PIPELINE
# ─────────────────────────────────────────────────────────────────────────────
full-pipeline: dirs preprocess assembly objects $(TARGET)
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  ✅ FULL BUILD PIPELINE COMPLETED!"
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  📁 Preprocessed: $(PREPROC_DIR)/"
	@echo "  📁 Assembly:     $(ASM_DIR)/"
	@echo "  📁 Objects:      $(OBJ_DIR)/"
	@echo "  📁 Executable:   $(TARGET)"
	@echo "═══════════════════════════════════════════════════════════"

# ─────────────────────────────────────────────────────────────────────────────
# RUN
# ─────────────────────────────────────────────────────────────────────────────
run: all
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  🚀 Running $(TARGET)"
	@echo "═══════════════════════════════════════════════════════════"
	@./$(TARGET)

# ─────────────────────────────────────────────────────────────────────────────
# ANALYSIS
# ─────────────────────────────────────────────────────────────────────────────
show-preprocessed:
	@echo "Preprocessed files:"
	@ls -la $(PREPROC_DIR)/ 2>/dev/null || echo "No files. Run 'make preprocess' first."

show-assembly:
	@echo "Assembly files:"
	@ls -la $(ASM_DIR)/ 2>/dev/null || echo "No files. Run 'make assembly' first."

show-symbols: objects
	@echo "Symbols in object files:"
	@for obj in $(OBJS); do \
		echo ""; \
		echo "=== $$obj ==="; \
		nm -C $$obj 2>/dev/null || echo "File not found"; \
	done

disassemble: $(TARGET)
	@echo "Disassembling $(TARGET)..."
	objdump -d -C -M intel $(TARGET) | head -100

# ─────────────────────────────────────────────────────────────────────────────
# CLEAN
# ─────────────────────────────────────────────────────────────────────────────
clean:
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  🧹 Cleaning build artifacts..."
	@echo "═══════════════════════════════════════════════════════════"
	rm -rf $(BUILD_DIR)/*
	@echo "  ✓ Cleaned"

# ─────────────────────────────────────────────────────────────────────────────
# HELP
# ─────────────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════════"
	@echo "                    C++ PROJECT MAKEFILE"
	@echo "═══════════════════════════════════════════════════════════════════"
	@echo ""
	@echo "  BUILD TARGETS:"
	@echo "    make all            Build project (default)"
	@echo "    make debug          Build with debug flags"
	@echo "    make release        Build with optimizations"
	@echo ""
	@echo "  COMPILATION STEPS:"
	@echo "    make preprocess     Step 1: .cpp → .i"
	@echo "    make assembly       Step 2: .cpp → .s"
	@echo "    make objects        Step 3: .cpp → .o"
	@echo "    make link           Step 4: .o → executable"
	@echo "    make full-pipeline  Run all 4 steps"
	@echo ""
	@echo "  RUN & ANALYSIS:"
	@echo "    make run            Build and run"
	@echo "    make show-preprocessed"
	@echo "    make show-assembly"
	@echo "    make show-symbols"
	@echo "    make disassemble"
	@echo ""
	@echo "  CLEAN:"
	@echo "    make clean          Clean all build artifacts"
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════════"

# Include dependency files
-include $(DEPS)
