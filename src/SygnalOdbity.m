clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Zmienne                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
okres = 10^-7;
dlugoscNaszegoSygnalu = 20;
Amplituda = 10;
ZaklucenieAmplitudy = 0.25;
ZaklucenieFazy = 0.05;
d = 50;
c = 299792458;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Koniec zmiennych                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%naszSygnal = [0 1 1 0 1 0 1 1 0 0 0 1];
naszSygnal = rand(1,dlugoscNaszegoSygnalu);
for i= 1:dlugoscNaszegoSygnalu;
    if(naszSygnal(i) >= 0.5)
        naszSygnal(i) = 1;
    else
        naszSygnal(i) = 0;
    end
end
t = 0.01:0.01:dlugoscNaszegoSygnalu;
x = 1:1:(dlugoscNaszegoSygnalu+2)*100;
for i = 1:dlugoscNaszegoSygnalu
%generujemy zaklucenia w Amplitudzie (wektor)
    zakluceniaAmpituda(i) = normrnd(0,ZaklucenieAmplitudy);
    zaklueniceFazeUp(i) = normrnd(0,ZaklucenieFazy);
end

zakluceniaAmpituda;
zaklueniceFazeUp;

%Zamiana z 1 i 0 na 1 i -1
for i = 1:dlugoscNaszegoSygnalu
    if (naszSygnal(i)== 0)
        zamienionyNaszSygnal(i) = -1;
    else
        zamienionyNaszSygnal(i) = 1;
    end
    %Dyskretyzacja odwrotna naszegoSygnalu
    %W sensie ¿e dla przykladu sygnal 10 bitó zwiêkszay na taki sam sygnal
    %1000 bitów.
    %Dziêki temu lepiej siê to wszystko wyœwietla
    %TU SIE DZIEJE MAGIA(dodajemy zaklucenia)
    for j = i:0.1:i+1
        pomocniczy(x(i*100:(i+1)*100)) = zamienionyNaszSygnal(i);
        if (mod(i,2) == 0)
            pomocniczyParzysty(x(i*100:(i+1)*100)) = zamienionyNaszSygnal(i);
            pomocniczyParzysty(x((i+1)*100:(i+2)*100)) = zamienionyNaszSygnal(i);
        else
            pomocniczyNieparzysty(x(i*100:(i+1)*100)) = zamienionyNaszSygnal(i);
            pomocniczyNieparzysty(x((i+1)*100:(i+2)*100)) = zamienionyNaszSygnal(i);
        end
    end
   
end

%Tutaj jedyne co sie dzieje too zmiana wyswietlania tego wszystkiego z -1 i
%1 na 0 i 1. Trochê to ³opatologizne ale dzia³a
for i = 1:dlugoscNaszegoSygnalu
    if (naszSygnal(i)== 0)
        zamienionyNaszSygnal(i) = 0;
    else
        zamienionyNaszSygnal(i) = 1;
    end
    %Dyskretyzacja odwrotna naszegoSygnalu
    for j = i:0.1:i+1
        cyfrowy(x(i*100:(i+1)*100)) = zamienionyNaszSygnal(i);
         if (mod(i,2) == 0)
            cyfrowyPomocniczyParzysty(x(i*100:(i+1)*100)) = zamienionyNaszSygnal(i);
            cyfrowyPomocniczyParzysty(x((i+1)*100:(i+2)*100)) = zamienionyNaszSygnal(i);
        else
            cyfrowyPomocniczyNieparzysty(x(i*100:(i+1)*100)) = zamienionyNaszSygnal(i);
            cyfrowyPomocniczyNieparzysty(x((i+1)*100:(i+2)*100)) = zamienionyNaszSygnal(i);
        end
    end
end

