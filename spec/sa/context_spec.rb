RSpec.describe SA::Context do
  let(:ctx) { SA::Context.new }
  let(:unit) { TestCls.new }

  describe '#annealing' do
    it 'should return better result' do
      unit.state = [0] * 8
      old_energy = unit.energy
      expect {
        ctx.annealing(unit, 10, 0.1, Proc.new {|t| t - 0.1 })
      }.to change(unit, :energy)
      expect(unit.energy < old_energy).to eql(true)
    end

    it 'should call TestCls#sa_iteration for each Temp' do
      cool_proc = Proc.new {|t| t - 2 }
      expect(unit).to receive(:sa_iteration).with(ctx, 6).ordered
      expect(cool_proc).to receive(:call).with(6).and_call_original.ordered
      expect(unit).to receive(:sa_iteration).with(ctx, 4).ordered
      expect(cool_proc).to receive(:call).with(4).and_call_original.ordered
      expect(unit).to receive(:sa_iteration).with(ctx, 2).ordered
      expect(cool_proc).to receive(:call).with(2).and_call_original.ordered
      ctx.annealing(unit, 6, 0, cool_proc)
    end

    it 'should use best history, if current energy worse than history' do
      10.times do |i|
        u = TestCls.new
        result = [[-300, [1] * 8], [-100, [1] * 7 + [0]], [-200, [1] * 6 + [0] * 2]]
        allow(u).to receive(:sa_iteration) do |ctx, temp|
          s = result.shift
          5.times { ctx.transfer(*s) }
        end

        ctx.annealing(u, 600, 0, Proc.new {|t| t - 200 })
        expect(u.state).to eql([1] * 8)
      end
    end
  end

  describe '#transfer' do
    before :each do
      ctx.instance_variable_set('@best_energy', 10)
      ctx.instance_variable_set('@best_state', 'state')
      ctx.instance_variable_set('@current_energy', 15)
      ctx.instance_variable_set('@current_temp', 30.0)
    end

    it 'should return true and update context if new_energy < current energy' do
      expect {
        expect {
          expect {
            expect(ctx.transfer(12, 'new_state')).to eql(true)
          }.to change { ctx.instance_variable_get('@current_energy') }.to(12)
        }.to_not change { ctx.instance_variable_get('@best_energy') }
      }.to_not change { ctx.instance_variable_get('@best_state') }
    end

    it 'should return true and update context if new_energy eql current energy' do
      ctx.instance_variable_set('@best_energy', 16)

      expect {
        expect {
          expect {
            expect(ctx.transfer(15, 'new_state')).to eql(true)
          }.to_not change { ctx.instance_variable_get('@current_energy') }
        }.to change { ctx.instance_variable_get('@best_energy') }.to(15)
      }.to change { ctx.instance_variable_get('@best_state') }.to('new_state')
    end

    it 'should return true and update context if new_energy < best energy' do
      expect {
        expect {
          expect {
            expect(ctx.transfer(9, 'new_state')).to eql(true)
          }.to change { ctx.instance_variable_get('@current_energy') }.to(9)
        }.to change { ctx.instance_variable_get('@best_energy') }.to(9)
      }.to change { ctx.instance_variable_get('@best_state') }.to('new_state')
    end

    it 'should return true and update context if rand number < transfer probability' do
      allow(Kernel).to receive(:rand).and_return(0.9)

      expect {
        expect {
          expect {
            expect(ctx.transfer(17, 'new_state')).to eql(true)
          }.to change { ctx.instance_variable_get('@current_energy') }.to(17)
        }.to_not change { ctx.instance_variable_get('@best_energy') }
      }.to_not change { ctx.instance_variable_get('@best_state') }
    end

    it 'should return false if rand number >= transfer probability' do
      allow(Kernel).to receive(:rand).and_return(0.95)

      expect {
        expect {
          expect {
            expect(ctx.transfer(17, 'new_state')).to eql(false)
          }.to_not change { ctx.instance_variable_get('@current_energy') }
        }.to_not change { ctx.instance_variable_get('@best_energy') }
      }.to_not change { ctx.instance_variable_get('@best_state') }
    end
  end
end

