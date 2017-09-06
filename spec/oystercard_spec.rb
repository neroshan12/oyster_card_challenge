require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}

  it "the balance is 0" do
    expect(oystercard.balance).to eq (0)
  end

  it 'is initially not in a journey' do
    expect(oystercard).not_to be_in_journey
  end

  describe "#top_up" do
  #  it { is_expected.to respond_to(:top_up).with(1).argument }
    it 'can top up balance' do
      expect{oystercard.top_up 1}.to change{ oystercard.balance }.by 1
    end
  end

  describe "#deduct" do
  #  it { is_expected. to respond_to(:deduct).with(1).argument }  # because we want to deduct a value
    it 'can deduct a value from the balance' do
      oystercard.top_up(20)
      expect{oystercard.deduct 3}.to change{oystercard.balance}.by -3
    end
  end

  describe "#touch in" do
    it 'can touch in' do
  #  oystercard.touch_in
    expect{oystercard.touch_in}.to change{oystercard.in_journey?}.from(false).to(true)
    end
  end

  describe "#touch out" do
    it 'can touch out' do
      oystercard.touch_in
#      oystercard.touch_out
      expect{oystercard.touch_out}.to change{oystercard.in_journey?}.from(true).to(false)
#      expect(oystercard).not_to be_in_journey
    end
  end

  describe '#error' do
    it "raises an error if maximum balance is exceeded" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      expect {oystercard.top_up 1}.to raise_error "Maximum balance exceeded (£#{maximum_balance})"
    end
  end
end
