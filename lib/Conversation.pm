package Conversation;

use strict;
use warnings;

use JSON;
use DateTime;

sub new {
    my ($pkg, $name, %params) = @_;

    return bless {
        name => $name,
        messages => [],
        %params,
    }, $pkg;
}

sub messages { $_[0]{messages} }

sub _current_time { DateTime->now(time_zone => 'America/New_York')->strftime("%c %Z") }

sub add_prompt {
    my ($self, $text, %params) = @_;

    push @{$self->{messages}}, { role => 'user', content => $text, time => _current_time(), %params };
}

sub add_response {
    my ($self, $text) = @_;

    push @{$self->{messages}}, { role => 'assistant', content => $text, time => _current_time() };
}

sub add_system_message {
    my ($self, $text) = @_;

    push @{$self->{messages}}, { role => 'system', content => $text, time => _current_time() };
}

sub load {
    my ($pkg, $name) = @_;

    die "No conversation name provided. Which one should I load?" unless $name;

    my $self = $pkg->new($name);

    system("mkdir", "./conversations/$self->{name}") unless -d "./conversations/$self->{name}";

    open my $f, "<", "./conversations/$self->{name}/messages";
    my $slurp = do { local $/; <$f> };

    $self->{messages} = decode_json($slurp || "[]");

    return $self;
}

sub save {
    my ($self) = @_;

    open my $f, ">", "./conversations/$self->{name}/messages";

    print $f encode_json($self->{messages});
}

1;
