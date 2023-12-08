%% Input
% clear;
I_in=imread("Chess_Board.png");
B=dec2bin(I_in);
BB = reshape(B',1,numel(B));
C = (BB=='1');

%% Encoding
K=1;
% N=3;
c=reshape(C,K,[])';

%Repetition Coding
E=zeros(size(c,1),N);
for i=1:size(c)
    if(c(i,:)==1)
        E(i,:)=ones(1,N);
    else
        %Not required as already initialised to zero
        %E(i,:)=zeros(1,N);
    end

end

e=reshape(E',1,[]);
source=reshape(e,N,[])';

%% Storage simulation
Pe_array=[1e-1,1e-2,1e-3,1e-4];
Pe=Pe_array(pitr);
r=unifrnd(0,1,size(e));
r=(r<Pe);
e(r)=~e(r);

%% Decoding
d=reshape(e,N,[])';

%Majority Decoder
Dec=zeros(size(d,1),K);
for i=1:size(d)
    if(sum(d(i,:))>N/2)
        Dec(i,:)=1;
    else
        Dec(i,:)=0;
    end
end

e=reshape(Dec',1,[]);

%% Output
L=['0','1'];
CC=L(1+e);
D = reshape(CC,size(B,2),size(B,1));
I_out = reshape(bin2dec(D'),size(I_in));
% imshow(I_out);