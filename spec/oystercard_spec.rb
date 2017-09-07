require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:entry_station) {double "entry_station"}
  let(:exit_station) {double "exit_station"}

  it "the balance is 0" do
    expect(oystercard.balance).to eq (0)
  end
  it 'is initially not in a journey' do
    expect(oystercard.in_journey).to eq false
  end
  it 'has an empty list of journeys as default' do
    expect(oystercard.journey_history).to be_empty
  end

  describe "#top_up" do
    it 'can top up balance' do
      expect{oystercard.top_up 1}.to change{ oystercard.balance }.by 1
    end
  end

  describe "#touch in" do
    it 'set in_journey to true' do
    oystercard.top_up(10)
    expect{oystercard.touch_in(entry_station)}.to change{oystercard.in_journey}.from(false).to(true)
    end
    it 'raise error if balance is below £1' do
    expect{oystercard.touch_in(entry_station)}.to raise_error "You do not have enough funds to travel"
    end
    it 'records what the entry station is' do
    oystercard.top_up(10)
    oystercard.touch_in(entry_station)
    expect(oystercard.entry_station).to eq entry_station
    end
  end

  describe "#touch out" do
    it 'can touch out' do          # balance is 10 within that it block
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.in_journey}.from(true).to(false)
    end
    it 'charges the minimum fare' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      minimum_fare = described_class::MINIMUM_FARE
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by -minimum_fare
    end
    it 'add entry and exit station to journey history' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      current_journey = {entry_station: entry_station, exit_station: exit_station}
      expect(oystercard.journey_history).to include(current_journey)
    end
    it 'stores a journey' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      current_journey = {entry_station: entry_station, exit_station: exit_station}
      expect(oystercard.journey_history).to include current_journey
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
