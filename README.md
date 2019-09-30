# Modulacja PSK (Phase-Shift Keying)

Studencki projekt na zajęcia z [Niezawodności i Diagnostyki Układów Cyfrowych](http://www.zsk.ict.pwr.wroc.pl/zsk/dyd/intinz/ndsc/) u [dr inż. Jacka Jarnickiego](http://www.zsk.ict.pwr.wroc.pl/zsk/pracownicy/jjarnicki)

Przygotowali:

 * [Wojak94](https://github.com/Wojak94)
 * [olafkrawczyk](https://github.com/olafkrawczyk)
 * [vins790](https://github.com/vins790)
 * [piotrmajcher94](https://github.com/piotrmajcher94)
 * [Torak28](https://github.com/Torak28)

# Wstęp

Naszym zadanie podczas tego projektu było napisanie w środowisku MATLAB programu symulującego dwa typy modulacji sygnałów cyfrowych – BPSK(ang. Binary Phase Shift Keying) oraz QPSK (ang. Quadrature Phase Shift Keying). Obie wymienione modulacje polegają na zmianach fazy sygnału. Oprócz samych algorytmów modulacji, mieliśmy również zaimplementować generator losowych sygnałów cyfrowych, dodawanie losowych zakłóceń na kanale transmisyjnym oraz algorytmy demodulacji BPSK i QPSK. Ostatnim zadaniem było zasymulowanie rzeczywistej sytuacji odbioru sygnału przez antenę. Nasz sygnał miał dotrzeć do anteny z dwóch stron, bezpośrednio od nadajnika oraz jako sygnał odbity od budynku znajdującego się za anteną. Na każdym etapie pracy mieliśmy tworzyć wykresy ilustrujące działanie naszych algorytmów oraz nasz sygnał. Zaczęliśmy od sporządzenia wykresów kwadratowego sygnału binarnego, później stworzyliśmy wykresy pokazujące nasz sygnał zmodulowany zarówno przez BPSK, jak i QPSK. Zilustrowaliśmy również wpływ losowych zakłóceń na wygląd sygnału. Oprócz tego nasz program wyświetla wykresy wskazowe dla obu typów modulacji oraz trójwymiarowe zobrazowanie zależności BER (ang. bit error rate), od różnych wartości zakłóceń fazy oraz amplitudy. Udało nam się zaimplementować wszystkie kroki, oraz zobrazować wyniki naszych eksperymentów na różnych typach wykresów. Szczegóły naszych algorytmów, fragmenty implementacji oraz wyniki eksperymentów zostały przedstawione w dalszej części sprawozdania.

# Podstawy modulacji

### Cel modulacji, zasada działania, zastosowanie

Modulacje cyfrowe są stosowane do transmisji danych binarnych w określonych wąskich rozłącznych pasmach kanału transmisyjnego przeznaczonych na transmisję poszczególnych sygnałów. Wykorzystuje się je np. w łączności modemowej, internetowej, radiowej w paśmie mikrofalowym i satelitarnej. Wprawdzie sygnały zmodulowane w systemach modulacji impulsowo-kodowej mogą być również transmitowane w wąskich pasmach, możliwe jest to jednak po zastosowaniu dodatkowej modulacji analogowej, np. modulacji AM. W przypadku modulacji cyfrowych wąskopasmowy charakter sygnałów wynika natomiast bezpośrednio z samej istoty zastosowanego sposobu modulacji. W cyfrowych systemach modulacji informacja o sygnale zakodowana w sekwencji znaków binarnych „1” i „0” lub sekwencji grup tych znaków o określonej długości jest przesyłana do odbiornika w postaci ciągu krótkich impulsów harmonicznych, których amplituda, faza początkowa lub częstotliwość jest uzmienniana w zależności od transmitowanego strumienia danych. W bardziej złożonych systemach uzmiennieniu mogą podlegać jednocześnie dwa z tych parametrów. (Szabatin, 2000)

![alt text](http://i.imgur.com/igtwr2e.png "Rysunek 1: Schemat transmisji sygnału")

### Podstawowe algorytmy modulacji

**Modulacja amplitudy AM (Amplitude Modulation)** - wielkość amplitudy przebiegu fali nośnej ulga zmianom zgodnie ze stanem sygnału wejściowego. Podczas modulacji sygnałów cyfrowych przełączanie dokonuje się między dwoma poziomami amplitudy, a sposób modulacji nazywa się kluczowaniem amplitudy ASK (Amplitude Shift Keying). Ten sposób modulacji podatny jest na tłumienie, w wyniku czego odbierany sygnał może być inny od wysłanego. Zmodulowany sygnał brzmi jak pojedynczy ton o szybkich zmianach głośności, aczkolwiek zmiany te następują zbyt szybko, by mogły być rozróżniane przez człowieka.

**Modulacja częstotliwości FM (Frequency Modulation)** - modulację częstotliwości stosowaną do transmisji cyfrowych nazwano kluczowaniem częstotliwości FSK (Frequency Shift Keying). Najczęściej używane są dwie częstotliwości: niska - odpowiednik logicznej 1, oraz wysoka - odpowiednik logicznego 0. Przy stosowaniu tej techniki modulacji można uzyskać szybkość transmisji jedynie : 300 b/s lub 600 b/s w trybie pracy dupleksowej (jednoczesna transmisja z pełną szybkością w obydwu kierunkach), a 1200 b/s już tylko w trybie pracy półdupleksowej (tryb pracy naprzemiennej ale w danym momencie jest ustalony tylko jeden kierunek transmisji. Dla odwrócenia kierunku potrzebna jest sygnalizacja że urządzenie ukończyło nadawanie). Zmodulowany sygnał brzmi jak dwa zmieniające się dźwięki.

**Modulacja fazy PM (Phase Modulation)** - polega na zmianie fazy sygnału nośnego zgodnie z ze zmianami cyfrowego sygnału. Na przykład jeśli fala biegnie w danej chwili ku dołowi, a sygnał cyfrowy ulegnie zmianie, kierunek przebiegu zmieniany jest tak, że biegnie on ku górze. W najprostszej formie modulacja fazy powoduje przesunięcie o 0 lub 180° Do modulacji przebiegów cyfrowych stosuje się modulację z kluczowaniem fazy PSK (Phase Shift Keying). Jest ona stosowana w modemach o średniej szybkości od 1200 b/s do 4800 b/s, także w połączeniu z innymi rodzajami modulacji. W modemach najczęściej stosuje się ulepszoną wersję tej modulacji to jest DPSK (Differential Phase-Shift Keying). W tej modulacji wartość binarna określana jest przez stopień przesunięcia fazy względem bieżącego bitu. Na przykład przesunięcie fazy o 90° może reprezentować binarne 0, a przesunięcie o 270° - reprezentować może binarną jedynkę. Dzięki temu sposobowi modem odbierający musi tylko określić charakter zmian fazy. (Wesołowski, 2006)

![alt text](http://i.imgur.com/KyQpLD5.png "Rysunek 2: Rodzaje modulacji")

### Modulacja BPSK

Modulacja BPSK z ang. „Binary Phase Shift Keying”, jest to binarna cyfrowa modulacja w której jeden zmodulowany symbol odpowiada jednemu bitowi. Powoduje to dużą odporność na zakłócenia. Transmisja realizowana jest za pomocą przesunięć fazy fali nośnej o 180 lub -180 stopni, w zależności od wartości przesyłanego bitu. (Bernhard H. Walke, 2003)

![alt text](http://i.imgur.com/evjT7HD.png "Rysunek 3: Modulacja BPSK")

### Modulacja QPSK

Nazwa cyfrowej modulacji QPSK pochodzi od angielskich słów „Quaternart Phase Shift Keying”. Jak wskazuje nazwa, modulacja QPSK mapuje transmitowaną sekwencję bitów, na sekwencje elementów których alfabet składa się z czterech różnych symboli. W transmitowanym sygnale, każdy symbol odpowiada dokładnie jednemu z czterech możliwych przesunięć fazy fali nośnej. (Bernhard H. Walke, 2003)

![alt text](http://i.imgur.com/Ab8DXOU.png "Rysunek 4: Modulacja QPSK")

# Symulacja systemu transmisji cyfrowej z modulacją BSK i QPSK

### Zasada działania i model systemu

Wszelkie modelowanie wykonywaliśmy w Matlabie, ty samym byliśmy zobowiązani do "przełożenia" rzeczywistości na realia jego języka. Rozpoczynamy od generowania sygnału.

Generujemy wektor naszSygnal, zawierający liczby z przedziału od 0 do 1. Następnie przechodząc po całym wektorze sprawdzamy czy wylosowane w poszczególnych komórkach liczby są większe od 0.5 czy nie. Liczby większe bądź równe 0.5 nadpisujemy przez 1, inne przez 0:

```Matlab
naszSygnal = rand(1,dlugoscNaszegoSygnalu);
for i= 1:dlugoscNaszegoSygnalu;
	if(naszSygnal(i) >= 0.5)
		naszSygnal(i) = 1;
	else
		naszSygnal(i) = 0;
	end
end
```
![alt text](http://i.imgur.com/wTom7om.png "Rysunek 5: Wejście bitowe")

Jak łatwo zauważyć generowany przez Nas sygnał będzie tak długi jak parametr dlugoscNaszegoSygnalu, o który pytamy użytkownika na samym początku. Dalej generujemy zakłócenia Fazy i Amplitudy:

```Matlab
for i = 1:dlugoscNaszegoSygnalu
	zakluceniaAmpituda(i) = normrnd(0,ZaklucenieAmplitudy);
	zaklueniceFazeUp(i) = normrnd(0,ZaklucenieFazy);
end
```

Tym razem jednak posługujemy się funkcją normrnd, która to zwraca losową liczbę z rozkładu normalnego o zadanych parametrach. W naszym przypadku jest to 0 dla wartości oczekiwanej, oraz parametry ZaklucenieAmplitudy i ZaklucenieFazy dla odchylenia standardowego. O oba parametry pytamy użytkownika przy starcie programu.

Podsumowując ten etap, mamy wektor naszego sygnału oraz wektory zakłóceń. Tyle tylko, że wygenerowany przez nas sygnał jest za krótki, w sensie że nie jesteśmy w stanie nanieść go na falę nośna w sposób który pozwoliłby nam w sposób jasny i jednoznaczny zakodować znajdującą się w nim informację. Musimy więc "rozmnożyć" go, zachowując jego właściwości:

```Matlab
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
```

Każdemu bitów oryginalnego sygnału, przypada teraz 100 takich samych próbek. Tym samym niezależnie od początkowej długości generowany przez Nas sygnał zwiększył się 100 krotnie. Co więcej w powyższym kawałku kodu dzielimy nasz sygnał na część parzystą i nieparzystą, co przydaje się przy modulacji QPSK.

### Opis symulatora

Jako że mamy już gotowy sygnał przygotowany do wyświetlenia na fali nośnej w sposób który gwarantuje nam nie gubienie informacji i jednoznaczność, pora nanieść go na nią i dodać zakłócenia. Rzutowanie na falę odbywa się prosto, poprzez wygenerowanie samej fali(w naszym przypadku cosinus dla BPSK), a następnie pomnożenie jej przez wygenerowany wcześniej sygnał. Samo dodawania zakłóceń odbywa się w dwóch krokach, pierw do fali nośnej dodajemy zakłócenia Fazy, a w następnej pętli mnożymy falę przez sygnał, nadajemy mu Amplitudę o którą wcześniej pytamy użytkowania i od razu ją zakłócamy:

```Matlab
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
```

Warto tutaj dodać że zakłócamy tak samo wszystkie 100 próbek odpowiadające danemu bitowi informacji. Dokładnie ta sama procedura powtórzona jest następnie w wypadku próbek parzystych i nieparzystych.
Na tym etapie posiadamy już modulacje BPSK i QPSK. Modulacja BPSK to nic innego jak wektor ct pokazany w kawałku kodu powyżej. Modulacja QPSK to suma zmodulowanych funkcją cosinus parzystych bitów i zmodulowanych funkcja sinus bitów nieparzystych.

![alt text](http://i.imgur.com/KJuzNHO.png "Rysunek 6: Wykres BPSK")

![alt text](http://i.imgur.com/N56cKzo.png "Rysunek 7: Wykres QPSK")

Sposób modulacji QPSK, to znaczy dodawanie Zmodulowanej fali nośnej bitów parzystych i nieparzystych powoduje skrócenie sygnału o połowę, co jest oczywiście zgodne z założeniami. W jednym punkcie, albo jak kto woli w jednej komórce wektora qpsk przechowywana jest informacja o dwóch bitach początkowego sygnału, początkowej informacji.

Posiadając oba sygnały w wersji zmodulowanej i zakłóconej przechodzimy do rysowania wykresów wskazowych. I tak dla BPSK tworzymy wektory punktów X i Y. Oba są tym samym sygnałem, zakłóconym w ten sam sposób, lecz zmodulowanym przy pomocy innych fal nośnych. Dla X jest to cosinus dla Y jest to sinus. Następnie X i Y musimy transponować na płaszczyznę biegunową z kartezjańskiej, w jakie znajdowaliśmy się do tej pory. Posiadając to wszystko wystarczy skorzystać z prostej zależności trygonometrycznej by uzyskać interesujące nas pary punktów:

```Matlab
Xbpsk = (Amp + zakAmp) * cos(Faz + zakFaz)
Ybpsk = (Amp + zakAmp) * sin(Faz + zakFaz)
j=1;
for i = 1:dlugoscNaszegoSygnalu
	punktyXbpsk(i) = ct(j);
	punktyYbpsk(i) = st(j);
	[theta,rho] = cart2pol(punktyXbpsk,punktyYbpsk);
	NoToXbpsk(i) = rho(i) * cos(theta(i));
	NoToYbpsk(i) = rho(i) * sin(theta(i));
	j=j+100;
end
```

Wyznaczanie współrzędnych do wykresu wskazowego modulacji QPSK jest analogiczne.

![alt text](http://i.imgur.com/vzGWgao.png "Rysunek 8: Wykres wskazowy BPSK")

![alt text](http://i.imgur.com/Ga3T9tU.png "Rysunek 9: Wykres wskazowy QPSK")

Do pełni szczęścia brakuję nam już tylko demodulacji. Na tym etapie projektu nasza demodulacja oparta jest o wykresy wskazowe:

```Matlab
for i = 1:dlugoscNaszegoSygnalu
	if (NoToXbpsk(i) > 0)
		wynikbpsk(i) = 1;
	else
		wynikbpsk(i) = 0;
	end
end
```

Dla modulacji BPSK wystarczy iterując po całym wektorze X sprawdzać położenie funkcji względem zera. Dla większych od zera przyjąć 1 a dla mniejszych 0. W przypadku QPSK idea jest dokładnie taka sama, z tą różnicą że sprawdzamy ćwiartkę układu współrzędnych:

```Matlab
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
```

Wypadało by teraz porównać wyniki demodulacji z naszym pierwotnym sygnałem, co sprowadza się do porównywania dwóch tablic:

```Matlab
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
```

Po tej operacji uzyskujemy ilość błędów BPSK i QPSK reprezentowaną jako liczbę oraz jako tablicę pokazującą które bity zostały źle odczytane.

Wszystkie powyższe operacje(generacje, modulacje, zakłócanie, demodulacje i obliczenia BERa) następnie wywoływaliśmy **dlugoscNaszegoSygnalu2** razy w celu wygenerowania trójwymiarowego wykresu wielkości BERu:

```Matlab
function[wynikb]=NaszProgramb(dlugosc,AMP,x,y) %BPSK
function[wynikq]=NaszProgramq(dlugosc,AMP,x,y) %QPSK
```

Do każdej z funkcji przesyłamy długość sygnału do wygenerowania, amplitudę jaka ma mieć wygenerowany sygnał oraz wartość odchyleń standardowych potrzebnych do wylosowania zakłóceń fazy i amplitudy. Wartości zakłóceń wpisane są do tablic i różnią się od siebie o 0.05:

```Matlab
indeks = 1;
for i = 0:0.05:1
	zakluceniaA(indeks) = i;
	zakluceniaF(indeks) = i;
	indeks = indeks + 1;
end
zakluceniaFa = zakluceniaF';
X = sort(zakluceniaA);
Y = sort(zakluceniaFa);
for i = 1:length(zakluceniaA)-1
	x = sort(zakluceniaA);
	y = sort(zakluceniaFa);
	X = [X;x];
	Y = [Y,y];
end
```

Przekładowy wygląd tablic X i Y:
```
X =
-3.0000 -1.5000 0 1.5000 3.0000
-3.0000 -1.5000 0 1.5000 3.0000
-3.0000 -1.5000 0 1.5000 3.0000
-3.0000 -1.5000 0 1.5000 3.0000
-3.0000 -1.5000 0 1.5000 3.0000
Y =
-3.0000 -3.0000 -3.0000 -3.0000 -3.0000
-1.5000 -1.5000 -1.5000 -1.5000 -1.5000
0 0 0 0 0
1.5000 1.5000 1.5000 1.5000 1.5000
3.0000 3.0000 3.0000 3.0000 3.0000
```

Jak łatwo zauważyć przy każdy wywołaniu funkcji generowany jest inny sygnał, a następnie generowane są losowe zakłócenia w których wartości z tablicy są jedynie odchyleniem standardowym. Zabieg ten jest celowy i ma na celu zwiększenie różnorodności naszych sygnałów.

Wyniki BERu dla każdej iteracji wywoływania naszej funkcji zapisywane są w wektorach **Zbpsk** i **Zqpsk**:

```Matlab
for i=1:length(zakluceniaAmp)
	for j=1:length(zakluceniaFaz)
		Zbpsk(i,j) = NaszProgramb(dlugoscNaszegoSygnalu,Amplituda,X(i,j),Y(i,j));
		Zqpsk(i,j) = NaszProgramq(dlugoscNaszegoSygnalu,Amplituda,X(i,j),Y(i,j));
	end
end
```

Jak łatwo zauważyć powyższa funkcja bardzo wpływa na długość wykonywania się całego programu.

![alt text](http://i.imgur.com/s98grBi.png "Rysunek 10: BER BPSK")

![alt text](http://i.imgur.com/atPf9QI.png "Rysunek 11: BER QPSK")


### Wyniki symulacji i wnioski

Jak łatwo zauważyć obie modulacje są w mały sposób zależne od zakłóceń Amplitudy, a w dużo większym stopniu od zakłóceń Fazy. Co więcej z powodu że QPSK ma mniejsze „pole manewru”(Rysunek 11), przez co rozumiemy że każde zakłócenie Fazy działa na nie mocniej niż w wypadku BPSK, tym samym można zaobserwować ,że ilość błędów w modulacji QPSK jest większa.

Najłatwiej dostrzec to porównując (Rysunek 10) i (Rysunek 11). Wysokość Osi OZ dla modulacji QPSK jest większa, co pokazuje że generuję się tam więcej błędów, co więcej widać że w modulacji BPSK błędy pojawiają się kiedy zakłócenia fazy osiągną ok. 0.5, w przypadku modulacji QPSK błędy pojawiają się już przy 0.25. Oprócz tego gołym okiem można zauważyć dużo mniejszy wpływ zakłócenia amplitudy na ilości błędów.

# Analiza systemu transmisji cyfrowej z odbiciem sygnału

### Zasada działania i model systemu

W tym momencie nasze modulacje skonfrontowaliśmy z rzeczywistym problemem. Scenariusz wygląda następująco - nasz sygnał dociera do pewnej anteny z dwóch stron. Z jedne strony w linii prostej od nadajnika, a z drugiej jako sygnał odbity od budynku znajdującego się za anteną, oczywiście opóźniony o odpowiednią wartość i adekwatnie osłabiony. Do wyliczenia opóźnienia zakładamy pewną realną częstotliwość naszego sygnału oraz odległość budynku od anteny. Obie fale trafiają na siebie, a następnie nałożone trafiają do Anteny. Odebrany sygnał poddajemy demodulacji, tym razem jednak nie posiadając informacji o wielkości zakłóceń. W tym wypadku nasza demodulacja polega na analizie kształtu odebranej fali. Pobieramy konkretne próbki i sprawdzamy ich znak oraz badamy monotoniczność sygnału w odpowiednich
miejscach.

![alt text](http://i.imgur.com/UMp76ZP.png "Rysunek 12: Modelowana sytuacja")

###Opis symulatora
Sama generacja obu sygnałów przebiega identycznie tak jak wcześniej. jedyna różnica pojawią się w związku z generacja drugiego sygnału. Jest on oczywiście osłabiany przez zmniejszenie amplitudy oraz przesuwany:

```Matlab
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
			ctPrze(j) = pomocniczy(j - k + 1)*costPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
			stPrze(j) = pomocniczy(j - k + 1)*sintPrze(j)*((Amplituda + zakluceniaAmpituda(i1))/wartosc_oslabienia);
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
```

Nasze przesunięte sygnały to **ctPrze** i **stPrze**. Wartość opóźnienia wyliczamy w następujący sposób:

![alt text](http://i.imgur.com/y8YKkk0.png "Wzory 1: Wykorzystane równania")

Jak widać wykorzystaliśmy zależność drogi od czasu w ruchu jednostajnym prostoliniowym, a następnie w oparciu o ilość próbek na jeden okres fali nośnej, wyliczyliśmy wartość osłabienia.

![alt text](http://i.imgur.com/lPkYINo.png "Rysunek 13: Wykres BPSK")

![alt text](http://i.imgur.com/eAS6m90.png "Rysunek 14: Wykres QPSK")

![alt text](http://i.imgur.com/RK0wTXw.png "Rysunek 15: Wykres BPSK opóźniony")

![alt text](http://i.imgur.com/RshWD9r.png "Rysunek 16: Wykres QPSK opóźniony")

Jako że mamy już zarówno sygnał pierwotny jaki i jego opóźnioną wersję nie pozostaje nam nic innego jak je dodać, a następnie wyrysować:

```Matlab
ctNowy = ct + ctPrze;
qpskNowy = ctP + ctPrzeP + stN + stPrzeN;
```

![alt text](http://i.imgur.com/RYTpFY1.png "Rysunek 17: Wykres BPSK docierający do anteny")

![alt text](http://i.imgur.com/O1SRItU.png "Rysunek 18: Wykres QPSK docierający do anteny")

Następnie przeprowadzamy demodulacje obu sygnałów. Tym razem jednak nie robimy tego w oparciu wykresy wskazowe, ale o same sygnały:

```Matlab
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
```

Idea jest prosta. Dla modulacji BPSK badamy znak przy 15,50 i 75 próbce każdego okresu. W zależności od niego przypisuje wynikowi 1 albo 0 (Dla przykładu, jeśli 15 i 75 próbka jest nad 0 osi OX mamy do czynienia z zakodowaną 1). Dla modulacji QPSK pierw badamy znak 1 próbki i w zależności od wyniku badamy czy funkcja rośnie czy nie. Zmiana sposobu demodulacji przy modulacji QPSK względem modulacji BPSK wynika z faktu, że wykresy dla (1,0) i (0,0) są takie same co do znaku próbek 15,50 i 75.

### Wynik symulacji

W celu uzyskania wartości BER postępujemy analogicznie jak wcześniej, czyli porównujemy dwie tablice:

```Matlab
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
```

Wyniki pokrywają się z przewidywaniami. Im większe zakłócenie Fazy tym więcej błędów, a zakłócanie amplitudy ma minimalny wpływ na ilość błędów w obu modulacjach. Modulacja QPSK nadal generuje więcej błędów od modulacji BPSK. Jedyna zmiana występuje w ilości błędów. Zakłócanie sygnału, sygnałem odbitym zwiększa ilość błędów o ok.20% co w wynika z przesunięć fazowych w momencie nakładania się fal.

# Bibliografia

1. *Bernhard H. Walke, P. S. (2003).*, **UMTS: The Fundamentals.**, ISBN: 978-0-470-84557-8.
2. *Lyons, G. (1999).*, **Wprowadzenie do cyfrowego przetwarzania sygnałów. Warszawa: Wydawnictwa Komunikacji i Łączności.**, ISBN: 978-83-206-1764-1.
3. *Nuaymi, P. L. (2007).*, **Technology for Broadband Wireless Access. rozdział 5.11, 5.2.**, ISBN: 978-0-470-02808-7.
4. *Pratap, R. (2013).*, **Matlab 7 dla naukowców i inżynierów.**, Warszawa: Wydawnictwo Naukowe PWN; ISBN: 978-8-301-1605-79.
5. *Szabatin, J. (2000).*, **Podstawy teorii sygnałów. Wydawnictwa Komunikacji i Łączności.**, ISBN: 978-83-206-1331-5.
6. *Wesołowski, K. (2006).*, **Podstawy cyfrowych systemów telekomunikacyjnych.**, Wydawnictwa Komunikacji i Łączności; ISBN: 832-0-615-089.
