SHELL := /bin/bash

NAME=doe
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
	wget https://github.com/Sable/mclab-core/releases/download/v1.0.2/McLabCore.jar

Instrumenter.class: Instrumenter.java McLabCore.jar
	javac -cp McLabCore.jar Instrumenter.java

ReachingDefs.class: ReachingDefs.java McLabCore.jar
	javac -cp McLabCore.jar ReachingDefs.java

analysis-reports:
	mkdir analysis-reports

profiling-reports: 
	mkdir profiling-reports

instrumented:
	mkdir instrumented

instrumented/profiler.m: instrumented
	cp profiler.m instrumented

$(TESTS): profiling-reports analysis-reports
	$(MAKE) TEST=$@ profiling-reports/$@.txt
	$(MAKE) TEST=$@ analysis-reports/$@.txt

instrumented/$(TEST).m: instrumented examples/$(TEST).m Instrumenter.class
	$(INSTRUMENT) examples/$(TEST).m > $@

profiling-reports/$(TEST).txt: instrumented/profiler.m instrumented/$(TEST).m
	cd instrumented/ && $(RUN_ON_MATLAB) "profiler('"$(TEST)"()')" > ../$@

analysis-reports/$(TEST).txt: ReachingDefs.class McLabCore.jar
	java -cp McLabCore.jar:. ReachingDefs examples/$(TEST).m > $@

clean:
	rm -rf analysis-reports
	rm -rf profiling-reports
	rm -rf instrumented
	rm -f *.class

release:
	make clean
	rm McLabCore.jar
	zip -r $(NAME).zip .


