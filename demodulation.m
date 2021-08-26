function bit_stream = demodulation(modulation_name, received, Rb, k, amp, freq)
% INPUTs:  received: modulated signal received from channel , Rb = bit rate 
%          k = samples per bit , amp = amplitude of the modulated signal
%          freq = carrier frequency of the modulated signal 
% OUTPUT:  bit_stream = demodulated bit stream 

n = length(received) / k;   % n = number of bits 
Tb = 1/Rb; 
Fs = k * Rb; 
Ts = 1/Fs; 
t = 0 : Ts : n*Tb-Ts;
bit_stream = []; 

a0 = amp(1); 
a1 = amp(2);
r = received .* sin(2*pi*freq(1)*t);
r = reshape(r, k, n); 
yd = mean(r); 
threshold = (a0 + a1) / 4; 
bit_stream = (yd >= threshold);
        
% converting logical array to double vector array
bit_stream = double(bit_stream); 
end