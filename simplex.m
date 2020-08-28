
function C_J = simplex(c,A,b,tipoineq)
   prompt = '¿Desea silentSimplex(0) o verboseSimplex(1)?';
    g = input(prompt);

    if g==1
        verboseSimplex(c,A,b,tipoineq)
        disp('V E R B O S E - S I M P E X')
    elseif g==0
        silentSimplex(c,A,b,tipoineq)
        disp('S I L E N T - S I M P E X')
    else
        disp('Error solo puede ingresar 1 o 0')
    end 