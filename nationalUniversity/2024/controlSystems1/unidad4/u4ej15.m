% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% ? ==========================================================================
function argouts = add_row (array_RH)

    N_COL   = size(array_RH)(2);

    argouts = array_RH(1, :)*0;
    % ! piv = (f-1, 1)
    pivot   = array_RH(end, 1);
    
    for col = 1:N_COL-1
        % ! | (f-2, 1)  (f-2, c+1) |    
        % ! | (f-1, 1)  (f-1, c+1) |    
        alpha           = array_RH(end-1:end, [1,col+1]);
        argouts(col)    = simplify(-det(alpha)/pivot);
    endfor

    if (isequal(argouts, argouts*0))
        disp('SE ANULO LA FILA -> EC AUXILIAR')
        disp('==========================================================================')
        % return argouts;
    elseif (argouts(1) == 0)
        disp('SE ANULO PRIMER ELEMENTO -> AGREGAR EPSILON')
        disp('==========================================================================')
        argouts(1) = sym('epsilon')
    else
        % return argouts;
    endif

endfunction

function argouts = do_routh_hurwitz (array_RH)
    
    argouts = array_RH;

    while (! isequal(argouts(end-1:end, 2), zeros(2, 1)))
        argouts(end+1, :) = add_row(argouts);
        % input('STEP ++ ? ')
    endwhile

endfunction

% ? ==========================================================================

% LIMITES DE ESTABILIDAD, CRITERIO DE ROUTH-HURWITZ
% ==========================================================================

% variables
syms k s real;

disp('==========================================================================')
disp('SISTEMA')
disp('==========================================================================')

G   = 1/(s + 1)^3
H   = 1
Gf  = expand(simplify(k*G/(1 + k*G*H)))

% Gf = (sym)
%              k
%   ───────────────────────
%        3      2
%   k + s  + 3⋅s  + 3⋅s + 1

array_RH    = sym([ [1  3   ];
                    [3  1+k ]])

piv = array_RH(2,1)
array_RH(3,1)   = simplify(-det(array_RH(1:2,[1,2]))/piv)

piv = array_RH(3,1)
array_RH(4,1)   = simplify(-det(array_RH(2:3,[1,2]))/piv)

piv = array_RH(4,1)
array_RH(5,1)   = simplify(-det(array_RH(3:4,[1,2]))/piv)

eq1 = array_RH(3,1) > 0
eq2 = array_RH(4,1) > 0

solve(eq1, k)
solve(eq2, k)

disp('Por Inspeccion Del Array: ESTABLE')
disp('Para k : (0,8)')
disp('==========================================================================')
disp('')

s   = tf('s')
k   = 1

Gf  = k/(s^3 + 3*s^2 + 3*s + (1+k))

figure
rlocus(Gf, .01, .01, 8)
figure
rlocusx(Gf)

disp('Por Lugar De Raices')
disp('Para k : (0,7]')
disp('==========================================================================')
disp('')

disp('======================================================================')
disp('SUCCESS')
