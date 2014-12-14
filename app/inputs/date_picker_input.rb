class DatePickerInput < Formtastic::Inputs::StringInput
  def input_html_options
    super.merge(class: 'ui-datepicker')
  end
end
