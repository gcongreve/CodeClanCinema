require_relative('../db/sql_runner')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers
    (name,
    funds)
    VALUES
    ($1,
     $2)
     RETURNING id;"
    values = [@name, @funds]
    id_return = SqlRunner.run(sql, values)
    @id = id_return.first['id'].to_i
  end

  def self.return_all()
    sql = "SELECT * FROM customers"
    customers_hashes = SqlRunner.run(sql)
    customers = customers_hashes.map { |customer| Customer.new(customer)}
    return customers
  end

  def update()
    sql = "UPDATE customers
	   SET (name, funds) = ($1, $2)
	   WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def which_films
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON films.id = film_id
    WHERE customer_id = $1;"
    values = [@id]
    film_hashs = SqlRunner.run(sql, values)
    films = film_hashs.map { |film| Film.new(film) }
    return films 
  end





end
