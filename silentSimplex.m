
function C_J = silentSimplex(c,A,b,tipoineq)
    %si se va a maximizar ingrese 1 de lo contrario ingrese 0
    prompt = '¿Desea minimizar(0) o maximizar(1)?';
    g = input(prompt);
    if g==1
        c=(-1)*(c);
    elseif g==0
        c=c;
    else
        disp('Error solo puede ingresar 1 o 0')
    end
    % matriz de coeficientes

    % numero de restricciones
    R=size(A,1);

    %numero de variables
    V=size(A,2);

    %se generan algunas restricciones para esa variable
    if length(tipoineq)<R || length(tipoineq)>R
        disp('ha ingresado una cantidad incorrecta de datos')
    end
    for e=tipoineq
        if e~=1 && e~=-1
            disp('solo puede ingresar 1 o -1')
        end
    end

    %Crea la matriz de identidad dependiendo la cantidad de restricciones
    ID=diag(tipoineq);
    indicesID=find(tipoineq==1);
    if min(tipoineq)==-1
        %encuentro los indices de los -1 y de los 1
        te=find(tipoineq==-1);
        amo=find(tipoineq==1);

        %selecciono los vectores de acuerdo a los indices
        variart=-ID(:,te);
        varnoart=ID(:,amo);

        %se unen la matriz inicial con la de variables atrificiales
        matriUvariart=[ID variart];

        %indices de la matriz de la identidad arregladita
        indicesID=[te amo];

        %matriz identidad arregladita
        ID=[varnoart variart];
    end
    % es la matriz a con la matriz de las variables de holgura
    AUID=[A ID];

    %Para la matriz los costos seran los basicos luego hay que crear ese vector
    C_B=zeros(1,R);

    %es la matriz de los costos iniciales con los de las variables de holgura
    cUC_B=[c C_B];


    %la matriz inversa 
    InverssBas=inv(ID);

    %sea X_B=B^-1*b y sea X_B=b_barra
    X_B=InverssBas*b;
    b_barra=X_B;

    %sea z_0=C_B*X_B
    z_0=C_B*X_B;

    %sea w=C_B*B^-1
    W=C_B*InverssBas;

    %se multiplica W por N, que es la matriz de los indices no basicos
    WN=W*A;

    %sea C_NBARRA=c_N-WN
    C_J=c-WN;
    %toma los valores de c_j y escoje los que sean menores a cero
    if min(C_J)>0
        disp('la solucion es optima')
        C_J;
        elseif min(C_J)==0
            disp('la solucion tiene optimos alternos')
        end
    while min(C_J)<0
        NumIteraciones = 1;
        % De los valores que estan en I_y toma el minimo de esos valores
        I_YP = min(C_J);
        %este nos da el indice de donde se encuentra ese I_yp en c_j
        %indice del que entra en la base
        K=find(C_J==I_YP);

        %A partir del indice sale el a_k
        a=A(:,K);

        %sea Y_k=B^-1*a_k
        Y=InverssBas*a;
        if min(Y)<0 && max(Y)<0
            disp('la solucion es no acotada')
        end
        %de columna pasa a fila
        x=Y';

        %escoje los de la fila mayores a cero
        Hell=[];
        for t=x 
            if t>0
                Hell=[Hell t];
            end
        end

        % mira cuales son los indices
        KH=[];
        for r=Hell
            KH=find(x);
        end

        %a partir de los indices me retorna los valores correspondientes a b_barra
        b_barrared=[];
        for d=KH
            b_barrared=[b_barrared b_barra(d,:)];
        end
        %se divide b_barra sobre su y_k correspondiente
        G=b_barrared./Hell;

        %se halla el minimo de ellos
        minimo_k= min(G);

        %encontrar el indice del minimo
        K2=find(G==minimo_k);
        BUS=b_barrared(K2);
        %me retorna el indice de la variable que sale
        K3=find(b_barra==BUS);

        aS=ID(:,K3);
        cmod=c(:,K);
        C_Bmod=C_B(:,K3);

        A(:,K)=aS;

        ID(:,K3)=a;

        % se modifca C_B
        C_B(:,K3)=cmod;

        %se modifica c
        c(:,K)=C_Bmod;

        %se repite again
        %la matriz inversa 
        InverssBas=inv(ID);
        %sea X_B=B^-1*b y sea X_B=b_barra
        X_B=InverssBas*b;
        b_barra=X_B;
        %sea z_0=C_B*X_B
        z_0=C_B*X_B;

        %sea w=C_B*B^-1
        W=C_B*InverssBas;

        %se multiplica W por N, que es la matriz de los indices no basicos
        WN=W*A;

        %sea C_NBARRA=c_N-WN
        C_J=c-WN; %C_J tienen que ser mayores a 0 (optima)

        if min(C_J)>0
        disp('la solucion es optima')
        C_J;
        break
        elseif min(C_J)==0
            disp('la solucion tiene optimos alternos')
            break
        end
        NumIteraciones = NumIteraciones + 1;
        if NumIteraciones == R
            disp('solucion no acotada')
            break 
        end 

    end
end