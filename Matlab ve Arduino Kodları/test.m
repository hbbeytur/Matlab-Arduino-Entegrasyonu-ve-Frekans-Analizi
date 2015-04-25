interval=5000; %Örnekleme sayýsý (Arduino koduyla ayný olacak þekilde )
x=1:interval;  %Ses verisi
millis=0;      %bir turun tamamlanma süresi (serial porttaki 5001. deðiþkeni alýr)
rate=0;        %Sampling Rate (serial porttaki 5002. deðiþkeni alýr)

fprintf(s,'%c','a');    %Serial porta 'a' yollayarak kaydý baþlatýr.
for t=1:interval            
    b=str2num(fgetl(s))*5.0/1023;   %string olarak genel serial port verisini sayýya çevirir ve 0-5 deðerleri arasýnda tekrardan ölçeklendirir.
    x(t)=b-3.25;                %gelen sinyalin DC kýsmý siliniyor
%    plot(x);                   %Gerçek zamanlý çizim kýsmý
%    axis([0,interval,-0.5,0.5]);
%    grid
%    drawnow
end
millis=str2num(fgetl(s));       %5001. deðer alýnýyor(süre)
rate=str2num(fgetl(s));         %5002. deðer alýnýyor (Sample Rate)
x=x';                           % alýnan ses dosyasýnýn analizde kullanýlmak üzere transpose u alýnýyor


%-------------SES ANALÝZ BAÞI--------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Sound Analysis with MATLAB Implementation    %
%                                                %
% Author: M.Sc. Eng. Hristo Zhivomirov  04/01/14 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% get a section of the sound file
%[x,fs] = audioread('track.wav');
%x = x(:,1);             % get the first channel

%ses=audiorecorder(48000,16,1);
%display('Kayýt Baþladý')
%recordblocking(ses,5);
%display('Kayýt Bitti')
%x=getaudiodata(ses);
fs=rate*1000;           %Hesaplanan Sample rate analizde kullanýlýyor
xmax = max(abs(x));     % find the maximum value
x = x/xmax;             % scalling the signal

% time & discretisation parameters
N = length(x);
t = (0:N-1)/fs;       

% plotting of the waveform
figure(1)
plot(t, x, 'r')
xlim([0 max(t)])
ylim([-1.1*max(abs(x)) 1.1*max(abs(x))])
grid on
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Normalized amplitude')
title('The signal in the time domain')



% spectral analysis
win = hanning(N);       % window
K = sum(win)/N;         % coherent amplification of the window
X = abs(fft(x.*win))/N; % FFT of the windowed signal
NUP = ceil((N+1)/2);    % calculate the number of unique points
X = X(100:NUP);           % FFT is symmetric, throw away second half ///Burada 100 Hz e kadarki kýsmý analizden çýkarýyorum 
if rem(N, 2)            % odd nfft excludes Nyquist point
  X(2:end) = X(2:end)*2;
else                    % even nfft includes Nyquist point
  X(2:end-1) = X(2:end-1)*2;
end
f = (99:NUP-1)*fs/N;     % frequency vector  ///Burada 100 Hz e kadarki kýsmý analizden çýkarýyorum 
X = 20*log10(X);        % spectrum magnitude

% plotting of the spectrum
figure(3)
semilogx(f, X, 'r')
xlim([0 max(f)])
grid on
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
title('Amplitude spectrum of the signal')
xlabel('Frequency, Hz')
ylabel('Magnitude, dB')


%---------------SES ANALÝZÝ SONU---------------


maxvalue=find(max(X)==X);  %Hesaplanan frekans grafiðinin maksimum noktasý bulunuyor
maxfre=f(maxvalue);
%secondmaxfre= find(max(X(X~=max(X))));
sprintf('Frekans= %.2f',maxfre-2) %Hesaplanan frekans deðeri basýlýyor (Aldýðým deðerlere göre 2 Hz çýkartmayý uygun gördüm)
rest=rest+1;    % Testin kaç kez yapýldýðý sayýlýyor

if(rest==5)    %6. turdan sonra Arduino'nun serial dan verdiði deðerlerde deðiþme oluyor reset atýlmasý gerekiyor.
    res;
end


