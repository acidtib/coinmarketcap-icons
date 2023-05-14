require "thor"
require "typhoeus"
require "json"
require "fileutils"


class CLI < Thor
  desc "fetch", "download all icons"
  option :name, :default => "slug", :type => :string
  option :size, :default => 128, :type => :numeric
  option :json, :type => :boolean, :lazy_default => false
  def fetch()
    # sizes coinmarketcap cdn replies
    sizes = {128 => "128x128", 64 => "64x64", 32 => "32x32", 16 => "16x16"}

    # possible file names
    names = ["id", "slug", "symbol", "rank"]

    json_result = []

    Dir.mkdir("icons") unless File.exist?("icons")

    puts "Downloading icons, size: #{sizes[options[:size]]} named: #{options[:name]}.png"
    puts "-"*40

    raise "select a valid name: #{names}" unless names.include?(options[:name])
    raise "select a valid size: #{sizes}" unless sizes.include?(options[:size])

    # parallel request, can be bumped for faster downloads
    hydra = Typhoeus::Hydra.new(max_concurrency: 5)

    # fetch updated list from coinmarketcap
    coins_list = Typhoeus.get("https://s2.coinmarketcap.com/generated/search/quick_search.json")

    raise "Failed to load coins list" if coins_list.code != 200

    coins_list_json = JSON.parse(coins_list.body)

    # create a queue with every file request
    coins_list_json.each_with_index do |coin, index|
      request = Typhoeus::Request.new("https://s2.coinmarketcap.com/static/img/coins/#{sizes[options[:size]]}/#{"#{coin["id"]}.png"}")
      request.on_complete do |response|
        json_result << coin.merge({logo: "#{coin[options[:name]]}.png"}) if options[:json]
        # save png using provided name
        File.write("icons/#{coin[options[:name]]}.png", response.body, mode: "w+")
        puts "[#{index + 1}:#{coins_list_json.count}] - #{coin[options[:name]]}.png saved succesfully."
      end
      hydra.queue(request)
    end
    
    hydra.run

    File.write("icons.json", json_result.to_json, mode: "w+") if options[:json]
  end
end

CLI.start(ARGV)