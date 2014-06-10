# https://gist.github.com/tokenvolt/6599141

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error',
      defaults: { input_html: { class: 'default_class' } } do |b|

    b.use :html5
    b.use :placeholder
    b.use :label, wrap_with: {tag: 'div', class: 'col-sm-2'}
    b.wrapper tag: 'div', class: 'col-sm-3' do |ba|
      ba.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block text-info' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end

  config.wrappers :nested, tag: 'div', class: 'form-group', error_class: 'has-error',
      defaults: { input_html: { class: 'default_class' } } do |b|

    b.use :html5
    b.use :placeholder
    b.use :label, wrap_with: {tag: 'div', class: 'col-sm-2'}
    b.wrapper tag: 'div', class: 'col-lg-10' do |ba|
      ba.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block text-info' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end

  config.wrappers :modal, tag: 'div', class: 'form-group', error_class: 'has-error',
      defaults: { input_html: { class: 'default_class' } } do |b|

    b.use :html5
    b.use :placeholder
    b.use :label, wrap_with: {tag: 'div', class: 'col-lg-3'}
    b.wrapper tag: 'div', class: 'col-lg-7' do |ba|
      ba.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block text-info' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end

  config.wrappers :inline, tag: 'span', class: 'inline', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label

    b.wrapper tag: 'span', class: 'inline' do |ba|
      ba.use :input
      ba.use :hint,  wrap_with: { tag: 'span', class: "help-block" }
      ba.use :error, wrap_with: { tag: 'span', class: "help-inline has-error" }
    end
  end

  config.wrappers :prepend, tag: 'div', class: "form-group", error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, wrap_with: {tag: 'div', class: 'col-sm-2'}
    b.wrapper tag: 'div', class: 'col-sm-4' do |input|
      input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block text-info' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :append, tag: 'div', class: "form-group", error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, wrap_with: {tag: 'div', class: 'col-sm-2'}
    b.wrapper tag: 'div', class: 'col-sm-4' do |input|
      input.wrapper tag: 'div', class: 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block text-info' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
