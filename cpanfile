requires 'perl', '5.008001';
requires 'Getopt::Long';
requires 'Data::Gimei', 'v0.0.7';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

