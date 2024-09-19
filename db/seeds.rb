# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

PuzzleType.transaction do
  {
    ast:  "Drawing ASTs for expressions",
    bool: "Booleans and conditionals",
    loop: "While loops and for loops",
    vars: "Variable scope and lifetime",
  }.each do |name, description|
    PuzzleType.find_or_initialize_by(name:).update!(description:)
  end
end
