function [Ualpha,Ubelta] = clark_3s_2s(Ua,Ub,Uc)
K = sqrt(2/3);
Ualpha=K*(Ua-1/2*Ub-1/2*Uc);               % 3s/2s�任  N3/N2 = 2/3   ��  ia + ib + ic = 0 
Ubelta=K*(sqrt(3)/2*Ub-sqrt(3)/2*Uc);
end