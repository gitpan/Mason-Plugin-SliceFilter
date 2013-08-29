package Mason::Plugin::SliceFilter;
use Moose;
with 'Mason::Plugin';

our $VERSION = '0.02';

=head1 NAME

Mason::Plugin::SliceFilter - Only output slices of your content optionally.

=head1 VERSION

Version 0.02

=head1 CATALYST USERS

If you use L<Mason> with L<Catalyst>, it's very likely your mason interpreter is run
within the context of your stash. So for this plugin to work, you need to transfer
the slice http parameter to the stash (in your MyApp::WWW::Controller::Root::auto for instance):

  $c->stash()->{slice} = $c->req->param('slice');

=head1 OTHER FRAMEWORK USERS

PLEASE See SYNOPSIS FIRST and then look at the PARAMETER CAPTURING injection section.

=head1 SYNOPSIS

See L<Mason> 'plugins'. Once this plugin included, you can use the following filter:

=head1 FILTER

=over

=item Slice

Outputs its content untouched in case there's no 'slice' parameter in
the request.

If there is a slice parameter in the request, output JUST this content if the requested slice
matches, ready to be embedded in your page in ajax for instance.

  % $.Slice( slice_id => 'myslice' ){{
   <p>This bit will be output just on its own if you call
      this page with ?slice=myslice.
   </p>
  % }}

  % $.Slice( slice_id => 'myslice' , slice_param => 'myparam' ){{
    <p>Same thing but with controlable slice param.</p>
  % }}


=back


=head1 PARAMETER CAPTURING

You can easily inject a sub that this filter will use to capture the slice ID from your framework
parameter mechanism if there's no easy way to inject the slice parameter into your mason ->run
call.

The simpliest (yet tedious) solution is to inject this sub each time you use the filter.

Example with Catalyst's $c object being exposed as a global in your mason:

  % $.Slice( slice_id => 'myslice' , get_slice => sub{ scalar($c->req->param(shift)); }){{

  % }}

A nicer alternative is to curry the slice filter into a 'MySlice' one
at Mason's top level component (typically Base.mc):

  <%class>
     ## Replace scalar($c->req->param(shift)) by whatever your framework exposes as a parameter getting method.
     has 'MySlice' => ( default =>
                     sub{
                         my $self = shift;
                         return sub{ my (%args) = @_;
                                     return $self->Slice(get_slice => sub{ scalar($c->req->param(shift)); } , %args );
                                    };
                        } );
  </%class>

  % ## Then later:
  % ## Notice the -> arrow
  % $.MySlice->(slice_id => 'aslice' ){{
   SliceA
  % }}


=head1 AUTHOR

Jerome Eteve, C<< <jerome.eteve at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mason-plugin-slicefilter at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mason-Plugin-SliceFilter>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Mason::Plugin::SliceFilter


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Mason-Plugin-SliceFilter>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Mason-Plugin-SliceFilter>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Mason-Plugin-SliceFilter>

=item * Search CPAN

L<http://search.cpan.org/dist/Mason-Plugin-SliceFilter/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Jerome Eteve.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Mason::Plugin::SliceFilter
