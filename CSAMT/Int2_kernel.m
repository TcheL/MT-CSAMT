function res = I2_kernel(lambda)

[Rv, m1] = Rs(lambda);

res = m1/Rv*lambda/(lambda + m1/Rv);

end
