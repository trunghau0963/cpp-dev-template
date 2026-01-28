#ifndef UTILS_HPP
#define UTILS_HPP

#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <chrono>

namespace utils {

// ═══════════════════════════════════════════════════════════════════════════════
// Utility Functions
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @brief Print a separator line
 */
inline void printSeparator(const std::string& title = "") {
    std::cout << "\n═══════════════════════════════════════════════════════════\n";
    if (!title.empty()) {
        std::cout << "  " << title << "\n";
        std::cout << "═══════════════════════════════════════════════════════════\n";
    }
}

/**
 * @brief Simple timer class for benchmarking
 */
class Timer {
public:
    Timer(const std::string& name = "Timer") 
        : name_(name), start_(std::chrono::high_resolution_clock::now()) {}
    
    ~Timer() {
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start_);
        std::cout << "[" << name_ << "] Elapsed: " << duration.count() << " μs\n";
    }

private:
    std::string name_;
    std::chrono::time_point<std::chrono::high_resolution_clock> start_;
};

/**
 * @brief Example class demonstrating modern C++ features
 */
class Example {
public:
    Example() = default;
    explicit Example(std::string name) : name_(std::move(name)) {}
    
    // Rule of 5
    ~Example() = default;
    Example(const Example&) = default;
    Example& operator=(const Example&) = default;
    Example(Example&&) noexcept = default;
    Example& operator=(Example&&) noexcept = default;
    
    [[nodiscard]] const std::string& getName() const { return name_; }
    void setName(std::string name) { name_ = std::move(name); }
    
    void print() const {
        std::cout << "Example: " << name_ << "\n";
    }

private:
    std::string name_{"default"};
};

}  // namespace utils

#endif  // UTILS_HPP
