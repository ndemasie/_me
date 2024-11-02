#!/usr/bin/env bash

# References
# https://hidutil-generator.netlify.app/
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html#//apple_ref/doc/uid/DTS40017618-CH1-KEY_TABLE_USAGES
# https://apple.stackexchange.com/questions/283252/how-do-i-remap-a-key-in-macos-sierra-e-g-right-alt-to-right-control

# Keypad Num Lock (0x53) -> PageUp (0x4B)
# Print Screen (0x46) -> PageDown (0x4E)
# hidutil property --set '{"UserKeyMapping":[
#   {"HIDKeyboardModifierMappingSrc":0x700000053,"HIDKeyboardModifierMappingDst":0x70000004B},
#   {"HIDKeyboardModifierMappingSrc":0x700000046,"HIDKeyboardModifierMappingDst":0x70000004E}
# ]}'

# F11 (0x44) -> PageUp (0x4B)
# F12 (0x45) -> PageDown (0x4E)
# hidutil property --set '{"UserKeyMapping":[
#   {"HIDKeyboardModifierMappingSrc":0x700000044,"HIDKeyboardModifierMappingDst":0x70000004B},
#   {"HIDKeyboardModifierMappingSrc":0x700000045,"HIDKeyboardModifierMappingDst":0x70000004E}
# ]}'

# Right CMD (0xE7) -> Return (0x28)
hidutil property --set '{"UserKeyMapping":[
  {"HIDKeyboardModifierMappingSrc":0x7000000E7,"HIDKeyboardModifierMappingDst":0x700000028},
]}'
