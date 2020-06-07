function [x, y] = rhoa_curve(rdf, iy)

global rho d k2;
nlayer = length(rho);

mu0 = 4*pi*1.0e-7;
phi = pi/2;
dL = 500.0;
I = 2;
nf = 200;
if(nlayer < 3)
  ifreq = linspace(0, 5, nf);
else
  ifreq = linspace(-3, 5, nf);
end

f = zeros(nf, 1);
omega = zeros(nf, 1);

if(nlayer == 1)
  r = rdf;
  f = 10.^ifreq;
  omega = 2*pi.*f;
  k = sqrt(1i.*omega*mu0/rho);
  ikr = 1i.*k*r;

  Er = I*dL/(2*pi*r^3)*rho*cos(phi)*(1 + exp(ikr).*(1 - ikr));
  Ep = I*dL/(2*pi*r^3)*rho*sin(phi)*(2 - exp(ikr).*(1 - ikr));
  Hr = - 3*I*dL/(2*pi*r^2)*cos(phi)*(besseli(1, ikr/2).*besselk(1, ikr/2) ...
    + ikr/6.*(besseli(1, ikr/2).*besselk(0, ikr/2) ...
    - besseli(0, ikr/2).*besselk(1, ikr/2)));
  Hp = I*dL/(2*pi*r^2)*cos(phi)*besseli(1, ikr/2).*besselk(1, ikr/2);
  Hz = - 3*I*dL/(2*pi*r^4)./(k.^2)*sin(phi).*(1 - exp(ikr).*(1 - ikr ...
    - 1.0/3*(k.^2)*r^2));
else
  r = rdf*d(1);
  Intv = zeros(nf, 7);
  for i = 1:1:nf
    f(i) = 10^ifreq(i);
    omega(i) = 2*pi*f(i);
    k2 = 1i*omega(i)*mu0./rho;
    Intv(i, 1) = hankel_J1_trans(r, @Int1_kernel);
    Intv(i, 2) = hankel_J0_trans(r, @Int2_kernel);
    Intv(i, 3) = hankel_J1_trans(r, @Int3_kernel);
    Intv(i, 4) = hankel_J1_trans(r, @Int4_kernel);
    Intv(i, 5) = hankel_J0_trans(r, @Int5_kernel);
    Intv(i, 6) = hankel_J1_trans(r, @Int6_kernel);
    Intv(i, 7) = hankel_J0_trans(r, @Int7_kernel);
  end

  Er = I*dL/(2*pi)/r*cos(phi)*(1i*omega*mu0.*Intv(:, 4) ...
    - r*rho(1)*Intv(:, 5) + rho(1)*Intv(:, 6));
  Ep = I*dL/(2*pi)/r*sin(phi)*(1i*omega*mu0.*Intv(:, 4) ...
    - 1i*omega*mu0*r.*Intv(:, 7) + rho(1)*Intv(:, 6));
  Hr = - I*dL/(2*pi)/r*sin(phi)*(Intv(:, 1) + r*Intv(:, 2));
  Hp = I*dL/(2*pi)/r*cos(phi)*Intv(:, 1);
  Hz = I*dL/(2*pi)*sin(phi)*Intv(:, 3);
end

Ex = Er*cos(phi) - Ep*sin(phi);
Hy = Hr*sin(phi) + Hp*cos(phi);

PE = I*dL;
rhoEx = pi*r^3/PE*abs(Ex);
rhoHy = omega*mu0*pi^2*r^6/(PE^2).*(Hy.^2);
rhoHz = omega*mu0*2*pi*r^4/(3*PE).*abs(Hz);
rhoExHy = 1.0./(omega*mu0).*((Ex./Hy).^2);
rhoHzHy = 4.0*r^2*omega*mu0/9.0.*((Hz./Hy).^2);

lambda1 = 1000*sqrt(10*rho(1)./f);
if(nlayer == 1)
  x = lambda1/r;
else
  x = lambda1/d(1);
end

ya = zeros(nf, 5);
ya(:, 1) = abs(rhoEx)/rho(1);
ya(:, 2) = abs(rhoHy)/rho(1);
ya(:, 3) = abs(rhoHz)/rho(1);
ya(:, 4) = abs(rhoExHy)/rho(1);
ya(:, 5) = abs(rhoHzHy)/rho(1);
y = ya(:, iy);

end
