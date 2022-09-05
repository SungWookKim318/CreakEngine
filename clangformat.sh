find -E . -regex '.*\.(cpp|hpp|cc|cxx|mm|m)' -exec clang-format -style=file -i {} \;
