clear; clc;

out = sim('Individual_1'); 

t = out.y2.Time;
y = out.y2.Data;

[f_am, t_est, t_pic, err_perm] = analizar_respuesta(t, y);

fprintf('--- RESULTADOS DE LA RESPUESTA SUBAMORTIGUADA ---\n');
fprintf('Frecuencia amortiguada: %.4f Hz\n', f_am);
fprintf('Tiempo de establecimiento (5%%): %.4f s\n', t_est);
fprintf('Tiempo de pico: %.4f s\n', t_pic);
fprintf('Error en régimen permanente: %.4f\n', err_perm);


function [f_amortiguada, t_establecimiento, t_pico, error_permanente] = analizar_respuesta(t, y)

y_final = y(end);

% 1. TIEMPO DE PICO
[~, idx_pico] = max(y);
t_pico = t(idx_pico);

% 2. FRECUENCIA AMORTIGUADA [Hz]
idx_picos = find(y(2:end-1) > y(1:end-2) & y(2:end-1) > y(3:end)) + 1;

if length(idx_picos) >= 2
    Td = t(idx_picos(2)) - t(idx_picos(1));
    f_amortiguada = 1 / Td;
else
    f_amortiguada = NaN;
end

% 3. TIEMPO DE ESTABLECIMIENTO
lim_inf = 0.95 * y_final;
lim_sup = 1.05 * y_final;

fuera_banda = find(y < lim_inf | y > lim_sup);
if ~isempty(fuera_banda)
    idx_ult = fuera_banda(end);
    if idx_ult < length(t)
        t_establecimiento = t(idx_ult + 1);
    else
        t_establecimiento = t(end);
    end
else
    t_establecimiento = 0;
end

% 4. ERROR EN RÉGIMEN PERMANENTE
referencia = 5; 
error_permanente = abs(referencia - y_final);
end