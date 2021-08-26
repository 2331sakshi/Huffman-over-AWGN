clc, clear all, close all; 
start = tic; 

% System Properties                       
modulation_name = 'BASK'; 
samples_per_bit = 40; 
Rb = 1000; 
amp = [1 0];
freq = 1000;                         
snr = 10; 
shift = 1; 

% Reading Text Data File 
fprintf('Reading data:\r\n');
file = fopen('source_data.txt');
text = fread(file,'*char')';
lentex=length(text);
fprintf('text = \r\n');
fprintf(text);
fprintf('\r\n');                    
fclose(file);

% Source Statistics   
fprintf('Distinct characters(including space and new line) = \r\n'); 
[unique_symbol, probability] = source_statistics(text); 
disp(unique_symbol);
fprintf('\r\n');
fprintf('Probabilities of each distinct character = \r\n'); 
disp(probability);

% Huffman Encoding                        
code_word = huffman_encoding(probability); 
fprintf('code_word for each distinct character = \r\n'); 
lencode=length(code_word);
disp(code_word);

% Stream Generator                     
bit_stream = stream_generator(unique_symbol, code_word, text);
input = bit_stream;
%disp(input);
sizebs = length(input);
figure(1)
subplot(4,1,1);
stairs(bit_stream);
ylim([-1 2]);
title('Generated Bit stream');

% Modulation
modulated = modulation(modulation_name, bit_stream, Rb, samples_per_bit, amp, freq); 
subplot(4,1,2);
stairs(modulated);
ylim([-2 2]);
title('Bit stream (modulated)');

% AWGN channel
received = awgn_channel(modulated, snr); 
subplot(4,1,3);
stairs(received);
ylim([-2 2]);
title('AWGN Channel');

% Demodulation  
demodulated_m = demodulation(modulation_name, modulated, Rb, samples_per_bit, amp, freq);
demodulated_c = demodulation(modulation_name, received, Rb, samples_per_bit, amp, freq);

output = demodulated_c; 
subplot(4,1,4);
stairs(output);
ylim([-1 2]);
title('Output bit stream (recieved)');

% Huffman Decoding 
decoded_msg = huffman_decoding(unique_symbol, code_word, demodulated_m); 
fprintf('decoded_msg = \r\n'); 
disp(decoded_msg);
fprintf('\r\n');

% Writting the Received Data 
f = fopen('received.txt','w+');
fclose(f);

% Time & Error Calculation 
toc(start); 
fprintf('\r\n');

Error = sum(abs(input - output)); 
disp(['Total Bit Error: ' num2str(Error)]); 
fprintf('\r\n');

fprintf('Length of text = ');
disp(lentex);
sizetex = lentex*8;
fprintf('Size of text(bits) = ');
disp(sizetex);
fprintf('Number of distinct characters = ');
disp(lencode);
fprintf('Size of encoded bit stream (bits) = ');
disp(sizebs);


