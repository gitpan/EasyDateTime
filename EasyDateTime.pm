package EasyDateTime;

#===Module:EasyDateTime
#===Author:Qian Yu <foolfish@cpan.org> 
#===Version:1.0.0
#===DateTime:2004-11-29 16:00:00 +0800
#===Note:First release version

use strict;
use vars qw($VERSION);
use Time::Local qw(timegm timelocal);
use overload (fallback => 1,
		'+'   => '_add_overload',
		'-'   => '_subtract_overload',
		'+=' => '_addself_overload',
		'-=' => '_subtractself_overload',
		'<=>' => '_compare_overload',
		'cmp' => '_compare_overload'
		);

use constant PackageName=>'EasyDateTime';
use constant DefaultYear=>2000;
use constant DefaultMonth=>1;
use constant DefaultDay=>1;
use constant DefaultHour=>0;
use constant DefaultMin=>0;
use constant DefaultSec=>0;

use constant FullMonthName=>
	['January','February','March','April','May','June','July','Auguest','September','October','November','December'];
use constant ShortMonthName=>
	['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
use constant FullDayName=>
	['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
use constant ShortDayName=>
	['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
use constant TimezoneName1=>
	['GMT-12:00','GMT-11:00','GMT-10:00','GMT-09:00','GMT-08:00','GMT-07:00',
	 'GMT-06:00','GMT-05:00','GMT-04:00','GMT-03:00','GMT-02:00','GMT-01:00',
	 'GMT'      ,'GMT+01:00','GMT+02:00','GMT+03:00','GMT+04:00','GMT+05:00',
	 'GMT+06:00','GMT+07:00','GMT+08:00','GMT+09:00','GMT+10:00','GMT+11:00',
	 'GMT+12:00','GMT+13:00'];
use constant TimezoneName2=>
	['-1200','-1100','-1000','-0900','-0800','-0700',
	 '-0600','-0500','-0400','-0300','-0200','-0100',
	 '+0000','+0100','+0200','+0300','+0400','+0500',
	 '+0600','+0700','+0800','+0900','+1000','+1100',
	 '+1200','+1300'];
use constant TimezoneName3=>
	['-12:00','-11:00','-10:00','-09:00','-08:00','-07:00',
	 '-06:00','-05:00','-04:00','-03:00','-02:00','-01:00',
	 '+00:00','+01:00','+02:00','+03:00','+04:00','+05:00',
	 '+06:00','+07:00','+08:00','+09:00','+10:00','+11:00',
	 '+12:00','+13:00'];

use constant ErrorMessage1=>PackageName.':the string %str is not a valid DateTimeStr;';
use constant ErrorMessage2=>PackageName.':this instance of EasyDateTime is locked and not allow to modify';


BEGIN {
	$VERSION="1.0.0";
}

#===$dt->[0] time
#===$dt->[1] timezone
#===$dt->[2] lock_flag 0 for not lock,1 for lock
sub new {
	if(ref $_[1] eq 'HASH')	{
		my $DateTimeHashRef=$_[1];
		my $t = [];
		$t->[5]=defined($DateTimeHashRef->{'year'})?$DateTimeHashRef->{'year'}:DefaultYear;
		$t->[4]=defined($DateTimeHashRef->{'month'})?$DateTimeHashRef->{'month'}:DefaultMonth;
		$t->[3]=defined($DateTimeHashRef->{'day'})?$DateTimeHashRef->{'day'}:DefaultDay;
		$t->[2]=defined($DateTimeHashRef->{'hour'})?$DateTimeHashRef->{'hour'}:DefaultHour;
		$t->[1]=defined($DateTimeHashRef->{'min'})?$DateTimeHashRef->{'min'}:DefaultMin;
		$t->[0]=defined($DateTimeHashRef->{'sec'})?$DateTimeHashRef->{'sec'}:DefaultSec;
		my $self = bless [],PackageName;
		$self->[2]=0;#not lock
		$self->[1]=defined($DateTimeHashRef->{'timezone'})?$DateTimeHashRef->{'timezone'}:&localtimezone();
		$self->[0]=timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4]-1,$t->[5])-$self->[1]*3600;
		return $self;
	} else {
		my $DateTimeStr=$_[1];
		my $Timezone=defined($_[2])?$_[2]:&localtimezone();
		my $self = bless [],PackageName;
		my $time=&_parse($DateTimeStr);
		if(!defined($time)){
			my $err_str=ErrorMessage1;
			_replace($err_str,'str',defined($DateTimeStr)?'"'.$DateTimeStr.'"':'undef');
			die $err_str;
		}
		$self->[0]=$time-$Timezone*3600;
		$self->[1]=$Timezone;
		$self->[2]=0;#not lock
		return $self;
	}
}


#===a locked EasyDateTime after clone , the new instance is a not lock one
sub clone {
	return bless [$_[0]->[0],$_[0]->[1],0],PackageName;
}


#===set this instance read only
sub lock{
	$_[0]->[2]=1;
}


sub year {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		$self->[0]=timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4],$_[0])-$self->[1]*3600;
		return $_[0];
	}else{
		return [gmtime($self->[0]+$self->[1]*3600)]->[5]+1900;
	}
}


