require "spec_helper"

RSpec.describe SA do
  it "has a version number" do
    expect(Sa::VERSION).not_to be nil
  end

  it "should proxy Context#annealing with simulated_annealing method" do
    ctx = double('ctx', annealing: true)
    unit = double('unit')
    p = Proc.new {|t| t - 0.1 }

    allow(SA::Context).to receive(:new).and_return(ctx)
    expect(ctx).to receive(:annealing).with(unit, 100, 0.1, p)

    TestCls.simulated_annealing(unit, {temp: 100, stop_temp: 0.1, cool: p})
  end
end
