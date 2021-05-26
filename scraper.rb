require 'nokogiri'
require 'httparty'
require 'byebug'
require 'awesome_print'
require "addressable/uri"
require "csv"

def scraper
    # using user-agent to check connection available 
    page = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://london.craigslist.org `
    url= "https://london.craigslist.org/search/hhh"
    # Verifying if the URL is correct 
    Addressable::URI.parse(url).host
    # HttpParty initial use 
    unparsed_page = HTTParty.get(url)
    # Nokogiri parses as elements of arrays 
    parsed_page = Nokogiri::HTML(unparsed_page.body)
    # Creating new Array where we will store all the information about flat listings 
    flats = Array.new
    # Getting div with overview of all the information required 
    flat_listings = parsed_page.css('div.result-info')
    page = 1
    per_page = flat_listings.count #currently 120
    total = parsed_page.css('span.totalcount')[0].text #total amount of listings on this page
    # For now we are doing it only on one page as craigslist has quite weird pagination 
    last_page = 1
    while page <= last_page
        pagination_url = "https://london.craigslist.org/d/housing/search/hhh"
        puts pagination_url
        puts "LISTING on page: #{page}"
        puts ''

        pagination_unparsed_page = HTTParty.get(pagination_url)
        pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page.body)
        pagination_flat_listings = pagination_parsed_page.css('li.result-row')
        pagination_flat_listings.each do |flat_listing|
            
            flat = {
                title: flat_listing.css('h3')[0].text.strip(),
                url: flat_listing.css('a')[0].attributes["href"].text,
                # Price is a span that repeats twice in two places within the listing
                # price: parsed_page.css('span.result-price')[0].text
            }
            
            flats << flat
            
            puts "Listing: #{flat[:title]}"
            puts "Link: #{flat[:url]}" 
            # puts "Price tag: #{flat[:price]}"

            # Saving file to csv, a+ means it will append the data to the end of the document, 
            # we can use 'w+' if we want to overwrite the document 

            CSV.open("results.csv", "a+") do |csv|
                csv << [flat[:title],flat [:url]]
            end
               
        end
        page += 1
    end
end


scraper








