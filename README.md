# LMake
An extensible cross-platform build system inspired by CMake and written in Lua

- [LMake](#lmake)
- [Motivation](#motivation)
- [Overview](#overview)

```
require 'lmake'
myPlugin = native.sharedlib {
	input = file.glob('myPlugin/*.cpp'),
	language = 'cpp',
	compiler = switch(system.platform, {
		windows = native.compilers.winsdk,
		linux = native.compilers.llvm,
		osx = native.compilers.xcode
	},
	arch = multi { 'x86', 'x86_64' }
}
```

# Motivation
(aka: What's wrong with CMake?)

CMake is a great system, but it suffers from a number of issues stemming from its initial design
choices. Here's how LMake will attempt to solve them.

* LMake *is* a build system

While LMake could be used to generate build files for GNU make, MSBuild, or others, its primary use
case is to build project directly by specifying a compiler such as GCC, clang or MSVC. With the lack
of a specific 'confugration' step, the rules for accessing and modifying different target properties
can be simplified.

* LMake projects can seamlessly integrate with any language

Adding a target type for your favourite language is almost as simple as defining a target instance.
The LMake framework includes (TODO) built-in support for C/C++, C#, Lua, Python, and all the GCC
supported languages.

* LMake runs on Lua 5.3

Targets will usually be defined in a simple, declarative style, but LMake embraces that build
processes can be complicated and allows the use of any Lua construct or library. Think of LMake as a
framework on top of Lua rather than its own programming language.

* LMake puts deployment first

LMake targets know about all their runtime dependent files, making deployment on any platform a
cinch. Just call `target.deploy(myLibrary, "directory")` (TODO).

* LMake is truly platform-independent

All LMake needs is a filesystem, a shell, and a Lua binary. Any platform-specific functionality,
path operations mainly, is defined separately making future extensions straightforward. Support for
Linux, Mac OS X, and Windows is included.

* LMake projects define more than just build steps

A target can have any number of 'actions'. Need a special command sequence to start your project?
Just embed it in your target definition, and run `lmake run myTarget`. Test results from all targets
are combined together in a single XML output, to be used by your CI system of choice or
pretty-printed to the console (TODO).

# Overview

The basic LMake element is the 'target', which is nothing more than an object created by calling
`target` and passing in a table of definitions. These definitions consist of 'properties' and
'actions'. Actions are top-level functions called by the command interpreter like 'build' and
'test', whereas properties are general-purpose mutable or immutable variables, such as 'input',
'language' or 'linkage'.


