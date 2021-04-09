require 'oystercard'
describe Oystercard do
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:history) {subject.history} 
  
  context "#balance" do
    it "card should have 0 balance initially" do
      expect(subject.balance).to eq(0)
    end
  end

  context "#top_up" do
    it "should add money to balance" do
      expect { subject.top_up(5) }.to change { subject.balance }.by 5 
    end

    it "should raise an error if the balance exceeds limit" do
      max_bal = ::MAX_BALANCE
      subject.top_up(max_bal)
      expect { subject.top_up(1) }.to raise_error("Error: You have exceeded the #{max_bal} limit.")
    end
  end
  
  context "#touch_in" do
    it "starts journey when touched in" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it "should raise an error when card is empty" do
      expect { subject.touch_in(entry_station) }.to raise_error("Error: Not enough money.")
    end
  end

  context "#touch_out" do
    it "should be out of journey once we touch out " do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey 
    end

    it "should charge the card when touched out" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect {subject.touch_out(exit_station)}.to change { subject.balance }.by(-::MIN_AMOUNT)
    end
  end

  context "#entry_station" do
    it "should recognise the station we entered from" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq(entry_station)
    end
  
    it "should change the entry station to be nil when touched out" do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq(nil)
    end
  end
   
  context "journey history" do
    it "should set an empty list of journeys as default" do
      expect(history).to eq []
    end

    it "creates journey" do
      subject.top_up(5)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(history).to eq [ {entry_station => exit_station} ]
    end
  end
end
