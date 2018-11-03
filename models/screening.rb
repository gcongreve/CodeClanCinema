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

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def any_tickets_left?()
    @tickets_left != 0
  end

  def remove_ticket()
    @tickets_left -= 1
  end


end
