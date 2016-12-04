%clear;
close all;
delete(instrfindall);

Input_IMG = imread('WL.png');
Input_IMG2 = imread('Smile.png');
Input_IMG3 = imread('Text.png');

%Remove illegal bits in converted image (1 is used for reset)
Input_IMG(Input_IMG==1)=0;
Input_IMG2(Input_IMG2==1)=0;
Input_IMG3(Input_IMG3==1)=0;

% Open Serial Port
S = serial('COM4', 'BAUD', 115200);
fclose(S);
fopen(S);

%Transfer Image
% fwrite(S,uint8(bin2dec('00000001')));
% for r = 1 : 32
%     for c = 1 : 32
%         fwrite(S,uint8(Input_IMG2(r,c,1)));
%         fwrite(S,uint8(Input_IMG2(r,c,2)));
%         fwrite(S,uint8(Input_IMG2(r,c,3)));        
%     end
% end

%Color by bits
% for r = 1 : 1024
%     fwrite(S,uint8(bin2dec('11110000')));
%     fwrite(S,uint8(bin2dec('11110000')));
%     fwrite(S,uint8(bin2dec('11110000')));          
% end

%Specific Color for Each LED
% for r = 1 : 1024
%     fwrite(S,uint8(218));
%     fwrite(S,uint8(165));
%     fwrite(S,uint8(32));          
% end

while true
    fwrite(S,uint8(bin2dec('00000001')));
    for r = 1 : 32
        for c = 1 : 32
            fwrite(S,uint8(Input_IMG(r,c,1)));
            fwrite(S,uint8(Input_IMG(r,c,2)));
            fwrite(S,uint8(Input_IMG(r,c,3)));        
        end
    end

    fwrite(S,uint8(bin2dec('00000001')));
    for r = 1 : 32
        for c = 1 : 32
            fwrite(S,uint8(Input_IMG2(r,c,1)));
            fwrite(S,uint8(Input_IMG2(r,c,2)));
            fwrite(S,uint8(Input_IMG2(r,c,3)));        
        end
    end
    
    fwrite(S,uint8(bin2dec('00000001')));
    for r = 1 : 32
        for c = 1 : 32
            fwrite(S,uint8(Input_IMG3(r,c,1)));
            fwrite(S,uint8(Input_IMG3(r,c,2)));
            fwrite(S,uint8(Input_IMG3(r,c,3)));        
        end
    end
end

fclose(S);