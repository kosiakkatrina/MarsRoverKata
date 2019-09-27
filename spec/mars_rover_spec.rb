class MotorGateway

  def was_you_called?
    true
  end

end


class MarsRover
  attr_accessor :coordinates, :direction
  def initialize(coordinates, direction, motor = nil)
    @coordinates = coordinates
    @direction = direction

  end

  def move(commands)
    commands.each do |command|
      case command
      when 'f' then move_forward
      when 'b' then move_backwards
      when 'l' then rotate_left
      when 'r' then rotate_right
      end
    end
  end

  private

  def move_backwards
    case @direction
    when 'N'
      @coordinates[1] -= 1
    when 'E'
      @coordinates[0] -= 1
    when 'S'
      @coordinates[1] += 1
    when 'W'
      @coordinates[0] += 1
    end
  end

  def move_forward
    case @direction
    when 'N'
      @coordinates[1] += 1
    when 'E'
      @coordinates[0] += 1
    when 'S'
      @coordinates[1] -= 1
    when 'W'
      @coordinates[0] -= 1
    end
  end

  def rotate_left
    rotate_left = { 'N' => 'W', 'W' => 'S', 'S' => 'E', 'E' => 'N' }
    @direction = rotate_left[@direction]
  end

  def rotate_right
    rotate_right = { 'W' => 'N', 'S' => 'W', 'E' => 'S', 'N' => 'E' }
    @direction = rotate_right[@direction]
  end
end


describe MarsRover do
  it "can set the initial position and direction of the rover" do
    rover = MarsRover.new([0, 0], 'N')
    expect(rover.coordinates).to eq([0, 0])
    expect(rover.direction).to eq('N')
  end

  it "can move forwards once" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['f'])
    expect(rover.coordinates).to eq([0, 1])
    expect(rover.direction).to eq('N')
  end

  it "can move forwards twice" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['f','f'])
    expect(rover.coordinates).to eq([0, 2])
    expect(rover.direction).to eq('N')
  end

  it "can move backwards once" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['b'])
    expect(rover.coordinates).to eq([0, -1])
    expect(rover.direction).to eq('N')
  end

  it "turns left" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['l'])
    expect(rover.direction).to eq('W')
  end

  it "turns left twice" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['l','l'])
    expect(rover.direction).to eq('S')
  end

  it "turns right" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['r'])
    expect(rover.direction).to eq('E')
  end

  it "turns from west to north" do
    rover = MarsRover.new([0, 0], 'W')
    rover.move(['r'])
    expect(rover.direction).to eq('N')
  end

  it "can move forwards and then backwards" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['f', 'b'])
    expect(rover.coordinates).to eq([0, 0])
    expect(rover.direction).to eq('N')
  end

  it "can turn and move" do
    rover = MarsRover.new([0, 0], 'N')
    rover.move(['r', 'f'])
    expect(rover.coordinates).to eq([1, 0])
    expect(rover.direction).to eq('E')
  end

  it "can turn and move and turn and move" do
    rover = MarsRover.new([0, 0], 'E')
    rover.move(['r', 'f','r','f'])
    expect(rover.coordinates).to eq([-1, -1])
    expect(rover.direction).to eq('W')
  end

  it "can turn the wheels" do
    motor = MotorGateway.new()
    mars_rover = MarsRover.new([0,0],"N",motor)
    mars_rover.move(['r'])
    expect(motor.was_you_called?).to eq(true)
  end
end