function [sys,x0,str,ts] = FOC_SMC(t,x,u,flag)
switch flag
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1
    sys=mdlDerivatives(t,x,u);
  case {2,4,9}
    sys=[];
  case 3
    sys=mdlOutputs(t,x,u);
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

function [sys,x0,str,ts]=mdlInitializeSizes   %ϵͳ�ĳ�ʼ��
sizes = simsizes;
sizes.NumContStates  = 0;   %����ϵͳ����״̬�ı���
sizes.NumDiscStates  = 0;   %����ϵͳ��ɢ״̬�ı���
sizes.NumOutputs     = 1;   %����ϵͳ����ı���
sizes.NumInputs      = 4;   %����ϵͳ����ı���
sizes.DirFeedthrough = 1;   %���������������Ժ��������u����Ӧ�ý�����������Ϊ1
sizes.NumSampleTimes = 0;   % ģ��������ڵĸ���
                            % ��Ҫ������ʱ�䣬һ��Ϊ1.
                            % �²�Ϊ���Ϊn������һʱ�̵�״̬��Ҫ֪��ǰn��״̬��ϵͳ״̬
sys = simsizes(sizes);
x0  = [];                   % ϵͳ��ʼ״̬����
str = [];                   % ��������������Ϊ��
ts  = [];                   % ����ʱ��[t1 t2] t1Ϊ�������ڣ����ȡt1=-1�򽫼̳������źŵĲ������ڣ�����t2Ϊƫ������һ��ȡΪ0
 
    
function sys=mdlOutputs(t,x,u)   %���������ݣ�ϵͳ���
%����ת��
we = u(1); 
%����ٶ�
w = u(2);  
%  we-w�Ļ���
inte_w = u(3);
%  ����ת��
TL = u(4);

%�Զ���ϵ��
xite = 2;   %Ϊ����ϵͳ������ģ��s=0�������ٶ�
q = 3;      %�����ٶ�ֱ���ɳ��� q ����
c = 10;     %���� c>0

q1 = we - w;   %x1
q2 = inte_w;   %x2
%��ģ��
s = q1 + c * q2;
% s = c * q1 + q2;
%������
p = 4;
%���Ŵ���
faif = 0.0714394;
%ת������
J = 0.000621417;
D = 3*p*faif/(2*J);
%����ϵ��
B = 0.000303448;
ut  = 1/D*(c * q1 + B/J*w + 1/J*TL + xite*sign(s) + q*s);

sys(1) = ut;

