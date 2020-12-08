class Instruction
  attr_reader :operation, :argument

  def initialize(in_operation, in_argument)
    self.operation = in_operation
    self.argument = in_argument.to_i
  end

  # return delta_setp: the number of steps to the next line
  def execute(in_comp_state) # an array with currently only the accumulator at index 0
    the_next_delta_step = 1
    case self.operation
    when "acc"
      in_comp_state[0] += argument
      # puts "Accumulator inc with #{self.argument} to #{in_comp_state[0]}"
    when "jmp"
      # puts "Jumped #{self.argument}"
      the_next_delta_step = argument
    when "nop"
      # puts "NOP"
    else
      puts "Unknown instruction"
      exit
    end
    the_next_delta_step
  end

  def toggle!
    if can_be_toggled?
      self.operation = (self.operation == "jmp" ? "nop" : "jmp")
    end
  end

  def can_be_toggled?
    self.operation != "acc"
  end

  private

  attr_writer :operation, :argument
end

class OpcodeComp
  attr_reader :accumulator, :instructions, :current_line, :lines_executed
  attr_writer :accumulator, :instructions, :current_line, :lines_executed

  def initialize(in_filename)
    reset_state

    self.instructions = []
    File.open(in_filename).each do |line|
      operation, argument = line.split(" ")
      self.instructions << Instruction.new(operation, argument)
    end
  end

  def reset_state
    self.accumulator = [0]
    self.current_line = 0
    self.lines_executed = []
  end

  def run
    reset_state

    the_toggle_index = 0
    the_toggle_index += 1 while !self.instructions[the_toggle_index].can_be_toggled?
    self.instructions[the_toggle_index].toggle!

    while true
      if self.lines_executed.include?(self.current_line) # loop detected
        reset_state
        self.instructions[the_toggle_index].toggle! # revert

        the_toggle_index += 1
        the_toggle_index += 1 while !self.instructions[the_toggle_index].can_be_toggled?
        self.instructions[the_toggle_index].toggle!
      end
      if self.current_line >= self.instructions.size || self.current_line <0
        puts "Program terminated: Accumulator = #{self.accumulator[0]}"
        exit
      end
      self.lines_executed << self.current_line
      self.current_line += self.instructions[self.current_line].execute(self.accumulator)
    end
  end
end

#part 1
the_opcode_program = OpcodeComp.new('day_8_input.txt')
# the_console.run

#part 2
the_opcode_program.run

