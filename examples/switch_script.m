%switch stmt
x = 3;

switch x
case 0
	% 1st case block just for checking
	x = 4
case 1
	% 2nd case block to make sure it evels all children
	x = 4;
otherwise
	% otherwise block
	x = 4
end
