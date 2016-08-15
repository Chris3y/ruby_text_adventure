require_relative 'choice'

class Item < Choice
  attr_reader :verb, :name, :text, :use_states, :next_choices, :block

  def setup(verb, name, text, *use_states, choices, &block)
  	super(verb, name, text, choices)
    @use_states = use_states
  end

  def to_s
      @name
  end

end