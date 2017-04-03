class TestCls
  include SA

  attr_accessor :state

  def initialize
    @state = 8.times.map { rand(2) }
  end

  def energy
    val = @state.join.to_i(2)
    (val * Math.sin(val)).round(3)
  end

  def sa_iteration(ctx, temp)
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

