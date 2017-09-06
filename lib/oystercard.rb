class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 3
  attr_reader :balance

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(value)
    raise "Maximum balance exceeded (£#{MAXIMUM_BALANCE})" if balance + value > MAXIMUM_BALANCE
    @balance += value
  end

  def in_journey?
    @in_journey
  end

  def touch_in
      raise "You do not have enough funds to travel" if @balance < MINIMUM_BALANCE
      @in_journey = true
  end

  def touch_out
    deduct (MINIMUM_FARE)
    @in_journey = false
  end

  private
  def deduct(value)
    @balance -= value
  end

end
