require 'arduino_ir_remote'

class Aircon
  def initialize
    @ir = ArduinoIrRemote.connect
  end

  def list
    ArduinoIrRemote::DATA.keys
  end

  def send(status)
    @ir.write ArduinoIrRemote::DATA[status]
  end
end
