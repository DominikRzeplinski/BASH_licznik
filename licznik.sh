# script to count files in catalogue
#Napisa� skrypt w j�zyku pow�oki bash/zsh wywo�ywany w nast�puj�cy spos�b:
#
#licznik [-R] katalog [typ]
#
#Skrypt zlicza pliki okre�lonego typu we wskazanym katalogu i wypisuje
#uzyskany wynik na stdout. Z opcj� �R skrypt dzia�a rekurencyjnie w
#ga��zi drzewa katalog�w wskazanej przez argument katalog. W przypadku
#katalog�w nale�y nie liczy� pozycji o nazwach: . i .. Przy braku
#argumentu typ nale�y zliczy� ��cznie pliki wszystkich typ�w (wszystkie
#pliki).
#
#Skrypty powinny zawiera� nast�puj�c� obs�ug� b��d�w:
#- sygnalizowa� b��dy sk�adni (podaj�c poprawn� posta�),
#- sygnalizowa� u�ycie niepoprawnego argumentu,
#- sygnalizowa� brak odpowiednich praw dost�pu do katalogu.

## command help 
blad_skladni()
{
echo '## B��d sk�adni ##'
echo 'licznik [-R] katalog [typ]'
echo '		-R			- zliczaj rekurencyjnie' 
echo '		katalog		- katalog w kt�rym zliczane s� pliki'
echo '		typ			- typ zliczanych plik�w np. txt'
echo '##################'
}

walidacja_parametrow()
{
## brak katalogu 
if [ "$katalog" = "" ]; then 
	echo 'Blad skladni: Podaj katalog'
	blad_skladni
	exit 1 
fi
## przekazano b�edny parametr 
if [ "${katalog:0:1}" = "-" ]; then 
	echo 'Blad skladni: B��dny parametr'
	blad_skladni
	exit 1
fi
## za duzo parametrow
if [ "$rekurencyjnie" = 1 ]; then 
	echo $4
	if [ "$liczbaParametrow" -gt 3 ]; then 
		echo 'Blad skladni: Za duzo parametrow'
		blad_skladni
		exit 1
	fi		
else
	if [ "$liczbaParametrow" -gt 2 ]; then 
		echo 'Blad skladni: Za duzo parametrow'
		blad_skladni
		exit 1
	fi		
fi
}

walidacja_katalogu()
{
## brak praw dost�pu do katalou
if [ ! -r "$katalog" ]; then
	echo 'Katalog nie istnieje lub nie masz do niego uprawnien'
	exit 1
fi
}

policz_pliki()
{
if [ "$typ" = "" ]; then 
	while read i; do 
		#echo "$i"
		if [ "$i" != "" ]; then 
			((liczbaPlikow++))
		fi
	done <<<$(find . -maxdepth 1 -name "*")
	((liczbaPlikow--))
else
	while read i; do 
		#echo "$i"
		if [ "$i" != "" ]; then 
			((liczbaPlikow++))
		fi
	done <<<$(find . -maxdepth 1 -name "*.$typ")
fi
}

policz_pliki_z_rekurencja()
{
#nullglob : If set, bash allows patterns which match no files to expand to a null string, rather than themselves.
if [ "$typ" = "" ]; then 
	while read i; do 
		#echo "$i"
		if [ "$i" != "" ]; then 
			((liczbaPlikow++))
		fi
	done <<<$(find . -name "*")
	((liczbaPlikow--))
else
	while read i; do 
		#echo "$i"
		if [ "$i" != "" ]; then 
			((liczbaPlikow++))
		fi
	done <<<$(find . -name "*.$typ")
fi
}

## Main
rekurencyjnie=0
katalog=
typ=*
liczbaPlikow=0
obecnyFolder=$PWD
liczbaParametrow=$#
## Odczyt parametrow
if [ "$1" = "-R" ]; then 
	rekurencyjnie=1
	katalog=$2
	typ=$3
else
	katalog=$1
	typ=$2
fi
######WALIDACJA
walidacja_parametrow
walidacja_katalogu
#####KONIEC WALIDACJI
cd $katalog

if [ "$rekurencyjnie" = "0" ];then
	policz_pliki
else
	policz_pliki_z_rekurencja
fi

cd $obecnyFolder
echo 'liczba plikow to: ' $liczbaPlikow
#echo 'rekurencyjnie = ' $rekurencyjnie
#echo 'katalog = ' $katalog
#echo 'typ = ' $typ
#$SHELL