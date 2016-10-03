This is the code from COMP621 lecture on October 4th, 2016. It was updated and
adapted by Erick Lavoie from Ismail Badawi introduction given for the 2014
version of the class. An overview of McSaf is also provided as a [pdf](mcsaf-intro.pdf) 
that details the changes in McLabCore since the original design of McSaf in 
[Jessie Doherty's master thesis](http://www.sable.mcgill.ca/publications/thesis/masters-jdoherty/mcsafthesis.pdf).

RoundTrip.java: "Hello world" example that just parses an input file and
pretty prints the AST.

ReachingDefs.java: A (naive) implementation of reaching defs; parses an input file,
analyzes, and prints in sets and out sets for each statement.

Instrumenter.java: A source-to-source transformation that helps compute the number
of runtime assignments MATLAB code makes. It parses an input file and spits out
the instrumented source on stdout. This instrumented code is to be used with the
profiler.m function, which takes a string (i.e. a function call) as an argument and
evals it.

To automatically run the ReachingDefs and Instrumenter on a few simple examples:

    make

# Pre-requisite

The pre-compiled jar archive containing all the framework libraries necessary to
compile and execute the examples is available from the releases of McLabCore:

https://github.com/Sable/mclab-core/releases

The Makefile provided automatically downloads a recent release (it was the latest at the time of updating this tutorial).

# Quick reference for using the java SDK on the commandline.

To compile one of the Java classes:

    javac -cp McLabCore.jar RoundTrip.java

To use the compiled Java class to instrument a file 'mfile.m':

    java -cp .:McLabCore.jar RoundTrip mfile.m

# Version dependency

The mclab framework provided with McLabCore.jar requires Java 1.8 or greater for compilation and execution.
