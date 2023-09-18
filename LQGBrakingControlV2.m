%% Automated braking control system
clear all 
clc
A = [ -0.5 -0.3 -0.01;  1 0 0;  0 1 0];
B = [ 1 0 0]';
C = [ 0, 0, 1];
D = 0;

sysH = ss(A,B,C,D);
sysG = tf(sysH);
sysp = size(C,1);
[sysn, sysm] = size(B);

sysQ = [ 0 0 0;  0 10000 0;  0 0 100];

sysR = eye(sysm);


Kr = lqr(A, B, sysQ, sysR);
Bnoise = eye(sysn);
W = eye(sysn);

V = 0.01*eye(sysm);
Estss = ss(A, [B Bnoise], C, [0 0 0 0]);
[Kess,Ke] = kalman(Estss,W,V);

setpointSx = -10;

xD = [0; 0; setpointSx];

uD = -inv(B'*B)*B'*A*xD;





