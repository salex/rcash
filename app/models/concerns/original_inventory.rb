class OriginalInventory

  attr_accessor :beer, :liquor,:beer_path,:liquor_path
  require 'csv'

  def initialize
    @beer = {}
    @liquor = {}
    @beer_path = Rails.root.join('yaml/inventory/beer.yaml')
    @liquor_path = Rails.root.join('yaml/inventory/liquor.yaml')

  end

  def get_qoh
    qoh_path = Rails.root.join('yaml/inventory/qoh.csv')
    qoh = CSV.parse(File.read(qoh_path))
    qoh.delete_at(0)
    @beer_qoh = []
    @liquor_qoh = []
    revenue = ["Liqueur","Rum & Tequila","Whiskey","Gin & Vodka"]
    qoh.each do |item|
      @liquor_qoh << item if revenue.include?(item[1])
      @beer_qoh << item if item[1] == 'Beer'
    end
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
    last = YAML.load_file(@beer_path)
    @beer_qoh.each do |item|
      key = item[0]
      if last.has_key?(key)
        beer[key] = last[key]
        beer[key]['curr'] = item[2].to_i
        beer[key]['order'] = item[3].to_i
      else
        beer[key] = {
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

  def get_liquor
    last = YAML.load_file(@liquor_path)
    @liquor_qoh.each do |item|
      key = item[0]
      if last.has_key?(key)

        liquor[key] = last[key]
        liquor[key]['curr'] = item[2].to_i
        liquor[key]['order'] = item[3].to_i
      else
        liquor[key] = {
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

  def create_beer
    @beer_qoh.each do |item|
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
    yaml = beer.to_yaml
    File.write(@beer_path,yaml)
  end

  def create_liquor
    @liquor_qoh.each do |item|
      liquor[item[0]] = {
        curr:item[2].to_i,
        order:item[3].to_i,
        size:1000,
        bottles:0,
        percent:0,
        total:0
      }.with_indifferent_access
    end
    yaml = liquor.to_yaml
    File.write(@liquor_path,yaml)
  end

end