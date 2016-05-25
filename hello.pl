use strict;
use warnings;

#это комментарий

#@ - массив
#@ARGV - массив аргументов командной строки, без имени самой программы
my ($filename) = @ARGV;#достаем из массива @ARGV первый член и помещаем его в переменную $filename

if (not defined $filename) {
    die "Need filename in first arg\n";
}

print "filename: $filename\n";

open(FILE, $filename) or die "Cannot open file $filename\n";

my $count = 0;
my $countLinesStartFromDigit = 0;
my $countAnatherLines = 0;

my $stackTrace = "";
my $prevLineBolongStackTrace = 0;   # в перле нет булевого литерала, но 0, '0', '', пустой список - вычислятся в false
                                    # все остальное - в true

while( my $line = <FILE> ) {
    $count++;
    if ($line =~ /^[\d<]/) {
        if ($prevLineBolongStackTrace) {
            print $stackTrace;
            $stackTrace = "";
            $prevLineBolongStackTrace = 0;
        }
        $countLinesStartFromDigit++;
        next;#переход к следующей итерации цикла
    }
    #заводим переменную куда будем складывать строки СтекТрейса
    $stackTrace = $stackTrace . $line;#конкатенация строк, operator dot (.)
    $prevLineBolongStackTrace = 1;

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