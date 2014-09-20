#!/bin/bash
# Test the substring function
source ~/.functions/substring
source ~/.functions/assert

# TODO: Pad the whitespace
# http://stackoverflow.com/questions/4409399/padding-characters-in-printf
assert true  substring "abcd"      "a"
assert false substring "abcd"      "e"
assert true  substring "abcd"      "ab"
assert true  substring "abcd"      "bc"
assert true  substring "abcd"      "cd"
assert true  substring "abcd"      "abcd"
assert false substring ""          "a"
assert true  substring "abcd efgh" "cd ef"
assert true  substring "abcd efgh" " "
