# frozen_string_literal: true

require 'benchmark'

require 'pry'

class Table
  def initialize(size: 10_000_000)
    @store = []

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
      @store.each do |row|
        if row[:id] == id
          result = row
          break
        end
      end
    end

    puts (result.nil? ? {} : result)
    puts "Time: #{(benchmark.real * 1000.0).round(2)}ms"

    result
  end

  def inspect
    "#<Table:#{"0x00%x" % object_id << 1} rows: #{@store.length}>"
  end
end
