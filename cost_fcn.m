function [s,c] = cost_fcn(x)
s = abs(sum(cos(5*x)+cos(7*x)+cos(11*x),2));
c = abs((sum(cos(x),2))/length(x) - 0.8);
end
