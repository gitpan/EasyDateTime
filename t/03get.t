#!/usr/bin/perl -w
use strict;
use Test::More tests => 8;
use lib '..';
use EasyDateTime;

my $dt=EasyDateTime->new('1983-03-07 01:02:03');
is($dt->year,1983,'test: $dt->year()');
is($dt->month,3,'test: $dt->month()');
is($dt->day,7,'test: $dt->day()');
is($dt->hour,1,'test: $dt->hour()');
is($dt->min,2,'test: $dt->min()');
is($dt->sec,3,'test: $dt->sec()');
is($dt->timezone,$dt->localtimezone,'test: $dt->timezone()');
is($dt->time,415818123,'test: $dt->time()');

