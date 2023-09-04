package DiscordBot;

use strict;
use warnings;

use IO::Async::Loop;
use IO::Async::Timer::Countdown;
use Net::Async::WebSocket::Client;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON;
use IPC::Run3;
use Data::Dumper;

sub new {
    my ($pkg, %params) = @_;

    run3 ['/opt/homebrew/bin/gpg', '--decrypt', '--batch', 'secure-config.gpg'], undef, \my $output, undef, undef;
    my $token = decode_json($output)->{'discord-bot-token-mordecai'};

    my $self = bless {
        token      => $token,
        messages   => [],
        on_message => $params{on_message},
        %params,
    }, $pkg;

    my $ua   = LWP::UserAgent->new;
    my $loop = IO::Async::Loop->new;
    my $ws   = Net::Async::WebSocket::Client->new(
        on_text_frame => sub {
            my ($ws, $frame) = @_;
            $self->_handle_message_created($frame);
        },
        on_read => sub {
            my ($self, $buffref, $eof) = @_;
            warn "WebSocket connection received eof\n" if $eof;
        },
    );

    $self->{ua}   = $ua;
    $self->{loop} = $loop;
    $self->{ws}   = $ws;

    $loop->add($ws);

    if (my $every_x_seconds = $self->{every_x_seconds}) {
        my ($seconds, $sub) = @$every_x_seconds;

        die "every_x_seconds first arrayref slot needs to have a valid number of seconds in it, not '$seconds'"
            unless $seconds =~ /\A\d+\z/;

        $self->{every_x_seconds} = IO::Async::Timer::Countdown->new(delay => $seconds, on_expire => sub {
            warn "Running 'every_x_seconds' callback (every $seconds) (pid=$$)\n";
            my $message = $sub->();
            $self->{every_x_seconds}->start; # restart

            return unless defined $message;

            my $r = $self->{ua}->request(POST(
                "https://discord.com/api/v10/channels/$self->{channel_id}/messages",
                Content_Type => 'application/json',
                User_Agent => 'DiscordBot (kewanalearn.com, 0.1)',
                Content => encode_json({ content => $message }),
                Authorization => "Bot $self->{token}",
            ));

            if (!$r->is_success) {
                my $content = $r->content;
                print Dumper $content;
            }
        });

        $self->{loop}->add($self->{every_x_seconds}->start);
    }

    return $self;
}

sub _handle_message_created {
    my ($self, $frame) = @_;

    my $data = decode_json($frame);

    $self->{last_s} = $data->{s};

    warn "In 'on_text_frame' ($data->{op}).\n";

    if ($data->{op} == 10) { # first connection ("hello" message)
        my $seconds = $data->{d}{heartbeat_interval} / 1000;

        print "HELLO: ".Dumper($data);

        $self->{keepalive_timer} = IO::Async::Timer::Countdown->new(delay => $seconds, on_expire => sub {
            warn "Sending heartbeat (pid=$$)\n";
            $self->{ws}->send_text_frame(encode_json({ op => 1, d => {sequence_number=>$self->{last_s}} })); # beat
            $self->{keepalive_timer}->start; # restart
        });

        $self->{loop}->add($self->{keepalive_timer}->start);
    }
    elsif ($data->{op} == 0 && $data->{t} eq 'READY') { # "ready"
        print "Got op=0, $data->{t} (pid=$$)\n";
    }
    elsif ($data->{op} == 0 && $data->{t} eq 'MESSAGE_CREATE') {
        warn " - In 'MESSAGE_CREATE' if-statement.\n";
        if ($data->{d}{author}{bot}) {
            warn " - Bot message detected.\n";
            print "Not responding, cause this is a message from a bot (likely me)\n";
        }
        else {
            warn " - Human message detected.\n";
            $self->{channel_id} = $data->{d}{channel_id};
            my $author          = $data->{d}{author}{username};
            my $content         = $data->{d}{content};

            my $response_message = $self->{on_message}->($author, $content);

            if (defined $response_message) {
                warn " - Going to deliver response to discord: $response_message.\n";
                my $r = $self->{ua}->request(POST(
                    "https://discord.com/api/v10/channels/$self->{channel_id}/messages",
                    Content_Type => 'application/json',
                    User_Agent => 'DiscordBot (kewanalearn.com, 0.1)',
                    Content => encode_json({ content => $response_message }),
                    Authorization => "Bot $self->{token}",
                ));

                if (!$r->is_success) {
                    my $content = $r->content;
                    print Dumper $content;
                }
            }
            else {
                warn " - No response message to reply with.\n";
            }
        }
    }
    else {
        print Dumper $data;
    }
}

sub run {
    my ($self) = @_;

    $self->{ws}->connect(
        url => URI->new('wss://gateway.discord.gg/?v=9&encoding=json'),
        on_connected => sub {
            my ($me) = @_;

            warn "In 'on_connected'. Sending text frame to 'Identify'\n";

            $me->send_text_frame(encode_json({
                op => 2, # Identify opcode
                d => {
                    token => $self->{token},
                    intents => 512, # Guild messages intent
                    properties => {
                        '$os' => 'Darwin',
                        '$browser' => 'my_bot',
                        '$device' => 'my_bot'
                    }
                }
            }));
        },
    );

    $self->{loop}->run;
}

1;
