package Mason::Plugin::SliceFilter::t::Basic;
use Test::Class::Most parent => 'Mason::Test::Class';
sub test_slice_filter :Test(5){
  my $self = shift;
  $self->setup_interp( plugins => [ '@Default', 'SliceFilter' ] );

  ## Just one slice without any param
  $self->test_comp( src =>
q|
% $.Slice(slice_id => 'aslice'){{
SliceA
% }}
|,
                    expect => 'SliceA');

## Hit the first slice
  $self->test_comp( src =>
q|
% $.Slice(slice_id => 'aslice'){{
SliceA
% }}
% $.Slice(slice_id => 'bslice' ){{
SliceB
% }}
|,
                    expect => 'SliceA' , args => { slice => 'aslice' });

## Hit the second slice
  $self->test_comp( src =>
q|
% $.Slice(slice_id => 'aslice'){{
SliceA
% }}
% $.Slice(slice_id => 'bslice' ){{
SliceB
% }}
|,
                    expect => 'SliceB' , args => { slice => 'bslice' });

## Nested ones.
  $self->test_comp( src =>
q|
% $.Slice(slice_id => 'aslice'){{
Before nest
% $.Slice(slice_id => 'nest' ){{
Nested
% }}
After nest
% }}
% $.Slice(slice_id => 'bslice' ){{
SliceB
% }}
|,
                    expect => 'Nested' , args => { slice => 'nest' });

## After nesting
  $self->test_comp( src =>
q|
% $.Slice(slice_id => 'aslice' ){{
Before nest
% $.Slice(slice_id => 'nest' ){{
Nested
% }}
After nest
% }}
% $.Slice(slice_id => 'bslice' ){{
SliceB
% }}
|,
                    expect => 'SliceB' , args => { slice => 'bslice' });


}

1;
