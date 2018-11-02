require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')


Ticket.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new({'name' => 'Customer One', 'funds' => 50})
customer1.save
customer2 = Customer.new({'name' => 'Customer Two', 'funds' => 60})
customer2.save
# customer1.name = 'Updated Customer'
# customer1.update

film1 = Film.new({'title' => 'Jaws', 'price' => 10})
film1.save
film2 = Film.new({'title' => 'Jaws 2', 'price' => 11})
film2.save
# film2.title = 'Jaws 3'
# film2.update


ticket1 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id})
ticket1.save
ticket2 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer2.id})
ticket2.save

p film1.which_customers_have_tickets

# binding.pry
# nil
