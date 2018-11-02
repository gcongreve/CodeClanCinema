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

  def update()
    sql = "UPDATE films
     SET (title, price) = ($1, $2)
     WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def which_customers_have_tickets()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = customer_id
    WHERE film_id = $1;"
    values = [@id]
    customers_hashes = SqlRunner.run(sql, values)
    customers = customers_hashes.map { |customer| Customer.new(customer)}
    return customers
  end





end
