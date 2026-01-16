# DEVELOPMENT

We use `Minilla` as our authoring tool and `Carton` as our module dependency
manager.

## How to Setup Development Environment
```bash
$ carton install --deployment
```

## How to Test
```bash
$ perl Build.PL
$ ./Build build
$ ./Build test
```

## How to Format
```bash
$ author/format.sh
```
