%% Input
I_in=imread("Chess_Board.png");
B=dec2bin(I_in);
BB = reshape(B',1,numel(B));
C = (BB=='1');
%% Encoding
% K=4;
% N=7;

K=2;
N=8;

c=reshape(C,K,[])';
% %Repetition Coding

% E=zeros(size(c,1),N);
% for i=1:size(c)
%     if(c(i,:)==1)
%         E(i,:)=ones(1,N);
%     else
%         E(i,:)=zeros(1,N);
%     end
% 
% end

%Linear Coding
% G=[1 0 0 0 1 1 1;
%    0 1 0 0 0 1 1;
%    0 0 1 0 1 0 1;
%    0 0 0 1 1 1 0];

% H=[1 0 1 1 1 0 0;
%    1 1 0 1 0 1 0;
%    1 1 1 0 0 0 1];


G = [1 0 1 1 1 0 1 0 ; 0 1 0 1 1 1 0 1];
H = [1 1 1 0 1 0; 0 1 1 1 0 1; 1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1]';
Htwo=zeros(N^2,N-K);
%sum of two columns of H
for i=1:size(H,2)
    for j=1:size(H,2)
        Htwo((N*(i-1))+j,:)=(H(:,i)+H(:,j))';

    end
end


% Codes=[1 0 0 0 1 1 1;
%        0 1 0 0 0 1 1;
%        0 0 1 0 1 0 1;
%        0 0 0 1 1 1 0;
% 
%        0 0 0 0 0 0 0;
%        1 1 0 0 1 0 0;
%        1 0 1 0 0 1 0;
%        1 0 0 1 0 0 1;
% 
%        0 1 1 0 1 1 0;
%        0 1 0 1 1 0 1;
%        0 0 1 1 0 1 1;
% 
%        1 1 1 0 0 0 1;
%        1 1 0 1 0 1 0;
%        1 0 1 1 1 0 0;
%        0 1 1 1 0 0 0;
%        
%        1 1 1 1 1 1 1];
Codes=[0 0 0 0 0 0 0 0;
       0 1 0 1 1 1 0 1;
       1 0 1 1 1 0 1 0;
       1 1 1 0 0 1 1 1];
E=mod(c*G,2);
e=reshape(E',1,[]);
source=reshape(e,N,[])';
%% Storage simulation
Pe_array=[1e-4,1e-3,1e-2,1e-1];
Pe=Pe_array(3);
r=unifrnd(0,1,size(e));
r=(r<Pe);
e(r)=~e(r);
%% Decoding
d=reshape(e,N,[])';

% %Majority Decoder
% Dec=zeros(size(d,1),K);
% for i=1:size(d)
%     if(sum(d(i,:))>N/2)
%         Dec(i,:)=1;
%     else
%         Dec(i,:)=0;
%     end
% 
% end


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
    %Assuming always a member since one error only can happen.
    [ismatch,idx]=ismember(out(errors(i),:),H','rows');
    if(ismatch==1)
    d(errors(i),idx)=mod(d(errors(i),idx)+1,2);%Flipping the error bit
    else
      [ismatch,idx]=ismember(out(errors(i),:),Htwo,'rows');  
        if(ismatch==1)%double error correction
            err_loc1=ceil(idx/N);
            err_loc2=idx-((err_loc1-1)*N);
            d(errors(i),err_loc1)=mod(d(errors(i),err_loc1)+1,2);%Flipping the error bit
            d(errors(i),err_loc2)=mod(d(errors(i),err_loc2)+1,2);%Flipping the error bit
        end
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