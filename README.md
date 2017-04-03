SA
========

A simple SA(Simulated Annealing) framework


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simulated_annealing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simulated_annealing

## Usage

```
require 'simulated_annealing'
or 
# require 'sa'

class Unit
  include SA

  attr_accessor :state

  def initialize
    @state = 8.times.map { rand(2) }
  end

  def energy
    val = @state.join.to_i(2)
    val * Math.sin(val)
  end

  def sa_iterator(ctx, temp)
    @state.length.times do
      i = rand(state.length)
      state[i] = 1 - state[i]

      unless ctx.transfer(self.energy, self.state)
        # recover
        state[i] = 1 - state[i] 
      end
    end
  end
end

Unit.simulated_annealing({
  temp: 100,
  cool: Proc {|t| t * 0.95 }
  stop_temp: 0.001
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sa.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

