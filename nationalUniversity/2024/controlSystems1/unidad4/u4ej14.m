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

% ESTABILIDAD RELATIVA, CRITERIO DE ROUTH-HURWITZ
% ==========================================================================

% variables
syms k s real;
% s = tf('s');

disp('==========================================================================')
disp('SISTEMA A')
disp('==========================================================================')

% expandir para inicializar array a mano
expand(2*(s + 1)^2)

array_RH    = sym([ [2  2   ];
                    [4  0   ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = simplify(-det(array_RH(1:2,[1,2]))/piv)
% 
array_RH = do_routh_hurwitz(array_RH)

disp('Por Inspeccion Del Array: ESTABLE')
disp('==========================================================================')
disp('')

disp('==========================================================================')
disp('SISTEMA B')
disp('==========================================================================')

array_RH    = sym([ [1  10  ];
                    [11 k   ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = simplify(-det(array_RH(1:2,:))/piv)
% piv = array_RH(3,1)
% array_RH(4,1)   = simplify(-det(array_RH(2:3,:))/piv)
% 
array_RH = do_routh_hurwitz(array_RH)

eq1 =   simplify(array_RH(3,1)) > 0
eq2 =   simplify(array_RH(4,1)) > 0

rhs(solve(eq1, k));

disp('Por Inspeccion Del Array: ESTABLE PARA k:')

interval(sym(0), ans, true, true)
disp('==========================================================================')
disp('')

disp('==========================================================================')
disp('SISTEMA C')
disp('==========================================================================')
s^3 + 2.996*s^2 + 3*s + 10.998

array_RH    = sym([ [1      3       ];
                    [2.996  10.998  ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = -det(array_RH(1:2,:))/piv
% 
% piv = array_RH(3,1)
% array_RH(4,1)   = -det(array_RH(2:3,:))/piv
% 
array_RH = do_routh_hurwitz(array_RH)

disp('Por Inspeccion Del Array: INESTABLE')
disp('==========================================================================')
disp('')

disp('==========================================================================')
disp('SISTEMA D')
disp('==========================================================================')
2*s^6 + 2*s^5 + 3*s^4 + s^3 + 3*s^2 + 2*s + 1

array_RH    = sym([ [2  3   3   1   ];
                    [2  1   2   0   ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = -det(array_RH(1:2,[1,2]))/piv
% array_RH(3,2)   = -det(array_RH(1:2,[1,3]))/piv
% array_RH(3,3)   = -det(array_RH(1:2,[1,4]))/piv
% 
% piv = array_RH(3,1)
% array_RH(4,1)   = -det(array_RH(2:3,[1,2]))/piv
% array_RH(4,2)   = -det(array_RH(2:3,[1,3]))/piv
% 
% piv = array_RH(4,1)
% array_RH(5,1)   = -det(array_RH(3:4,[1,2]))/piv
% 
% piv = array_RH(5,1)
% array_RH(6,1)   = -det(array_RH(4:5,[1,2]))/piv
array_RH = do_routh_hurwitz(array_RH)

e51 = array_RH(5,1)
disp("limit(e51, 'epsilon', 0)")
limit(e51, 'epsilon', 0)

e61 = array_RH(6,1)
disp("limit(e61, 'epsilon', 0)")
limit(e61, 'epsilon', 0)

disp('Por Inspeccion Del Array: INESTABLE')
disp('==========================================================================')
disp('')

disp('==========================================================================')
disp('SISTEMA E')
disp('==========================================================================')
s^5 + 3*s^4 - 2*s^2 + 7*s + 12

array_RH    = sym([ [1  0   7   ];
                    [3  -2  12  ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = -det(array_RH(1:2,[1,2]))/piv
% array_RH(3,2)   = -det(array_RH(1:2,[1,3]))/piv
% 
% piv = array_RH(3,1)
% array_RH(4,1)   = -det(array_RH(2:3,[1,2]))/piv
% array_RH(4,2)   = -det(array_RH(2:3,[1,3]))/piv
% 
% piv = array_RH(4,1)
% array_RH(5,1)   = -det(array_RH(3:4,[1,2]))/piv
% array_RH(5,2)   = -det(array_RH(3:4,[1,3]))/piv
% 
% piv = array_RH(5,1)
% array_RH(6,1)   = -det(array_RH(4:5,[1,2]))/piv
% array_RH(6,2)   = -det(array_RH(4:5,[1,3]))/piv
% 
array_RH = do_routh_hurwitz(array_RH)

disp('Por Inspeccion Del Array: INESTABLE')
disp('==========================================================================')
disp('')

disp('==========================================================================')
disp('SISTEMA F')
disp('==========================================================================')
array_RH    = sym([ [1  1   2+k ];
                    [1  3   1   ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = simplify(-det(array_RH(1:2,[1,2]))/piv)
% array_RH(3,2)   = simplify(-det(array_RH(1:2,[1,3]))/piv)
% 
% piv = array_RH(3,1)
% array_RH(4,1)   = simplify(-det(array_RH(2:3,[1,2]))/piv)
% array_RH(4,2)   = simplify(-det(array_RH(2:3,[1,3]))/piv)
% 
% piv = array_RH(4,1)
% array_RH(5,1)   = simplify(-det(array_RH(3:4,[1,2]))/piv)
% array_RH(5,2)   = simplify(-det(array_RH(3:4,[1,3]))/piv)
% 
% piv = array_RH(5,1)
% array_RH(6,1)   = simplify(-det(array_RH(4:5,[1,2]))/piv)
% array_RH(6,2)   = simplify(-det(array_RH(4:5,[1,3]))/piv)
% 
array_RH = do_routh_hurwitz(array_RH)

disp('Por Inspeccion Del Array: INESTABLE')
disp('==========================================================================')
disp('')

disp('==========================================================================')
disp('SISTEMA G')
disp('==========================================================================')

array_RH    = sym([ [6  3   1+k ];
                    [1  k   0   ]])

% piv = array_RH(2,1)
% array_RH(3,1)   = simplify(-det(array_RH(1:2,[1,2]))/piv)
% array_RH(3,2)   = simplify(-det(array_RH(1:2,[1,3]))/piv)
% 
% piv = array_RH(3,1)
% array_RH(4,1)   = simplify(-det(array_RH(2:3,[1,2]))/piv)
% array_RH(4,2)   = simplify(-det(array_RH(2:3,[1,3]))/piv)
% 
% piv = array_RH(4,1)
% array_RH(5,1)   = simplify(-det(array_RH(3:4,[1,2]))/piv)
% array_RH(5,2)   = simplify(-det(array_RH(3:4,[1,3]))/piv)
% 
array_RH = do_routh_hurwitz(array_RH)

eq1 = array_RH(3,1) > 0
eq2 = array_RH(4,1) > 0
eq3 = array_RH(5,1) > 0

solve(eq1, k)
solve(eq2, k)
solve(eq3, k)

disp('Por Inspeccion Del Array (confiando en las inecuaciones de octave): INESTABLE')
disp('==========================================================================')
disp('')

disp('======================================================================')
disp('SUCCESS')
