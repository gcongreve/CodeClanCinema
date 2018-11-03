require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

require('pry-byebug')


Ticket.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new({'name' => 'Customer One', 'funds' => 50})
customer1.save
# customer2 = Customer.new({'name' => 'Customer Two', 'funds' => 60})
# customer2.save


# customer1.name = 'Updated Customer'
# customer1.update

film1 = Film.new({'title' => 'Jaws', 'price' => 10})
film1.save
# film2 = Film.new({'title' => 'Jaws 2', 'price' => 11})
# film2.save
# film2.title = 'Jaws 3'
# film2.update

# p customer1.number_of_tickets
# customer1.buy_ticket(film1)
# p customer1.number_of_tickets


# ticket1 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer1.id})
# ticket1.save
# ticket2 = Ticket.new({'film_id' => film1.id, 'customer_id' => customer2.id})
# ticket2.save

screening1 = Screening.new({'film_id' => film1.id, 'start_time' => '10.00', 'tickets_left' => 2 })
screening1.save
screening2 = Screening.new({'film_id' => film1.id, 'start_time' => '12.00', 'tickets_left' => 2 })
screening2.save


customer1.buy_screening_ticket(screening1)

#p film1.which_customers
# p customer1.which_films
#
# p customer1.funds
# customer1.pay_for_film(film1)
# p customer1.funds
binding.pry
nil
