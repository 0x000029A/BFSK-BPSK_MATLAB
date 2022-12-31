clc
clear all
close all

%% BPSK Modulator
Fc = input('Enter carrier frequency: ');
Tb = input('Enter period of each bit: ');
Fs = input('Enter sampling frequency: ');
Ds = input('Enter phase shift in degrees: ');
BitStreamStr = input('Enter the bit stream separated by a space: ', 's');
BitStream = sscanf(BitStreamStr, '%f');

Ts = 1 / Fs;
Rb = 1 / Tb;
Tlen = length(BitStream) * Tb;
t = 0:Ts:Tlen;

ph = (Ds*pi)/180;
cos1 = cos(2*pi*Fc*t);
cos2 = cos(2*pi*Fc*t + ph);

BPSK_MOD = zeros(length(t), 1);
BitStreamP = zeros(length(t), 1);

for i = 1:length(BitStream)
    for j = Tb*(i-1)*Fs + 1:(Tb*i*Fs) + 1
        if BitStream(i) == 0
            BPSK_MOD(j) = cos1(j);
        else
            BPSK_MOD(j) = cos2(j);
            BitStreamP(j) = 1;
        end
    end
end

subplot(4, 1, 1);
plot(t, cos1);
title("Carrier Wave");
xlabel("Time");
ylabel("Amplitude");
ylim([-2 2]);

subplot(4, 1, 2);
plot(t, BitStreamP);
title("Bit Stream");
xlabel("Time");
ylabel("Amplitude");
ylim([-2 2]);

subplot(4, 1, 3);
plot(t, BPSK_MOD);
title("Modulated Wave");
xlabel("Time");
ylabel("Amplitude");
ylim([-2 2]);
%% BPSK Demodulator
d_pmdmod = pmdemod(BPSK_MOD, Fc, Fs, ph);
d_BitStream = my_sig(d_pmdmod);
subplot(4,1,4)
plot(t, d_BitStream);
title("Demodulated Bit Stream");
xlabel("Time");
ylabel("Amplitude");
ylim([-2 2]);
%%%%%%%%
function Y = my_sig(X)
    Y = zeros(size(X));
    for i = 1:numel(X)
        if X(i) <= -0.5
            Y(i) = 1;
        elseif X(i) >= 0.5
            Y(i) = 1;
        elseif X(i) > -0.5
            if X(i) < 0.5
                Y(i) = 0;
            end
        else
            Y(i) = X(i);
        end
	end
end
