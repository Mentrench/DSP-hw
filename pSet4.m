
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



