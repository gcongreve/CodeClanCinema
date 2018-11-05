require_relative('../db/sql_runner')

class Ticket

  attr_reader :id, :customer_id, :film_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def self.return_all()
    sql = "SELECT * FROM tickets"
    tickets_hashes = SqlRunner.run(sql)
    tickets = tickets_hashes.map { |ticket| Ticket.new(ticket)}
    return tickets
  end

  def save()
    sql = "INSERT INTO tickets
    (film_id,
    customer_id,
    screening_id)
    VALUES
    ($1,
    $2,
    $3)
    RETURNING id;"
    values = [@film_id, @customer_id, @screening_id]
    id_return = SqlRunner.run(sql, values)
    @id = id_return.first['id']
  end

  def update_ticket()
    sql = "UPDATE tickets
     SET (customer_id, film_id, screening_id) = ($1, $2, $3)
     WHERE id = $4;"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
