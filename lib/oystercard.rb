class Oystercard 
  attr_reader :balance, :entry_station, :history #, :exit_station
  ::DEFAULT_BALANCE = 0
  ::MAX_BALANCE = 90
  ::MIN_AMOUNT = 1
    
    def initialize(balance = DEFAULT_BALANCE, entry_station = nil, history = [])
      @balance = balance
      @entry_station = entry_station
      @history = history
    end 

    def top_up(amount)
      fail "Error: You have exceeded the #{MAX_BALANCE} limit." if @balance >= MAX_BALANCE
      @balance += amount
    end

    def touch_in(station)
      fail "Error: Not enough money." if @balance < MIN_AMOUNT
      @entry_station = station
    end

    def touch_out(exit_station)
      deduct(MIN_AMOUNT)
      add_to_history(exit_station)
      @entry_station = nil
    end

    def in_journey?
      entry_station != nil
    end

    private 

    def deduct(amount)
      @balance -= amount
    end

    def add_to_history(exit_station)
      @history << { @entry_station => exit_station }
    end
end