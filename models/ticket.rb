require_relative('../db/sql_runner')

class Ticket

  attr_reader :customer_id, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets
    (film_id,
    customer_id)
    VALUES
    ($1,
    $2)
    RETURNING id;"
    values = [@customer_id, @film_id]
    id_return = SqlRunner.run(sql, values)
    @id = id_return.first['id']
  end




end
