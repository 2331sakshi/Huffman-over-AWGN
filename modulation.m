function modulated = modulation(modulation_name, bit_stream, Rb, k, amp, freq)
% INPUTs: bit_stream = string of bits, Rb = bit rate 
%         k = samples per bit
%         amp = amplitude of the modulated signal, freq = carrier frequency of the modulated signal 
% OUTPUT: modulated = modulated signal of the bit stream 

modulated = []; 

N = length(bit_stream); % converting string to vector 

% line coding 
line_code = repelem(bit_stream, k); 
Tb = 1/Rb;      % bit duration 
Fs = k * Rb;    % sampling frequency 
Ts = 1 / Fs;
time = 0 : Ts : N*Tb-Ts;

carrier = sin(2*pi*freq*time); 
a1 = amp(1); 
a0 = amp(2);
line_code = a1 * line_code + a0 .* (line_code==0); 
modulated = line_code .* carrier;
    
end