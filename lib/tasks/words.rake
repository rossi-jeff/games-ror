namespace :words do
  desc "add word list to words table"
  task seed_words: :environment do
		count = 0
		fileName = "lib/tasks/usa2.txt"
		wordList = IO.readlines(fileName)
		wordList.each do | word |
			word = word.scrub.strip
			if word.size >= 4 && word.size <= 30 && !word.match?(/[^a-zA-Z]/)
				Word.create({
					Word: word,
					Length: word.size
				})
				count += 1
			end
			if count % 1000 == 0
				puts "#{count} words added"
			end
		end
		puts "#{count} words added"
  end

end
