class Admin::JobsController < Admin::BaseController
  def index
    @jobs = Job.all.order('posted_at DESC').page(params[:page] || 1).per(50)
  end

  def edit
    @job = Job.friendly.find(params[:id])
    @job.reviewed!
  end

  def update
    @job = Job.friendly.find(params[:id])
    if @job && @job.update_attributes(job_params)
      redirect_to admin_jobs_path, notice: "Job updated"
    else
      flash[:error] = "Unable to update job post: #{@job.errors.full_messages.to_sentence}"
      render :edit      
    end
  end

  def destroy
    @job = Job.friendly.find(params[:id])
    @job.expire!
    redirect_to admin_jobs_path, notice: "Job expired"
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :category, :how_to_apply, :company, :location, :company_url, :company_description, :tags => [])
  end
end
