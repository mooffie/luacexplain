
LuacExplain
===========

'luacexplain' is a small program that enhances the output of "luac -l",
and especially of "luac -l -l".

It's intended for whoever wants to understand Lua VM's instructions (or
"opcodes") better.

After every VM instruction it prints two lines:

- Pseudo code explaining what the instruction do.

- If possible, the instruction's operands in a more human-readable
  format (You have to use "luac -l -l" for this!).

The program operates like a unix pipe: you pipe the output of luac into
it.

An example
==========

Let's suppose we have the following code in test.lua:

    local c

    local function bobo(x, y)
      do
        local c = x + y
      end
      do
        local zzz = c
      end
      return "bye"
    end

Let's first run plain vanilla 'luac' on it:

    $ luac -l -l -p test.lua
    ...
    function <test.lua:4,12> (5 instructions at 0x9c521f8)
    2 params, 3 slots, 1 upvalue, 4 locals, 1 constant, 0 functions
        1    [6]     ADD          2 0 1
        2    [9]     GETUPVAL     2 0     ; c
        3    [11]    LOADK        2 -1    ; "bye"
        4    [11]    RETURN       2 2
        5    [12]    RETURN       0 1
    ...

And now let's pipe it through 'luacexplain':

    $ luac -l -l -p test.lua | luacexplain
    ...
    function <test.lua:4,12> (5 instructions at 0x9c521f8)
    2 params, 3 slots, 1 upvalue, 4 locals, 1 constant, 0 functions
        1    [6]     ADD          2 0 1
                                         ;; R(A) := RK(B) + RK(C)
                                         ;; 2<?c> 0<x> 1<y>
        2    [9]     GETUPVAL     2 0     ; c
                                         ;; R(A) := UpValue[B]
                                         ;; 2<?zzz> 0<^c>
        3    [11]    LOADK        2 -1    ; "bye"
                                         ;; R(A) := Kst(Bx)
                                         ;; 2 -1<"bye">
        4    [11]    RETURN       2 2
                                         ;; return R(A), ... ,R(A+B-2)
                                         ;; 2 2
        5    [12]    RETURN       0 1
                                         ;; return R(A), ... ,R(A+B-2)
                                         ;; --RETURN nothing--
    ...

Note the two new lines, prefixed with ";;", after each instruction.

The first line is the pseudo code. The second line is a repeat of the
operands with, when possible, additional information between angle
brackets: this information is either a variable name or a constant value.

Cool, heh?

Note how it's smart enough to recognize that register #2 first refers to
variable "c" and later to variable "zzz" (and later still to no
variable). Incidentally, note how "c" and "zzz" are printed with "?" in
front: that's because it's their place of definition (the "local" line)
where they're not "officially" recognized yet (a more exact explanation
is in the source code, if you're interested).

Upvalues are printed with "^" in front (as in "^c").

To understadd the pseduo-code --the meaning of "R()", "RK()" etc.-- you
need to know a tiny bit about the VM. You can find all the explanatory
text you need in either of:

  - ["A No-Frills Introduction to Lua 5.1 VM Instructions"](https://docs.google.com/viewer?a=v&pid=sites&srcid=ZGVmYXVsdGRvbWFpbnxydWJibGVwaWxlc3xneDo2MTdkZDIxZTZjMWFmZmJi), by Kein-Hong Man.
    You need to read **just the first two or three pages**. It's good for any Lua,
    not just 5.1.

  - The comments in [lopcodes.h](http://www.lua.org/source/5.3/lopcodes.h.html).

  - ["Lua 5.2 Bytecode and Virtual Machine"](https://github.com/dlaurie/lua52vm-tools), by Dirk Laurie (skip
    to "Instruction anatomy").

The pseudo code is taken from the 'lopcodes.h' header, which is shipped
with the program. There are actually four headers shipped: for Lua 5.0,
5.1, 5.2, 5.3, and all of them get parsed and merged so 'luacexplain'
supports all Lua versions: you don't need tell it what version of 'luac'
you're using! (Though, if you're super pedantic, you can direct
'luacexplain', via a command line option, to turn on just a specific
version of Lua opcodes; see the source code.)

Installation
============

Place all the files (the one executable and lua*-lopcodes.h) in some
directory appearing in your $PATH.

Or create a launcher script calling the executable and place it in some
'bin' folder of yours appearing in $PATH.

Operation
=========

Simply pipe luac's output to this program, as demonstrated above:

    $ luac -l -l some_script.lua | luacexplain

Or you can can supply the input as an argument:

    $ luacexplain previously_saved_luac_output.txt
