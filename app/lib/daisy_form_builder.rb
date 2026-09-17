class DaisyFormBuilder < ActionView::Helpers::FormBuilder
  INPUT_CLASS    = 'input input-bordered w-full'.freeze
  SELECT_CLASS   = 'select select-bordered w-full'.freeze
  TEXTAREA_CLASS = 'textarea textarea-bordered w-full'.freeze
  FILE_CLASS     = 'file-input file-input-bordered w-full'.freeze
  LABEL_CLASS    = 'block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1'.freeze
  WRAPPER_CLASS  = 'w-full mb-4'.freeze
  SUBMIT_CLASS   = 'btn btn-primary text-white'.freeze

  BUILDER_OPTIONS = %i[label hide_label help wrapper custom switch label_as_placeholder
                       skip_label label_class control_class].freeze

  TEXT_HELPERS = %i[
    text_field email_field password_field number_field telephone_field phone_field
    url_field search_field date_field datetime_field datetime_local_field
    time_field month_field week_field color_field range_field
  ].freeze

  TEXT_HELPERS.each do |helper|
    define_method(helper) do |attribute, options = {}|
      render_field(attribute, options, INPUT_CLASS, 'input-error') { |opts| super(attribute, opts) }
    end
  end

  def text_area(attribute, options = {})
    render_field(attribute, options, TEXTAREA_CLASS, 'textarea-error') { |opts| super(attribute, opts) }
  end

  def file_field(attribute, options = {})
    render_field(attribute, options, FILE_CLASS, 'file-input-error') { |opts| super(attribute, opts) }
  end

  def select(attribute, choices = nil, options = {}, html_options = {}, &block)
    extras = extract_builder_options!(options)
    html_options = html_options.dup
    html_options[:class] = merge_classes(SELECT_CLASS, html_options[:class])
    html_options[:class] = merge_classes(html_options[:class], 'select-error') if errors_on?(attribute)

    field_group(attribute, extras) { super(attribute, choices, options, html_options, &block) }
  end

  def collection_select(attribute, collection, value_method, text_method, options = {}, html_options = {})
    extras = extract_builder_options!(options)
    html_options = html_options.dup
    html_options[:class] = merge_classes(SELECT_CLASS, html_options[:class])

    field_group(attribute, extras) do
      super(attribute, collection, value_method, text_method, options, html_options)
    end
  end

  def date_select(attribute, options = {}, html_options = {})
    extras = extract_builder_options!(options)
    html_options = html_options.dup
    html_options[:class] = merge_classes('select select-bordered', html_options[:class])

    field_group(attribute, extras) do
      @template.content_tag(:div, super(attribute, options, html_options), class: 'flex gap-2')
    end
  end

  def check_box(attribute, options = {}, checked_value = '1', unchecked_value = '0')
    options = options.dup
    extras  = extract_builder_options!(options)
    control_class = extras[:switch] ? 'toggle toggle-primary' : 'checkbox checkbox-primary'
    options[:class] = merge_classes(control_class, options[:class])

    box = super(attribute, options, checked_value, unchecked_value)
    return box if extras[:hide_label] || extras[:skip_label]

    label_text = extras[:label] || attribute.to_s.humanize
    wrapper_class = merge_classes('mb-4', extras.dig(:wrapper, :class))

    @template.content_tag(:div, class: wrapper_class) do
      @template.content_tag(:label, class: 'label cursor-pointer justify-start gap-3 p-0') do
        @template.safe_join([box, @template.content_tag(:span, label_text, class: 'label-text text-sm')])
      end
    end
  end

  def label(attribute, text = nil, options = {}, &block)
    options = { class: LABEL_CLASS }.merge(options)
    super(attribute, text, options, &block)
  end

  def submit(value = nil, options = {})
    options = options.dup
    options[:class] = options[:class].presence || SUBMIT_CLASS
    super(value, options)
  end

  def button(value = nil, options = {}, &block)
    options = options.dup
    options[:class] = options[:class].presence || SUBMIT_CLASS
    super(value, options, &block)
  end

  private

  def render_field(attribute, options, control_class, error_class)
    options = options.dup
    extras  = extract_builder_options!(options)
    options[:class] = merge_classes(control_class, options[:class])
    options[:class] = merge_classes(options[:class], error_class) if errors_on?(attribute)

    field_group(attribute, extras) { yield(options) }
  end

  def field_group(attribute, extras)
    wrapper = extras[:wrapper]
    wrapper = { class: wrapper } if wrapper.is_a?(String)
    wrapper ||= {}

    wrapper_attrs = wrapper.except(:class)
    wrapper_attrs[:class] = merge_classes(WRAPPER_CLASS, wrapper[:class])

    parts = []
    unless extras[:hide_label] || extras[:skip_label]
      parts << label(attribute, extras[:label], class: merge_classes(LABEL_CLASS, extras[:label_class]))
    end
    parts << yield
    parts << @template.content_tag(:p, extras[:help], class: 'text-xs text-slate-500 mt-1') if extras[:help].present?
    parts << error_tag(attribute)

    @template.content_tag(:div, @template.safe_join(parts.compact), **wrapper_attrs)
  end

  def error_tag(attribute)
    return nil unless errors_on?(attribute)

    @template.content_tag(:p, object.errors[attribute].join(', '), class: 'text-error text-xs mt-1')
  end

  def errors_on?(attribute)
    object.respond_to?(:errors) && object.errors[attribute].present?
  end

  def extract_builder_options!(options)
    BUILDER_OPTIONS.index_with { |key| options.delete(key) }.compact
  end

  def merge_classes(*classes)
    classes.flatten.map(&:presence).compact.join(' ').presence
  end
end
