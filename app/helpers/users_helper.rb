module UsersHelper
  def job_list_action(user,job)
    if !user.email_validated?
      "Awaiting Email Address Validation"
    else
      if job.posted?
        (link_to "#{fa_icon 'pause'} Pause".html_safe, pause_job_path(job), method: :patch, class: 'btn btn-xs btn-default') + ' ' +
        (link_to "#{fa_icon 'pencil-square-o'} Edit Post".html_safe, edit_job_path(job), class: 'btn btn-xs btn-default')
      else
        (link_to "#{fa_icon 'play'} Post Now".html_safe, post_job_path(job), method: :post, class: 'btn btn-xs btn-default') + ' ' +
        (link_to "#{fa_icon 'trash'} Delete".html_safe, job_path(job), method: :delete, class: 'btn btn-xs btn-danger', data: { confirm: "Are you sure you want to delete #{job.title}?" })
      end
    end
  end

  def dashboard_message(user)
    if !user.email_validated?
      if user.jobs.pending.present?
        "You still need to validate your email address before your jobs can be posted on the site. #{link_to 'Resend verification now.', validations_path, method: :post}".html_safe
      else
        "You still need to validate your email address. #{link_to 'Resend verification now.', validations_path, method: :post}".html_safe
      end
    else
      if user.jobs.paused.present?
        "You have job posts which are paused. Click <b>Post Now</b> below to make them appear on the site.".html_safe
      else
        nil
      end
    end
  end
end
