function res = I3_kernel(lambda)

[Rv, m1] = Rs(lambda);

res = lambda^2/(lambda + m1/Rv);

end
