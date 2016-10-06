function [] = test()
  x = 1;
  y = 2;
  if (x > y)
    disp('then branch');
  elseif (x < y)
    disp('elseif branch');
  elseif (x+1 > y)
    disp('elseif branch');
  else
    disp('else branch');
  end
end
