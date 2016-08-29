
class Song < Parse::Object
  # See: https://github.com/modernistik/parse-stack#defining-properties

  property :name, :string
  property :released, :integer
  property :genres, :array
  belongs_to :artist

end
