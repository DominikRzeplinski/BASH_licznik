# script to count files in catalogue
#Napisaæ skrypt w jêzyku pow³oki bash/zsh wywo³ywany w nastêpuj¹cy sposób:
#
#licznik [-R] katalog [typ]
#
#Skrypt zlicza pliki okreœlonego typu we wskazanym katalogu i wypisuje
#uzyskany wynik na stdout. Z opcj¹ –R skrypt dzia³a rekurencyjnie w
#ga³êzi drzewa katalogów wskazanej przez argument katalog. W przypadku
#katalogów nale¿y nie liczyæ pozycji o nazwach: . i .. Przy braku
#argumentu typ nale¿y zliczyæ ³¹cznie pliki wszystkich typów (wszystkie
#pliki).
#
#Skrypty powinny zawieraæ nastêpuj¹c¹ obs³ugê b³êdów:
#- sygnalizowaæ b³êdy sk³adni (podaj¹c poprawn¹ postaæ),
#- sygnalizowaæ u¿ycie niepoprawnego argumentu,
#- sygnalizowaæ brak odpowiednich praw dostêpu do katalogu.

## command help 
blad_skladni()
{
echo '## B³¹d sk³adni ##'
echo 'licznik [-R] katalog [typ]'
echo '		-R			- zliczaj rekurencyjnie' 
echo '		katalog		- katalog w którym zliczane s¹ pliki'
echo '		typ			- typ zliczanych plików np. txt'
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
## przekazano b³edny parametr 
if [ "${katalog:0:1}" = "-" ]; then 
	echo 'Blad skladni: B³êdny parametr'
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
## brak praw dostêpu do katalou
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