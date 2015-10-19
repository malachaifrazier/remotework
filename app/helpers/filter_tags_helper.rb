module FilterTagsHelper
  def tag_autocomplete_options(tags)
    tags ||= []
    (TagBuilder.tag_list - tags).map { |name| {tag: name} }.to_json
  end
end
