class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  
  store_in collection: "results"

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  scope :upcoming, ->{ where(:"race.date".gte => Date.current) }
  scope :past, ->{ where(:"race.date".lt => Date.current) }

  embeds_many :results, class_name: "LegResult", order: [:"event.o".asc], after_add: :update_total
  embeds_one :race, class_name: "RaceRef", autobuild: true
  #embeds_one :racer, class_name: "RacerInfo", as: :parent, autobuild: true

  def update_total(result)
    self.secs = results.reduce(0) do |total, result|
        total + result.secs.to_i
    end
  end

	def the_race
    self.race.race
  end

end
