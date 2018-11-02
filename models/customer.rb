require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')

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

  # def film_price(film_name)
  #   sql = "SELECT films.price FROM films
	#    WHERE films.title = $1;"
  #    values = [film_name]
  #    prices = SqlRunner.run(sql, values)
  #    return prices.to_i
  # end

  def enough_money?(film)
    @funds > film.price
  end

  def pay_for_film(film)#film object
    @funds -= film.price
  end

  def buy_ticket(film_object)
    if enough_money?(film_object)
      pay_for_film(film_object)
      ticket = Ticket.new({'film_id' => film_object.id, 'customer_id' => @id })
      ticket.save
      update
    end
  end

  def number_of_tickets
    sql = "SELECT * FROM tickets
	   WHERE customer_id = $1"
    value = [@id]
    tickets_array = SqlRunner.run(sql, value)
    tickets = tickets_array.count
    return tickets
  end



end
