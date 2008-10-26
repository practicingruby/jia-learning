class Person
  def initialize(options)
    @floor       = options[:floor]
    @destination = options[:destination]
  end
  
  def at_destination?
    @destination == @floor
  end
  
  attr_accessor :floor, :destination
end

if __FILE__ == $PROGRAM_NAME
  require "rubygems"
  require "spec"
  
  describe "A Person" do
    before :each do
      @person = Person.new(:floor => 0, :destination => 0)
    end
    
    it "should start off on the first floor" do
      @person.floor.should be_zero
    end
    
    it "should start off not wanting to go anywhere" do
      @person.destination.should be_zero
    end
    
    it "should be able to change its destination" do
      @person.destination = 8
      @person.destination.should == 8
    end
    
    it "should start off at its destination" do
      @person.should be_at_destination
    end
    
    it "should know when it is not at its destination" do
      @person.destination = 8
      @person.should_not be_at_destination
    end
    
  end
  
end