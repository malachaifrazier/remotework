module ApplicationHelper
  # Could we have done this w/ polymorphic URLs?
  def add_tag_url(tags, new_tag)
    tags ||= []
    tags += [new_tag]
    tag_url(tags)
  end

  # Could we have done this w/ polymorphic URLs?
  def remove_tag_url(tags, remove_tag)
    tags ||= []
    tags -= [remove_tag]
    tag_url(tags)
  end

  # Could we have done this w/ polymorphic URLs?
  def tag_url(tags)
    if tags.present?
      return tag_path(tags.join('+'))
    else
      return root_path
    end
  end

  def alert_enroll_path(opts={})
    url = ['/alerts']
    if opts[:tags].present?
      url << 'tags'
      url << opts[:tags].join('+')
    end
    url << opts[:action] if opts[:action].present?
    url.join('/')
  end
end
