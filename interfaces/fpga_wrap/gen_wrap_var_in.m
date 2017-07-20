function funstr = gen_wrap_var_in(vars)
%Diese Funktion generiert die Variablendeklarationen
%% #############
% # Changelog #
% #############
%
% 22.11.16 Annika Mayer (annika.mayer@isys.uni-stuttgart.de):
% Wenn mem_type==2 und pstruc existiert, werden nur Schnittstellen f�r
% Matrizen mit unterschiedlichem Inhalt angelegt.
% 9.03.17  Annika Mayer
% Daten einlesen nur f�r Strukturen die nicht Dimension Null haben.


global gendata
global pstruc

K = gendata.dim.K;
nx = gendata.dim.n_x;
nu = gendata.dim.n_u;

for i=1:length(vars)
    I2=0:K;
    I2= I2((vars{i}.dim1~=0)&(vars{i}.dim2~=0));
    if (~isempty(pstruc)) && (gendata.mem_type==2) && (~isempty(I2))
      fcell=@(x)strcmp(vars{i}.name,x);
      % Findet Index in pstruc Elemente f�r Eingangselement
      I1=find(cellfun(fcell,pstruc.names)==1,1,'first');
      if ~isempty(I1)
      %Index der unterschiedlichen Elemente    
      I2=pstruc.id_diff_input(1:pstruc.N_diff_input(I1),I1)-1; 
      end
    end 
    
%     if (gendata.simple_struct==1) && (gendata.mem_type==2)
%         I2=[0,1,K];
%     end
    
    for k2=1:length(I2)
        k=I2(k2);
        if length(vars{i}.dim1) > 1
            dim1 = vars{i}.dim1(k+1);
        else
            dim1 = vars{i}.dim1;
        end
        if length(vars{i}.dim2) > 1
            dim2 = vars{i}.dim2(k+1);
        else
            dim2 = vars{i}.dim2;
        end
        addc(['Zeitschritt ' num2str(k)])
        addl(['dptr = ' gendata.prefix 'get_' vars{i}.name '(' num2str(k) ');'])

    end
end

end
