#!/usr/bin/perl

# Unit testing for PPI, generated by Test::Inline

use strict;
use File::Spec::Functions ':ALL';
BEGIN {
	$|  = 1;
	$^W = 1;
	$PPI::XS_DISABLE = 1;
	$PPI::XS_DISABLE = 1; # Prevent warning
}
use PPI;

# Execute the tests
use Test::More tests => 32;

# =begin testing literal 9
{
my @pairs = (
	"F",          'F',
	"Foo::Bar",   'Foo::Bar',
	"Foo'Bar",    'Foo::Bar',
);
while ( @pairs ) {
	my $from  = shift @pairs;
	my $to    = shift @pairs;
	my $doc   = PPI::Document->new( \"$from;" );
	isa_ok( $doc, 'PPI::Document' );
	my $word = $doc->find_first('Token::Word');
	isa_ok( $word, 'PPI::Token::Word' );
	is( $word->literal, $to, "The source $from becomes $to ok" );
}
}



# =begin testing method_call 23
{
my $Document = PPI::Document->new(\<<'END_PERL');
indirect $foo;
$bar->method_with_parentheses();
print SomeClass->method_without_parentheses + 1;
sub_call();
$baz->chained_from->chained_to;
a_first_thing a_middle_thing a_last_thing;
(first_list_element, second_list_element, third_list_element);
first_comma_separated_word, second_comma_separated_word, third_comma_separated_word;
single_bareword_statement;
{ bareword_no_semicolon_end_of_block }
$buz{hash_key};
fat_comma_left_side => $thingy;
END_PERL

isa_ok( $Document, 'PPI::Document' );
my $words = $Document->find('Token::Word');
is( scalar @{$words}, 21, 'Found the 21 test words' );
my %words = map { $_ => $_ } @{$words};
is(
	scalar $words{indirect}->method_call(),
	undef,
	'Indirect notation is unknown.',
);
is(
	scalar $words{method_with_parentheses}->method_call(),
	1,
	'Method with parentheses is true.',
);
is(
	scalar $words{method_without_parentheses}->method_call(),
	1,
	'Method without parentheses is true.',
);
is(
	scalar $words{print}->method_call(),
	undef,
	'Plain print is unknown.',
);
is(
	scalar $words{SomeClass}->method_call(),
	undef,
	'Class in class method call is unknown.',
);
is(
	scalar $words{sub_call}->method_call(),
	0,
	'Subroutine call is false.',
);
is(
	scalar $words{chained_from}->method_call(),
	1,
	'Method that is chained from is true.',
);
is(
	scalar $words{chained_to}->method_call(),
	1,
	'Method that is chained to is true.',
);
is(
	scalar $words{a_first_thing}->method_call(),
	undef,
	'First bareword is unknown.',
);
is(
	scalar $words{a_middle_thing}->method_call(),
	undef,
	'Bareword in the middle is unknown.',
);
is(
	scalar $words{a_last_thing}->method_call(),
	0,
	'Bareword at the end is false.',
);
foreach my $false_word (
	qw<
		first_list_element second_list_element third_list_element
		first_comma_separated_word second_comma_separated_word third_comma_separated_word
		single_bareword_statement
		bareword_no_semicolon_end_of_block
		hash_key
		fat_comma_left_side
	>
) {
	is(
		scalar $words{$false_word}->method_call(),
		0,
		"$false_word is false.",
	);
}
}


1;
