=begin
Your goal is to get a database that has all the student data (so say if we wanted to build a command line version of the student website we could use that database).
Then you go to students.flatironschool.com and via nokogiri, find all the individual profile pages. Open each one of those (probably in a loop) and from the individual students page, scrape all their data.
   
Once you have all the students, drop it into a database.
IVAN: do hard-coded, then try to add abstractions
=end

require 'sqlite3'
require 'open-uri'
require 'nokogiri'
require 'ap'

# Open a database
db = SQLite3::Database.new "students.db"

# Create a table in the database
sql_create_table = <<-SQL
  CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY,
    name TEXT
  )
SQL

db.execute(sql_create_table)

flatiron_domain = "http://students.flatironschool.com/"
index_html = Nokogiri::HTML(open(flatiron_domain))

index_links = index_html.css("div.big-comment a")
index_urls = index_links.collect do |link|
  "#{flatiron_domain}#{link["href"]}"
end

profiles_html_arr = index_urls.collect do |url|
  profile_html = Nokogiri::HTML(open(url))
end