sub month {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		$self->[0]=timegm($t->[0],$t->[1],$t->[2],$t->[3],$_[0]-1,$t->[5])-$self->[1]*3600;
		return $_[0];
	}else{
		return [gmtime($self->[0]+$self->[1]*3600)]->[4]+1;
	}
}


sub day {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		$self->[0]=timegm($t->[0],$t->[1],$t->[2],$_[0],$t->[4],$t->[5])-$self->[1]*3600;
		return $_[0];
	}else{
		return [gmtime($self->[0]+$self->[1]*3600)]->[3];
	}
}


sub hour {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		$self->[0]=timegm($t->[0],$t->[1],$_[0],$t->[3],$t->[4],$t->[5])-$self->[1]*3600;
		return $_[0];
	}else{
		return [gmtime($self->[0]+$self->[1]*3600)]->[2];
	}
}


sub min {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		$self->[0]=timegm($t->[0],$_[0],$t->[2],$t->[3],$t->[4],$t->[5])-$self->[1]*3600;
		return $_[0];
	}else{
		return [gmtime($self->[0]+$self->[1]*3600)]->[1];
	}
}


sub sec {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		$self->[0]=timegm($_[0],$t->[1],$t->[2],$t->[3],$t->[4],$t->[5])-$self->[1]*3600;
		return $_[0];
	}else{
		return [gmtime($self->[0]+$self->[1]*3600)]->[0];
	}
}


sub timezone {
	my $self=shift;
	if(defined($_[0])){
		if($self->[2]==1){die ErrorMessage2};
		$self->[1]=$_[0];
		return $_[0];
	}else{
		return $self->[1];
	}
}
#===return a integer Suitable for feeding to gmtime and localtime. 
#===Seconds since the Unix Epoch (January 1 1970 00:00:00 GMT)
sub time {
	my $self=shift;
	return $self->[0];
}

#===attention: cannot set timezone here!
sub set {
	my $self=shift;
	my $DateTimeHashRef=$_[0];
	my $t=[gmtime($self->[0]+$self->[1]*3600)];
	$t->[5]=defined($DateTimeHashRef->{'year'})?$DateTimeHashRef->{'year'}:$t->[5]+1900;
	$t->[4]=defined($DateTimeHashRef->{'month'})?$DateTimeHashRef->{'month'}:$t->[4]+1;
	$t->[3]=defined($DateTimeHashRef->{'day'})?$DateTimeHashRef->{'day'}:$t->[3];
	$t->[2]=defined($DateTimeHashRef->{'hour'})?$DateTimeHashRef->{'hour'}:$t->[2];
	$t->[1]=defined($DateTimeHashRef->{'min'})?$DateTimeHashRef->{'min'}:$t->[1];
	$t->[0]=defined($DateTimeHashRef->{'sec'})?$DateTimeHashRef->{'sec'}:$t->[0];
	$self->[0]=timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4]-1,$t->[5])-$self->[1]*3600;
	return 1;
}

#===set the time to the start of the day of month
#===$dt->to_end_of_month(); #same as $dt->to_end_of_month(0)
#===$dt->to_end_of_month(1);#go to the end of next month

sub to_end_of_month{
	my $self=shift;
	my ($offset)=@_;
	if(!defined($offset)){
		$offset=0;
	}
	$self->set({day=>1,hour=>0,min=>0,sec=>0});
	_addself_overload($self,{month=>$offset+1});
	_subtractself_overload($self,{day=>1});
	return 1;
}


#===return the default timezone of server
#===EasyDateTime->localtimezone();
sub localtimezone {
	return int ((timegm(0,0,0,1,0,2000)-timelocal(0,0,0,1,0,2000))/3600);
}

#===return the EasyDateTime instance represent the time of now
#===EasyDateTime->now(Timezone);
#===EasyDateTime->now();
sub now {
	my $self = bless [],PackageName;
	$self->[0]=CORE::time();
	$self->[1]=$_[1]?$_[1]:&localtimezone();
	return $self;
}

