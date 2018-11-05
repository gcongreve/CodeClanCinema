require_relative('../db/sql_runner')

class Screening

  attr_accessor :film_id, :start_time, :tickets_left
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @start_time = options['start_time']
    @tickets_left = options['tickets_left'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def self.return_all()
    sql = "SELECT * FROM screenings"
    screenings_hashes = SqlRunner.run(sql)
    screenings = screenings_hashes.map { |screening| Screening.new(screening)}
    return screenings
  end

  #returns all screenings a film. -Class version- also have instance version
  def self.return_films_screenings(film)
    sql = "SELECT * FROM screenings
      WHERE film_id = $1"
    values = [film.id]
    screenings_hashes = SqlRunner.run(sql, values)
    screenings = screenings_hashes.map { |screen| Screening.new(screen) }
    return screenings
  end

  #most popular screening of a film - Class version, also have instance version.
  def self.most_popular_screening_of_a_film(film)
    most_popular = nil
    unsold_tickets = 2 #max capacity of the cinema
    screenings = return_films_screenings(film)
    screenings.each do |screening|
      if screening.tickets_left.to_i < unsold_tickets
        most_popular = screening
      end
    end
    return most_popular
  end

  def self.return_all() #returns all screenings from database
    sql = "SELECT * FROM screenings"
    screenings_hashes = SqlRunner.run(sql)
    screenings = screenings_hashes.map { |screening| Screening.new(screening)}
    return screenings
  end

  #returns the most popular screening at the cinema.
  def self.most_popular_screening
    most_popular = nil
    unsold_tickets = 2 #max capacity of the cinema
    return_all.each do |screening|
      if screening.tickets_left.to_i < unsold_tickets
        most_popular = screening
      end
    end
    return most_popular
  end

  def save()
    sql = "INSERT INTO screenings
    (film_id,
    start_time,
    tickets_left)
    VALUES
    ($1,
    $2,
    $3)
    RETURNING id;"
    values = [@film_id, @start_time, @tickets_left]
    id_return = SqlRunner.run(sql, values)
    @id = id_return.first['id']
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update_screening()
    sql = "UPDATE screenings
     SET (film_id, start_time, tickets_left) = ($1, $2, $3)
     WHERE id = $4;"
    values = [@film_id, @start_time, @tickets_left, @id]
    SqlRunner.run(sql, values)
  end

  def any_tickets_left?()
    @tickets_left != 0
  end

  def remove_ticket()
    @tickets_left -= 1
  end

  def price()  #returns the price of the film showing at the screening
    sql = "SELECT films.price FROM films
  	INNER JOIN screenings
  	ON films.id = film_id
  	WHERE screenings.id = $1;"
    values = [@id]
    price = SqlRunner.run(sql, values).first['price'].to_i
    return price
  end

  #shows all customers who have got tickets for whatever film is showing at the screening. Could be for any screening of the film though.
  def customers_for_film_from_screening()
    sql = ("SELECT customers.* FROM customers
  	INNER JOIN tickets
  	ON customers.id = customer_id
  	INNER JOIN films
  	ON films.id = film_id
  	INNER JOIN screenings
  	ON screenings.film_id = films.id
  	WHERE screenings.id = $1;
  	")
    values = [@id]
    customers_hashes = SqlRunner.run(sql, values)
    customers = customers_hashes.map{ |customer| Customer.new(customer)}
    return customers
  end

  def return_film_screenings #returns all screenings of a film from instance
    sql = "SELECT * FROM screenings
      WHERE film_id = $1"
    values = [@film_id]
    screenings_hashes = SqlRunner.run(sql, values)
    screenings = screenings_hashes.map { |screen| Screening.new(screen) }
    return screenings
  end

  #most popular screening of a film - instance version.
  def most_popular_screening_film
    most_popular = nil
    unsold_tickets = 2 #max capacity of the cinema
    screenings = return_film_screenings
    screenings.each do |screening|
      if screening.tickets_left.to_i < unsold_tickets
        most_popular = screening
      end
    end
    return most_popular
  end

end
