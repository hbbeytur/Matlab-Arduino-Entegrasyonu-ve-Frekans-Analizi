%Serial Portun açýlmasý için kullanýlan kod

flag=1;
s=serial('/dev/cu.usbmodem1411');  %Arduinonun baðlý olduðu porta göre parantez içini düzenleyin
set(s,'Databits',8);               
set(s,'Stopbits',1);
set(s,'Baudrate',115200);          %Kullanýlan Baudrate (115200 en hýzlýsý)
set(s,'Parity','none');
fopen(s);                       %Serial port açýlýyor
a='b';                          %Serial port baðlantýsý kontrol ediliyor
while(a ~='a')                  
    a=fread(s,1,'uchar');       %Serial porttan gönderilen deðer kontrol ediliyor
end
if (a=='a')
    disp('serial read');        
end
fprintf(s,'%c','a');           %Serial porta 'a' deðiþkeni yollanarak iletiþim açýlýyor
%mbox = msgbox('Serial Communication setup.'); uiwait(mbox);
fscanf(s, '%u');
rest=0;                        % 6. tur hatasý için port açýldýðýnda tur sayýsý sýfýrlanýyor
