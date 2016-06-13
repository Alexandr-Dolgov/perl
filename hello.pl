use strict;
use warnings;

#это комментарий

#@ - массив
#@ARGV - массив аргументов командной строки, без имени самой программы
my ($filename) = @ARGV;#достаем из массива @ARGV первый член и помещаем его в переменную $filename

if (not defined $filename) {
    die "Need filename in first arg\n";
}

open(FILE, $filename) or die "Cannot open file $filename\n";

my $count = 0;
my $stackTrace = "";
my $prevLineBelongStackTrace = 0;   # в перле нет булевого литерала, но 0, '0', '', пустой список - вычислятся в false
                                    # все остальное - в true

my @allStackTraces;
my @allStackTracesLineFrom;
my @allStackTracesLineTo;
my $countStackTraceLines = 0;

while( my $line = <FILE> ) {
    $count++;
    if ($line =~ /^[\d<]/) { # если строчка начинается с цифры или символа '<' то это не строчка стектрейса
        if ($prevLineBelongStackTrace) {
            push(@allStackTraces, $stackTrace);
            push(@allStackTracesLineFrom, $count - $countStackTraceLines);
            push(@allStackTracesLineTo, $count - 1);
            $countStackTraceLines = 0;

            $stackTrace = "";
            $prevLineBelongStackTrace = 0;
        }
        next;#переход к следующей итерации цикла
    }
    #заводим переменную куда будем складывать строки СтекТрейса
    $stackTrace = $stackTrace . $line;#конкатенация строк, operator dot (.)
    $countStackTraceLines++;
    $prevLineBelongStackTrace = 1;
}

#вывести все стектрейсы
#for (my $i=0; $i < scalar @allStackTraces; $i++) {
#    print "#$i from $allStackTracesLineFrom[$i] to $allStackTracesLineTo[$i]\n";
#    print "$allStackTraces[$i]\n";
#}

#вывести уникальные стектрейсы с номерами строк, где они были встречены
for (my $i=0; $i < ((scalar @allStackTraces) - 1); $i++) {
    print "#$i from $allStackTracesLineFrom[$i] to $allStackTracesLineTo[$i]";
    for (my $j=$i+1; $j < scalar @allStackTraces; $j++) {
        if ($allStackTraces[$i] eq $allStackTraces[$j]) {
            splice @allStackTraces, $j, 1;
            my $from =  splice @allStackTracesLineFrom, $j, 1;
            my $to =  splice @allStackTracesLineTo, $j, 1;
            print ", from $from to $to";
        }
    }
    print "\n$allStackTraces[$i]\n";
}