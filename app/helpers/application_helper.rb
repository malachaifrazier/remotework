module ApplicationHelper
  #
  # Tag URL helpers. The URLs with tags have plus signs in them instead 
  # of %20's to make them prettier and maybe (?) help s/ SEO? Mostly to
  # make them pretty.
  #
  def add_tag_url(tags, new_tag, q)
    tags ||= []
    tags += [new_tag]
    tag_url(tags.uniq,q)
  end

  def remove_tag_url(tags, remove_tag, q)
    tags ||= []
    tags -= [remove_tag]
    tag_url(tags,q)
  end

  def tag_url(tags, q)
    if tags.present?
      return tag_path(tags.join('+'), q: q)
    else
      return root_path
    end
  end

  def remove_search_query_url(referrer)
    path = Rails.application.routes.recognize_path(referrer)
    path.delete(:q)
    url_for(path)
  end

  def alert_enroll_path(opts={})
    url = ['/alerts']
    if opts[:tags].present?
      url << 'tags'
      url << opts[:tags].join('+')
    end
    url << opts[:action] if opts[:action].present?
    result = url.join('/')
    result << '?q=' + opts[:q] if opts[:q].present?
    result
  end

  def welcome_message
    ['Howdy!', 'Hello there!', 'Greetings!', 'Welcome!', "Hey there, what's up?", 'Good to see you!'].sample
  end
end
