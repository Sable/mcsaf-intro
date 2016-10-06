% example program to catch all types of statements
% and make sure all cases are handled

% expr stmt
5 + 5;
% assign stmt
x = 5 + 5;

% while stmt
while x > 0
	% assign stmt
	x = x - 1;
	% if stmt
	if x == 9
		% continue stmt
		continue;
	end
	% break stmt
	break;
end

% if stmt
if 5
	x = 4;
% elseif branch checking
elseif 4
	x = 4;
% else branch checking
else
	x = 4;
end

% switch stmt
switch x
case 0
	% 1st case block just for checking
	x = 4;
case 1
	% 2nd case block to make sure it evals all children
	x = 4;
otherwise
	% otherwise block
	x = 4;
end

% try/catch!
try
	a = notAFunction();
catch
	% catch block
	x = 4;
end

