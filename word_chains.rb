require 'set'

class WordChainer
  def initialize(dictionary_file_name)
    @dictionary = read_dictionary(dictionary_file_name)
  end

  def read_dictionary(filename)
    words = Set.new
    File.open(filename, "r").each do |line|
      words << line.chomp
    end
    words
  end

  def adjacent_words(word)
    length = word.length
    @dictionary.select do |other_word|
      length == other_word.length && same_enough?(word, other_word, length - 1)
    end
  end

  def same_enough?(word1, word2, amount_same)
    amount_same <= word1.chars.each_with_index.inject(0) do |sames, (char, i)|
      word1[i] == word2[i] ? sames + 1 : sames
    end
  end

  def run(source, target)
    @current_words = Set.new << source
    @all_seen_words = { source => nil }
    until @current_words.empty? do
      @current_words = explore_current_words
      break if @all_seen_words[target]
    end
    puts build_path(target)
  end

  def explore_current_words
    new_current_words = Set.new
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        unless @all_seen_words.keys.include?(adjacent_word)
          @all_seen_words[adjacent_word] = current_word
          new_current_words << adjacent_word
        end
      end
    end
    new_current_words
  end

  def build_path(target)
    path = [target]
    here = target
    until @all_seen_words[here].nil?
      path << @all_seen_words[here]
      here = @all_seen_words[here]
    end
    path.reverse!
  end

end

if __FILE__ == $PROGRAM_NAME
  time1 = Time.now
  WordChainer.new('dictionary.txt').run('duck','ruby')
  p Time.now - time1
end
