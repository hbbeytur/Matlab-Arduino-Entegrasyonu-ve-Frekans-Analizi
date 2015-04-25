%Serial Portun a��lmas� i�in kullan�lan kod

flag=1;
s=serial('/dev/cu.usbmodem1411');  %Arduinonun ba�l� oldu�u porta g�re parantez i�ini d�zenleyin
set(s,'Databits',8);               
set(s,'Stopbits',1);
set(s,'Baudrate',115200);          %Kullan�lan Baudrate (115200 en h�zl�s�)
set(s,'Parity','none');
fopen(s);                       %Serial port a��l�yor
a='b';                          %Serial port ba�lant�s� kontrol ediliyor
while(a ~='a')                  
    a=fread(s,1,'uchar');       %Serial porttan g�nderilen de�er kontrol ediliyor
end
if (a=='a')
    disp('serial read');        
end
fprintf(s,'%c','a');           %Serial porta 'a' de�i�keni yollanarak ileti�im a��l�yor
%mbox = msgbox('Serial Communication setup.'); uiwait(mbox);
fscanf(s, '%u');
rest=0;                        % 6. tur hatas� i�in port a��ld���nda tur say�s� s�f�rlan�yor
