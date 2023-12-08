%% Input
I_in=imread("Chess_Board.png");
B=dec2bin(I_in);
BB = reshape(B',1,numel(B));
C = (BB=='1');%Image in bits

%% Storage simulation
e=C;
Pe_array=[1e-4,1e-3,1e-2,1e-1];
Pe=Pe_array(1);
r=unifrnd(0,1,size(e));
r=(r<Pe);
e(r)=~e(r);

%% Output
L=['0','1'];
CC=L(1+e);
D = reshape(CC,size(B,2),size(B,1));
I_out = reshape(bin2dec(D'),size(I_in));
imshow(I_out);
title("Pe = "+Pe)