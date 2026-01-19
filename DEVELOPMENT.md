# DEVELOPMENT

We use `Minilla` as our authoring tool and `Carmel` as our module dependency
manager.

## How to Setup Development Environment
```bash
$ cpanm Carmel@v0.1.56
$ carmel install
```

## How to Test
```bash
$ carmel exec perl Build.PL
$ carmel exec perl Build build
$ carmel exec perl Build test
```

## How to Format
```bash
$ author/format.sh
```

## How to release to CPAN
```bash
$ carmel exec minil test
$ carmel exec minil release --dry-run
$ carmel exec minil release
```

## Docker
```bash
$ docker build -t gimei .
$ docker run --rm -it -v $PWD:/gimei gimei
```

```bash
$ git clone https://github.com/tokuhirom/plenv.git ~/.plenv
$ echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(plenv init -)"' >> ~/.bash_profile
$ exec $SHELL -l
$ git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
$ plenv install 5.40.3
$ plenv install-cpanm
$ plenv rehash
```
