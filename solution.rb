class Building
  attr_accessor :address
  attr_reader :apartments
  def initialize(address)
    @address = address
    @apartments = []
  end

  def add_apartment(apartment)
    @apartments.push apartment
  end

  def remove_apartment(apartment_number)
    index = @apartments.index {|apt| apt.number == apartment_number}
    if index
      @apartments.delete_at(index)
    else
      raise "apartment not found"
    end
  end

  def total_square_footage
    @apartments.inject { |sqr_total, apt|
      sqr_total + apt.sqr_feet
    }
  end

  def total_monthly_revenue
    @apartments.inject { |revenue, apt|
      revenue + apt.rent
    }
  end

  def tenants
    tenants = []
    @apartments.each do |apt|
      apt.each do |tenant|
        tenants.push tenant
      end
    end
    tenants
  end

  def apartments_by_credit_score
    apartment = { bad: [], mediocre: [], good: [], great: [], excellent: [] }

    @apartments.each do |apt|
      apartment[apt.average_credit_score.to_sym].push apt
    end
  end
end

class Apartment
  attr_accessor :number, :rent, :sqr_feet, :num_bedrooms, :num_bathrooms
  attr_reader :tenants

  def initialize(number, rent, sqr_feet, num_bedrooms, num_bathrooms)
    @number = number
    @rent = rent
    @sqr_feet = sqr_feet
    @num_bedrooms = num_bedrooms
    @num_bathrooms = num_bathrooms
    @tenants = []
  end

  def add_tenant(tenant)
    if (tenant.credit_rating != "bad")
      @tenants.push tenant
    else
      raise "Tenant #{tenant.name} has a BAD Credit Score"
    end
  end

  def remove_tenant(tenant)
    name = tenant.class == Tenant ? tenant.name : tenant
    if not @tenants.delete_if {|t| t.name == name}
      raise "apartment not found"
    end

    # unless @tenants.delete(tenant)
    #   if @tenants.index {|t| t.name == tenant}
    #     @tenants.delete_if {|t| t.name == tenant}
    #   else
    #     raise "apartment not found"
    #   end
    # end
  end

  def remove_all_tenants
    @tenants.delete_if { true }
  end

  def average_credit_score
    @tenants.inject{ |sum, t| sum + t.credit_score }.to_f / @tenants.size
  end
end

class Tenant
  attr_accessor :name, :age, :credit_score

  def initialize(name, age, credit_score)
    @name = name
    @age = age
    @credit_score = credit_score
  end

  def credit_rating
    case @credit_score
      when 0..559
        "bad"
      when 560..659
        "mediocre"
      when 660..724
        "good"
      when 725..759
        "great"
      else
        "excellent"
    end
  end
end
# name, age, credit_score
tenant1 = Tenant.new('fer', 35, 730)
# puts tenant1.credit_rating

tenant2 = Tenant.new('denis', 25, 770)
# puts tenant2.credit_rating

tenant3 = Tenant.new('michael', 65, 470)
# puts tenant3.credit_rating

# number, rent, sqr_feet, num_bedrooms, num_bathrooms
apt1 = Apartment.new(108, 1500, 2000, 2, 1)
apt2 = Apartment.new(100, 1200, 1800, 1, 1)

apt1.add_tenant(tenant1)
apt1.add_tenant(tenant2)

apt1.remove_tenant(tenant1)
apt1.remove_tenant('denis')

blg1 = Building.new("33 Des Voeux")
blg1.add_apartment(apt1)

