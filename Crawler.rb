require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'byebug'
require 'csv'

def main(search_phrase)
  browser = Watir::Browser.new
  page_counter = 1
  CSV.open("wynik.csv", "w") do |csv|
    csv << ["Tytul", "Cena", "Link"]
    while page_counter <= 1
      # if page_counter > 1
      #   url = 'https://allegro.pl/listing?string=' + search_phrase + '?p=' + page_counter.to_s
      # else
      #   url = 'https://allegro.pl/listing?string=' + search_phrase
      # end
      url = 'https://allegro.pl/listing?string=' + search_phrase
      browser.goto url
      page = Nokogiri::HTML(browser.html)
      opbox = page.css('div.opbox-listing')
      articles = opbox.css('article.mx7m_1')
      articles.each do |article|
        link = article.css('a')[0].attributes["href"].value
        browser.goto link
        nested_product = Nokogiri::HTML(browser.html)
        title = article.css('h2.mgn2_14').text
        price = article.css('span._1svub').text
        csv << [title, price, link]
      end
      page_counter = page_counter + 1
    end
  end
  browser.close
end

if ARGV[0]
  print('Start programu. Szukam produktów według słowa kluczowego ' + ARGV[0])
  main(ARGV[0])
else
  print('Brak zdefiniowanej kategorii. Proszę określić kategorię jako pierwszy parametr przy wywoływaniu programu.')
end