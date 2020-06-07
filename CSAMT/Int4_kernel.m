function res = I4_kernel(lambda)

[Rv, m1] = Rs(lambda);

res = 1.0/(lambda + m1/Rv);

end
