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

my $count = 0;
while( <$filename> ) { $count++; }
print "line in file: $count\n";


