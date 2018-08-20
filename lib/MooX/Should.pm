package MooX::Should;

use Moo       ();
use Moo::Role ();

use Devel::StrictMode;

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

1;
