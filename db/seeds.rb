# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

PuzzleType.transaction do
  {
    ast:   [0, "Drawing ASTs for expressions"],
    bool:  [1, "Booleans and conditionals"],
    loop:  [2, "While loops and for loops"],
    class: [3, "Class declarations and object modeling"],
    stack: [4, "Stack frames and objects"],
    vars:  [5, "Variable scope and lifetime"],
    rel:   [6, "Class relationships"],
    type:  [7, "Static and runtime types"],
    clos:  [8, "Closures and event handling"],
  }.each do |name, (display_order, description)|
    PuzzleType.find_or_initialize_by(name:).update!(description:, display_order:)
  end
end
