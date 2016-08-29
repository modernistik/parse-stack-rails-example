
class Artist < Parse::Object
  # See: https://github.com/modernistik/parse-stack#defining-properties

  property :name, :string
  has_many :fans, through: :relation, as: :user
end
