class StatePensionDate < Struct.new(:gender, :start_date, :end_date, :pension_date)
  def match?(dob, sex)
    same_gender?(sex) and born_in_range?(dob)
  end

  def same_gender?(sex)
    gender == sex or :both == gender
  end

  def born_in_range?(dob)
    dob >= start_date and dob <= end_date
  end
end

class StatePensionQuery < Struct.new(:dob, :gender)
  def self.find(dob, gender)
    state_pension_query = new(dob, gender)
    result = state_pension_query.run
    result.pension_date
  end

  def run
    state_pension_dates.find{|p| p.match?(dob, gender)}
  end

  def state_pension_dates
    pension_dates_static + pension_dates_dynamic
  end

  def pension_dates_dynamic
    [
      StatePensionDate.new(:female, Date.new(1890,01,01), Date.new(1950, 04, 05), 60.years.since(dob)),
      StatePensionDate.new(:male, Date.new(1890,01,01), Date.new(1953, 10, 05), 65.years.since(dob)),
      StatePensionDate.new(:both, Date.new(1954,10,06), Date.new(1968, 04, 05), 66.years.since(dob)),
      StatePensionDate.new(:both, Date.new(1969,04,06), Date.new(1977, 04, 05), 67.years.since(dob)),
      StatePensionDate.new(:both, Date.new(1978,04,06), Date.today, 68.years.since(dob))
    ]
  end

  def pension_dates_static
    YAML.load(File.open("lib/data/state_pension_dates.yml").read)
  end
end