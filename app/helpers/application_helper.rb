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
end