#===check wheather a string is a valid Datetime String
sub validate {
	if($_[0] eq PackageName){
		shift;
	}elsif(ref $_[0] eq PackageName){
		shift;
	}
	if(ref $_[0] eq 'HASH'){
		my $rh_datetime=shift;
		my $year=$rh_datetime->{year};
		my $month=$rh_datetime->{month};
		my $day=$rh_datetime->{day};
		my $hour=$rh_datetime->{hour};
		my $min=$rh_datetime->{min};
		my $sec=$rh_datetime->{sec};
		
		if(defined($rh_datetime->{timezone})&&!is_num($rh_datetime->{timezone})){
			return '';
		}
		
		if(is_num($year)&&is_num($month)&&is_num($day)&&is_num($hour)&&is_num($min)&&is_num($sec)){
			eval{timegm($sec,$min,$hour,$day,$month-1,$year)};
			if($@){return '';
			}else{
				return 1;
			}
		}elsif(is_num($year)&&is_num($month)&&is_num($day)&&!is_num($hour)&&!is_num($min)&&!is_num($sec)){
			eval{timegm(0,0,0,$day,$month-1,$year)};
			if($@){return '';
			}else{
				return 1;
			}
		}elsif(!is_num($year)&&!is_num($month)&&!is_num($day)&&is_num($hour)&&is_num($min)&&is_num($sec)){
			eval{timegm($sec,$min,$hour,1,0,2000)};
			if($@){return '';
			}else{
				return 1;
			}
		}
	}
	return defined(&_parse($_[0]))?1:'';
}

#===YEAR
#%yyyy       A full numeric representation of a year, 4 digits(2004)
#%yy         A two digit representation of a year(04)
#%is_leap    Whether it's a leap year(0 or 1)

#===MONTH
#%MM         Numeric representation of a month, with leading zeros (01..12)
#%M          Numeric representation of a month, without leading zeros (1..12)
#%MN         A full textual representation of a month (January through December)
#%MA         A short textual representation of a month, three letters (Jan through Dec)
#%DM         Number of days in the given month (28..31)

#===DAY
#%dd         Day of the month, 2 digits with leading zeros (01..31)
#%d          Day of the month without leading zeros (1..31)
#%yday       The day of the year (starting from 0,sunday=0)
#%wday       Numeric representation of the day of the week(start from 0)
#%dn         A full textual representation of the day of the week (Sunday through Saturday)
#%da         A textual representation of a day, three letters (Mon through Sun)

#===HOUR
#%h12        12-hour format of an hour without leading zeros (1..12)
#%h          24-hour format of an hour without leading zeros (0..23)
#%hh12       12-hour format of an hour with leading zeros (01..12)
#%hh         24-hour format of an hour with leading zeros (00..23)
#%ap         a Lowercase Ante meridiem and Post meridiem  (am or pm)
#%AP         Uppercase Ante meridiem and Post meridiem (AM or PM)

#===MINUTE
#%mm         Minutes with leading zeros (00..59)
#%m          Minutes without leading zeros (0..59)

#===SECOND
#%ss         Seconds, with leading zeros (00..59)
#%s          Seconds, without leading zeros (0..59)

#===TIMEZONE
#%tz         Difference to Greenwich time (GMT) in hours
#%ts         Timezone offset in seconds
#%lt         Timezone setting of this machine
#%tn1        A textual representation of the timezone (GMT+02:00)
#%tn2        A textual representation of the timezone (+0200)
#%tn3        A textual representation of the timezone (+02:00)

#===FULL DATETIME
#%date       string like '2004-08-06'
#%time       string like '03:02:01'
#%iso1861    string like '2004-02-12T15:19:21+00:00' 
#%rfc2822    string like 'Thu, 21 Dec 2000 16:01:07 +0200'
#%datetime   string like '2004-08-06 03:02:01'

#%%          %

