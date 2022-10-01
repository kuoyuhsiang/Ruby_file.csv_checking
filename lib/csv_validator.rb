require 'csv'
require 'active_support'
require 'active_support/core_ext'

class CsvValidator
  attr_reader :errors

  def initialize(file_path, table_info, locales: [])
    @file_path = file_path
    @table_info = table_info
    @csv = CSV.table(file_path, { header_converters: lambda { |header| header.to_s } })
    @errors = []
    # TODO, add any initialize process if you need
  end

  def valid?
    a = @table_info.not_null_columns
    
    p  @file_path
    p "&" * 50
     @csv.each do |row|
       row.each do |key|
        if a.include?(key[0])
           if (key[1] != nil) == false
            p @errors.push("Empty Content")
           end
        end 
       end
    end
    p "&" * 50
    # TODO
    true
  end

  private

  # TODO, implement any private methods you need
end

