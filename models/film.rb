require_relative('../db/sql_runner')

class Film

  attr_accessor :title, :price
  attr_reader :id

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

  def self.return_all()
    sql = "SELECT * FROM films"
    films_hashes = SqlRunner.run(sql)
    films = films_hashes.map { |film| Film.new(film)}
    return films
  end






end
