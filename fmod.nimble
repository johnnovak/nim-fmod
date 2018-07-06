# Package

version       = "0.1.0"
author        = "John Novak"
description   = "Nim wrapper for the FMOD Low Level C API"
license       = "MIT"

skipDirs = @["examples"]

# Dependencies

requires "nim >= 0.18.0"

# Tasks

task compileExamples, "Compiles the examples":
  exec "nim c examples/playsound"
  exec "nim c examples/usercreatedsound"
