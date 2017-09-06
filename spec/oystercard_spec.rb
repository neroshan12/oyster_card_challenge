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

#   describe "#deduct" do
# #  it { is_expected. to respond_to(:deduct).with(1).argument }  # because we want to deduct a value
#     it 'can deduct a value from the balance' do
#       oystercard.top_up(20)
#       expect{oystercard.deduct 3}.to change{oystercard.balance}.by -3
#     end
#   end

  describe "#touch in" do
    it 'set in_journey to true' do
#  oystercard.touch_in
    oystercard.top_up(10)
    expect{oystercard.touch_in(station)}.to change{oystercard.in_journey?}.from(false).to(true)
    end

    it 'raise error if balance is below £1' do
    expect{oystercard.touch_in(station)}.to raise_error "You do not have enough funds to travel"
    end

    let(:station) {double "station"}
    it 'records what the entry station is' do
    oystercard.top_up(10)
    oystercard.touch_in(station)
    expect(oystercard.entry_station).to eq station
    end
  end

  describe "#touch out" do
    let(:station) {double "station"}
    it 'can touch out' do          # balance is 10 within that it block
      oystercard.top_up(10)
      oystercard.touch_in(station)
#     oystercard.touch_in
#      oystercard.touch_out
      expect{oystercard.touch_out(station)}.to change{oystercard.in_journey?}.from(true).to(false)
#      expect(oystercard).not_to be_in_journey
    end
    it 'charges the minimum fare' do
      oystercard.top_up(10)
      oystercard.touch_in(station)
      minimum_fare = described_class::MINIMUM_FARE
      expect{oystercard.touch_out(station)}.to change{oystercard.balance}.by -minimum_fare
    end
    it 'forgets station when touch out' do
      oystercard.touch_out(station)
    #  expect{oystercard.entry_station}.to change{oystercard.entry_station}.from(station).to(nil)
      expect(oystercard.entry_station).to eq nil
    end
  end

  describe '#error' do
    it "raises an error if maximum balance is exceeded" do
      maximum_balance = described_class::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      expect {oystercard.top_up 1}.to raise_error "Maximum balance exceeded (£#{maximum_balance})"
    end
  end
end
