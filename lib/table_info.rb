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
    has_timestamp = []
    @schema.each do |n|
       if n[1][:type] == "datetime"
        has_timestamp.push(n)
       end
    end
    has_timestamp
    # TODO
  end

  def not_null_columns
    not_null = []
    @schema.each do |n|
      if n[1][:null] == false 
        not_null.push(n[0])
       end
   end
   not_null
    # TODO
  end

  def length_limit_data(headers)
    # TODO
  end

  private

  # TODO, implement any private methods you need
end

