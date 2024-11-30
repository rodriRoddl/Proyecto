% Parámetros del sistema
T_cycle = 0.02; % Duración del ciclo (en segundos)
T_guard = 0.0001; % Tiempo de guarda (en segundos)
N = 10; % Número de ONUs
R = 1e9; % Tasa de datos (en bits/s)
W = rand(1, N); % Pesos SLA aleatorios para cada ONU
W = W / sum(W); % Normalización de W

% Cálculo de ancho de banda mínimo
B_min = (T_cycle - 2 * N * T_guard) * W * R / (8 * sum(W));

% Simulación de solicitudes de ancho de banda (EF, AF, BE)
EF_requests = rand(1, N) * 1e7; % Solicitudes EF aleatorias (bits)
AF_requests = rand(1, N) * 1e7; % Solicitudes AF aleatorias (bits)
BE_requests = rand(1, N) * 1e7; % Solicitudes BE aleatorias (bits)

% Ancho de banda total solicitado
Total_requests = EF_requests + AF_requests + BE_requests;

% Cálculo del ancho de banda otorgado
B_granted = min(Total_requests, B_min);

% Tiempos de latencia simulados
latency = Total_requests ./ B_granted; % Latencia aproximada (en segundos)

% Gráficos
figure;
subplot(2, 1, 1);
hold on;
plot(1:N, B_min, 'o-', 'LineWidth', 2, 'DisplayName', 'B_{min}');
plot(1:N, Total_requests, 'x-', 'LineWidth', 2, 'DisplayName', 'Solicitudes Totales');
plot(1:N, B_granted, 's-', 'LineWidth', 2, 'DisplayName', 'B_{otorgado}');
xlabel('ONU');
ylabel('Ancho de Banda (bits)');
title('Asignación de Ancho de Banda por ONU');
legend show;
grid on;

subplot(2, 1, 2);
plot(1:N, latency, 'o-', 'LineWidth', 2, 'DisplayName', 'Latencia');
xlabel('ONU');
ylabel('Latencia (s)');
title('Tiempos de Latencia por ONU');
legend show;
grid on;
