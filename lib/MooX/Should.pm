package MooX::Should;

# ABSTRACT: optional type restrictions for Moo attributes

use Moo       ();
use Moo::Role ();

use Devel::StrictMode;

our $VERSION = 'v0.1.1';

sub import {
    my ($class) = @_;

    my $target = caller;

    my $installer =
      $target->isa("Moo::Object")
      ? \&Moo::_install_tracked
      : \&Moo::Role::install_tracked;

    if ( my $has = $target->can('has') ) {

        my $wrapper = sub {
            my ( $name, %args ) = @_;

            if ( my $should = delete $args{should} ) {
                $args{isa} = $should if STRICT;
            }

            return $has->( $name => %args );
        };

        $installer->( $target, "has", $wrapper );

    }

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

  use Types::Common::Numeric qw/ PositiveNum /;
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

=cut

1;
