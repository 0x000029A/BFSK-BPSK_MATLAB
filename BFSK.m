clc
clear all
close all

%% BFSK Modulator
Fc = input('Enter carrier frequency: ');
Tb = input('Enter period of each bit: ');
Fs = input('Enter sampling frequency');
F_SEP = input('Enter frequency separation: ');
BitStreamStr = input('Enter the bit stream separated by a space: ', 's');
BitStream = sscanf(BitStreamStr, '%f');

Ts = 1 / Fs;
Rb = 1 / Tb;
Tlen = length(BitStream) * Tb;
t = 0:Ts:Tlen;

F1 = Fc + F_SEP;
F2 = Fc - F_SEP;

cos0 = cos(2*pi*Fc*t);
cos1 = cos(2*pi*F1*t);
cos2 = cos(2*pi*F2*t);

BFSK_MOD = zeros(length(t), 1);
BitStreamP = zeros(length(t), 1);

for i = 1:length(BitStream)
    for j = Tb*(i-1)*Fs + 1:(Tb*i*Fs) + 1
        if BitStream(i) == 0
            BFSK_MOD(j) = cos1(j);
        else
            BFSK_MOD(j) = cos2(j);
            BitStreamP(j) = 1;
        end
    end
end

subplot(4, 1, 1);
plot(t, cos0);
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
plot(t, BFSK_MOD);
title("Modulated Wave");
xlabel("Time");
ylabel("Amplitude");
ylim([-2 2]);

%% BFSK Demodulator
d_fmdmod = -fmdemod(BFSK_MOD, Fc, Fs, F_SEP);
d_lp = lowpass(d_fmdmod, Rb, Fs);
d_sign = sign(d_lp);
d_BitStream = max(d_sign,0);

subplot(4,1,4)
plot(t, d_BitStream);
title("Demodulated Bit Stream");
xlabel("Time");
ylabel("Amplitude");
ylim([-2 2]);
