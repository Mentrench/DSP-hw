%{
%Setup Values
w = linspace(0, pi, 500); %Frequency range
hA = [0.3, -1, 0.3];
hB = [0.3, 1, 0.3];

HA = freqz(hA, 1, w);
HB = freqz(hB, 1, w);

% Plot the frequency response of both filters
figure;
plot(w/pi, abs(HA), 'b', 'LineWidth', 2); hold on;
plot(w/pi, abs(HB), 'r', 'LineWidth', 2);
grid on;
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');
title('Frequency Response of Filters');
legend('Filter A', 'Filter B');
%}

[phi, t] = srrc_pulse(T, over, A, a);

T = 0.1;
over = 10;
a = 0.5;
A = 5;
Ts = T/over;

%Part 1
N = 10^5;
b = (sign(randn(N, 1)) + 1) / 2;

%Part 2
symbols = 2*b - 1;

%Part 3
X_delta = 1/Ts * upsample(symbols, over);
time = linspace(0,N*T,N*over);

%Part 4
X = conv(phi, X_delta) * Ts;
X_time = time(1) + t(1) : Ts : time(end) + t(end) - Ts;

%Part 5
[ h1 , h1_time ] = srrc_pulse (T , over , A , a ) ;
Y = conv (X , h1 ) * Ts ;
Y_time = X_time (1) + h1_time (1) : Ts : X_time ( end ) + h1_time ( end ) ;

%Part 6 
sample_times = (0: N -1) * T ;
idx = ismember ( round ( Y_time ,2) , round ( sample_times ,2) ) > 0;
Y_sampled = Y ( idx ) ;
msv = ( max ( abs ( Y_sampled ) ) ^2) ;

%Part 7
sigma = sqrt ( msv ) : -0.001: sqrt ( msv /20) ;
N0 = sigma .^2;

%Part 8
SNR = msv ./( N0 ) ;
SNR_dB = 10* log10 ( SNR ) ;

%Part 9
BER_theory = 0.5* erfc ( sqrt ( SNR ) / sqrt (2) ) ;

%Part 10-13
BER_sim = zeros(1, length(sigma));

for k = 1:length(sigma)
    % Step 10
    noise = sigma(k) * randn(size(Y));
    Y_noisy = Y + noise;
    
    % Step 11
    Y_sampled = Y_noisy(idx);
    detected_symbols = sign(Y_sampled);
    
    % Step 12
    errors = sum(detected_symbols(:) ~= symbols(:));
    BER_sim(k) = errors / length(symbols);
end % Step 13

% Step 14
figure;
semilogy(SNR_dB, BER_theory, 'b-', 'LineWidth', 2); 
hold on; grid on;
semilogy(SNR_dB, BER_sim, 'r*', 'MarkerSize', 6);
xlabel('SNR (dB)');
ylabel('BER');
title('Bit Error Rate vs SNR');
legend('Theory', 'Simulation', 'Location', 'northeast');
axis([0 14 10^-6 10^0]);