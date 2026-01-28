#ifndef CONFIG_HPP
#define CONFIG_HPP
#include <iostream>
#include <string>

// ═══════════════════════════════════════════════════════════════════════════════
// Project Configuration
// ═══════════════════════════════════════════════════════════════════════════════

namespace config {

// Version information
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
#if defined(_WIN32) || defined(_WIN64)
    constexpr const char* PLATFORM = "Windows";
#elif defined(__linux__)
    constexpr const char* PLATFORM = "Linux";
#elif defined(__APPLE__)
    constexpr const char* PLATFORM = "macOS";
#else
    constexpr const char* PLATFORM = "Unknown";
#endif

// Compiler detection
#if defined(__clang__)
    constexpr const char* COMPILER = "Clang";
#elif defined(__GNUC__)
    constexpr const char* COMPILER = "GCC";
#elif defined(_MSC_VER)
    constexpr const char* COMPILER = "MSVC";
#else
    constexpr const char* COMPILER = "Unknown";
#endif

// Print build info
inline void printBuildInfo() {
    std::cout << "═══════════════════════════════════════════════════════════\n";
    std::cout << "  " << PROJECT_NAME << " v" << VERSION << "\n";
    std::cout << "═══════════════════════════════════════════════════════════\n";
    std::cout << "  Build Type: " << BUILD_TYPE << "\n";
    std::cout << "  Platform:   " << PLATFORM << "\n";
    std::cout << "  Compiler:   " << COMPILER << "\n";
    std::cout << "═══════════════════════════════════════════════════════════\n";
}

}  // namespace config

#endif  // CONFIG_HPP
