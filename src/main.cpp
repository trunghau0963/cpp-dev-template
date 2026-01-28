/**
 * @file main.cpp
 * @brief Main entry point - Demo của C++ project template
 *
 * File này demonstrate:
 * - Modern C++ features (C++20)
 * - Proper include structure
 * - Build system integration
 */

#include <algorithm>
#include <iostream>
#include <memory>
#include <ranges>
#include <string>
#include <vector>

// Project headers
#include "config.hpp"
#include "utils.hpp"

// ═══════════════════════════════════════════════════════════════════════════════
// Demo Functions
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * @brief Demo smart pointers
 */
void demoSmartPointers() {
    utils::printSeparator("Smart Pointers Demo");

    // unique_ptr
    auto unique = std::make_unique<utils::Example>("Unique");
    unique->print();

    // shared_ptr
    auto shared1 = std::make_shared<utils::Example>("Shared");
    auto shared2 = shared1;  // Reference count = 2
    std::cout << "Shared count: " << shared1.use_count() << "\n";

    // weak_ptr
    std::weak_ptr<utils::Example> weak = shared1;
    if (auto locked = weak.lock()) {
        locked->print();
    }
}

/**
 * @brief Demo C++20 ranges
 */
void demoRanges() {
    utils::printSeparator("C++20 Ranges Demo");

    std::vector<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    // Filter và transform với ranges
    auto result = numbers | std::views::filter([](int n) { return n % 2 == 0; }) |
                  std::views::transform([](int n) { return n * n; });

    std::cout << "Even squares: ";
    for (int n : result) {
        std::cout << n << " ";
    }
    std::cout << "\n";
}

/**
 * @brief Demo lambda expressions
 */
void demoLambdas() {
    utils::printSeparator("Lambda Expressions Demo");

    // Generic lambda (C++14)
    auto print = [](const auto& value) { std::cout << value << " "; };

    // Lambda with capture
    int multiplier = 3;
    auto multiply = [multiplier](int x) { return x * multiplier; };

    std::vector<int> nums = {1, 2, 3, 4, 5};
    std::cout << "Original: ";
    std::ranges::for_each(nums, print);

    std::cout << "\nMultiplied by " << multiplier << ": ";
    std::ranges::transform(nums, nums.begin(), multiply);
    std::ranges::for_each(nums, print);
    std::cout << "\n";
}

/**
 * @brief Demo structured bindings (C++17)
 */
void demoStructuredBindings() {
    utils::printSeparator("Structured Bindings Demo");

    std::vector<std::pair<std::string, int>> data = {{"Alice", 25}, {"Bob", 30}, {"Charlie", 35}};

    for (const auto& [name, age] : data) {
        std::cout << name << " is " << age << " years old\n";
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Main Entry Point
// ═══════════════════════════════════════════════════════════════════════════════

int main([[maybe_unused]] int argc, [[maybe_unused]] char* argv[]) {
    // Print build information
    config::printBuildInfo();

    // Run demos
    {
        utils::Timer timer("Total Execution");

        demoSmartPointers();
        demoRanges();
        demoLambdas();
        demoStructuredBindings();
    }

    utils::printSeparator("Program Completed");

    return 0;
}
