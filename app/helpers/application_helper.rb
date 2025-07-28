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
      'Contact email address'
    when 'phone'
      'Contact phone number'
    when 'cta_text'
      'Text for buttons or call-to-action links'
    when 'cta_link', 'link'
      'URL where the button or link should go'
    else
      "Content for the #{field.humanize.downcase} field"
    end
  end
end