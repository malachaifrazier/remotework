module JobsHelper
  def when_posted(job)
    content_tag(:span, data: {toggle: 'tooltip', title: job.posted_at.to_s(:short)}) do
      "#{time_ago_in_words(job.posted_at)} ago"
    end.html_safe
  end
end
