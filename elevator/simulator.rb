require "elevator"
require "person"

class Simulator
  def initialize(people, elevator)
    @people   = people
    @elevator = elevator
  end
  
  attr_reader :people, :elevator
  
  def update_people
    @people.each do |person|
      if person.at_destination?
        if elevator.people.include?(person)
          elevator.remove_person(person)
          puts "#{person.object_id} reached destination floor #{elevator.floor}"
        end
      elsif elevator.floor == person.floor
        unless elevator.people.include?(person) || elevator.at_capacity?
          elevator.add_person(person) 
          puts "#{person.object_id} gets on the elevator at #{elevator.floor}"
        end
      end
    end
  end
  
  def run
    until @people.all? { |person| person.at_destination? }
      0.upto(elevator.top_floor) do |floor|
        puts "elevator is now on floor #{@elevator.floor}" <<
             " with #{@elevator.occupants} people"
        update_people
        elevator.move_up
      end
    
      elevator.top_floor.downto(0) do |floor|
        puts "elevator is now on floor #{@elevator.floor}" <<
             " with #{@elevator.occupants} people"
        update_people
        elevator.move_down
      end
    end
  end
  

end

if __FILE__ == $PROGRAM_NAME
  person   = Person.new(:floor => 5, :destination => 10)
  person2  = Person.new(:floor => 8, :destination => 9)
  person3  = Person.new(:floor => 9, :destination => 2) 
  person4  = Person.new(:floor => 1, :destination => 10)
  elevator = Elevator.new(:capacity => 2, :top_floor => 10)
  people = [person, person2, person3, person4]
  
  sim = Simulator.new(people, elevator)
  sim.run
end