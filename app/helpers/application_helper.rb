module ApplicationHelper
  def describe_attempt_score(score)
    case score
      when nil                      then "No points yet"
      when AttemptScore.no_credit   then "No points yet"
      when AttemptScore.half_credit then "Half credit"
      when AttemptScore.full_credit then "Full credit"
      else score
    end
  end

  def describe_attempt_state(attempt_state)
    case attempt_state
      when nil                    then ""
      when AttemptState.queued    then "Generating…"
      when AttemptState.available then "Awaiting your solution"
      when AttemptState.submitted then "Submitted for grading"
      when AttemptState.graded    then "Graded"
      else attempt_state
    end
  end

  def filter_link(param, value)
    css_classes = ['choice']
    css_classes << 'active' if params[param] == value.to_s
    link_to value, { param => value }, "data-turbo-prefetch" => false, class: css_classes
  end

  def labeled_radio_button(form, param, value, label)
    [
      form.radio_button(param, value),
      form.label(:"#{param}_#{value}", label),
    ].join.html_safe
  end
end
