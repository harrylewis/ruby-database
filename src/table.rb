# frozen_string_literal: true

require 'benchmark'

require 'btree'

class Table
  def initialize(size: 10_000_000)
    @store = []
    @index = nil

    benchmark do
      (1..size).each do |id|
        @store.push(id: id)
      end

      'Initialized'
    end
  end

  def where(id:)
    result = nil

    benchmark do
      if @index.nil?
        @store.each do |row|
          if row[:id] == id
            result = row
            break
          end
        end
      else
        location = @index.value_of(id)

        unless location.nil?
          result = @store[location]
        end
      end

      result
    end
  end

  def insert(id:)
    row = { id: id }

    benchmark do
      @store.push(row)

      unless @index.nil?
        @index.insert(id, @store.length - 1)
      end

      'Row inserted'
    end
  end

  def create_index
    benchmark do
      @index = Btree.create(5)

      @store.each_with_index do |row, i|
        @index.insert(row[:id], i)
      end

      'Index created'
    end
  end

  def delete_index
    benchmark do
      @index = nil

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
