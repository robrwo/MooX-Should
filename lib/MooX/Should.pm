package MooX::Should;

use Moo       ();
use Moo::Role ();

use Devel::StrictMode;

our $VERSION = 'v0.1.0';

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

=head1 SEE ALSO

=over

=item *

L<Devel::StrictMode>

=item *

L<PerlX::Maybe>

=back

=cut

1;
