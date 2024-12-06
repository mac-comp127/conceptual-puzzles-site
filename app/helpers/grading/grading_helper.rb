module Grading::GradingHelper
  def field_row(form, type, field, label, *args)
    render 'field', form:, type:, field:, label:, args:
  end
end