sub str {
	my $self=shift;
	my $format_str=$_[0];
	if(defined($format_str)){
		my $t=[gmtime($self->[0]+$self->[1]*3600)];
		
		my $map={
			datetime=>sprintf('%s-%02s-%02s %02s:%02s:%02s',$t->[5]+1900,$t->[4]+1,$t->[3],$t->[2],$t->[1],$t->[0]),
			rfc2822=>sprintf('%s, %02s %s %04s %02s:%02s:%02s %s',ShortDayName->[$t->[6]],$t->[3],ShortMonthName->[$t->[4]],$t->[5]+1900,$t->[2],$t->[1],$t->[0],TimezoneName2->[$self->[1]+12]),
			iso1861=>sprintf(' %s-%02s-%02sT%02s:%02s:%02s%s',$t->[5]+1900,$t->[4]+1,$t->[3],$t->[2],$t->[1],$t->[0],TimezoneName3->[$self->[1]+12]),
			date=>sprintf('%s-%02s-%02s',$t->[5]+1900,$t->[4]+1,$t->[3]),
			'time'=>sprintf('%02s:%02s:%02s',$t->[2],$t->[1],$t->[0]),
			tn3=>TimezoneName3->[$self->[1]+12],
			tn2=>TimezoneName2->[$self->[1]+12],
			tn1=>TimezoneName1->[$self->[1]+12],
			lt=>&localtimezone(),
			ts=>$self->[1]*3600,
			tz=>$self->[1],
			ss=>sprintf('%02s',$t->[0]),
			s=>$t->[0],
			mm=>sprintf('%02s',$t->[1]),
			m=>$t->[1],
			AP=>$t->[2]>12||$t->[2]==0?'PM':'AM',
			ap=>$t->[2]>12||$t->[2]==0?'pm':'am',
			hh=>sprintf('%02s',$t->[2]),
			h=>$t->[2],
			hh12=>sprintf('%02s',$t->[2]?($t->[2]>12?($t->[2]-12):$t->[2]):12),
			h12=>$t->[2]?($t->[2]>12?($t->[2]-12):$t->[2]):12,
			da=>ShortDayName->[$t->[6]],
			dn=>FullDayName->[$t->[6]],
			wday=>$t->[6],
			yday=>$t->[7],
			dd=>sprintf('%02s',$t->[3]),
			d=>$t->[3],
			DM=> in($t->[4],3,5,8,10)?30:in($t->[4],0,2,4,6,7,9,11)?31:(($t->[5]+1900)%4==0)&&((($t->[5]+1900)%400==0)||(($t->[5]+1900)%100!=0))?29:28,
			MA=>ShortMonthName->[$t->[4]],
			MN=>FullMonthName->[$t->[4]],
			MM=>sprintf('%02s',$t->[4]+1),
			M=>$t->[4]+1,
			is_leap=>(($t->[5]+1900)%4==0)&&((($t->[5]+1900)%400==0)||(($t->[5]+1900)%100!=0))?1:0,
			yyyy=>$t->[5]+1900,
			yy=>($t->[5]+1900)%100
		};
		
		_replace($format_str,"%%","%\000");
		_replace($format_str,'%datetime',$map->{datetime});
		_replace($format_str,'%rfc2822',$map->{rfc2822});
		_replace($format_str,'%iso1861',$map->{iso1861});
		_replace($format_str,'%is_leap',$map->{is_leap});
		_replace($format_str,'%yyyy',$map->{yyyy});
		_replace($format_str,'%hh12',$map->{hh12});
		_replace($format_str,'%date',$map->{date});
		_replace($format_str,'%time',$map->{'time'});
		_replace($format_str,'%wday',$map->{wday});
		_replace($format_str,'%yday',$map->{yday});
		_replace($format_str,'%tn1',$map->{tn1});
		_replace($format_str,'%tn2',$map->{tn2});
		_replace($format_str,'%tn3',$map->{tn3});
		_replace($format_str,'%h12',$map->{h12});
		_replace($format_str,'%lt',$map->{lt});
		_replace($format_str,'%ts',$map->{ts});
		_replace($format_str,'%tz',$map->{tz});
		_replace($format_str,'%ss',$map->{ss});
		_replace($format_str,'%mm',$map->{mm});
		_replace($format_str,'%AP',$map->{AP});
		_replace($format_str,'%ap',$map->{ap});
		_replace($format_str,'%hh',$map->{hh});
		_replace($format_str,'%da',$map->{da});
		_replace($format_str,'%dn',$map->{dn});
		_replace($format_str,'%dd',$map->{dd});
		_replace($format_str,'%DM',$map->{DM});
		_replace($format_str,'%MA',$map->{MA});
		_replace($format_str,'%MN',$map->{MN});
		_replace($format_str,'%MM',$map->{MM});
		_replace($format_str,'%yy',$map->{yy});
		_replace($format_str,'%h',$map->{h});
		_replace($format_str,'%M',$map->{M});
		_replace($format_str,'%d',$map->{d});
		_replace($format_str,'%m',$map->{m});
		_replace($format_str,'%s',$map->{s});
		_replace($format_str,"%\000","%");
		return $format_str;
	}else{
		my $t=[gmtime($self->[0]+$self->[1]*3600)];	
		return sprintf('%04s-%02s-%02s %02s:%02s:%02s',$t->[5]+1900,$t->[4]+1,$t->[3],$t->[2],$t->[1],$t->[0]);
	}
}


#===override the operator
sub _subtract_overload {
	my ($d1,$d2,$rev)=@_;
	($d1,$d2)=($d2,$d1) if $rev;
	if(ref($d2) eq "HASH"){
		#===CASE: $dt-TimeIntervalHashRef
		my ($month,$sec)=(0,0);
		$month+=12*(defined($d2->{'year'})?$d2->{'year'}:0);
		$month+=defined($d2->{'month'})?$d2->{'month'}:0;
		$sec+=86400*(defined($d2->{'day'})?$d2->{'day'}:0);
		$sec+=3600*(defined($d2->{'hour'})?$d2->{'hour'}:0);
		$sec+=60*(defined($d2->{'min'})?$d2->{'min'}:0);
		$sec+=defined($d2->{'sec'})?$d2->{'sec'}:0;
		my $t=[gmtime($d1->[0]-$sec+$d1->[1]*3600)];
		$t->[5]=$t->[5]+($t->[4]-$month)/12;
		$t->[4]= ($t->[4]-$month)%12;
		return bless
		[
			timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4],$t->[5])-$d1->[1]*3600,$d1->[1],0
		],PackageName;
	}elsif(UNIVERSAL::isa($d2,PackageName)){
		#===CASE: $dt1-$dt2
		return $d1->[0]-$d2->[0];
	}else{
		#===CASE:$dt-SecCount
		return bless [$d1->[0]-int($d2),$d1->[1],0],PackageName;
	}
}


