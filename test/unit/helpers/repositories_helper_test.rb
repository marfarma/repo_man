require 'test_helper'

class RepositoriesHelperTest < ActionView::TestCase
  should 'return error messages with custom text and formatting' do
    form = stub()

    form.expects(:error_messages).with(
    :header_message => "Errors!",
    :header_tag     => "h2",
    :message        => "Try again. Repo Man's got all night, every night."
    )

    custom_error_messages(form)
  end
end
