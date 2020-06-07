global rho d;

%% half space:
% rho = 500;
% d = inf;

%% two layers:
% type = 'D';
% rho = [300, 20];
% d = [1100, inf];

% type = 'G';
% rho = [300, 1000];
% d = [1100, inf];

%% three layers:
type = 'H';
rho = [300, 20, 700];
d = [1200, 300, inf];

% type = 'K';
% rho = [100, 3200, 25];
% d = [1000, 4000, inf];

% type = 'KH';
% rho = [300, 1000, 10, 500];
% d = [800, 400, 300, inf];

nlayer = length(rho);

if(nlayer == 1)
  rdf = 1000;
  figure;
    [x, rhoa] = rhoa_curve(rdf, 1);
    loglog(x, rhoa, 'LineWidth', 2);
    hold on;

    [x, rhoa] = rhoa_curve(rdf, 3);
    loglog(x, rhoa, 'LineWidth', 2);

    grid on;
    set(gcf, 'position', [0, 0, 750, 500]);

    xlabel('\lambda_1/r', 'FontSize', 12);
    ylabel('\rho_\omega/\rho_1', 'FontSize', 12);
    title('在均匀大地表面上电偶极源频率测深曲线', 'FontSize', 14);

    legend({'\rho^E/\rho_1', '\rho^M/\rho_1'}, 'FontSize', 10);
    hold off;
else
  rdf = [2, 3, 6, 12, 20, 30, 42];
  iy = 4;

  nr = length(rdf);

  figure;
    [x, rhoa] = rhoa_curve(rdf(1), iy);
    loglog(x, rhoa, 'LineWidth', 2);
    hold on;

    for i = 2:1:nr
      [x, rhoa] = rhoa_curve(rdf(i), iy);
      loglog(x, rhoa, 'LineWidth', 2);
    end

    grid on;
    set(gcf, 'position', [0, 0, 750, 500]);

    xlabel('\lambda_1/d_1', 'FontSize', 12);
    if(iy == 1)
      ylabel('\rho^E/\rho_1', 'FontSize', 12);
    elseif(iy == 3)
      ylabel('\rho^M/\rho_1', 'FontSize', 12);
    elseif(iy == 4)
      ylabel('\rho^a/\rho_1', 'FontSize', 12);
    end
    title([type, ' 型地层频率测深振幅理论曲线'], 'FontSize', 14);

    for i = 1:1:nr
      legs{i} = sprintf('r/d_%d = %d', i, rdf(i));
    end
    legend(legs, 'FontSize', 10);
    % legend({}, 'location', 'northwest');
    hold off;
end
