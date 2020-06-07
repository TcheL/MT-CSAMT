
type = 'A';
rho = [1, 20, 330];
h = [1000, 2000, inf];
h21 = [4, 10, 20, 60, 120, 240, 480];

% type = 'H';
% rho = [1, 1/19, inf];
% h = [1000, 2000, inf];
% h21 = [0.2, 0.5, 1, 2, 5, 10, 20];

% type = 'K';
% rho = [1, 19, 0];
% h = [1000, 2000, inf];
% h21 = [19/5, 19/2, 19, 38, 76, 152, 304];

% type = 'Q';
% rho = [1, 1/20, 1/400];
% h = [1000, 2000, inf];
% h21 = [0, 1, 2, 4, 8, 16, 32];

freq = 10.^linspace(-7, 3, 200);
x = 1000*sqrt(10*rho(1)./freq)/h(1);

ncurve = length(h21);

figure;
  h(2) = h21(1)*h(1);
  [rhoa, ~] = MT1DFW(rho, h, freq);
  loglog(x, rhoa, 'LineWidth', 2);
  hold on;

  for i = 2:1:ncurve
    h(2) = h21(i)*h(1);
    [rhoa, ~] = MT1DFW(rho, h, freq);
    loglog(x, rhoa, 'LineWidth', 2);
  end

  grid on;
  set(gcf, 'position', [0, 0, 750, 500]);

  xlabel('\lambda_1/h_1', 'FontSize', 12);
  ylabel('\rho_a/\rho_1', 'FontSize', 12);
  title([type, ' 型介质的视电阻率理论曲线'], 'FontSize', 14);

  for i = 1:1:nr
    legs{i} = sprintf('h_2/h_1 = %.2f', h21(i));
  end
  legend(legs, 'FontSize', 10);
  % legend({}, 'location', 'northwest');
  hold off;

