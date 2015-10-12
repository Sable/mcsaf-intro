function profiler(code)
  global g__assignment_count
  g__assignment_count = 0;
  disp(strcat('Profiling:  ', code));
  eval(code);
  disp(['# assigments: ', num2str(g__assignment_count)])
  exit(0);
end
