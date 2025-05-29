
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

    % resolucion, relacionada al 95% de la exp amortiguadora mas rapida
    re_min  = min(real(poles))
    t_step  = abs(log(.95)/re_min);
    % tiempo de sim, relacionado al 5% de la exp amortiguadora mas lenta
    re_max  = max(real(poles))
    t_max   = abs(log(.05)/re_max);
endfunction

function [tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, y)

    comment('METODO DE CHEN (polos distintos)')
    disp('  tau_1   == -t1/Ln(alpha1)')
    disp('  tau_2   == -t1/Ln(alpha2)')
    disp('  tau_3   == beta (tau_1 - tau_2) + tau_1')
    comment("Donde:")
    disp('      alpha1  == (k1 k2 + k3 - sqrt(b)) / 2(k1**2 + k2)')
    disp('      alpha2  == (k1 k2 + k3 + sqrt(b)) / 2(k1**2 + k2)')
    disp('      beta    == ((2 k1**3 + 3 k1 k2 + k3) / sqrt(b)) - 1')
    disp('      b       == 4 k1**3 k3 - 3 k1**2 k2**2 - 4 k2**3 + k3**2 + 6 k1 k2 k3')
    disp('          k1      == y(t1)/K - 1')
    disp('          k2      == y(2t1)/K - 1')
    disp('          k3      == y(3t1)/K - 1')
    disp('          K       == y(inf)')
    disp('=======================================================================')
    disp('')

    % la distancia entre los k debe ser la suficiente
    k1  = y(1)/K - 1;
    k2  = y(2)/K - 1;
    k3  = y(3)/K - 1;

    b       = 4*(k1^3)*k3 - 3*(k1^2)*(k2^2) - 4*k2^3 + k3^2 + 6*k1*k2*k3;
    alpha1  = (k1*k2 + k3 - sqrt(b)) / (2*((k1^2) + k2));
    alpha2  = (k1*k2 + k3 + sqrt(b)) / (2*((k1^2) + k2));
    bbeta   = (k1 + alpha2) / (alpha1 - alpha2);
    % ! Porque No Anda?
    % ! bbeta   = ((2*k1^3 + 3*k1*k2 + k3 - sqrt(b))) / sqrt(b)

    tau_1   = -t1/log(alpha1);
    tau_2   = -t1/log(alpha2);
    tau_3   = bbeta*(tau_1 - tau_2) + tau_1;

    % ! por hipotesis, tau_1 debe ser menor que tau_2
    if (tau_1 > tau_2) disp('Warning: tau_1 > tau_2') endif
endfunction

comment('USING MYLIB');
