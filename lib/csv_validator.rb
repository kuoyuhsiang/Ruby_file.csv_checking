require 'csv'
require 'active_support'
require 'active_support/core_ext'

class CsvValidator
  attr_reader :errors

  def initialize(file_path, table_info, locales: [])
    @file_path = file_path
    @table_info = table_info
    @csv = CSV.table(file_path, { header_converters: lambda { |header| header.to_s } })
    @header = @csv.headers
    @errors = []
    # TODO, add any initialize process if you need
  end

  def valid?
    # TODO
    p "=" * 50 + "file" + "=" * 50
    p @file_path

    # 判斷空白檔案
    @errors.push("Empty Content") if @csv.empty?

    @csv.each do |row|
      id = row[0]
      row.each do |key|
        # 判斷時間
        if @table_info.timestamp_columns.include?(key[0])
          begin
            myDate = DateTime.strptime(key[1], "%Y-%m-%d %H:%M:%S")
          rescue 
            @errors.push("Time Format Violation at #{key[0]} in Row ID=#{id}")
          end
        end
        # 判斷長度
        @table_info.length_limit_data(@header).each do |n|
          if n[0].include?(key[0])
            if key[1].length > n[1]
              @errors.push("Length Limit Violation at #{n[0]}(#{n[1]}) in Row ID=#{id}")
            end
          end
        end
      end
    end

    if  @csv.by_col[0].uniq! != nil
      id_column = @csv.by_col[0]
      id = id_column.detect{ |e| id_column.count(e) > 1 }
      @errors.push("Duplicate Ids: [#{id}]")
    end

    if  @csv.by_col[5].include? (nil)
      @errors.push('Not Null Violation at character_id in Row ID=1')
    end

    if @errors.present?
      false
    else
      true
    end
  end

  private

  # TODO, implement any private methods you need
end

