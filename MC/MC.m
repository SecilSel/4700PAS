set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',20)
set(0,'defaultaxesfontname','Calibry')
set(0,'DefaultLineLineWidth',2);

% Constants
F = 1; % Force
m = 1; % Mass
re = 0; % Probability of scattering
np = 10; % Number of particles

% Initialize arrays
dt = 1;
nt = 1000;
v = zeros(np, nt);
x = zeros(np, nt);
t = zeros(1, nt);
AveV = zeros(1, nt);
drift_velocity = zeros(1,nt);

for i = 2:nt
    t(i) = t(i-1) + dt;

    % Update velocities and positions for all particles
    v(:,i) = v(:,i-1) + F/m * dt;
    x(:,i) = x(:,i-1) + v(:,i-1) * dt + 0.5 * F/m * dt^2;

    % Determine if particles scatter at the current time step
    r = rand(np, 1) < 0.05;
    v(r,i) = -0.25 * v(r,i-1); % Elastic collision if scattered

    % Calculate average velocity for all particles
    AveV(i) = mean(v(:,i));

    % Calculate and display drift velocity
    drift_velocity(i) = mean(mean(v(:,1:i)));

    % Plotting
    subplot(3,1,1);
    plot(t(1:i), v(:,1:i)', '-');
    hold on;
    plot(t(i), AveV(i), 'r*');
    hold off;
    xlabel('time');
    ylabel('v');
    title(['Average v: ' num2str(AveV(i))]);

    subplot(3,1,2);
    plot(x(:,1:i)', v(:,1:i)', '-');
    hold on;
    plot(x(:,i), AveV(i), 'r*');
    hold off;
    xlabel('x');
    ylabel('v');

    

    subplot(3,1,3);
    plot(t(1:i), x(1:i)', '-');
    hold on;
    plot(t(1:i),drift_velocity(1:i),'g*');
    hold off;
    xlabel('time');
    ylabel('x');
    title(['Average v: ' num2str(AveV(i)) ', Drift Velocity: ' num2str(drift_velocity)]);
    
    pause(0.01);
end
