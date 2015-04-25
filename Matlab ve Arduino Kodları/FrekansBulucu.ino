char a = 'b';
int b=0;
long i=0;
int t1=0;
int t2=0;
void setup() {
Serial.begin(115200);  //Serial Portun acilmasi BaudRate=115200
Serial.println('a');
 while (a!='a'){       //Buradaki kisimda baglantinin teyit edilmesi adina
    a=Serial.read();   //gonderilecek 'a' harfi bekleniyor.
  }                    
  a= 'b';              //veri alinmasina baslamadan once tekrardan kontrol icin degisken tekrardan degistiriliyor
}


void loop() {

  
  while (a!='a'){          //Matlabdan verileri okurken senkronizasyonu saglamak icin tekrardan yukaridaki kontrol yapiliyor
    a=Serial.read();
    b=i;                  //5000 tur ile sinirlamak icin i degiskeninin degeri aliniyor
    t1= millis();         //Sample Rate hesabi icin gerekli zaman olcumu
  }
  int mic;
  mic=analogRead(3);      //analog pinin ciktisi 0-1023 arasinda degerler veriyor
  //char aralik='    ';    //buradaki kodlar gelistirme sirasinda kullandgm kontrol degiskenleri Sample rate i arttirmak icin kapali tutuyorum.
  //Serial.print(i/time);
  //Serial.print(aralik);
  //Serial.print(i);
  //Serial.print(aralik);
 //Serial.print(time); 
  //Serial.print(aralik);
  Serial.println(mic);      //Serial port a string olarak okunan deger baslyor
i=i+1;                      //mikrofon degerinin kac kez basildigini sayiyor. (5000 e kadar)

if(i==(b+5000)){            //5000 ornekleme tamamlaninca bu kisma giriyor
a='b';                      //loop u durdurmak icin degisken degistiriyor
t2= millis();               //5000 orneklemeyi ne kadar surede aldigi hesaplaniyor
Serial.println(t2-t1);       //Serial porta 5001. deger olarak yollaniyor
Serial.println(5000.0/(t2-t1));  //Sampling Rate hesaplaniyor ve 5002. deger olarak serial porttan yollaniyor
Serial.flush();              //Serial port bellegi siliniyor (bu kodu 6. turdan sonraki problem icin kullandim ama cozum olmadi)
}


  // put your main code here, to run repeatedly

}
