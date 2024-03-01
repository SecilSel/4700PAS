set(0, 'DefaultFigureWindowStyle', 'docked')

nx = 100;
ny = 100;
ni = 10000;
V = zeros(nx, ny);

% Set boundary conditions
V(1:nx, 1) = 1; % Left boundary
V(1:nx, end) = 1; % Right boundary
V(1, 2:ny-1) = 0; % Top boundary (insulating)
V(end, 2:ny-1) = 0; % Bottom boundary (insulating)

SidesToZero = 1;

for k = 1:ni
%    for i = 2:nx-1
%        for j = 2:ny-1
            % Finite difference iteration
            %V(i, j) = 0.25 * (V(i+1, j) + V(i-1, j) + V(i, j+1) + V(i, j-1));
            
%        end
%    end
V=imboxfilt(V,3)
    % Reset boundary conditions
    V(1:nx, 1) = 1; % Left boundary
    V(1:nx, end) = 1; % Right boundary
    V(1, 2:ny-1) = 0; % Top boundary (insulating)
    V(end, 2:ny-1) = 0; % Bottom boundary (insulating)

    % Plot the solution every 50 iterations
    if mod(k, 50) == 0
        surf(V')
        pause(0.05)
    end
end

% Calculate electric field
[Ex, Ey] = gradient(V);

% Plot electric field vectors
figure
quiver(-Ey', -Ex', 0.8)
title('Electric Field Vectors')
