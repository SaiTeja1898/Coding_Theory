%% Input
clear;
I_in=imread("Chess_Board.png");
B=dec2bin(I_in);
BB = reshape(B',1,numel(B));
C = (BB=='1');

%% Encoding
K=4;
N=7;

c=reshape(C,K,[])';

%Linear Coding
G=[1 0 0 0 1 1 1;
   0 1 0 0 0 1 1;
   0 0 1 0 1 0 1;
   0 0 0 1 1 1 0];

H=[1 0 1 1 1 0 0;
   1 1 0 1 0 1 0;
   1 1 1 0 0 0 1];

Codes=((dec2bin(0:2^K-1))-'0')*G;

E=mod(c*G,2);
e=reshape(E',1,[]);
source=reshape(e,N,[])';

%% Storage simulation
Pe_array=[1e-4,1e-3,1e-2,1e-1];
Pe=Pe_array(4);
r=unifrnd(0,1,size(e));
r=(r<Pe);
e(r)=~e(r);

%% Decoding
d=reshape(e,N,[])';

%Minimum Distance and Parity Check
% for i=1:size(d)
%     [ismatch,idx]=ismember(d(i,:),Codes,'rows');
%     if ~ismatch
%         %Find the minimum distance code
%         HD=sum(xor(d(i,:),Codes),2);
%         [~,idx]=min(HD);
%         d(i,:)=Codes(idx,:);
%     end
% end
% Dec=d(:,1:K);

%Parity Check decoding
out=mod(d*H',2);
error=sum(out,2);
errors=find(error>=1);%which code has error
for i=1:nnz(errors)%nnz is useful if code contains other than 0,1
    %Is a match if it has only one error
    [ismatch,idx]=ismember(out(errors(i),:),H','rows');%comparing with H columns
    if(ismatch==1)
        d(errors(i),idx)=mod(d(errors(i),idx)+1,2);%Flipping the error bit
    end
end
Dec=d(:,1:K);

e=reshape(Dec',1,[]);
%% Output
L=['0','1'];
CC=L(1+e);
D = reshape(CC,size(B,2),size(B,1));
I_out = reshape(bin2dec(D'),size(I_in));
imshow(I_out);
title("Single ECC using Parity check matrix decoder (Pe = "+Pe+")");