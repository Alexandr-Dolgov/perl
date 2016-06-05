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
my $countLinesStartFromDigit = 0;
my $countAnatherLines = 0;

my $stackTrace = "";
my $prevLineBelongStackTrace = 0;   # в перле нет булевого литерала, но 0, '0', '', пустой список - вычислятся в false
                                    # все остальное - в true

my @allStackTraces;

while( my $line = <FILE> ) {
    $count++;
    if ($line =~ /^[\d<]/) { # если строчка начинается с цифры или символа '<' то это не строчка стектрейса
        if ($prevLineBelongStackTrace) {
            #todo сначала надо посмотреть в массив, нет ли там уже такого стектрейса
            #если нет, то положить в конец этот стектрейс, если есть
            #то туда, где лежат номера, добавить count
            push(@allStackTraces, $stackTrace);


            $stackTrace = "";
            $prevLineBelongStackTrace = 0;
        }
        $countLinesStartFromDigit++;
        next;#переход к следующей итерации цикла
    }
    #заводим переменную куда будем складывать строки СтекТрейса
    $stackTrace = $stackTrace . $line;#конкатенация строк, operator dot (.)
    $prevLineBelongStackTrace = 1;

    $countAnatherLines++;
}
print "count lines: $count\n";
print "count lines start from digit: $countLinesStartFromDigit\n";
print "count another lines: $countAnatherLines\n";


#------------------------
#читаем файл построчно,
# если эта строка не начинается с '\tat ' и не начинается с цифры (что говорит что это не Stack Trace, a просто log)
# тогда значит что эта строчка это начало нового Stack Trace
# и все следующие строчки начинающиеся с '\tat ' это часть этого Stack Trace
#
# Нам нужно прочитать целиком один Stack Trace и занести его в память
#
# каждому СтекТрейсу мы должны поставить в соответствие массив чисел - номера строк в исходном файле где этот СтекТрейс был встречен
# сам по себе СтекТрейс это должен быть массив строк

# на груви подошла бы такая структура: список мап, где каждая мапа: [stackTrace: списокСтрокЭтогоСтекстрейса, lines: списокЧиселСНомерамиСтокГдеЭтотСтекТрейсБылНайден]