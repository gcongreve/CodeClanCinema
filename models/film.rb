require_relative('../db/sql_runner')

class Film

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    (title,
    price)
    VALUES
    ($1,
    $2)
    RETURNING id;"
    values = [@title, @price]
    id_return = SqlRunner.run(sql, values)
    @id = id_return.first['id']
  end






end
