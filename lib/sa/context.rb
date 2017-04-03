module SA
  class Context
    attr_accessor :best_state, :best_energy

    # options:
    #   temp: Int or Float
    #   cool: Proc, return new Temp
    #   stop_temp: Int or Float, stop annealing when temp < stop_temp
    def annealing(unit, temp, stop_temp, cool_proc)
      @best_state = unit.state
      @best_energy = unit.energy

      @current_energy = unit.energy
      @current_temp = temp.to_f

      while @current_temp > stop_temp do
        unit.sa_iteration(self, @current_temp)
        @current_temp = cool_proc.call(@current_temp).to_f
      end

      unit.state = @best_state if @best_energy < unit.energy
      unit
    end

    def transfer(energy, state)
      if energy <= @current_energy
        @current_energy = energy
        if energy < best_energy
          @best_energy = energy
          @best_state = state.dup
        end
        true
      else
        p = Math::E ** -((energy - @current_energy) / @current_temp)
        v = Kernel.rand
        if v < p
          @current_energy = energy
          true
        else
          false
        end
      end
    end
  end
end

