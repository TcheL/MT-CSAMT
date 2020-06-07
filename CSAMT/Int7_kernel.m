function res = I7_kernel(lambda)

[Rv, m1] = Rs(lambda);

res = lambda/(lambda + m1/Rv);

end