sub _add_overload {
	my ($d1,$d2,$rev)=@_;
	($d1,$d2)=($d2,$d1) if $rev;
	my $result;my $flag;
	if(ref($d2) eq "HASH"){
		#===CASE: $dt+TimeIntervalHashRef
		my ($month,$sec)=(0,0);
		$month+=12*(defined($d2->{'year'})?$d2->{'year'}:0);
		$month+=defined($d2->{'month'})?$d2->{'month'}:0;
		$sec+=86400*(defined($d2->{'day'})?$d2->{'day'}:0);
		$sec+=3600*(defined($d2->{'hour'})?$d2->{'hour'}:0);
		$sec+=60*(defined($d2->{'min'})?$d2->{'min'}:0);
		$sec+=defined($d2->{'sec'})?$d2->{'sec'}:0;
		my $t=[gmtime($d1->[0]+$sec+$d1->[1]*3600)];
		$t->[5]=$t->[5]+($t->[4]+$month)/12;
		$t->[4]= ($t->[4]+$month)%12;
		return bless
		[
			timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4],$t->[5])-$d1->[1]*3600,$d1->[1],0
		],PackageName;
	}else{
		#===CASE: $dt+SecCount
		return bless [$d1->[0]+int($d2),$d1->[1],0],PackageName;
	}
}


sub _subtractself_overload {
	my ($d1,$d2,$rev)=@_;
	($d1,$d2)=($d2,$d1) if $rev;
	if($d1->[2]==1){die ErrorMessage2};
	my $result;my $flag;
	if(ref($d2) eq "HASH"){
		#===CASE: $dt-=TimeIntervalHashRef
		my ($month,$sec)=(0,0);
		$month+=12*(defined($d2->{'year'})?$d2->{'year'}:0);
		$month+=defined($d2->{'month'})?$d2->{'month'}:0;
		$sec+=86400*(defined($d2->{'day'})?$d2->{'day'}:0);
		$sec+=3600*(defined($d2->{'hour'})?$d2->{'hour'}:0);
		$sec+=60*(defined($d2->{'min'})?$d2->{'min'}:0);
		$sec+=defined($d2->{'sec'})?$d2->{'sec'}:0;
		my $t=[gmtime($d1->[0]-$sec+$d1->[1]*3600)];
		$t->[5]=$t->[5]+($t->[4]-$month)/12;
		$t->[4]= ($t->[4]-$month)%12;
		$d1->[0]=timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4],$t->[5])-$d1->[1]*3600;
		return $d1;
	}else{
		#===CASE: $dt+=SecCount
		$d1->[0]=$d1->[0]- int($d2);
		return $d1;
	}
}

sub _addself_overload {
	my ($d1,$d2,$rev)=@_;
	($d1,$d2)=($d2,$d1) if $rev;
	if($d1->[2]==1){die ErrorMessage2};
	my $result;my $flag;
	if(ref($d2) eq "HASH"){
		#===CASE: $dt+=TimeIntervalHashRef
		my ($month,$sec)=(0,0);
		$month+=12*(defined($d2->{'year'})?$d2->{'year'}:0);
		$month+=defined($d2->{'month'})?$d2->{'month'}:0;
		$sec+=86400*(defined($d2->{'day'})?$d2->{'day'}:0);
		$sec+=3600*(defined($d2->{'hour'})?$d2->{'hour'}:0);
		$sec+=60*(defined($d2->{'min'})?$d2->{'min'}:0);
		$sec+=defined($d2->{'sec'})?$d2->{'sec'}:0;
		my $t=[gmtime($d1->[0]+$sec+$d1->[1]*3600)];
		$t->[5]=$t->[5]+($t->[4]+$month)/12;
		$t->[4]= ($t->[4]+$month)%12;
		$d1->[0]=timegm($t->[0],$t->[1],$t->[2],$t->[3],$t->[4],$t->[5])-$d1->[1]*3600;
		return $d1;
	}else{
		#===CASE: $dt+=SecCount
		$d1->[0]=$d1->[0]+int($d2);
		return $d1;
	}
}

sub _compare_overload {
	my ($d1,$d2,$rev)=@_;
	($d1,$d2)=($d2,$d1) if $rev;
	return $d1->[0]<=>$d2->[0];
}

