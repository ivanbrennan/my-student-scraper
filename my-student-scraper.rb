=begin
ADD columns:
  name
  social media(4)
  stu website
  quote
  bio
  work
Refactor with abstractions
=end

require 'sqlite3'
require 'open-uri'
require 'nokogiri'
require 'ap'

FLATIRON_DOMAIN = "http://students.flatironschool.com/"

def build_html(url)
  Nokogiri::HTML(open(url))
end

def stu_name(profile_html)
  profile_html.css("h4.ib_main_header").text
end

def stu_img(profile_html)
  src = profile_html.css("img.student_pic").attr("src").text
  img_url = "#{FLATIRON_DOMAIN}#{src[3..-1]}"
end

idx_html = build_html(FLATIRON_DOMAIN)
idx_links = idx_html.css("div.big-comment a").collect do |a|
  "#{FLATIRON_DOMAIN}#{a["href"]}"
end

# Create an array of students
students_arr = idx_links.inject([]) do |students, link|
  student_html = build_html(link)
  students << {
    :name => stu_name(student_html),
    :img => stu_img(student_html)
  }
end

# SQL statements
# Create table
sql_create_table = <<-SQL
  CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    img TEXT
  )
SQL

# Open a database
db = SQLite3::Database.new "students.db"
# Create a table in the database
db.execute(sql_create_table)

# Insert students
sql_insert = "INSERT INTO students (name, img) VALUES (?,?)"
students_arr.each do |student_hash|
  db.execute(sql_insert, student_hash[:name], student_hash[:img])
end
