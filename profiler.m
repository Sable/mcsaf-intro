%
%  This profiler function abstracts the plumbing required to 
%  setup instrumentation data structures, execute instrumented scripts and functions,
%  and output profiling results. It only supports functions which take no arguments.
%
%  From a design standpoint, the main advantages of putting the plumbing required to 
%  execute instrumented code inside a 'profiler' function rather than directly in the instrumented code are that:
%  1. We avoid the extra-code that would need to be generated in the instrumented code, which would require
%     different logic to support both scripts and functions;
%  2. We can test the profiler independently of the instrumented code with small hand-written instrumented examples
%     before testing on automatically instrumented ones.
%
function profiler(call_expr)
  disp('Setup of profiling data structures');
  % We use a global variable so that it is accessible by all functions without having to modify the function
  % signatures
  global g__assignment_count
  g__assignment_count = 0;

  disp(strcat('Profiling:  ', call_expr));
  % Note that:
  % 1. 'call_expr' contains either a script call or a function call (ex: 'foo_script()' or 'foo_function()').
  % 2. MATLAB allows both scripts and functions to be called with the same syntax, using brackets (ex: 'foo_script();', 'foo_function();').
  % 3. 'eval' allows any string to be interpreted as if it was a command typed by the user in the interpreter.
  % Therefore, 'eval' allows the profiler script to execute any script or function referred to in the call_expr.

  % Case 1:    'call_expr' calls a script 
  % Ex:        eval('foo_script()');   
  % Behaviour: 1. Finds a file named 'foo_script.m' in the path, starting in the current working directory. 
  %            2. Since the file is a script (it does not contain function definitions), it executes its content line-by-line.
  %
  % Case 2:    'call_expr' calls a function with no arguments
  % Ex:        eval('foo_function()'); 
  % Behaviour: 1. Finds a file named 'foo_function' in the path, starting in the current working directory. 
  %            2. Since the file is a function (it contains at least one function definition), it calls the first function in the 'foo_function.m' file with no arguments.
  eval(call_expr);

  disp('Output profiling results');
  disp(['# assigments: ', num2str(g__assignment_count)])
  exit(0);
end
