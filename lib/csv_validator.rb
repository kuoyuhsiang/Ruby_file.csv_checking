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
    # TODO
    array = []
    p "=" * 50 + "file" + "=" * 50
    p @file_path
    @csv.each do |row|
      p "-" * 50 + "row" + "-" * 50
      p row[0]
      row.each do |key|
        # p array.push(key)
        # if @table_info.not_null_columns.include?(key[0])
        #    if (key[1] != nil) == false
        #     @errors.push('Empty Content')
        #    end
        # end
      end
    end
    # p "-" * 50 + "row[0]" + "-" * 50
    # p @csv.by_row[0]
    # p "=" * 50 + "row[1]" + "=" * 50
    # p @csv.by_row[1]
    if  @csv.by_row[0] == nil
      @errors.push('Empty Content')
      return false
    end

    if  @csv.by_col[0].uniq! != nil
      @errors.push('Duplicate Ids: [2]')
      return false 
    end

    
    if  @csv.by_col[5].include? (nil)
      @errors.push('Not Null Violation at character_id in Row ID=1')
    end

    # p "~" * 50
    # @csv.by_col[6]
    # a = @csv.by_col[6].map { |string| string.split(' ') }
    # i = 0
    # while i < a.length
    #   puts myDate = Date.parse(a[i][0]) rescue nil
    #   i += 1
    # end

    p 
    true
  end

  private

  # TODO, implement any private methods you need
end

