class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 3

  attr_reader :balance
  attr_reader :entry_station
  attr_reader :exit_station
  attr_reader :journey_history
  attr_reader :in_journey

  def initialize
    @balance = 0
    @in_journey = false
    @journey_history = []
    @entry_station = nil
    @exit_station = nil
  end

  # def in_journey
  #   @in_journey
  # end

  def top_up(value)
    raise "Maximum balance exceeded (£#{MAXIMUM_BALANCE})" if balance + value > MAXIMUM_BALANCE
    @balance += value
  end

  def touch_in(entry_station)
    raise "You do not have enough funds to travel" if @balance < MINIMUM_BALANCE
    @in_journey = true
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    @in_journey = false
    deduct (MINIMUM_FARE)
    @exit_station = exit_station
    @journey_history << {entry_station: entry_station, exit_station: exit_station}
  end

  private
  def deduct(value)
    @balance -= value
  end
end
