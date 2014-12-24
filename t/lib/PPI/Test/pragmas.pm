package t::lib::PPI::Test::pragmas;

=head1 NAME

PPI::Test::pragmas -- standard complier/runtime setup for PPI tests

PPI modules do not enable warnings, but this module enables warnings
in the tests, and it forces a test failure if any warnings occur.
This gives full warnings coverage during the test suite without
forcing PPI users to accept an unbounded number of warnings in code
they don't control.  See L<https://github.com/adamkennedy/PPI/issues/142>
for a  fuller explanation of this philosophy.

=cut

use 5.006;
use strict;
use warnings;

use Test::NoWarnings;

BEGIN {
	select STDERR;  ## no critic ( InputOutput::ProhibitOneArgSelect )
	$| = 1;
	select STDOUT;  ## no critic ( InputOutput::ProhibitOneArgSelect )

	no warnings 'once';  ## no critic ( TestingAndDebugging::ProhibitNoWarnings )
	$PPI::XS_DISABLE = 1;
	$PPI::Lexer::X_TOKENIZER ||= $ENV{X_TOKENIZER};
}

sub import {
	strict->import();
	warnings->import();
	Test::NoWarnings->import();
	return;
}


1;
