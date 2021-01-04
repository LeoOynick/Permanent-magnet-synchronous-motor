function [Ud,Uq] = park_2s_2r(Ualpha,Ubelta,theta)

 Ud=Ualpha*cos(theta)+Ubelta*sin(theta);          % 2s/2r�任
 Uq=-Ualpha*sin(theta)+Ubelta*cos(theta);
end