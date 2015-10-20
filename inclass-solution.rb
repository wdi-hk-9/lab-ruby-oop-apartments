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
    # push the tenant object into @tenants if credit rating is not bad and there is enough bedrooms
    if (tenant.credit_rating != "bad" && (@tenants.size + 1) < @num_bedrooms)
      @tenants.push tenant
    else
      raise "Tenant #{tenant.name} has a BAD Credit Score or not enough rooms"
    end
  end

  # tenant can be a Tenant Object or a string
  def remove_tenant(tenant)
    puts "#{@tenants[0].name}"

    # method 1
    # if tenant is a Tenant Object Class, use the .name method to get the name
    # else tenant is a String Class, simply make name equal to the string (equal to tenant variable)
    name_to_match = tenant.class == Tenant ? tenant.name : tenant
    # check if any tenant inside the @tenants array have a name equal to name_to_match
    # if match is found, delete that tenant from the @tenants array
    # else raise an error saying no tenant found
    if not @tenants.delete_if {|t| t.name == name_to_match}
      raise "tenant not found"
    end

    # This is the same as the following code

    # @tenants.each do |t|
    #   if t.name == name_to_match
    #     @tenants.delete(t)
    #     return true
    #   else
    #     raise "tenant not found"
    #     return false
    #   end
    # end

    # method 2
    # try to delete tenant as an object
    # unless @tenants.delete(tenant)
    #   # if that doesn't work, try to delete tenant as a string
    #   if @tenants.index {|t| t.name == tenant}
    #     @tenants.delete_if {|t| t.name == tenant}
    #   else
    #     raise "tenant not found"
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
    master_tenant_list = []
    @apartments.each do |apt|
      apt.tenants.each do |tenant|
        master_tenant_list.push tenant
      end
    end
    master_tenant_list
  end

  def apartments_by_credit_score
    apartment_rating_distribution = {bad: [], mediocre: [], good: [], great: [], excellent: []}

    @apartments.each do |apt|
      case apt.average_credit_score
        when 0..559
          rating = "bad"
        when 560..659
          rating = "mediocre"
        when 660..724
          rating = "good"
        when 725..759
          rating = "great"
        else
          rating = "excellent"
      end
      apartment_rating_distribution[rating.to_sym].push apt
    end
  end
end

tenant1 = Tenant.new('fer', 35, 730)
tenant2 = Tenant.new('denis', 25, 770)
tenant3 = Tenant.new('michael', 65, 470)

apt1 = Apartment.new(108, 1500, 2000, 5, 1)
apt1.add_tenant(tenant1)
apt1.add_tenant(tenant2)
# apt1.add_tenant(tenant3) # there should be an error because this guy have have bad credit rating
apt1.remove_tenant(tenant1)

blg1 = Building.new("33 Des Voeux")
blg1.add_apartment(apt1)
