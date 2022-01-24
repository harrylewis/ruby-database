# frozen_string_literal: true

class Database
  def initialize
    @tables = {}
  end

  def create_table(name:, schema:)
    @tables[name] = Table.new(name: name, schema: schema)
  end

  def insert(table:, rows:)
    @tables[table].insert(rows: rows)
  end

  def select(table:, column:, value:)
    @tables[table].where(column: column, value: value)
  end

  def create_index(table:, column:)
    @tables[table].create_index(column: column)
  end

  def delete_index(table:, column:)
    @tables[table].delete_index(column: column)
  end
end
