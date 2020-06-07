function res = I5_kernel(lambda)

[Rv, m1] = R(lambda);

res = m1*lambda/Rv;

end
