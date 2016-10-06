% try/catch!
try
	a = notAFunction();
catch
	% catch block
	try
		x = 4;
	catch
		y = 2;
	end
end
