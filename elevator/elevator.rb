require "person"

class Elevator
  
  class OverCapacityError < StandardError; end
  
  def initialize(options)
    @capacity  = options[:capacity]
    @top_floor = options[:top_floor]
    @floor     = 0
    @people    = []
  end
  
  def move_up
    self.floor += 1 unless @floor == @top_floor
  end
  
  def move_down
    self.floor -= 1 unless @floor.zero?
  end
  
  def floor=(floor)
    @floor = floor
    people.each { |person| person.floor = @floor }
  end
  
  def go_to(destination)
    distance = destination - floor
    action = distance > 0 ? :move_up : :move_down
    distance.abs.times { send(action) }
  end
  
  def add_person(person)
    raise OverCapacityError unless occupants < @capacity
    @people << person
  end
  
  def remove_person(person)
    @people.delete(person)
  end
  
  def occupants
    @people.length
  end
  
  def at_capacity?
    capacity == occupants
  end
  
  attr_reader :capacity, :floor, :people, :top_floor
end


if __FILE__ == $PROGRAM_NAME
  require "rubygems"
  require "spec"
  
  describe "An elevator" do
    
    before :each do
      @elevator =  Elevator.new(:capacity => 10, :top_floor => 20)
    end
    
    it "should have a maximum capacity" do
      @elevator.capacity.should == 10
    end
    
    it "should start on floor 0" do
      @elevator.floor.should == 0
    end
    
    it "should be able to go up a floor" do
      @elevator.move_up
      @elevator.floor.should == 1
    end
    
    it "should be able to go down a floor" do
      3.times { @elevator.move_up }
      @elevator.move_down
      @elevator.floor.should == 2
    end
    
    it "should not move below floor zero" do
      @elevator.move_down
      @elevator.floor.should == 0
    end
    
    it "should not go higher than the maximum floor" do
      100.times { @elevator.move_up }
      @elevator.floor.should == 20
    end
    
    it "should call move_up each time it goes up a floor using goto" do
      @elevator.should_receive(:move_up).exactly(8).times
      @elevator.go_to(8)
    end
    
    it "should be able to move to a specific floor" do
      @elevator.go_to(8)
      @elevator.floor.should == 8
      
      @elevator.go_to(2)
      @elevator.floor.should == 2
    end
    
    it "should not move when going to the same floor" do
      @elevator.go_to(8)
      @elevator.go_to(8)
      @elevator.floor.should == 8
    end
    
    it "should be able to load people" do
      5.times {  @elevator.add_person(new_person) }
      @elevator.occupants.should == 5
      
      2.times { @elevator.add_person(new_person) }
      @elevator.occupants.should == 7
    end
    
    it "should not take more than its capacity" do
      adding_too_many_people = lambda do
        20.times { @elevator.add_person(new_person) }
      end
      
      adding_too_many_people.should raise_error(Elevator::OverCapacityError)
    end
    
    it "should be able to unload people" do
      people = Hash[*[ :joe, :jim, :bob, :jacky ].map { |x| [x, new_person] }.flatten]
      
      people.each { |_,person| @elevator.add_person(person) }

      @elevator.remove_person(people[:jim])
      @elevator.remove_person(people[:bob])
      
      @elevator.people.should include(people[:joe])
      @elevator.people.should include(people[:jacky]) 
      
      @elevator.people.should_not include(people[:jim])
      @elevator.people.should_not include(people[:bob])
    end
    
    it "should set each person's floor as it moves" do
      5.times {  @elevator.add_person(new_person) }
      @elevator.go_to(5)
      @elevator.people.each do |person|
        person.floor.should == 5
      end
    end
    
    def new_person
      Person.new(:floor => 0, :destination => 1) 
    end
 
  end

end