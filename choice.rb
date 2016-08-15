class Choice
  attr_reader :verb, :name, :text, :next_choices, :block

  def setup(verb, name, text, choices, &block)
    @verb = verb
    (name.include? '%') ? @name = name.sub('%', verb.upcase) : @name = name
    @text = text
    @next_choices = choices
    @block = block if block_given?
  end

  # No initialize This is to allow choices to be cross-referenced with 
  # each other and make their order of creation unimportant.  
  # to do: write test to check setup has been called(?)
end