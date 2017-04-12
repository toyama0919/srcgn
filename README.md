# srcgn

Make transcript by music file. use Google speech api.

## Examples

### flac file
```
$ srcgn -l ja -f test.flac --format json
```

### mp3 file
```
$ srcgn -l ja -f test.mp3 --format json
```

## Settings Environment(Example)
```
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.gcp/credentials.json
export GOOGLE_CLOUD_PROJECT="MY-PROJECT"
```

## Installation

require sox and mp3splt.

#### MAC
```
$ brew install mp3splt
$ brew install sox --with-lame --with-flac --with-libvorbis
```

#### Linux
```
$ sudo yum -y install sox
$ sudo yum -y install mp3splt
```

### Gem install

Add this line to your application's Gemfile:

```
gem 'srcgn'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install srcgn
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Information

* [Homepage](https://github.com/toyama0919/srcgn)
* [Issues](https://github.com/toyama0919/srcgn/issues)
* [Documentation](http://rubydoc.info/gems/srcgn/frames)
* [Email](mailto:toyama0919@gmail.com)

## Copyright

Copyright (c) 2017 toyama0919

See [LICENSE.txt](../LICENSE.txt) for details.
