interval=5000; %�rnekleme say�s� (Arduino koduyla ayn� olacak �ekilde )
x=1:interval;  %Ses verisi
millis=0;      %bir turun tamamlanma s�resi (serial porttaki 5001. de�i�keni al�r)
rate=0;        %Sampling Rate (serial porttaki 5002. de�i�keni al�r)

fprintf(s,'%c','a');    %Serial porta 'a' yollayarak kayd� ba�lat�r.
for t=1:interval            
    b=str2num(fgetl(s))*5.0/1023;   %string olarak genel serial port verisini say�ya �evirir ve 0-5 de�erleri aras�nda tekrardan �l�eklendirir.
    x(t)=b-3.25;                %gelen sinyalin DC k�sm� siliniyor
%    plot(x);                   %Ger�ek zamanl� �izim k�sm�
%    axis([0,interval,-0.5,0.5]);
%    grid
%    drawnow
end
millis=str2num(fgetl(s));       %5001. de�er al�n�yor(s�re)
rate=str2num(fgetl(s));         %5002. de�er al�n�yor (Sample Rate)
x=x';                           % al�nan ses dosyas�n�n analizde kullan�lmak �zere transpose u al�n�yor


%-------------SES ANAL�Z BA�I--------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Sound Analysis with MATLAB Implementation    %
%                                                %
% Author: M.Sc. Eng. Hristo Zhivomirov  04/01/14 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% get a section of the sound file
%[x,fs] = audioread('track.wav');
%x = x(:,1);             % get the first channel

%ses=audiorecorder(48000,16,1);
%display('Kay�t Ba�lad�')
%recordblocking(ses,5);
%display('Kay�t Bitti')
%x=getaudiodata(ses);
fs=rate*1000;           %Hesaplanan Sample rate analizde kullan�l�yor
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
X = X(100:NUP);           % FFT is symmetric, throw away second half ///Burada 100 Hz e kadarki k�sm� analizden ��kar�yorum 
if rem(N, 2)            % odd nfft excludes Nyquist point
  X(2:end) = X(2:end)*2;
else                    % even nfft includes Nyquist point
  X(2:end-1) = X(2:end-1)*2;
end
f = (99:NUP-1)*fs/N;     % frequency vector  ///Burada 100 Hz e kadarki k�sm� analizden ��kar�yorum 
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


%---------------SES ANAL�Z� SONU---------------


maxvalue=find(max(X)==X);  %Hesaplanan frekans grafi�inin maksimum noktas� bulunuyor
maxfre=f(maxvalue);
%secondmaxfre= find(max(X(X~=max(X))));
sprintf('Frekans= %.2f',maxfre-2) %Hesaplanan frekans de�eri bas�l�yor (Ald���m de�erlere g�re 2 Hz ��kartmay� uygun g�rd�m)
rest=rest+1;    % Testin ka� kez yap�ld��� say�l�yor

if(rest==5)    %6. turdan sonra Arduino'nun serial dan verdi�i de�erlerde de�i�me oluyor reset at�lmas� gerekiyor.
    res;
end


