function [res, m1] = R(lambda)

global rho d k2;
m = sqrt(lambda^2 - k2);

nlayer = length(d);
res = 1.0;

for i = nlayer - 1: - 1:1
  res = acoth((m(i)/m(i + 1)*rho(i)/rho(i + 1))*res);
  res = coth(m(i)*d(i) + res);
end

m1 = m(1);

end
