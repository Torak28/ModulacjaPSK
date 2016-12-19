function[wynikb]=NaszProgramb(dlugosc,AMP,x,y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Zmienne                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dlugoscNaszegoSygnalu = dlugosc;
Amplituda = AMP;
ZaklucenieAmplitudy = x;
ZaklucenieFazy = y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Koniec zmiennych                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

x=1;
y=100;
for i = 1:dlugoscNaszegoSygnalu
    for j = x:y
        cost(j) = cos(2*pi*t(j) + zaklueniceFazeUp(i));
        sint(j) = sin(2*pi*t(j) + zaklueniceFazeUp(i));
    end
    x=x+100;
    y=y+100;
end
x=1;
y=100;
for i = 1:dlugoscNaszegoSygnalu
    for j = x:y
        ct(j) = pomocniczy(j)*cost(j)*(Amplituda + zakluceniaAmpituda(i));
        st(j) = pomocniczy(j)*sint(j)*(Amplituda + zakluceniaAmpituda(i));
    end
    x=x+100;
    y=y+100;
end

x=1;
y=100;
for i = 1:dlugoscNaszegoSygnalu/2
    for j = x:y
        ctP(j) = pParzysty(j)*cost(j)*(Amplituda + zakluceniaAmpituda(i));
        ctN(j) = pNieparzysty(j)*cost(j)*(Amplituda + zakluceniaAmpituda(i));
        stP(j) = pParzysty(j)*sint(j)*(Amplituda + zakluceniaAmpituda(i));
        stN(j) = pNieparzysty(j)*sint(j)*(Amplituda + zakluceniaAmpituda(i));
    end
    x=x+100;
    y=y+100;
end

qpsk = ctP + stN;

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

%Demodulaja QPSK
for i = 1:dlugoscNaszegoSygnalu/2
    if (punktyXqpskN(i) > 0)
        miejsce1 = 1;
    elseif (punktyXqpskN(i) < 0)
        miejsce1 = 0;
    end
    if (punktyXqpskP(i) > 0)
        miejsce2 = 0;
    elseif (punktyXqpskP(i) < 0)
        miejsce2 = 1;
    end
    if (miejsce1 == 0 && miejsce2 == 0)
        qXrys(i) = punktyXqpskP(i);
        qYrys(i) = punktyYqpskP(i);
    elseif (miejsce1 == 0 && miejsce2 == 1)
        qXrys(i) = punktyXqpskN(i);
        qYrys(i) = punktyYqpskN(i);
    elseif (miejsce1 == 1 && miejsce2 == 1)
        qXrys(i) = punktyXqpskP(i);
        qYrys(i) = punktyYqpskP(i);
    elseif (miejsce1 == 1 && miejsce2 == 0)
        qXrys(i) = punktyXqpskN(i);
        qYrys(i) = punktyYqpskN(i);
    end
    
end

%Demodulaja BPSK
for i = 1:dlugoscNaszegoSygnalu
    if (NoToXbpsk(i) > 0)
        wynikbpsk(i) = 1;
    else
        wynikbpsk(i) = 0;
    end
end

indekswyniku = 1;
for i = 1:dlugoscNaszegoSygnalu/2
    if (qX(i) > 0 && qY(i) > 0)
        wynikqpsk(indekswyniku) = 0;
        wynikqpsk(indekswyniku + 1) = 0;
    elseif (qX(i) > 0 && qY(i) < 0)
        wynikqpsk(indekswyniku) = 1;
        wynikqpsk(indekswyniku + 1) = 0;
    elseif (qX(i) < 0 && qY(i) < 0)
        wynikqpsk(indekswyniku) = 1;
        wynikqpsk(indekswyniku + 1) = 1;
    elseif (qX(i) < 0 && qY(i) > 0)
        wynikqpsk(indekswyniku) = 0;
        wynikqpsk(indekswyniku + 1) = 1;
    end
    indekswyniku = indekswyniku + 2;
end

x=1;
y=100;
for i = 1:dlugoscNaszegoSygnalu
    for j = x:y
        cyfrowyWynikBpsk(j) = wynikbpsk(i);
        cyfrowyWynikQpsk(j) = wynikqpsk(i);
    end
    x=x+100;
    y=y+100;
end

%liczymy BER hehe
BERbpsk = 0;
BERqpsk = 0;
for i = 1:dlugoscNaszegoSygnalu
    if (naszSygnal(i) == wynikbpsk(i))
        BERbpsktablica(i) = 0;
    else
        BERbpsk = BERbpsk + 1;
        BERbpsktablica(i) = 1;
    end
    if (naszSygnal(i) == wynikqpsk(i))
        BERqpsktablica(i) = 0;
    else
        BERqpsk = BERqpsk + 1;
        BERqpsktablica(i) = 1;
    end
end 

for i = 1:length(t)/2
    t1(i) = t(i);
end

wynikb = BERbpsk;
wynikq = BERqpsk;