%clear;
close all;
delete(instrfindall);

%Input_IMG = imread('WL2.png');

% Open Serial Port
S = serial('COM4', 'BAUD', 115200);
fclose(S);
fopen(S);

%fwrite(S,uint8(bin2dec('11111111')));



for r = 1 : 32
    for c = 1 : 32
        fwrite(S,uint8(Input_IMG(r,c,1)));
        fwrite(S,uint8(Input_IMG(r,c,2)));
        fwrite(S,uint8(Input_IMG(r,c,3)));
        
%     fwrite(S,uint8(bin2dec('11111111')));
%     fwrite(S,uint8(bin2dec('00000000')));
%     fwrite(S,uint8(bin2dec('00000000')));
%     
%     fwrite(S,uint8(bin2dec('00000000')));
%     fwrite(S,uint8(bin2dec('11111111')));
%     fwrite(S,uint8(bin2dec('00000000')));
    end
end

fclose(S);