#===below functions is for internal use
sub _parse {
	local $_ = shift;
	unless(defined($_)) {return undef;}
	if(/^\s*(\d{4}|\d{2})([\-\.\/])(\d{1,2})\2(\d{1,2})\s*$/){
		eval{$_=timegm(DefaultSec,DefaultMin,DefaultHour,$4,$3-1,$1);};
		if($@){return undef;}else{return $_;}
	}elsif(/^\s*(\d{4}|\d{2})([\-\.\/])(\d{1,2})\2(\d{1,2})(\x20+|T)(\d{1,2})([\:\.])(\d{1,2})\7(\d{1,2})\s*$/){
		eval{$_=timegm($9,$8,$6,$4,$3-1,$1);};
		if($@){return undef;}else{return $_;}
	}elsif(/^\s*(\d{1,2})([\:\.])(\d{1,2})\2(\d{1,2})\s*$/){
		eval{$_=timegm($4,$3,$1,DefaultDay,DefaultMonth-1,DefaultYear);};
		if($@){return undef;}else{return $_;}
	}else{
		return undef;
	}
}

sub _replace {
	if(ref $_[1] eq 'HASH'){
		foreach my $k(keys(%{$_[1]})){
			my $v=$_[1]->{$k};
			$k='%'.$k;
			$_[0]=~s/$k/$v/g;
		}
	}else{
		$_[0]=~s/$_[1]/$_[2]/g;
	}
}

sub in{
	my $word=shift;
	foreach(@_){if ($word eq $_){return 1;}}
	return 0;
}

sub is_num {
	local $_=shift;
	return defined&&/^\s*-?\d+\.?\d*\s*$/;
}

1;
__END__

=head1 NAME

EasyDateTime - A date and time object

=head1 SYNOPSIS

    use EasyDateTime;

    # Constructors
    $dt = EasyDateTime->new({year=>2000,month=>1,day=>1,hour=>0,min=>0,sec=>0,timezone=>8});
    $dt = EasyDateTime->new('2004-08-28 08:06:00'); #date can be seperate by . / or -
    $dt = EasyDateTime->new('2004-08-28T08:06:00',8);
    $dt = EasyDateTime->new('2004/08/28 08:06:00',8); #the second param is timezone
    $dt = EasyDateTime->new('2004/8/28'); #the time will be filled 00:00:00
    $dt = EasyDateTime->new('8:6:00 '); #the date will be filled 2000-01-01
    
    # getter and setter
    $dt->year();
    $dt->year(2004);
    $dt->month();
    $dt->month(3);
    $dt->day();
    $dt->day(24);
    $dt->hour();
    $dt->hour(8);
    $dt->min();
    $dt->min(20);
    $dt->sec();
    $dt->sec(30);
    $dt->timezone();
    $dt->timezone(8);
    
    # clone & lock
    $dt2=$dt->clone(); #create new instance copy from this instance
    $dt->lock(); #set $dt read only
    
    # now localtimezone validate
    $dt=EasyDateTime->now(); #use the time of now to create a instance
    $dt=EasyDateTime->now(8); #use timezone 8 and time of now to create a instance
    print $dt->localtimezone(); #print the localtimezone of server that run this script;
    EasyDateTime->validate('2004-08-28T08:06:00'); #check whether this string is a valid datetime_str
    EasyDateTime->validate({year=>2000,month=>1,day=>1});
    
    # other func
    $dt->to_end_of_month();

    # format output
    $dt->str(); #'2004-08-28 08:06:00'
    $dt->str('%yyyy%MM'); #'200408'

    # operator overload
    $dt2=$dt+3600; #$dt2=$dt + 3600 seconds
    $dt2=$dt+{day=>1};
    $dt2=$dt+{month=>1};
     #attention sometime this func will fail when for example $dt = '2004-10-31'
     #if you want to goto [next] end of month use to_end_of_month instead
    $dt2=$dt-3000;
    $sec_count=$dt2-$dt; #return interval of $dt2 and $dt by seconeds
    $dt2=$dt-{day=>1};
	
    $dt+={day=>1};
    $dt+=3600;
    $dt-={day=>1};
    $dt-=3600;
	
    print $dt2>$dt1; #overload operator <=> and cmp, and '2004-01-01 00:00:00' > '2003-01-01 00:00:00'   

=head1 DESCRIPTION

    EasyDateTime is a class for the representation of date/time combinations.
    It's simple to use,and function is enough for daily use.
    Only one file ,and don't denpend on external module,and system independent.

=head1 EXAMPLES

This example how to get the start of month
	
	$dt->set{day=>1,hour=>0,min=>0,sec=>0}; #2004-08-01 00:00:00

This example how to get the end of month

   $dt->to_end_of_month(); #2004-08-31 00:00:00

This example how to get the next of month

   $dt->to_end_of_month(1); #2004-09-30 00:00:00
   
This example how to explore every day of month

   $dt_start=EasyDateTime->new('2004-08-01 00:00:00');
   $dt_end=$dt_start->clone();
   $dt_end->to_end_of_month();
   for($dt=$dt_start->clone();$dt<$dt_end;$dt+={day=>1}){
   ... ...
   }; 

This example how to explore every month of year
   
   $dt_start=EasyDateTime->new('2004-01-01 00:00:00');
   $dt_end=$dt_start->clone();
   $dt_end+={year=>1};
   for($dt=$dt_start->clone();$dt<$dt_end;$dt+={month=>1}){
   ... ...
   };

