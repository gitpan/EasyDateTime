#!/usr/bin/perl -w
use strict;
use Test::More tests => 2;
use lib '..';
use EasyDateTime;


my $dt;

$dt=EasyDateTime->new('1983-03-07 01:02:03');

$dt->to_end_of_month();
is($dt->str,'1983-03-31 00:00:00','test to_end_of_month();');

$dt->to_end_of_month(1);
is($dt->str,'1983-04-30 00:00:00','test to_end_of_month();');