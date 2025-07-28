module ApplicationHelper
  def render_component_with_sample_data(component)
    html = component.html_content

    # Enhanced sample data for better previews
    sample_data = {
      'title' => 'Your Company Name',
      'subtitle' => 'Professional Services & Solutions',
      'headline' => 'Welcome to Our Amazing Platform',
      'subheadline' => 'We provide exceptional services that help your business grow and succeed in today\'s competitive market.',
      'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.',
      'navigation' => '<a href="#" class="mr-6 hover:text-blue-600">Home</a><a href="#" class="mr-6 hover:text-blue-600">About</a><a href="#" class="mr-6 hover:text-blue-600">Services</a><a href="#" class="mr-6 hover:text-blue-600">Contact</a>',
      'cta_text' => 'Get Started Today',
      'cta_link' => '#',
      'link' => '#',
      'image_url' => 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=600&h=400&fit=crop',
      'content' => 'This is sample content that demonstrates how your text will appear in this component. You can customize this content when building your website.',
      'name' => 'John Smith',
      'email' => 'contact@company.com',
      'phone' => '(555) 123-4567',
      'address' => '123 Business Street, City, State 12345',
      'company' => 'Your Company Name',
      'service_title' => 'Our Services',
      'service_description' => 'We offer comprehensive solutions tailored to your needs.',
      'testimonial' => 'This company provided excellent service and exceeded our expectations.',
      'client_name' => 'Jane Doe',
      'client_company' => 'ABC Corporation',
      'faq_question' => 'What services do you provide?',
      'faq_answer' => 'We provide a full range of professional services including consulting, development, and support.',
      'gallery_image' => 'https://images.unsplash.com/photo-1560472355-536de3962603?w=300&h=300&fit=crop',
      'team_name' => 'Sarah Johnson',
      'team_role' => 'Senior Consultant',
      'team_bio' => 'Sarah has over 10 years of experience in the industry and leads our consulting team.',
      'team_image' => 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=300&h=300&fit=crop'
    }

    component.editable_fields_array.each do |field|
      placeholder = "{{#{field}}}"
      sample_value = sample_data[field] || "Sample #{field.humanize.titleize}"
      html = html.gsub(placeholder, sample_value)
    end

    html
  end

  def render_component_with_user_content(component, website_content)
    html = component.html_content

    component.editable_fields_array.each do |field|
      placeholder = "{{#{field}}}"
      user_value = website_content.get_content_for_field(field)

      # Use user content if available, otherwise use placeholder
      final_value = user_value.present? ? user_value : "Enter your #{field.humanize.downcase}"
      html = html.gsub(placeholder, final_value)
    end

    html
  end

  def get_placeholder_for_field(field)
    case field.downcase
    when 'title', 'headline'
      'Your Company Name'
    when 'subtitle', 'subheadline'
      'Your tagline or subtitle'
    when 'description', 'content'
      'Describe your business or service...'
    when 'email'
      'your.email@example.com'
    when 'phone'
      '(555) 123-4567'
    when 'address'
      'Your business address'
    when 'cta_text'
      'Contact Us'
    when 'cta_link', 'link'
      'https://example.com'
    when 'name'
      'Your Name'
    when 'company'
      'Your Company'
    when /bio|about/
      'Tell us about yourself or your business...'
    when /service/
      'Describe your service offering'
    when /testimonial/
      'What customers say about you'
    when /question/
      'Frequently asked question'
    when /answer/
      'Answer to the question'
    else
      "Enter your #{field.humanize.downcase}"
    end
  end

  def get_help_text_for_field(field)
    case field.downcase
    when 'title', 'headline'
      'This will be the main heading visible to visitors'
    when 'subtitle', 'subheadline'
      'Supporting text that appears below the main heading'
    when 'description', 'content'
      'Main content area - you can use multiple lines'
    when 'email'
      'Contact email address - must be a valid email format'
    when 'phone'
      'Contact phone number - include area code'
    when 'cta_text'
      'Text for buttons or call-to-action links'
    when 'cta_link', 'link'
      'URL where the button or link should go (include https://)'
    when 'address'
      'Your physical business address'
    when /bio|about/
      'Personal or business biography'
    when /service/
      'Description of services you provide'
    when /testimonial/
      'Customer testimonial or review'
    when /image|photo/
      'URL to an image file'
    else
      "Content for the #{field.humanize.downcase} field"
    end
  end

  def get_field_type(field)
    case field.downcase
    when /email/
      'email'
    when /phone/
      'tel'
    when /url|link/
      'url'
    when /description|content|bio|about|testimonial|answer/
      'textarea'
    when /image|photo/
      'url'
    else
      'text'
    end
  end

  def field_requires_validation?(field)
    %w[email phone url link].any? { |type| field.downcase.include?(type) }
  end

  # Helper to generate component edit form fields
  def render_component_field(field, current_value, component_id)
    field_type = get_field_type(field)
    placeholder = get_placeholder_for_field(field)
    help_text = get_help_text_for_field(field)

    case field_type
    when 'textarea'
      text_area_tag "content[#{field}]", current_value,
                    rows: 3,
                    placeholder: placeholder,
                    class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm component-field",
                    data: { field: field, component: component_id }
    when 'email'
      email_field_tag "content[#{field}]", current_value,
                      placeholder: placeholder,
                      class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm component-field",
                      data: { field: field, component: component_id }
    when 'tel'
      telephone_field_tag "content[#{field}]", current_value,
                          placeholder: placeholder,
                          class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm component-field",
                          data: { field: field, component: component_id }
    when 'url'
      url_field_tag "content[#{field}]", current_value,
                    placeholder: placeholder,
                    class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm component-field",
                    data: { field: field, component: component_id }
    else
      text_field_tag "content[#{field}]", current_value,
                     placeholder: placeholder,
                     class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm component-field",
                     data: { field: field, component: component_id }
    end
  end

  # Format component names for display
  def format_component_name(name)
    name.humanize.titlecase
  end

  # Check if component has valid editable fields
  def component_has_editable_fields?(component)
    component.editable_fields_array.any?
  end

  # Generate CSS classes for component state
  def component_css_classes(component, is_editing = false)
    classes = %w[border border-gray-200 rounded-lg component-card]
    classes << 'border-blue-300 bg-blue-50' if is_editing
    classes.join(' ')
  end
end