This example how to explore every last day of month of year
   
   $dt_start=EasyDateTime->new('2004-01-01 00:00:00');
   $dt_end=$dt_start->clone();
   $dt_start->to_end_of_month();
   $dt_end+={year=>1};
   for($dt=$dt_start->clone();$dt<$dt_end;$dt->to_end_of_month(1)){
   ... ...
   };
   
This example how to lock a EasyDateTime instance
   
   $dt->lock();
   $dt+={day=>1};#this will cause die for u cannot changed the value of a locked instance

Bad example
   
   for($dt=$dt_start;$dt>$dt_end;$dt+={day=>1}){
   ... ...
   }
   
   because $dt and $dt_start is reference the same instance,
   when u changed the value of $dt, $dt_start is also changed
   so u use assignment without clone is DANGEROUS!!!!
   and in case other won't change ur $dt, u can use lock() to set $dt read only 

=head1 CONSTRUCTOR

=over 4

=item * new(L<RH_DATETIME|/RH_DATETIME>)

    Example:
        $dt = EasyDateTime->new({year=>2000,month=>1,day=>1,hour=>0,min=>0,sec=>0,timezone=>8});
        $dt = EasyDateTime->new({year=>2000,month=>1,day=>1});
        $dt = EasyDateTime->new({hour=>0,min=>0,sec=>0});

=item * new(L<DATETIME_STR|/DATETIME_STR>[,$TIMEZONE])

    Example:
        $dt = EasyDateTime->new('2004-08-28 08:06:00',8);
        $dt = EasyDateTime->new('2004-08-28 08:06:00');
        $dt = EasyDateTime->new(' 2004-08-28 08:06:00 ');
        $dt = EasyDateTime->new('2004-08-28T08:06:00');
        $dt = EasyDateTime->new('2004/08/28 08:06:0');
        $dt = EasyDateTime->new('2004.08.28 08:06:00');
        $dt = EasyDateTime->new('2004-08-28 08.06.00');
        $dt = EasyDateTime->new('04-8-28 8:6:0');
        $dt = EasyDateTime->new('2004-08-28');
        $dt = EasyDateTime->new('08:06:00');

=back

=head1 METHODS

=over 4

=item * year ([$YEAR])

get or set the year of EasyDateTime instance

=item * month ([$MONTH])

get or set the month of EasyDateTime instance

=item * day ([$DAY])

get or set the day of EasyDateTime instance

=item * hour ([$HOUR])

get or set the hour of EasyDateTime instance

=item * min ([$MINUTE])

get or set the minute of EasyDateTime instance

=item * sec ([$SECOND])

get or set the second of EasyDateTime instance

=item * timezone ([$TIMEZONE])

get or set the second of EasyDateTime instance

=item * time ()

return a integer Suitable for feeding to gmtime and localtime. 
Seconds since the Unix Epoch (January 1 1970 00:00:00 GMT)

=item * set (L<RH_DATETIME|/RH_DATETIME>)

set the specified item of EasyDateTime instance,if item was not list in RH_DATETIME,then the item will stay same

=item * to_end_of_month ([$MONTH_OFFSET])

set the time to the end of (the  $MONTH_OFFSET th) month,
for example, if $MONTH_OFFSET was not set or $MONTH_OFFSET==0 then set the time to the start of last day of this month
if $MONTH_OFFSET==1 then set the time to the start of last day of next month

=item * clone ()

make a copy of this EasyDateTime instance

=item * lock ()

make this EasyDateTime instance read only, if a EasyDateTime instance was locked, 
 then any operation trying to modify it will cause die

=item * str ([L<FORMAT_STR|/FORMAT_STR>])

return a formated string use the template L<FORMAT_STR|/FORMAT_STR>
if no L<FORMAT_STR|/FORMAT_STR> set ,then use format '%yyyy-%MM-%dd %hh:%mm:%ss'


=item * localtimezone ()

return localtimezone

=item * now ([$TIMEZONE])

return a EasyDateTime instance represent the time of now,if $TIMEZONE not set, use localtimezone

=item * validate(L<RH_DATETIME|/RH_DATETIME>)

=item * validate(L<DATETIME_STR|/DATETIME_STR>)

check whether a L<RH_DATETIME|/RH_DATETIME> or a L<DATETIME_STR|/DATETIME_STR> is valid

=back

=head1 PARAMETER

=head2 RH_DATETIME
	
	RH_DATETIME is a reference of hash like 
	    {year=>2000,month=>1,day=>1,hour=>0,min=>0,sec=>0,timezone=>8}
	it represent a datetime ,if some item is not set, will use default value instead
		default value of year is 2000
		default value of month is 1
		default value of day is 1
		default value of hour is 0
		default value of min is 0
		default value of sec is 0
		default value of timezone is the localtimezone of machine

