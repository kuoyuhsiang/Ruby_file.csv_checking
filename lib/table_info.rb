# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

class TableInfo
  attr_reader :localized_header_pattern

  def initialize(schema)
    @schema = schema
    # TODO, add any initialize process if you need
  end

  def timestamp_columns
    # TODO
    has_timestamp = []
    @schema.each do |n|
       if n[1][:type] == "timestamp" || n[1][:type] == "datetime"
        has_timestamp.push(n[0])
       end
    end
    has_timestamp
  end

  def not_null_columns
    # TODO
    not_null = []
    @schema.each do |n|
      if n[1][:null] == false 
        if !n[1][:auto_increment] && !n[1][:default] 
          not_null.push(n[0])
        end
       end
    end
   not_null
  end

  def length_limit_data(headers)
    # TODO
    length_limit_data = []
    default_limit = 255
    matched_header = headers.select { |n| n.match(/\[/)}
    matched_header.each do |col|
      title = col.split('[')[0]
      limit_character = @schema["#{title}"][:limit] || default_limit
      length_limit_data.push([col, limit_character])
    end
    length_limit_data
  end

  private

  # TODO, implement any private methods you need
end

