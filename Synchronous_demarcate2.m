function [sys,x0,str,ts] = Synchronous_demarcate2(t,x,u,flag)
%�˳���Ϊ��ʶ���������ת������
switch flag
  case 0  %��ʼ��
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 2 %��ɢ״̬���㣬��һ������ʱ�̣���ֹ�����趨
    sys=[];%mdlUpdates(t,x,u);
  case 3  %����źż���
    sys=mdlOutputs(t,x,u);
  case {1,4,9}  %����źż���
    sys=[];
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

function [sys,x0,str,ts]=mdlInitializeSizes   %ϵͳ�ĳ�ʼ��
sizes = simsizes;
sizes.NumContStates  = 0;   %����ϵͳ����״̬�ı���
sizes.NumDiscStates  = 0;   %����ϵͳ��ɢ״̬�ı���
sizes.NumOutputs     = 1;   %����ϵͳ����ı���
sizes.NumInputs      = 3;   %����ϵͳ����ı���
sizes.DirFeedthrough = 1;   %���������������Ժ��������u����Ӧ�ý�����������Ϊ1,���벻ֱ�Ӵ��������
sizes.NumSampleTimes = 1;   % ģ��������ڵĸ���
                            % ��Ҫ������ʱ�䣬һ��Ϊ1.
                            % �²�Ϊ���Ϊn������һʱ�̵�״̬��Ҫ֪��ǰn��״̬��ϵͳ״̬
sys = simsizes(sizes);
x0  = [];            % ϵͳ��ʼ״̬����
str = [];                   % ��������������Ϊ��
ts  = [-1 0];                   % ����ʱ��[t1 t2] t1Ϊ�������ڣ����ȡt1=-1�򽫼̳������źŵĲ������ڣ�����t2Ϊƫ������һ��ȡΪ0

global  P_past2 theta_past2 
P_past2 = 1e4 * eye(2,2);  %һ��ȡ1e4 - 1e10
theta_past2 = [0.0001; 0.0001];       %һ��ȡһ����С����ʵ����

function sys=mdlOutputs(t,x,u)   %���������ݣ�ϵͳ���
%��ֵ��ȷ��
lambda = 0.99;  %��������0-1
global   P_past2 theta_past2
xt = [u(1) u(2)];  %1*2 fait
y = u(3);
I = [1 0;0 1];

K = P_past2*xt'/(lambda + xt * P_past2*xt');   %2*1
P_new = 1/lambda*(I - K*xt) * P_past2;  %2*2
theta_new = theta_past2 + K*(y-xt*theta_past2);   %2*1

P_past2 = P_new ;
theta_past2 = theta_new;

sys(1) = theta_new(1);







