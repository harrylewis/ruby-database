# frozen_string_literal: true

require 'benchmark'

require 'btree'

class Table
  attr_reader :name

  # Creates a new database table described by `schema`.
  #
  # @param [Array] schema An array of symbols. Must contain `:id`.
  def initialize(name:, schema:)
    benchmark do
      @store = []
      @index = nil
      @name = name
      @schema = schema
      @indexes = {}

      'Initialized'
    end
  end

  def where(column:, value:)
    result = nil

    benchmark do
      index = @indexes[column]

      if index.nil?
        @store.each do |row|
          if row[column] == value
            result = row
            break
          end
        end
      else
        location = index.value_of(value)

        unless location.nil?
          result = @store[location]
        end
      end

      result
    end
  end

  def insert(row:)
    row = @schema.map { |column| [column, row[column]] }.to_h

    benchmark do
      @store.push(row)

      unless @index.nil?
        @index.insert(row[:id], @store.length - 1)
      end

      'Row inserted'
    end
  end

  def create_index(column:)
    benchmark do
      @indexes[column] = Btree.create(5)

      @store.each_with_index do |row, i|
        @indexes[column].insert(row[column], i)
      end

      'Index created'
    end
  end

  def delete_index(column:)
    benchmark do
      @indexes[column] = nil

      'Index deleted'
    end
  end

  def inspect
    "#<Table:#{"0x00%x" % object_id << 1} rows: #{@store.length}>"
  end

  private

  def benchmark(&block)
    result = nil

    benchmark = Benchmark.measure do
      result = block.call
    end

    puts result
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"
  end
end
