require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
    ##Scraping all available jobs now in London
    url= "https://www.totaljobs.com/jobs/in-london?radius=0"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    jobs = Array.new
    job_listings = parsed_page.css('div.job.new')

     # Divide all number of listing by number of pages and then rounding it up to
    page = 1
    per_page = job_listings.count #currently 20
    total = parsed_page.css('div.page-title').text.split(' ')[0].gsub(',','').to_i#38374 for London jobs currently available
    last_page = (total.to_f / per_page.to_f).round
    while page <= last_page
        pagination_url = "https://www.totaljobs.com/jobs/in-london?radius=0&page=#{page}"
        puts pagination_url
        puts "Page: #{page}"
        puts ''

        pagination_unparsed_page = HTTParty.get(pagination_url)
        pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
        pagination_job_listings = pagination_parsed_page.css('div.job.new')
        pagination_job_listings.each do |job_listing|
            job = {
                title: job_listing.css('div.job-title').text.strip(),
                company: job_listing.css('h3').text.strip(),
                location: job_listing.css('li.location').text.strip(),
                url: job_listing.css('a')[0].attributes["href"].value
            }
            jobs << job
            puts "Added #{job[:title]}"
            puts ""
        end
        page += 1
    end
end

scraper

## TODO: Read some more about gsub


# div job.new
# div.job-title
# li salary


#From here we can scrap stuff

# jobCard = parsed_page.css('div.job.new')
# jobCard.first.text
# firstJob = jobCard.first
# firstJob.css('div.job-title').text
# firstJob.css('h3').text
# firstJob.css('a')[0].attributes["href"].value  <-  scraping further looking for first value of href in those a