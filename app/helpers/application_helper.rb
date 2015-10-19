module ApplicationHelper
  # Could we have done this w/ polymorphic URLs?
  def add_tag_url(category, tags, new_tag)
    tags ||= []
    tags += [new_tag]
    category_tag_url(category, tags)
  end

  # Could we have done this w/ polymorphic URLs?
  def remove_tag_url(category, tags, remove_tag)
    tags ||= []
    tags -= [remove_tag]
    category_tag_url(category, tags)
  end

  # Could we have done this w/ polymorphic URLs?
  def category_tag_url(category, tags)
    if category.present?
      if tags.present?
        return category_tag_path(category, tags.join('+'))
      else
        return category_path(category)
      end
    else
      if tags.present?
        return tag_path(tags.join('+'))
      else
        return root_path
      end
    end
  end

  def alert_enroll_path(opts={})
    url = ['/alerts']
    if opts[:category].present?
      url << 'category'
      url << opts[:category]
    end
    if opts[:tags].present?
      url << 'tags'
      url << opts[:tags].join('+')
    end
    url << opts[:action] if opts[:action].present?
    url.join('/')
  end
end
