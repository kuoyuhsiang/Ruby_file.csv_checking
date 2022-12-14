# frozen_string_literal: true

require 'csv'
require 'active_support'
require 'active_support/core_ext'

class CsvValidator
  attr_reader :errors

  def initialize(file_path, table_info, locales: [])
    # TODO, add any initialize process if you need
    @file_path = file_path
    @table_info = table_info
    @csv = CSV.table(file_path, { header_converters: ->(header) { header.to_s } })
    @header = @csv.headers
    @errors = []
  end

  def valid?
    # TODO
    empty_content?(@csv)
    id_duplicate?(@csv)
    @csv.each do |row|
      id = row[0]
      row.each do |key|
        time_format_violation?(key, id)
        length_limit_violation?(key, id)
        not_null_violation?(key, id)
      end
    end
    @errors.empty?
  end

  private

  # TODO, implement any private methods you need

  def empty_content?(csv)
    @errors.push('Empty Content') if csv.empty?
  end

  def id_duplicate?(csv)
    if csv.by_col[0].uniq! != nil
      id_column = csv.by_col[0]
      @id = id_column.detect { |e| id_column.count(e) > 1 }
      @errors.push("Duplicate Ids: [#{@id}]")
    end
  end

  def time_format_violation?(key, id)
    if @table_info.timestamp_columns.include?(key[0])
      begin
        DateTime.strptime(key[1], '%Y-%m-%d %H:%M:%S')
      rescue StandardError
        @errors.push("Time Format Violation at #{key[0]} in Row ID=#{id}")
      end
    end
  end

  def length_limit_violation?(key, id)
    @table_info.length_limit_data(@header).each do |colume_title|
      next unless colume_title[0].include?(key[0])

      if key[1].length > colume_title[1]
        @errors.push("Length Limit Violation at #{colume_title[0]}(#{colume_title[1]}) in Row ID=#{id}")
      end
    end
  end

  def not_null_violation?(key, id)
    @errors.push("Not Null Violation at character_id in Row ID=#{id}") if key[1].nil?
  end
end
