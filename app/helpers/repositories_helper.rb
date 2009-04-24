# Methods added to this helper will be available to all templates in the application.
module RepositoriesHelper
  def custom_error_messages(form)
    form.error_messages(
    :header_message => "Errors!",
    :header_tag     => "h2",
    :message        => "Try again. Repo Man's got all night, every night."
    )
  end
end
