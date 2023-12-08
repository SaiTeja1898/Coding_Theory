clear;
itr=1;
pitr=4;
for N=[3 7]
    Ass1_Q2
    subplot(1,2,itr)
    
    imshow(I_out);
    title("N="+N);
    itr=itr+1;
    clearvars -except N itr pitr
end
sgtitle("Repetition Coding (p=1e-"+pitr+")");