pomocniczy = pomocniczy(101:end);
pomocniczyParzysty = pomocniczyParzysty(201:(dlugoscNaszegoSygnalu+2)*100);
pomocniczyNieparzysty = pomocniczyNieparzysty(101:(dlugoscNaszegoSygnalu+1)*100);
cyfrowy = cyfrowy(101:end);
cyfrowyPomocniczyParzysty = cyfrowyPomocniczyParzysty(201:(dlugoscNaszegoSygnalu+2)*100);
cyfrowyPomocniczyNieparzysty = cyfrowyPomocniczyNieparzysty(101:(dlugoscNaszegoSygnalu+1)*100);

for i = 1 : length(pomocniczyParzysty)/2
    paryszte(i) = 2 * i;
    nieparyszte(i) = 2 * i - 1;
end

for i = 1 : length(pomocniczyParzysty)/2
    pParzysty(i) = pomocniczyParzysty(paryszte(i));
    pNieparzysty(i) = pomocniczyNieparzysty(nieparyszte(i));
    cpParzysty(i) = cyfrowyPomocniczyParzysty(paryszte(i));
    cpNieparzysty(i) = cyfrowyPomocniczyNieparzysty(nieparyszte(i));
end
wartosc_oslabienia = 10;
opoznienie = (2*d/c)/okres;
probki_na_okres = 100;
k = floor(opoznienie * probki_na_okres);
x=1;
y=100;
i1 = 1;
i2 = 1;
for i = 1:dlugoscNaszegoSygnalu
    for j = x:y
        cost(j) = cos(2*pi*t(j) + zaklueniceFazeUp(i));
        sint(j) = sin(2*pi*t(j) + zaklueniceFazeUp(i));
        if(j < k)
            costPrze(j) = 0;
            sintPrze(j) = 0;
        else
            
            costPrze(j) = cos(2*pi*t(j - k + 1) + zaklueniceFazeUp(i1));
            sintPrze(j) = sin(2*pi*t(j - k + 1) + zaklueniceFazeUp(i1));
            if(i2 == 100)
                i1 = i1+1;
                i2 = 1;
            else
                i2 = i2+1;
            end
        end
    end
    x=x+100;
    y=y+100;
end
x=1;
y=100;
i1 = 1;
i2 = 1;
for i = 1:dlugoscNaszegoSygnalu
    for j = x:y
        ct(j) = pomocniczy(j)*cost(j)*(Amplituda + zakluceniaAmpituda(i));
        st(j) = pomocniczy(j)*sint(j)*(Amplituda + zakluceniaAmpituda(i));
        if(j < k)
            ctPrze(j) = 0;
            stPrze(j) = 0;
        else
            
            ctPrze(j) =  pomocniczy(j - k + 1)*costPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
            stPrze(j) =  pomocniczy(j - k + 1)*sintPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
            if(i2 == 100)
                i1 = i1+1;
                i2 = 1;
            else
                i2 = i2+1;
            end
        end
    end
    x=x+100;
    y=y+100;
end

x=1;
y=100;
i1 = 1;
i2 = 1;
for i = 1:dlugoscNaszegoSygnalu/2
    for j = x:y
        ctP(j) = pParzysty(j)*cost(j)*(Amplituda + zakluceniaAmpituda(i));
        ctN(j) = pNieparzysty(j)*cost(j)*(Amplituda + zakluceniaAmpituda(i));
        stP(j) = pParzysty(j)*sint(j)*(Amplituda + zakluceniaAmpituda(i));
        stN(j) = pNieparzysty(j)*sint(j)*(Amplituda + zakluceniaAmpituda(i));
    if(j < k)
        ctPrzeP(j) = 0;
        ctPrzeN(j) = 0;
        stPrzeP(j) = 0;
        stPrzeN(j) = 0;
    else 
        ctPrzeP(j) =  pomocniczy(j - k + 1)*costPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
        ctPrzeN(j) =  pomocniczy(j - k + 1)*costPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
        stPrzeP(j) =  pomocniczy(j - k + 1)*sintPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
        stPrzeN(j) =  pomocniczy(j - k + 1)*sintPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
            if(i2 == 100)
                i1 = i1+1;
                i2 = 1;
            else
                i2 = i2+1;
            end
        end
    end
    x=x+100;
    y=y+100;
