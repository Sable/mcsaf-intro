function [x] = local_function()
    1+1;
    a = simple_function(1);
    a = simple_function(2);
end

function [y] = simple_function(a)
	if a == 1
		y = 5;
	else
		y = 6;
	end
end
