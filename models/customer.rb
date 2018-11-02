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





end
