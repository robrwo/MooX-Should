package MooX::Should;

# ABSTRACT: optional type restrictions for Moo attributes

use version 0.77 ();

use Moo       ();
use Moo::Role ();

our $USE_MOO_UTILS;

BEGIN {
    if( version->parse( Moo->VERSION ) >= version->parse('2.003006') ) {
        $USE_MOO_UTILS = 1;
        require Moo::_Utils;
    }
}

use Devel::StrictMode;

our $VERSION = 'v0.1.4';


sub import {
    my ($class) = @_;

    my $target = caller;

    my $has = $target->can('has') or return;

    my $installer =
      $USE_MOO_UTILS
      ? \&Moo::_Utils::_install_tracked
      : $target->isa("Moo::Object")
          ? \&Moo::_install_tracked
          : \&Moo::Role::_install_tracked;

    my $wrapper = sub {
        my ( $name, %args ) = @_;

        if (STRICT) {
            $args{isa} = delete $args{should} if exists $args{should}
        } else {
            delete $arg{should}
        }

        return $has->( $name => %args );
    };

    $installer->( $target, "has", $wrapper );


}

=head1 SYNOPSIS

  use Moo;

  use MooX::Should;
  use Types::Standard -types;

  has thing => (
    is     => 'ro',
    should => Int,
  );

=head1 DESCRIPTION

This module is basically a shortcut for

  use Devel::StrictMode;
  use PerlX::Maybe;

  has thing => (
          is  => 'ro',
    maybe isa => STRICT ? Int : undef,
  );

It allows you to completely ignore any type restrictions on L<Moo>
attributes at runtime, or to selectively enable them.

Note that you can specify a (weaker) type restriction for an attribute:

  use Types::Common::Numeric qw/ PositiveInt /;
  use Types::Standard qw/ Int /;

  has thing => (
    is     => 'ro',
    isa    => Int,
    should => PositiveInt,
  );

but this is equivalent to

  use Devel::StrictMode;

  has thing => (
    is     => 'ro',
    isa    => STRICT ? PositiveInt : Int,
  );

=head1 SEE ALSO

=over

=item *

L<Devel::StrictMode>

=item *

L<PerlX::Maybe>

=back

=head1 append:AUTHOR

Originally written by Robert Rothenberg <rrwo@cpan.org>.

=cut

1;
