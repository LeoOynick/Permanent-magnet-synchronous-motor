function [sys,x0,str,ts]=PMSMdq(t,x,u,flag,parameters,x0_in)
%������     ld.lq: dq�ĵ��        r:  ����     psi_f : ת����PM�Ĵ�ͨ  p:������    j:��������͸���  mu_f:ճ��Ħ��
%���룺     ud,uq: dq�ĵ�ѹ       tl: ����ת��
%�ڲ������� id,iq: dq�ĵ���     ud,uq:dq�ĵ�ѹ   wr   :����Ľ��ٶ�    te:���ת��   theta��ת��λ��
%�����     wr������Ľ��ٶ�      te�����ת��      id��iq��dq�ĵ���  theta��ת��λ��
% u(1 2 3)                  = ud uq tl
% parameters(1 2 3 4 5 6 7 )= ld lq r psi_f p j mu_f
% sys(1 2 3 4 5 6)          = wr te id iq theta
% x(1 2 3 4)                = id iq wr theta
switch flag
    case 0
        [sys,x0,str,ts]=mdlInitializeSizes(x0_in);
    case 1
        sys=mdlDerivatives(x,u,parameters);
    case 3
        sys=mdlOutputs(x,u,parameters);
    case {2,4,9}
        sys=[];
    otherwise 
        error(['Unhandled flag=',num2str(flag)]);
end
  
function[ sys,x0,str,ts]=mdlInitializeSizes(x0_in)
 sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   
sys = simsizes(sizes);
x0  = x0_in;
str = [];
ts  = [0 0];

%id'=ud/ld-r*id/ld+lq*p*wr*iq/ld
function [sys]=mdlDerivatives(x,u,parameters)
sys(1)=u(1)/parameters(1)-parameters(3)*x(1)/parameters(1)+parameters(2)*parameters(5)*x(3)*x(2)/parameters(1);
%iq'=uq/ld-r*iq/lq-ld*p*wr*id/lq-psi_f*p*wr/lq
sys(2)=u(2)/parameters(2)-parameters(3)*x(2)/parameters(2)-parameters(1)*parameters(5)*x(3)*x(1)/parameters(2)-parameters(4)*parameters(5)*x(3)/parameters(2);
%te=1.5*p*[psi_f*iq+(ld-lq)*id*iq]
te=1.5*parameters(5)*(parameters(4)*x(2)+(parameters(1)-parameters(2))*x(1)*x(2));
%wr'=(te-mu_f*wr-tl)/j
sys(3)=(te-parameters(7)*x(3)-u(3))/parameters(6);
%theta'=p*wr
sys(4)=parameters(5)*x(3);


function sys=mdlOutputs(x,u,parameters,te)
sys(1)=x(3);
%te=1.5*parameters(5)*(parameters(4)*x(2)+(parameters(1)-parameters(2))*x(1)*x(2));
te=1.5*parameters(5)*(parameters(4)*x(2)+(parameters(1)-parameters(2))*x(1)*x(2));
sys(2)=te;
sys(3)=x(1); %id
sys(4)=x(2); %iq
sys(5)=x(4); %theta







