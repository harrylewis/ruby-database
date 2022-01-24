# frozen_string_literal: true

class Database
  def initialize
    @tables = {}
  end

  def create_table(name:, schema:)
    @tables[name] = Table.new(name: name, schema: schema)
  end
end