end

qpsk = ctP + stN;
qpskPrze = ctPrzeP + stPrzeN;
qpskNowy = ctP + ctPrzeP + stN + stPrzeN;

j=1;
for i = 1:dlugoscNaszegoSygnalu   
    punktyXbpsk(i) = ct(j);
    punktyYbpsk(i) = st(j); 
    [theta,rho] = cart2pol(punktyXbpsk,punktyYbpsk);
    NoToXbpsk(i) = rho(i) * cos(theta(i));
    NoToYbpsk(i) = rho(i) * sin(theta(i));
    j=j+100;
end

j=60;
for i = 1:dlugoscNaszegoSygnalu/2
    punktyXqpskP(i) = ctP(j);
    punktyYqpskP(i) = stP(j); 
    j=j+100;
end 

j=90;
for i = 1:dlugoscNaszegoSygnalu/2  
    punktyXqpskN(i) = ctN(j);
    punktyYqpskN(i) = stN(j); 
    j=j+100;
end 

for i = 1:dlugoscNaszegoSygnalu/2
    qpskX(i) = punktyXqpskP(i);
    qpskY(i) = punktyYqpskN(i);
    [theta,rho] = cart2pol(qpskX,qpskY);
    qX(i) = rho(i) * cos(theta(i));
    qY(i) = rho(i) * sin(theta(i));
end

for i = 1:length(t)/2
    t1(i) = t(i);
end

ctNowy = ct + ctPrze;

%Demodulacja bpsk
poczatek = 15;
srodek = 50;
koniec = 75;
wynikowy_syg_bit_bpsk = [];
for i = 1:dlugoscNaszegoSygnalu
    jedynka = 0;
    zero = 0;
    if(ctNowy(floor(poczatek)) >= 0)
        jedynka = jedynka + 1;
    else
        zero = zero + 1;
    end
    if(ctNowy(floor(srodek)) < 0)
        jedynka = jedynka + 1;
    else
        zero = zero + 1;
    end
    if(ctNowy(floor(koniec)) >= 0)
        jedynka = jedynka + 1;
    else
        zero = zero + 1;
    end
    if(zero > jedynka)
        wynikowy_syg_bit_bpsk(i) = 0;
    else
        wynikowy_syg_bit_bpsk(i) = 1;
    end
    poczatek = poczatek + 100;
    srodek = srodek + 100;
    koniec = koniec + 100;
end

%Demodulacja qpsk
poczatek1 = 1;
poczatek2 = 2;
indekswyniku = 1;
wynikowy_syg_bit_qpsk2 = [];
for i = 1:dlugoscNaszegoSygnalu/2
    jedynkajedynka = 0;
    jedynkazero = 0;
    zerojedynka = 0;
    zerozero = 0;
    if((qpskNowy(floor(poczatek1)))>= 0)
        if((qpskNowy(floor(poczatek2)) - qpskNowy(floor(poczatek1))) >= 0)
            jedynkajedynka = jedynkajedynka + 1;
        else
            zerojedynka = zerojedynka + 1;
        end
    else
        if((qpskNowy(floor(poczatek2)) - qpskNowy(floor(poczatek1))) >= 0)
            jedynkazero = jedynkazero + 1;
        else
            zerozero = zerozero + 1;
        end
    end
    if(jedynkajedynka > jedynkazero && jedynkajedynka > zerojedynka && jedynkajedynka > zerozero)
        wynikowy_syg_bit_qpsk2(indekswyniku) = 1;
        wynikowy_syg_bit_qpsk2(indekswyniku + 1) = 1;
    elseif(jedynkazero > jedynkajedynka && jedynkazero > zerojedynka && jedynkazero > zerozero)
        wynikowy_syg_bit_qpsk2(indekswyniku) = 1;
        wynikowy_syg_bit_qpsk2(indekswyniku + 1) = 0;
    elseif(zerojedynka > jedynkajedynka && zerojedynka > jedynkazero && zerojedynka > zerozero)
        wynikowy_syg_bit_qpsk2(indekswyniku) = 0;
        wynikowy_syg_bit_qpsk2(indekswyniku + 1) = 1;
    elseif(zerozero > jedynkajedynka && zerozero > zerojedynka && zerozero > jedynkazero)
        wynikowy_syg_bit_qpsk2(indekswyniku) = 0;
        wynikowy_syg_bit_qpsk2(indekswyniku + 1) = 0;
    end
    poczatek1 = poczatek1 + 100;
    poczatek2 = poczatek2 + 100;
    indekswyniku = indekswyniku + 2;
