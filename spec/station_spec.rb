require 'station'
describe Station do
  let(:subject) { Station.new(2, "London Fields") }
    it "recognises the zone" do
      expect(subject.zone).to eq(2)
    end

    it "recognises the name" do
      expect(subject.name).to eq("London Fields")
    end
end