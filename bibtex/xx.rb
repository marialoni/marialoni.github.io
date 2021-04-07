#!/usr/bin/env ruby
require 'bundler/inline'
require 'yaml'
require 'pp'

gemfile do
  source 'https://rubygems.org'
  gem 'bibtex-ruby', '~> 6'
  gem 'nokogiri', '~> 1.11'
  gem 'text', '~> 1.3'
end

bib = BibTeX.open('aloni.bib')
bib_entries = bib.map { |bib_entry|
  bib_entry.fields.keys.reject { |key|
    key.to_s.include?('date-added') || key.to_s.include?('date-modified')
  }.map { |key|
    bib_entry[key]
  }.join(' ')
}
#puts bib_entries

html = Nokogiri::HTML(File.read('../articles.html'))
html_entries = html.xpath('//li').map { |node|
  node.text.split.join(' ')
}
#puts html_entries

html_entries.each { |html_entry|
  puts html_entry
  closest = bib_entries.map { |bib_entry|
    {
      'value' => bib_entry,
      'distance' => Text::Levenshtein.distance(html_entry, bib_entry)
    }
  }.sort_by { |hsh| hsh['distance'] }.first['value']
  puts '--'
  puts closest
  puts
  puts
}


#foo = bib[/Journal of Logic, Language and Information/]

#