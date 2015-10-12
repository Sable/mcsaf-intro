SHELL := /bin/bash
TEST = ""

TESTS = \
    for_script \
    simple_function \
    basic_redefinition


.PHONY: tests $(TESTS)

tests: $(TESTS)

INSTRUMENT = java -cp .:McLabCore.jar Instrumenter
RUN_ON_MATLAB = matlab -nodisplay -r 

McLabCore.jar:
	wget https://github.com/Sable/mcsaf-intro/releases/download/comp621-2015-v0.9/McLabCore.jar

Instrumenter.class: Instrumenter.java McLabCore.jar
	javac -cp McLabCore.jar Instrumenter.java

reports: 
	mkdir reports

instrumented:
	mkdir instrumented

instrumented/profiler.m: instrumented
	cp profiler.m instrumented

$(TESTS): reports
	$(MAKE) TEST=$@ reports/$@.txt

instrumented/$(TEST).m: instrumented examples/$(TEST).m Instrumenter.class
	$(INSTRUMENT) examples/$(TEST).m > $@

reports/$(TEST).txt: instrumented/profiler.m instrumented/$(TEST).m
	cd instrumented/ && $(RUN_ON_MATLAB) "profiler('"$(TEST)"()')" > ../$@

clean:
	rm -f reports/*.txt
	rm -f instrumented/*.m
	cp profiler.m instrumented
	rm -f *.class


