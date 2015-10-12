SHELL := /bin/bash
TEST = ""

TESTS = \
    empty_lines \
    for_script \
    if_script \
    multiline_script \
    multiple_functions \
    simple_function \
    simple_script \
    while_script


.PHONY: tests $(TESTS)

tests: $(TESTS)

INSTRUMENT = java -cp .:../McLabCore.jar Instrumenter
RUN_ON_MATLAB = matlab -nodisplay -r 

Instrumenter.class: Instrumenter.java
	javac -cp ../McLabCore.jar Instrumenter.java


$(TESTS): 
	$(MAKE) TEST=$@ reports/$@.txt

instrumented/$(TEST).m: examples/$(TEST).m Instrumenter.class
	$(INSTRUMENT) examples/$(TEST).m > $@

reports/$(TEST).txt: instrumented/$(TEST).m
	cd instrumented/ && $(RUN_ON_MATLAB) "profiler('"$(TEST)"()')" > ../$@

clean:
	rm -f reports/*.txt
	rm -f instrumented/*.m
	cp profiler.m instrumented
	rm -f *.class


