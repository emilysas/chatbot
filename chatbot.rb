# the key() method creates a new array populated with the keys from the responses hash
# select {|item| block} returns a new array containing all the elements for which the given block returns a true value,
# so here it returns a new array in which the keys match the input
# sample chooses a random element(s) from the array - CAN'T FIGURE OUT HOW THIS WORKS HERE

# So key = a random choice from an array of keys that match the users input
# Where the input matches the key, then the response will be the associated value
# Where there is no response then it will puts 'sorry?', 
# Where there is a response it will puts that, interpolating the matchdata $1 for c1 and $2 for c2

RESPONSES = { 'goodbye' => 'bye',
              'sayonara' => 'sayonara',
              'the weather is (.*)' => 'I hate it when it\'s %{c1}',
              'I love (.*)' => 'I love %{c1} too',
              'I groove to (.*) and (.*)' => 'I love %{c1} but I hate %{c2}',
              'I\'m hungry for (.*)' => 'I can\'t have %{c1}, on account of my allergies',
              'I can\'t stand (.*)!' => 'Interesting! What is it about %{c1} that you don\'t like?',
              'I have two children called (.*) and (.*)' => '%{c1} is an awesome name; but %{c2} is a bit, well, you know!',
              'I could talk to you all night' => 'That\'s sweet, but I\'m afraid I have better things to do.',
              'What\'ve you been upto today?' => 'Oh you know, same old same old',
              'This conversation is getting a bit (.*)' => '%{c1}! I don\'t know whether to be insulted or flattered',
              'What\'re you doing tonight?' => 'Erm, washing my hair.',
          	  'What\'s your name?' => 'I\'m currently known as chatbot, but in a former life I was called Eliza',
          	  'What is your name?' => 'I go by chatbot',
          	  'What sort of music do you like?' => 'Well I\'m a computer programme, so I\'m going to go ahead and say electronic music'}

@full_responses = RESPONSES
@new_responses = {}


require 'colorize'

def get_response(input)
  
  answers = ["I get what you're saying", "Really?", "I totally understand", "I'm hearing you", "It's interesting you say that", "I don't follow you", "Hmmm, this conversation is going nowhere", "Yaaaaawn.... what were you saying?"]
  answering_questions = ["I'm not sure it's appropriate for you to ask me that!", "Why do you ask?", "Is that really something you're interested in finding out?", "I don't really see the point of your question?", "Is this an interrogation?"]

  key = @full_responses.keys.select {|k| /#{k}/ =~ input }.sample 
  /#{key}/ =~ input
  response = @full_responses[key]
    if response.nil?
      if input.match(/\?/)
        @new_responses.store(input, answering_questions.sample)
      else 
      	@new_responses.store(input, answers.sample)
      end
    else 
      response % { c1: $1, c2: $2, c3: $3, c4: $4, c5: $5}
    end
end

def open_file
  	file = File.open("responses.csv")
  	file.readlines.each do |line|
      key, value = line.chomp.split(',')
      @full_responses.store(key, value)
      file.close
	end
end

open_file
puts "bot: Hello, what's your name?".blue
print "Enter name: "
@name = gets.chomp
puts "bot: Hello #{@name}".blue
print "#{@name}: "


while(input = gets.chomp) do
  if input == "quit"
  	file = File.open("responses.csv", "w")
    file.puts @new_responses
    file.close
    exit
  else
  	puts "bot: ".blue + "#{get_response(input)}".blue
  	print "#{@name}: "
  end
end
