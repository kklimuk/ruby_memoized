# RubyMemoized

RubyMemoized makes it easy to memoize methods, even if they have arguments or blocks, 
by making memoization as easy as declaring a method private.
To experiment with that code, run `bin/console` for an interactive prompt.

For more information about the motivation behind the gem, 
please see [this blog post](https://medium.com/@kklimuk/memoization-in-ruby-made-easy-a4b0f6c11846).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_memoized'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_memoized

## Usage

Suppose we have the following class:

```ruby
class FibonacciCalculator
  def calculate(n)
    return n if (0..1).include?(n)
    calculate(n - 1) + calculate(n - 2)
  end
end
```

Right now, when we try to use this `FibonacciCalculator` for any larger number, it takes quite a while to compute since
it has to perform the method calls in line 34.

One of the ways we can make this computation much faster is to save (memoize) the pieces so they return immediately.
Let's do that in a separate method:

```ruby
class FibonacciCalculator
  def calculate(n)
    return n if (0..1).include?(n)
    calculate(n - 1) + calculate(n - 2)
  end

  memoized

  def memoized_calculate(n)
    return n if (0..1).include?(n)
    memoized_calculate(n - 1) + memoized_calculate(n - 2)
  end
end
```

Here, we put a call to the `memoized` class method. This class method will allow us to make sure that the outputs of 
any method calls below it will be saved (memoized).

Let's see the how the performance of one stacks up against the other for an `n` of 35.

```
                    user       system    total     real
with memoization    0.000000   0.000000  0.000000  ( 0.000469)
without memoization 46.010000  0.160000  46.170000 (46.597599)
```

Cool, but now suppose we wrote another method that we didn't want memoized after `memoized_calculate`.
We could unmemoize it by doing the following:

```ruby
class FibonacciCalculator
  include RubyMemoized

  memoized

  def memoized_calculate(n)
    return n if (0..1).include?(n)
    memoized_calculate(n - 1) + memoized_calculate(n - 2)
  end
  
  unmemoized
  
  def calculate(n)
    return n if (0..1).include?(n)
    calculate(n - 1) + calculate(n - 2)
  end
end
```

Alright, that sounds all well and good. But what if we really didn't wanna call `include RubyMemoized` everywhere but
still wanted to use memoization?

We could just add it to `Object`!

```ruby
class Object
  include RubyMemoized
end
```

Now we make objects that use `memoized`/`unmemoized` willy-nilly.

```ruby
class RandomThing
  memoize
  def hardcore_calculation
    # TODO: Write really hardcore calculation.
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kklimuk/memoized. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

