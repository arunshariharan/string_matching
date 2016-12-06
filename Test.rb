require 'json'
require 'pp'
require 'stopwords'

database = File.read(File.expand_path("Test2.json"))
db = JSON.parse(database)

jokes = []
File.foreach(File.expand_path("1liner.txt")) do |each_line|
  next if each_line.chomp.empty?
  jokes << each_line.chomp
end

baby_jokes = []
File.foreach(File.expand_path("babyjoke.txt")) do |each_line|
  next if each_line.chomp.empty?
  qnA = each_line.split('?')
  answer = qnA[1].chomp if (qnA[1] != nil)
  baby_jokes << [qnA[0].chomp, answer]
end

joke2 = []
(jokes.size).times.each do |time|
  next if (time%2 != 0) && (time != 0)
  joke2 << [jokes[time], jokes[time + 1]]
end


db["parent"].to_a.each do |key, value|
  joke2.each do |item|    
    db["parent"][item[0]] = item[1]
    db["parent"][item[0]] = item[1]    
  end
end

db["parent"].to_a.each do |key, value|
  baby_jokes.each do |item|    
    db["parent"][item[0]] = item[1]
    (item[1] == nil) ? (db["parent"][item[0]] = " Hahaha, that's actually a good joke!!") : (db["parent"][item[0]] = item[1])
  end
end

test_sentence = "Mummy! Mummy! It's hot in here - can I come out?"
stopwords = ["in", "the", "by", "guy", "a", "and", "with", "what", "do", "of", "you", "no", "or", "call", "if", "it's"]
stop_filter = Stopwords::Filter.new stopwords
filtered_sentence = stop_filter.filter test_sentence.downcase.split(' ')


filter = Stopwords::Filter.new stopwords
matching_question = Hash.new
db["parent"].each_with_index do |(key, value), ind|
  count =0
  key.downcase.split(' ').any? { |key_word|
    f = stop_filter.filter key_word.split(' ')
    if (f & filtered_sentence) != []
      #puts ind
      count += 1
    end
   print ""
  }
  matching_question[ind] = count
end
write = File.open(File.expand_path("Test2.json"), "w")
open(write, "a") { |file| 
      file << JSON.pretty_generate(db)
}

refined_questions =  matching_question.delete_if {|key, value| value == 0}
refined_questions = refined_questions.sort_by { |key, value| value }.last.first

puts db["parent"].values[refined_questions]

=begin
This one is too mundane!!!
# if filtered_sentence.any? {|word| 
  #   key.downcase.split(' ').any? { |key_word|
  #     f = stop_filter.filter key_word.split(' ')
  #     if filtered_sentence.join(' ').include? f.join(' ')
  #       count += 1
  #     end
  #   }
  #   key.include? word
  # }
  # #count == 0
  # #puts value
  # end
=end