end

BERbpskPrze = 0;
BERqpskPrze = 0;
for i = 1:dlugoscNaszegoSygnalu
    if(naszSygnal(i) == wynikowy_syg_bit_bpsk(i))
        BERbpskPrze = BERbpskPrze + 0;
    else
        BERbpskPrze = BERbpskPrze + 1;
    end
    if(naszSygnal(i) == wynikowy_syg_bit_qpsk2(i))
        BERqpskPrze = BERqpskPrze + 0;
    else
        BERqpskPrze = BERqpskPrze + 1;
    end
end

figure;
plot(t,cyfrowy);
xlabel('Poszczególne bity');
ylabel('Amplituda');
title('Wejœcie bitowe:');
grid on ;
axis([0 dlugoscNaszegoSygnalu -0.5 +1.5]);
 
figure;
plot(t,ct);
xlabel('Czas');
ylabel('Amplituda');
title('BPSK');
grid on;
grid minor;
axis([0 dlugoscNaszegoSygnalu -(Amplituda + 5) +(Amplituda + 5)]); 
ax = gca;
ax.GridLineStyle = '-';
ax.MinorGridLineStyle = '-';

figure;
plot(t,ctPrze);
xlabel('Czas');
ylabel('Amplituda');
title('BPSK opozniony');
grid on;
grid minor;
axis([0 dlugoscNaszegoSygnalu -(Amplituda + 5) +(Amplituda + 5)]); 
ax = gca;
ax.GridLineStyle = '-';
ax.MinorGridLineStyle = '-';

figure;
plot(t,ctNowy);
xlabel('Czas');
ylabel('Amplituda');
title('BPSK trafiaj¹cy do Anteny');
grid on;
grid minor;
axis([0 dlugoscNaszegoSygnalu -(Amplituda + 10) +(Amplituda + 10)]); 
ax = gca;
ax.GridLineStyle = '-';
ax.MinorGridLineStyle = '-';

figure;
plot(t1,qpsk);
xlabel('Czas');
ylabel('Amplituda');
title('QPSK');
grid on;
grid minor;
axis([0 dlugoscNaszegoSygnalu/2 -(Amplituda + 10) +(Amplituda + 10)]); 
ax = gca;
ax.GridLineStyle = '-';
ax.MinorGridLineStyle = '-'; 

figure;
plot(t1,qpskPrze);
xlabel('Czas');
ylabel('Amplituda');
title('QPSK opozniony');
grid on;
grid minor;
axis([0 dlugoscNaszegoSygnalu/2 -(Amplituda + 5) +(Amplituda + 5)]); 
ax = gca;
ax.GridLineStyle = '-';
ax.MinorGridLineStyle = '-'; 

figure;
plot(t1,qpskNowy);
xlabel('Czas');
ylabel('Amplituda');
title('QPSK trafiaj¹cy do Anteny');
grid on;
grid minor;
axis([0 dlugoscNaszegoSygnalu/2 -(Amplituda + 13) +(Amplituda + 13)]); 
ax = gca;
ax.GridLineStyle = '-';
ax.MinorGridLineStyle = '-'; 


naszSygnal;
BERbpskPrze
BERqpskPrze