=head2 RH_TIMEINTERVAL

    RH_DATETIME is a reference of hash like 
	    {year=>0,month=>0,day=>0,hour=>0,min=>0,sec=>0}
	it represent the interval between two datetime if some item is not set, will use default value instead
		default value of year is 0
		default value of month is 0
		default value of day is 0
		default value of hour is 0
		default value of min is 0
		default value of sec is 0

=head2 DATETIME_STR

=over 4

=item * Samples can be accepted

     '2004-08-28 08:06:00' ' 2004-08-28 08:06:00 '
     '2004-08-28T08:06:00' '2004/08/28 08:06:00'
     '2004.08.28 08:06:00' '2004-08-28 08.06.00'
     '04-8-28 8:6:0' '2004-08-28' '08:06:00'

=item * Which string can be accepted?

    rule 1:there can be some blank in the begin or end of DATETIME_STR e.g. ' 2004-08-28 08:06:00 '
    rule 2:date can be separate by . / or - e.g. '2004/08/28 08:06:00'
    rule 3:time can be separate by . or : e.g. '2004-08-28 08.06.00'
    rule 4:date and time can be join by white space or 'T' e.g. '2004-08-28T08:06:00'
    rule 5:can be (date and time) or only date or only time e.g. '2004-08-28' or '08:06:00'
    rule 6:year can be 2 digits or 4 digits,other field can be 2 digits or 1 digit e.g. '04-8-28 8:6:0'
    rule 7:if only the date be set then the time will be set to 00:00:00
           if only the time be set then the date will be set to 2000-01-01

=item * Regular Expression

    ^\s*(\d{4}|\d{2})([\-\.\/])(\d{1,2})\2(\d{1,2})(\x20+|T)(\d{1,2})([\:\.])(\d{1,2})\7(\d{1,2})\s*$
    ^\s*(\d{4}|\d{2})([\-\.\/])(\d{1,2})\2(\d{1,2})\s*$
    ^\s*(\d{1,2})([\:\.])(\d{1,2})\2(\d{1,2})\s*$

=back

=head2 FORMAT_STR

=head3 YEAR

=over 4

=item * %yyyy

A full numeric representation of a year, 4 digits(2004)

=item * %yy

A two digit representation of a year(04)

=item * %is_leap

Whether it's a leap year(0 or 1)

=back

=head3 MONTH

=over 4

=item * %MM

Numeric representation of a month, with leading zeros (01..12)

=item * %M

Numeric representation of a month, without leading zeros (1..12)

=item * %MN

A full textual representation of a month (January through December)

=item * %MA

A short textual representation of a month, three letters (Jan through Dec)

=item * %DM

Number of days in the given month (28..31)

=back

=head3 DAY

=over 4

=item * %dd

Day of the month, 2 digits with leading zeros (01..31)

=item * %d

Day of the month without leading zeros (1..31)

=item * %yday

The day of the year (starting from 0)

=item * %wday

Numeric representation of the day of the week(start from 0, sunday=0)

=item * %dn

A full textual representation of the day of the week (Sunday through Saturday)

=item * %da

A textual representation of a day, three letters (Mon through Sun)

=back

=head3 HOUR

=over 4

=item * %h12

12-hour format of an hour without leading zeros (1..12)

=item * %h

24-hour format of an hour without leading zeros (0..23)

=item * %hh12 

12-hour format of an hour with leading zeros (01..12)

=item * %hh

24-hour format of an hour with leading zeros (00..23)

=item * %ap

a Lowercase Ante meridiem and Post meridiem  (am or pm)

=item * %AP

Uppercase Ante meridiem and Post meridiem (AM or PM)

=back

=head3 MINUTE

=over 4

=item * %mm

Minutes with leading zeros (00..59)

=item * %m

Minutes without leading zeros (0..59)

=back

=head3 SECOND

=over 4

=item * %ss

Seconds, with leading zeros (00..59)

=item * %s

Seconds, without leading zeros (0..59)

=back

=head3 TIMEZONE

=over 4

=item * %tz

Difference to Greenwich time (GMT) in hours

=item * %ts

Timezone offset in seconds

=item * %lt

Timezone setting of this machine

=item * %tn1

A textual representation of the timezone (GMT+02:00)

=item * %tn2

A textual representation of the timezone (+0200)

=item * %tn3

A textual representation of the timezone (+02:00)

=back

=head3 FULL DATETIME

=over 4

=item * %date

string like '2004-08-06'

=item * %time

A textual representation of the timezone (+02:00)

=item * %iso1861

string like '2004-02-12T15:19:21+00:00'

=item * %rfc2822

string like 'Thu, 21 Dec 2000 16:01:07 +0200'

=item * %datetime

string like '2004-08-06 03:02:01'

=back

=head3 OTHER

=over 4

=item * %%

%

=back

=head1 LIMITATION

the datetime is limited in the year 1900 to 2037

=head1 AUTHOR

Qian Yu <foolfish@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2004-2004 Qian Yu. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=cut