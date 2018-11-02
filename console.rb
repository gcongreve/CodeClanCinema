require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

require('pry-byebug')

customer1 = Customer.new({'name' => 'Customer One', 'funds' => 50})
customer1.save






binding.pry
nil
