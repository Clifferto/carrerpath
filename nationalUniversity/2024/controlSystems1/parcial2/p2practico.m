% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

% % ? ==========================================================================
% function argouts = add_row (array_RH)

%     N_COL   = size(array_RH)(2);

%     argouts = array_RH(1, :)*0;
%     % ! piv = (f-1, 1)
%     pivot   = array_RH(end, 1);
    
%     for col = 1:N_COL-1
%         % ! | (f-2, 1)  (f-2, c+1) |    
%         % ! | (f-1, 1)  (f-1, c+1) |    
%         alpha           = array_RH(end-1:end, [1,col+1]);
%         argouts(col)    = simplify(-det(alpha)/pivot);
%     endfor

%     if (isequal(argouts, argouts*0))
%         disp('SE ANULO LA FILA -> EC AUXILIAR')
%         disp('==========================================================================')
%         % return argouts;
%     elseif (argouts(1) == 0)
%         disp('SE ANULO PRIMER ELEMENTO -> AGREGAR EPSILON')
%         disp('==========================================================================')
%         argouts(1) = sym('epsilon')
%     else
%         % return argouts;
%     endif

% endfunction

% function argouts = do_routh_hurwitz (array_RH)
    
%     argouts = array_RH;

%     while (! isequal(argouts(end-1:end, 2), zeros(2, 1)))
%         argouts(end+1, :) = add_row(argouts);
%         % input('STEP ++ ? ')
%     endwhile

% endfunction

% % ? ==========================================================================

% % variables
% syms s k real

% G   = (16*s + 1328)/(s^3 + 58*s^2 + 576*s - 5760)
% Gf  = simplify(k*G/(1+ k*G*1))

% % Gf = (sym)

% %                 16⋅k⋅(s + 83)
% %   ─────────────────────────────────────────
% %                    3       2
% %   16⋅k⋅(s + 83) + s  + 58⋅s  + 576⋅s - 5760

% % POL CARACTERISTICO
% expand(16*k*(s + 83) + s^3  + 58*s^2  + 576*s - 5760)

% % ans = (sym)

% %                      3       2
% %   16⋅k⋅s + 1328⋅k + s  + 58⋅s  + 576⋅s - 5760

% array_RH    = sym([ [1  (576+16*k)      ];
%                     [58 (1328*k-5760)   ]])

% array_RH = do_routh_hurwitz(array_RH)

% % CONDICIONES
% eq1 = array_RH(3,1) > 0
% eq2 = array_RH(4,1) > 0

% solve(eq1, k)
% solve(eq2, k)

% disp('')
% disp('=======================================================================')
% disp('ESTABLE PARA: 360/83 < k < 2448/25 == 4.3373 < k < 97.920')
% disp('=======================================================================')

% ! ==========================================================================

% % realimentacion unitaria
% H   = 1
% G   = zpk([], [-1 -22], [3])

% rlocusx(G*H)

% disp('')
% disp('Por Inspeccion Del LR, Puntos De Trabajo (Criticamente Amortiguada == Psita = 1)')
% disp('=======================================================================')
% k = 36.75

% ! ==========================================================================

% variables
s   = tf('s');
G   = tf([66 2904], [1 30 183 154])
% realimentacion unitaria
H   = 1

% Transfer function 'G' from input 'u1' to output ...
%              66 s + 2904
%  y1:  --------------------------
%       s^3 + 30 s^2 + 183 s + 154

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
FTLA    = G*H;

damp(G)
rlocus(FTLA)

disp('')
disp('=======================================================================')
disp('CONTROLADOR PI (Mejorar Transitorio Y Eliminar ess_p)')
disp('=======================================================================')
% SIN SOBREPICO Y TIEMPO DE ESTABLECIMIENTO MINIMO
psita   = 1

k       = 1;
p_dom   = -max(pole(G*H))
PI      = k*(s + p_dom)/s;

FTLA    = minreal(PI*G*H)
% Transfer function 'FTLA' from input 'u1' to output ...
%           66 s + 2904
%  y1:  --------------------
%       s^3 + 29 s^2 + 154 s

figure
rlocus(FTLA)
sgrid(psita, [25:25:100])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -3.32

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = (66*sp + 2904)/(sp^3 + 29*sp^2 + 154*sp);
k       = 1/(abs(FTLAp))
Ti      = abs(1/p_dom)

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

figure
step(feedback(G,H), feedback(PI*G,H))

% ==========================================================================
close all;

disp('')
disp('=======================================================================')
disp('CONTROLADOR PI (Mejorar Transitorio Y Eliminar ess_p)')
disp('=======================================================================')
% SOBREPICO MENOR AL 4% Y TIEMPO DE ESTABLECIMIENTO MINIMO

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================
psita   = .707

% NO CAMBIA EL SISTEMA, POR TANTO EL POLO DOMINANTE SE MANTIENE
k   = 1
PI  = k*(s + p_dom)/s;

FTLA    = minreal(PI*G*H)
% Transfer function 'FTLA' from input 'u1' to output ...
%           66 s + 2904
%  y1:  --------------------
%       s^3 + 29 s^2 + 154 s

rlocus(FTLA)
sgrid(psita, [25:25:100])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -3.18 + 3.23j

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = (66*sp + 2904)/(sp^3 + 29*sp^2 + 154*sp);
k       = 1/(abs(FTLAp))
Ti      = abs(1/p_dom)

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

figure
step(feedback(G,H), feedback(PI*G,H))

disp('')
disp('=======================================================================')
disp('SUCCESS')
