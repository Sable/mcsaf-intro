This is the code from COMP621 lecture on October 6, 2015. It was updated and
adapted by Erick Lavoie from Ismail Badawi introduction given for the 2014
version of the class.

RoundTrip.java: "Hello world" example that just parses an input file and
pretty prints the AST.

ReachingDefs.java: A (naive) implementation of reaching defs; parses an input file,
analyzes, and prints in sets and out sets for each statement.

Instrumenter.java: A source-to-source transformation that helps compute the number
of runtime assignments MATLAB code makes. It parses an input file and spits out
the instrumented source on stdout. This instrumented code is to be used with the
profiler.m function, which takes a string (i.e. a function call) as an argument and
evals it.

To compile one of the classes:

javac -cp McLabCore.jar RoundTrip.java

To run:

java -cp .:McLabCore.jar RoundTrip mfile.m
