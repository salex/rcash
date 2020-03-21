class Inventory

  attr_accessor :beer, :liquor, :qoh
  require 'csv'

  def initialize
    @beer = {}
    @liquor = {}
    @qoh = []
  end

  # def merge
  #   get_qoh
  #   goh_hash = qoh.pluck(0,1).to_h
  #   beer_keys = beer.keys
  #   liquor_keys = liquor.keys
  #   revenue = ["Liqueur","Rum & Tequila","Whiskey","Gin & Vodka","Beer"]

  #   goh_hash.each do |k,v|
  #     if  revenue.include?(v)
  #       if v == 'Beer'
  #         unless beer_keys.include?(k)
  #           # add beer item
  #         end
  #       else
  #         unless liquor_keys.include?(k)
  #           #add liquor item
  #         end
  #       end
  #     end
  #   end
  #   beer_keys.each do |k|
  #     unless qoh_hash.has_key?(k)
  #       # delete from beer
  #     end
  #   end
  #   liquor_keys.each do |k|
  #     unless qoh_hash.has_key?(k)
  #       # delete from beer
  #     end
  #   end
  #   new_beer = {}
  #   new_liquor = {}
  # end

  def get_qoh
    qoh_path = Rails.root.join('yaml/Inventory/qoh.csv')
    @qoh = CSV.parse(File.read(qoh_path))
    qoh.delete_at(0)
    # p qoh
    @beer_path = Rails.root.join('yaml/Inventory/beer.yaml')
    @liquor_path = Rails.root.join('yaml/Inventory/liquor.yaml')
    if File.file?(@beer_path)
      get_beer
    else
      create_beer
    end
    if File.file?(@liquor_path)
      get_liquor
    else
      create_liquor
    end
    return nil
  end

  def get_beer
    @beer = YAML.load_file(@beer_path)
    qoh.each do |item|
      if item[1] == 'Beer'
        if beer.has_key?(item[0])
          beer[item[0]]['curr'] = item[2].to_i
          beer[item[0]]['order'] = item[3].to_i
          p item
        else
          beer[item[0]] = {
            curr:item[2].to_i,
            order:item[3].to_i,
            size:24,
            cases:0,
            bottles_w:0,
            bottles_c:0,
            total:0
          }.with_indifferent_access
        end
      end
    end
    p beer
  end

  def get_liquor
    revenue = ["Liqueur","Rum & Tequila","Whiskey","Gin & Vodka"]
    @liquor = YAML.load_file(@liquor_path)
    # p "liquor from yaml -- #{@liquor}"

    # puts "end of liq"
    qoh.each do |item|
      if revenue.include?(item[1])
        if liquor.has_key?(item[0])
          liquor[item[0]]['curr'] = item[2].to_i
          liquor[item[0]]['order'] = item[3].to_i
        else
          liquor[item[0]] = {
              curr:item[2].to_i,
              order:item[3].to_i,
              size:1000,
              bottles:0,
              percent:0,
              total:0
            }.with_indifferent_access
        end
      end
    end
  end

  def create_beer
    qoh.each do |item|
      if item[1] == 'Beer'
        beer[item[0]] = {
          curr:item[2].to_i,
          order:item[3].to_i,
          size:24,
          cases:0,
          bottles_w:0,
          bottles_c:0,
          total:0
        }.with_indifferent_access
      end
    end
    yaml = beer.to_yaml
    File.write(@beer_path,yaml)
  end

  def create_liquor
    revenue = ["Liqueur","Rum & Tequila","Whiskey","Gin & Vodka"]
    qoh.each do |item|
      if revenue.include?(item[1])
        liquor[item[0]] = {
          curr:item[2].to_i,
          order:item[3].to_i,
          size:1000,
          bottles:0,
          percent:0,
          total:0
        }.with_indifferent_access
      end
    end
    yaml = liquor.to_yaml
    File.write(@liquor_path,yaml)
  end

end