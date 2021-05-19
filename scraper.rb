require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
    url= "https://www.totaljobs.com/jobs/in-london?radius=0"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    jobs = Array.new
    job_listings = parsed_page.css('div.job.new')
    job_listings.each do |job_listing|
        job = {
            title: job_listing.css('div.job-title').text.strip(),
            company: job_listing.css('h3').text.strip(),
            location: job_listing.css('li.location').text.strip(),
            url: job_listing.css('a')[0].attributes["href"].value
        }
        jobs << job
    end
    byebug
end

scraper


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