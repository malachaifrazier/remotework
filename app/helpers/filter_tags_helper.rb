module FilterTagsHelper
  def tag_autocomplete_options(tags)
    tags ||= []
    (TagBuilder.tag_list - tags).map { |name| {tag: name} }.to_json
  end

  def render_tag(tag, tags, q)
    content_tag(:span, class: "label label-tag label-#{TagBuilder.tag_type(tag.to_s)}-tag") do
      link_to(tag.to_s, add_tag_url(tags, tag.to_s, q))
    end
  end
end
