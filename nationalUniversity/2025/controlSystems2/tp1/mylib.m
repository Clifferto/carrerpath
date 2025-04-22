
% ! definir el archivo como un script file
1;

function comment(msg)
    disp('')
    disp(msg)
    disp('=======================================================================')
    disp('')
endfunction

function [t_step t_max] = get_time_params(poles)
    % descartar polo en origen si hay
    poles(poles == 0) = [];

    % si complejos, resolucion relacionada al periodo de la parte imaginaria del polo
    if any(iscomplex(poles))
        wd      = imag(poles(1));
        t_step  = 2*pi / wd;
    % si reales, resolucion relacionada al 95% de la exp amortiguadora mas rapida
    else
        re_min  = min(real(poles));
        t_step  = abs(log(.95)/re_min);
    endif
    
    % tiempo de sim, relacionado al 5% de la exp amortiguadora mas lenta: e ^ (-t RE{p}_max)
    re_max  = max(real(poles));
    t_max   = abs(log(.05)/re_max);
endfunction

function [tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, y)
    k1  = y(1)/K - 1;
    k2  = y(2)/K - 1;
    k3  = y(3)/K - 1;

    b       = 4*(k1^3)*k3 - 3*(k1^2)*(k2^2) - 4*k2^3 + k3^2 + 6*k1*k2*k3;
    alpha1  = (k1*k2 + k3 - sqrt(b)) / (2*((k1^2) + k2));
    alpha2  = (k1*k2 + k3 + sqrt(b)) / (2*((k1^2) + k2));
    bbeta   = (k1 + alpha2) / (alpha1 - alpha2);
    % ! Porque No Anda?
    % ! bbeta   = ((2*k1^3 + 3*k1*k2 + k3 - sqrt(b))) / sqrt(b)

    tau_1   = real(-t1/log(alpha1));
    tau_2   = real(-t1/log(alpha2));
    tau_3   = real(bbeta*(tau_1 - tau_2) + tau_1);

    if tau_1 < 0 disp('Warning: tau_1 < 0') endif
    if tau_2 < 0 disp('Warning: tau_2 < 0') endif
    if tau_3 < 0 disp('Warning: tau_3 < 0') endif
endfunction

comment('USING MYLIB');
