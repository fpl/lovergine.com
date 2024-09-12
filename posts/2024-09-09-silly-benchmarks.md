title: A silly benchmarking of some programming languages
date: 2024-09-09 19:00
tags: languages, benchmarking
summary: A silly benchmark for multiple languages
---

I lately wrote some silly benchmarking code inspired by [a brief article of Halim Shams](https://halimshams.medium.com/python-vs-c-speed-comparison-48187511c595), just to perform some quite dumb performance tests with multiple languages.
The whole set of test code snippets is available [here](https://github.com/fpl/silly-bench/) and includes C, Rust, Guile, Java, Perl, Tcl, Python, R, Octave, and Ruby programming languages, as available on Debian 12 (bookworm) distribution.

The home workstation used for the trials is not too recent, so slightly better results could be obtained (and expected). Of course, that code is just a long do-nothing loop, which is not for sure the most helpful type of code, but anyway, some interesting considerations can be made on the results.

The resulting running times are the following ones:

```
Lang: user time
---------------
C: 0m0,001s
Java: 0m0,038s
Guile: 0m2,644s
Rust: 0m4,639s
R: 0m14,065s
Ruby: 0m21,022s
Perl: 0m31,190s
Octave: 1m38,300s
Python: 1m39,374s
Python-range: 0m45,752s
Tcl: 13m54,620s
```

First of all, it appears evident that one does not need any particularly refined benchmarking code to get general trends on programming language performances, which are perfectly aligned with known performance tests, as obtained by well-stated benchmarking code. 
So, C and Java snippets are the clear winners, while Guile and Rust have both very respectful performances (see the **Update** section). Note that while C is built in an ELF binary, Java is running a VM, and its resulting performance reveals that the JVM is highly optimized. Not bad at all, guys. One aspect which is not evident at all is the requirement of using full-optimization for the
C compiler; otherwise, the running time would be not too far from that of Guile. Even, note that both Guile and Python use a JIT implementation.

Other languages results reveal some expected slowness, but some of them could be a surprise for someone. The terrible result of the _old glory_ Tcl, for instance, is only overtaken by the disappointing performance of Python 3.11 (but 3.12 is even a bit slower). Note that it strictly could depend on constructs used in the code snippet, as the alternative use of `range()` for Python reveals. 

Some conclusions about this silly benchmarking experiment for dummies could be: 
 * Never take the performance of (your) code for granted.
 * Interpreted languages can be performance hogs, but it is not necessarily so, and the reason could be looking at you in front of the mirror in your bathroom.
 * Some languages can be better than others for performances, but it is rarely an easy take.
 * Never, never, never think that the constructs in a language you are using are the best ones for that language. Maybe they only could be more readable for you.
 * The _one-language-fits-all_ is a belief for fools only.
 * Some old glories (Scheme Guile _docet_) can reveal unexpected speeds, but that's not necessarily true for any of them (Tcl _docet_).

## Update

[Jean Simard](https://github.com/woshilapin) pointed out after publication the missing optimization for the Rust code generation, which is similar to the C one,
and indeed, that works for Rust too, so that performances of C, Java, and Rust becomes quite comparable.  In the meantime, I added Go and a couple of other Scheme implementations to the list of benchmarked languages. Not bad at all, so the resulting times are now the following ones:
```
C: 0m0,001s
Rust: 0m0,000s
Java: 0m0,046s
Go: 0m0,607s
Chez Scheme: 0m2,203s
Guile: 0m2,643s
Racket: 0m6,278s
R: 0m17,463s
Ruby: 0m20,803s
Perl: 0m36,111s
Octave: 1m40,700s
Python: 1m50,594s
Python-range: 0m45,106s
Tcl: 13m56,178s
```
