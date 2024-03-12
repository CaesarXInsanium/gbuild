# Purpose

I wish to be able to create a system build system in the GNU Guile
programming language. I already have a simple test script that I can
build off of. I will work on this while I get some more motivation for
the Vulkan Rendering Engine that I am working one.

This project will be a script and library project. It is a
library/script that runs a project file. It is greatly inspired by the
Meson build system. I just wanted something that I built myself. Not
just a script.

## `cbuild`{.verbatim}

Binary that will load the project file, and then run the relevant
commands in order to create executables and libraries

## Library

Functions that are necessary to define targets and methods of getting there.
