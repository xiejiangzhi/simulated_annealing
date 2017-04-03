require "sa/version"
require 'sa/context'

module SA
  def self.included(cls)
    cls.extend(SA::ClassMethods)
  end

  module ClassMethods
    def simulated_annealing(unit, options)
      opts = options.each_with_object({}) {|kv, r| r[kv.first.to_sym] = kv.last }
      ctx = SA::Context.new
      ctx.annealing(unit, opts[:temp], opts[:stop_temp], opts[:cool])
      return unit
    end
  end
end
