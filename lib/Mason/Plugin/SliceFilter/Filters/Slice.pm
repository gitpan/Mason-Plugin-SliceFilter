package Mason::Plugin::SliceFilter::Filters::Slice;
## So we can access Mason::Request->current_request
use Mason::Request;
use Moose;
extends qw/Mason::DynamicFilter/;


has 'slice_id' => ( is => 'ro' , isa => 'Str' , required => 1 );
has 'slice_param' => ( is => 'ro', isa => 'Str', required => 1 , default => 'slice' );

has '+filter' =>
  ( default => sub{
      my ($self) = @_;
      return sub{
        my ($yield) = @_;
        my $m = Mason::Request->current_request();
        my $slice_param = $m->request_args()->{$self->slice_param()};
        ## warn "GOT SLICE PARAM '$slice_param'";
        unless(length($slice_param // '' ) ){
          ## warn "NO SLICE PARAM. Yielding";
          $yield->();
        }else{

          ## warn "We have a slice $slice_param";
          if( $slice_param eq $self->slice_id ){
            ## warn "SLICE HIT on $slice_param!";
            ## Flush any previously generated content
            $m->clear_buffer();
            $m->out_method->(($yield->()), $m );
            $m->flush_buffer();
            $m->abort();
            ## Job done
          }else{
            ## warn "SLICE MISS on $slice_param";
            $yield->();
          }
        }
      };
    });

__PACKAGE__->meta->make_immutable();
__END__

=head1 NAME

Mason::Plugin::SliceFilter::Filters::Slice - Actual implementation of Slice filter

=cut
