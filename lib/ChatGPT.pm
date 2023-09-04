package ChatGPT;

use strict;
use warnings;

use JSON;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use IPC::Run3;
use Data::Dumper;
use utf8;
use Encode;

sub new {
    my ($pkg, %params) = @_;

    run3 ['/opt/homebrew/bin/gpg', '--decrypt', '--batch', 'secure-config.gpg'], undef, \my $output, undef, undef;
    my $api_key = decode_json($output)->{'openai-api-key'};
    my $ua = LWP::UserAgent->new;

    return bless {
        api_key      => $api_key,
        ua           => $ua,
        default_role => 'user',
        role_for_instructional_messages => 'system',
        %params,
    }, $pkg;
}

sub query {
    my $self = shift;
    my %params = @_ == 1
        ? (messages => { role => $self->{default_role}, content => $_[0] })
        : @_;

    my $messages            = $params{messages} // [];
    my $pre_system_message  = $params{pre_message};
    my $post_system_message = $params{post_message};

    my $r = $self->{ua}->request(POST('https://api.openai.com/v1/chat/completions',
        Content_Type  => 'application/json',
        Content       => encode_json {
            model    => 'gpt-3.5-turbo',
            messages => [
                $pre_system_message ? {role => $self->{role_for_instructional_messages}, content => $pre_system_message} : (),
                @{_massage_messages($messages)},
                $post_system_message ? {role => $self->{role_for_instructional_messages}, content => $post_system_message} : (),
            ],
        },
        Authorization => "Bearer $self->{api_key}",
    ));

    return decode_json($r->decoded_content)->{choices}[0]{message}{content}
        if $r->is_success;

    my $content = $r->content;
    die Dumper $content;
}

sub _massage_messages {
    my ($running_convo) = @_;
    return [ map { { role => $_->{role}, content => $_->{content} }; } @$running_convo ];
}

1;
