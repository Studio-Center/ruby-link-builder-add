#!/usr/bin/env ruby
require 'csv'

class LinkAdder

	def initialize

		# set initial values
		@startCSV = 'list.csv'
		@linkToAdd = 'http://johnmarshallbank.com'
		@results = Hash.new

		# walk assigned CSV
		walkCSV

	end

	# load sentences and keyword list
	def openCSV
		@start_list = CSV.open(@startCSV, :encoding => 'windows-1251:utf-8').to_a
	end

	# walk selected list
	def walkCSV
		openCSV

		# walk through provided list of keywords and sentences
		@start_list.each { |keyword,sentence|

			# check for non-empty keyword
			if keyword.to_s.length > 0

				# clean provided sentence and keyword values
				newKeyword = keyword.to_s.strip
				newSentence = sentence.to_s.strip
				newSentence.gsub! /#{newKeyword}/i, '<a href="' << @linkToAdd << '" title="' << newKeyword << '">' << newKeyword << '</a>'

				# print current keyword
				puts "#{newKeyword}"

				# initialize hash array if it does not exist
				if !@results.has_key?(newKeyword.to_sym)
					@results[newKeyword.to_sym] = Array.new
				end

				# store results in hash/array mix
				@results[newKeyword.to_sym] << newSentence

			end

		}

		# write results to file
		writeFile

		# let user know script has finished
		puts "Done!"

	end

	def writeFile
		CSV.open("results.csv", "wb") {|csv| 
			@results.each {|result| 
				csv << [result[0].to_s]
					result[1].each { |chr|  
						csv << ['',chr.to_s]
					}
			}
		}
	end

end

addLinks = LinkAdder.new