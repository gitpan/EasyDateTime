#!/usr/bin/perl -w
use strict;
use Test::More tests => 27;
use lib '..';
use EasyDateTime;

my $dt;
my $dt2;

$dt=EasyDateTime->new('1983-03-07 01:02:03');
$dt2=$dt->clone();
$dt->set({year=>2000,month=>1,day=>1,hour=>0,min=>0,sec=>0});
is($dt2->str,'1983-03-07 01:02:03','test: clone()');#1
$dt->lock();
eval{$dt->year();};if(!$@){is(1,1,'test: lock() 1');undef $@;}#2
eval{$dt->year(2003);};if($@){is(1,1,'test: lock() 2;');undef $@;}#3
eval{$dt->month();};if(!$@){is(1,1,'test: lock() 3');undef $@;}#4
eval{$dt->month(3);};if($@){is(1,1,'test: lock() 4');undef $@;}#5
eval{$dt->day();};if(!$@){is(1,1,'test: lock() 5');undef $@;}#6
eval{$dt->day(7);};if($@){is(1,1,'test: lock() 6');undef $@;}#7
eval{$dt->hour();};if(!$@){is(1,1,'test: lock() 7');undef $@;}#8
eval{$dt->hour(1);};if($@){is(1,1,'test: lock() 8');undef $@;}#9
eval{$dt->min();};if(!$@){is(1,1,'test: lock() 9');undef $@;}#10
eval{$dt->min(2);};if($@){is(1,1,'test: lock() 10');undef $@;}#11
eval{$dt->sec();};if(!$@){is(1,1,'test: lock() 11');undef $@;}#12
eval{$dt->sec(3);};if($@){is(1,1,'test: lock() 12');undef $@;}#13
eval{$dt->timezone();};if(!$@){is(1,1,'test: lock() 13');undef $@;}#14
eval{$dt->time();};if(!$@){is(1,1,'test: lock() 14');undef $@;}#15
eval{$dt->set({});};if(!$@){is(1,1,'test: lock() 15');undef $@;}#16
eval{$dt->str();};if(!$@){is(1,1,'test: lock() 16');undef $@;}#17
eval{$dt->str('abc');};if(!$@){is(1,1,'test: lock() 17');undef $@;}#18
eval{$dt2=$dt+3600;};if(!$@){is(1,1,'test: lock() 18');undef $@;}#19
eval{$dt2=$dt+{year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};};if(!$@){is(1,1,'test: lock() 19');undef $@;}#20
eval{$dt2=$dt-3600;};if(!$@){is(1,1,'test: lock() 20');undef $@;}#21
eval{$dt2=$dt-{year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};};if(!$@){is(1,1,'test: lock() 21');undef $@;}#22
eval{my $abc=$dt-$dt2;};if(!$@){is(1,1,'test: lock() 22');undef $@;}#23
eval{$dt+=3600;;};if($@){is(1,1,'test: lock() 23');undef $@;}#24
eval{$dt+={year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};};if($@){is(1,1,'test: lock() 24');undef $@;}#25
eval{$dt-=3600;;};if($@){is(1,1,'test: lock() 25');undef $@;}#26
eval{$dt-={year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};};if($@){is(1,1,'test: lock() 26');undef $@;}#27


