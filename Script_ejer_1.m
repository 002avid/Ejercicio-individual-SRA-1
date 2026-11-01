%Se limpia todo el contexto previo a esta ejecución
clear; clc;

% Ejecuta el modelo y guarda la señal en out
out = sim('Individual_1'); 

%Se separa la señal en dos vectores: Tiempo y posición
t = out.y2.Time;
y = out.y2.Data;

%Se llama a la función
[f_am, t_est, t_pic, err_perm] = signal_analyzer(t, y);

% Muestra los resultados del análisis de la señal
fprintf('Frecuencia amortiguada: %.4f Hz\n', f_am);
fprintf('Tiempo de establecimiento (5%%): %.4f s\n', t_est);
fprintf('Tiempo de pico: %.4f s\n', t_pic);
fprintf('Error en régimen permanente: %.4f\n', err_perm);

%Se define la función
function [f_amortiguada, t_establecimiento, t_pico, error_permanente] = signal_analyzer(t, y)

%Se guarda el valor final registrado de la posición de la señal
y_final = y(end);

%Se encuentra el índice del
%valor más grande en cuanto a
%posición. El valor no nos interesa y se descarta
[~, idx_pico] = max(y);
%Se calcula el tiempo correspondiente al índice encontrado
t_pico = t(idx_pico);

%Se detectan los máximos locales
idx_picos = find(y(2:end-1) > y(1:end-2) & y(2:end-1) > y(3:end)) + 1;

%Se utilizan los dos primeros picos encontrados para calcular la frecuencia
%amortiguada
Td = t(idx_picos(2)) - t(idx_picos(1));
f_amortiguada = 1 / Td;

%Se define la banda de tolerancia del 5% alrededor del valor final
lim_inf = 0.95 * y_final;
lim_sup = 1.05 * y_final;

%Se identifican los instantes en que la señal está fuera de la banda y nos
%quedamos con el último
fuera_banda = find(y < lim_inf | y > lim_sup);
idx_ult = fuera_banda(end);
t_establecimiento = t(idx_ult + 1);

%Se calcula el error permanente respecto a la referencia
referencia = 5; 
error_permanente = abs(referencia - y_final);
end