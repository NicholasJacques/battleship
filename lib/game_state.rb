class GameState
  attr_accessor :prompt, :response_handler, :new_messages

  def initialize(game, )
    @game = nil
    @prompt = nil
    @response_handler= nil
    @new_messages = []
  end

end