tic
clc;clear;
m=3;k=3;N=7;
text = fileread('input.txt');
bintext=dec2bin(text,8);
txtbinary=reshape(bintext',1,[]);
txtbinary=txtbinary-'0';
numzeroappend=0;
if mod(size(txtbinary,2),m*k)~=0
    numzeroappend=(m*k)-(mod(size(txtbinary,2),m*k));%Make data multiple of m*k
    txtbinary=[txtbinary zeros(1,numzeroappend)];
end
txtbinary=reshape(txtbinary,m,[])'; %Every row maps to a symbol

smblvector=binaryVectorToDecimal(txtbinary);%Convert each row to symbol
smblvector=reshape(smblvector,k,[])';%Each row corresponds to msg a(x)

%Generating idft matrix
primele=gf(2,m); % z in F8 z^3+z+1(default)
one2six=1:1:(N-1);
minone2six=-1:-1:-(N-1);
invpwrmatrix=diag(1:(N-1))*repmat(minone2six,N-1,1);
% pwrmatrix=diag(1:(N-1))*repmat(one2six,N-1,1);
invdftmatrix=[ones(1,N);ones((N-1),1) primele.^invpwrmatrix];
% dftmatrix=[ones(1,N);ones((N-1),1) primele.^pwrmatrix];

codewordmtx=invdftmatrix(:,1:k)*smblvector';
codewordmtx=codewordmtx';%each row codeword c(x)
% clearvars -except codewordmtx numzeroappend invdftmatrix m k N
%Random Erasure Model
e=[1 1 1 1 0 0 0];
erasemtx=unique(perms(e),'rows');
permidx=round(unifrnd(0.5,size(erasemtx,1)+0.5));%used to randomly select pattern of erasure
e=erasemtx(permidx,:)
idx=find(e==0);
dataaftererasure=codewordmtx(:,idx);%Selecting non erasure columns

%Generating all possible codewords
P=nchoosek([0:(2^m)-1 0:(2^m)-1 0:(2^m)-1],k);
msgwordset=unique(P,'rows');
codewordset=invdftmatrix(:,1:k)*msgwordset';
codewordset=codewordset';
codewordsetaftererasure=codewordset(:,idx);
dataaftererasure=gf(dataaftererasure,m);
[~,outidx]=ismember(dataaftererasure.x,codewordsetaftererasure.x,'rows');


data=msgwordset(outidx,:);%Since all elements would be decoded w/o errors outidx won't be -1
data=reshape(data',1,[]);
data=dec2bin(data,m);
data=reshape(data',1,[]);
data=data(1:size(data,2)-numzeroappend);
data=reshape(data,8,[])'-'0';
data=char(binaryVectorToDecimal(data)');
isequal(text,data)

fileID = fopen('output.txt','w');
fprintf(fileID,'%s',data);
fclose(fileID);
toc