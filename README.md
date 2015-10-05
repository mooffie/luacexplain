
LuacExplain
===========

'luacexplain' is a small program that enhances the output of "luac -l"
(and especially of "luac -l -l").

It's intended for whoever wants to understand Lua VM's instructions (or
"opcodes") better.

After every VM instruction it prints two lines:

- Pseudo code explaining what the instruction do.
- If possible, the instruction's operands in a more human-readable format.

The program operates like a unix pipe: you pipe the output of luac into
it.

Installation
============

Place all the files (the one executable and lua*-lopcodes.h) in some
directory appearing in your $PATH.

Or create a launcher script calling the executable and place it in some
'bin' folder of yours appearing in $PATH.

Operation
=========

Simply pipe luac's output to this program:

  $ luac -l -l some_script.lua | luacexplain

An example
==========

ToDo.
