require 'open-uri'
require 'net/http'
require 'mechanize'
require 'uri'

class TestClass
	def self.main
		initial = "qds"
		visited_links = Array.new
		arr_result = Array.new
		self.add_info(initial, visited_links, arr_result)
		arr_result.uniq!
		#Remove blanks
		arr_result.reject! { |c| c.empty? }
		arr_result.sort!
		output = File.open( "answer.txt","w" )
		arr_result.each do |ae|
			output <<  ae + "\n"
		end
		output.close
	end

	def self.add_info(link, visited_links, arr_result)
		# Visit
		agent = Mechanize.new
	 	page = agent.get("https://cdn.hackerrank.com/hackerrank/static/contests/capture-the-flag/infinite/" + link + ".html")
		# Check if this one has text
		if page.body.include?("Secret Phrase")
			text = page.search("font").text.sub!('Secret Phrase: ', '')
			arr_result.push(text)
		end
		visited_links.push(link)
		# Get all the links in the page
		page.links.each do |link|
			if !visited_links.include?(link.text)
				self.add_info(link.text, visited_links, arr_result)
			end
		end
	end
end