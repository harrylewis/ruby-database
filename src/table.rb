# frozen_string_literal: true

require 'benchmark'

require 'btree'

class Table
  def initialize(size: 10_000_000)
    @store = []
    @index = nil

    benchmark = Benchmark.measure do
      (1..size).each do |id|
        @store.push(id: id)
      end
    end

    puts "Initialized"
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"
  end

  def where(id:)
    result = nil

    benchmark = Benchmark.measure do
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
    end

    puts (result.nil? ? {} : result)
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"

    result
  end

  def insert(id:)
    row = { id: id }

    benchmark = Benchmark.measure do
      @store.push(row)

      unless @index.nil?
        @index.insert(id, @store.length - 1)
      end
    end

    puts "Row inserted"
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"
  end

  def create_index
    benchmark = Benchmark.measure do
      @index = Btree.create(5)

      @store.each_with_index do |row, i|
        @index.insert(row[:id], i)
      end
    end

    puts "Index created"
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"
  end

  def delete_index
    benchmark = Benchmark.measure do
      @index = nil
    end

    puts "Index deleted"
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"
  end

  def inspect
    "#<Table:#{"0x00%x" % object_id << 1} rows: #{@store.length}>"
  end
end
