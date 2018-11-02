require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

customer1 = Customer.new({'name' => 'Customer One', 'funds' => 50})
customer1.save

film1 = Film.new({'title' => 'Jaws', 'price' => 10})
film1.save

ticket1 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id})
ticket1.save



binding.pry
nil
