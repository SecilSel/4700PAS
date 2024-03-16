% Parameters
Is = 0.01e-12;  % 0.01pA
Ib = 0.1e-12;   % 0.1pA
Vb = 1.3;       % 1.3V
Gp = 0.1;       % 0.1 Ω−1

% Create the V vector
V = linspace(-1.95, 0.7, 200);

% Create the I vector
I = Is * (exp(V*1.2 / 0.025) - 1) + Gp * V - Ib * (exp(-V*1.2 / 0.025) - 1);

% Create a second I vector with 20% random variation in the current to represent experimental noise
noise_factor = 0.2;
noise = noise_factor * randn(size(I));
I_with_noise = I + noise;

% Plot the data
figure;
subplot(2,1,1);
plot(V, I, 'b');
title('Diode Characteristics');
xlabel('Voltage (V)');
ylabel('Current (A)');
grid on;

subplot(2,1,2);
semilogy(V, abs(I_with_noise), 'r'); % Using semilogy to plot y-axis in log scale
title('Diode Characteristics with Noise');
xlabel('Voltage (V)');
ylabel('Current (A)');
grid on;

% Perform polynomial fitting

% 4th order polynomial fit
p4 = polyfit(V, I_with_noise, 4);
I_fit_4th = polyval(p4, V);

% 8th order polynomial fit
p8 = polyfit(V, I_with_noise, 8);
I_fit_8th = polyval(p8, V);

% Plot the data and polynomial fits
figure;
subplot(2,1,1);
plot(V, I_with_noise, 'r', V, I_fit_4th, 'b', V, I_fit_8th, 'g--');
title('Polynomial Fitting (With Noise)');
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original Data', '4th Order Fit', '8th Order Fit');
grid on;

subplot(2,1,2);
semilogy(V, abs(I_with_noise), 'r', V, abs(I_fit_4th), 'b', V, abs(I_fit_8th), 'g--');
title('Polynomial Fitting (With Noise) - Log Scale');
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original Data', '4th Order Fit', '8th Order Fit');
grid on;

% Define the fit type
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');

% Create the fit object
ff_all_params = fit(V', I_with_noise', fo, 'StartPoint', [1e-12, 1e-12, 1e-12, 1.3]);

% Extract the parameters
A = ff_all_params.A;
B = ff_all_params.B;
C = ff_all_params.C;
D = ff_all_params.D;

% Generate curves
I_fit_all_params = feval(ff_all_params, V);

% Plot the original data and the fitted curve
figure;
subplot(2,1,1);
plot(V, I_with_noise, 'r', V, I_fit_all_params, 'b--');
title('Nonlinear Curve Fitting (All Parameters)');
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original Data', 'Fitted Curve');
grid on;

subplot(2,1,2);
semilogy(V, abs(I_with_noise), 'r', V, abs(I_fit_all_params), 'b--');
title('Nonlinear Curve Fitting (All Parameters) - Log Scale');
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original Data', 'Fitted Curve');
grid on;

% Prepare inputs and targets
inputs = V.';
targets = I_with_noise.';

% Define the size of the hidden layer
hiddenLayerSize = 10;

% Create and configure the neural network
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the neural network
[net,tr] = train(net, inputs, targets);

% Obtain the outputs from the trained network
outputs = net(inputs);

% Calculate errors and performance
errors = gsubtract(outputs, targets);
performance = perform(net, targets, outputs);

% View the trained network
view(net);

% Extract the fitted current values
Inn = outputs;