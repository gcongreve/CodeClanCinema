require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')
require_relative('screening')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.return_all()
    sql = "SELECT * FROM customers"
    customers_hashes = SqlRunner.run(sql)
    customers = customers_hashes.map { |customer| Customer.new(customer)}
    return customers
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

  def update_customer()
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

  def which_films #returns the films customer has tickets for
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON films.id = film_id
    WHERE customer_id = $1;"
    values = [@id]
    film_hashs = SqlRunner.run(sql, values)
    films = film_hashs.map { |film| Film.new(film) }
    return films
  end

  def enough_money?(film)
    @funds > film.price
  end

  def pay_for_film(film)#film object
    @funds -= film.price
  end

  # def buy_ticket(film_object)
  #   if enough_money?(film_object)
  #     pay_for_film(film_object)
  #     ticket = Ticket.new({'film_id' => film_object.id, 'customer_id' => @id })
  #     ticket.save
  #     update_customer
  #   end
  # end

  def buy_screening_ticket(screening)
    if screening.any_tickets_left? && enough_money?(screening)
      pay_for_film(screening)
      screening.remove_ticket
      screening.update_screening
      ticket = Ticket.new({'film_id' => screening.film_id, 'screening_id' => screening.id, 'customer_id' => @id })
      ticket.save
      update_customer
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

  #returns all screenings for films that the customer has a ticket for. Although it also returns screenings that the customer is not attending- if there's more  than 1 screening.
  def return_screenings_for_films_ticket()
    sql = "SELECT screenings.* FROM screenings
  	INNER JOIN films
  	ON films.id = screenings.film_id
  	INNER JOIN tickets
  	ON films.id = tickets.film_id
  	INNER JOIN customers
  	ON customers.id = tickets.customer_id
  	WHERE customers.id = $1;"
    values = [@id]
    screen_hashs = SqlRunner(sql, values)
    screenings = screen_hashs.map { |screening| Screening.new(screening) }
    return screenings
  end

end
