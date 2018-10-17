# Hackarade #4: Create your own interpreter

*This is material for Hackarade #4, an internal hackathon at Cookpad Inc.*

## Goal

To be able to create an interpreter of a simple programming language.

## Abstract

An *interpreter* is a program that read a program text written by a user, and that makes a computer run as instructed.  A common interpreter has the following components:

* *parser*, which translates a user program into an internal representation called "abstract syntax tree",
* *evaluator*, which executes the instruction by walking the tree, and
* other runtimes including built-in features, memory management, etc.

Today, we will write a very simple Ruby interpreter in Ruby.  We will focus on the "evaluator".  A simple parser is provided by the organizer, and all other runtime features are "outsourced" to Ruby's ones.

## MinRuby: A Target Language

The target language (which our interpreter runs a program written in) and the host language (which we use to write our interpreter) are Ruby.  More precisely, the target language is *MinRuby*, a very simplified variant of Ruby, which includes the following features:

* Arithmetic, comparison: `1 + 2 * 3`、`42 > 40`、`3 * 4 == 5 + 7`
* Statements, variables: `x = 42; x = x + 1; p(x)`
* Branch, loop: `if 42 > 40`、`while 42 > 40`
* Function call: `p(1)`
* Function definition: `def fib(n); ...; end`
* Array and Hash: `a = [1, 2, 3]; a[1] = 42; p(a[0])`、`h = {}; h["foo"] = "bar"; p(h["foo"])`

## Abstract Syntax Tree

An abstract syntax tree (AST) is a "tree" representation of a program.  For example, we can represent a program text "`1 + 2 * 3`" as the following tree structure:

      (+)
      / \
     /   \
    1    (*)
         / \
        /   \
       2     3

This tree can be encoded in a data structure of Ruby arrays:

    ["+",
      ["lit", 1],
      ["-",
        ["lit", 2],
        ["lit", 3]]]

You can easily see the correspondence between the original tree and this data, I believe :-)  Each array corresponds to each node of the tree structure.  The first element of each array is a string that represents its node type.  The second and later elements are its child nodes and/or auxiliary data.  `"lit"` is an abbreviation of *literal*, and its second element is an integer value of the literal.

We will create an "evaluator" that traverses this tree and runs its instruction.  In the case of the tree above, we can use recursive call to "evaluate" the left and right nodes to a value (in this case, an integer), and combines the two values as the label indicates.

Here is another example.  A text "`x = 42; y = x + 1; p(y)`" can be represented as:

    ["stmts",
      ["var_assign", "x", ["lit", 42]],
      ["var_assign", "y", ["+", ["var_ref", "x"], ["lit", 1]]],
      ["func_call", "p", ["var_ref", "y"]]]

`"stmts"` is an abbreviation of *statements*, which means a sequential evaluation of one or more expressions.  `"var_assign"` is an assignment to a variable, `"var_ref"` is a reference of a variable, and `"func_call"` is a function call.  Observe the correspondence to the original text.

## Preparation

It is called "parsing" to create an AST from a program text.  The parser we use today is provided as `minruby` gem.  Please install:

```
$ gem install minruby
```

If you run the following program, you will see ASTs.  Try to parse some programs and observe the result.

```
require "pp"
require "minruby"

pp minruby_parse("1 + 2 * 3")
pp minruby_parse("(1 + 2) * 3")
pp minruby_parse("x = 42; y = x + 1; p(y)")
```

Note that you will see an error if you give a program that uses unsupported features like method call.  Also, it supports only a small subset of Ruby syntax: for example, it cannot parse "`x+=1`".  Please be patient.


## Problems 1--6

We provide `interp.rb`, an incomplete source code of a MinRuby interpreter.
Fill in the blanks so that it can run all test programs, `target*-*.rb`.

You can implement each feature in turn:

* Problem 1: Arithmetics (`target1-*.rb`)
* Problem 2: Statements and variables (`target2-*.rb`)
* Problem 3: Branches and loops (`target3-*.rb`)
* Problem 4: Function calls (`target4-*.rb`)
* Problem 5: User-defined functions (`target5-*.rb`)
* Problem 6: Arrays and Hashes (`target6-*.rb`)

The first `interp.rb` can run `target1-1.rb` as is:

```
$ ruby interp.rb target1-1.rb
2
```

However, it won't be able to run `target1-2.rb`:

```
$ ruby interp.rb target1-2.rb
Traceback (most recent call last):
	4: from interp.rb:167:in `<main>'
	3: from interp.rb:80:in `evaluate'
	2: from interp.rb:80:in `map'
	1: from interp.rb:80:in `block in evaluate'
interp.rb:19:in `evaluate': NotImplementedError (NotImplementedError)
```

Please read the code, and replace "`raise(NotImplementedError) # Problem 1`" with your code.


## Problem 7: Self-Hosting

Improve your interpreter so that it can do "self-hosting", which means that the interpreter runs itself.
It is okay if it can run as follows:

```
$ ruby interp.rb interp.rb target.rb
```

And then, if correctly implemented, the interpreter will run itself that runs itself:

```
$ ruby interp.rb interp.rb interp.rb target.rb
```

If you see a stack overflow error, you may want to set an environment variable `RUBY_THREAD_VM_STACK_SIZE` to extend the stack size:

```
$ export RUBY_THREAD_VM_STACK_SIZE=4000000
$ ruby interp.rb interp.rb fib.rb
```

### Advice for Problem 7

To do self-hosting, you need to rewrite the interpreter in MinRuby, not in Ruby.
In other words, the interpreter should be written by using only the features that it supports.
The current interpreter uses global variables, `Array#each`, `Array#map`, `require`, `minruby_parse`, etc. which are not supported by the interpreter itself.

For example, you can iterate an array without `Array#each` by using `while`:

```
i = 0
while ary[i]
  elem = ary[i]
  ...
  i = i + 1
end
```

Also, you can provide `require` as a dummy function.

The feature set of MinRuby was carefully designed so that it equips all features needed to implement a MinRuby interpreter.

Alternatively, you can enhance your interpreter to support global variables and method calls.  (However, `minruby_parse` does not support them, so you need first to enhance the parser.)


## Advanced Problems

If you have time, try the following problems.

### Implement your favorite Ruby feature

Make your MinRuby interpreter support your favorite features, e.g., blocks, class/modules, eval, callcc, etc.

### Overtake Ruby

Make your interpreter support a feature that Ruby does not support: increment/decrement operators (`++`), call by reference, lazy evaluation, static type analysis, delimited continuations, etc.

If you need syntax extension, please write your own parser first.  Piece of cake, for you?

### Implement an interpreter in a different language

Rewrite `interp.rb` in your favorite language, like Python, JavaScript, Go, Rust, Swift, Kotlin, etc.

### Do self-hosting completely

Do self-hosting without `minruby` gem.

You need to implement `minruby_parse` in MinRuby.  Recursive descent parsing would be easy.
It is too hard to implement all Ruby syntactic features; you may want to restrict your language.
(For example, you may prohibit omission of parentheses of function calls.)

### Write a compiler

Write your compiler which accepts an AST and emits a bytecode of VM that runs the instructions of the original code.
You can choose your favorite VM, or even you can design your own VM.
