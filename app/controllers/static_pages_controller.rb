class StaticPagesController < ApplicationController
  def home
  end

  def doors
    if request.method == "POST"
      create_job_info(params)
      respond_to do |format|
        if @new_job.save
          format.html {}
          format.js {}
          format.json { render :json => @new_job }
        end
      end
    end
    if !params[:open_job].nil?
      @job_header = JobHeader.find(params[:open_job])
      @job_details = JobDetail.find(:all, :conditions => { :job_id => @job_header.id })
    end
    return
  end

  def drawer_fronts
    if request.method == "POST"
      create_job_info(params)
      respond_to do |format|
        if @new_job.save
          format.html {}
          format.js {}
          format.json { render :json => @new_job }
        end
      end
    end
    if !params[:open_job].nil?
      @job_header = JobHeader.find(params[:open_job])
      @job_details = JobDetail.find(:all, :conditions => { :job_id => @job_header.id })
    end
    return
  end

  def dovetail_drawers
    if request.method == "POST"
      create_job_info(params)
      respond_to do |format|
        if @new_job.save
          format.html {}
          format.js {}
          format.json { render :json => @new_job }
        end
      end
    end
    if !params[:open_job].nil?
      @job_header = JobHeader.find(params[:open_job])
      @job_details = JobDetail.find(:all, :conditions => { :job_id => @job_header.id })
    end
    return
  end

  def search
    if request.method == "GET" && !params[:jobs].nil?
      date_from = params[:date_from]
      date_to = params[:date_to]
      job_name = params[:jobs]
      if date_from.empty? && date_to.empty?
        if job_name == "All"
          @jobs = JobHeader.find(:all, :order => "job ASC" )
        else
          @jobs = JobHeader.where( "job = ?", job_name )
        end
      elsif date_from.empty? && !date_to.empty?
        date_to = Date.strptime(date_to, "%m/%d/%Y")
        if job_name == "All"
          @jobs = JobHeader.where( "date_due <= ?", date_to )
        else
          @jobs = JobHeader.where( "job = ? AND date_due <= ?", params[:jobs], date_to )
        end
      elsif !date_from.empty? && date_to.empty?
        date_from = Date.strptime(date_from, "%m/%d/%Y")
        if job_name == "All"
          @jobs = JobHeader.where( "date_due >= ?", date_from )
        else
          @jobs = JobHeader.where( "job = ? AND date_due >= ?", params[:jobs], date_from )
        end
      else
        date_from = Date.strptime(date_from, "%m/%d/%Y")
        date_to = Date.strptime(date_to, "%m/%d/%Y")
        if job_name == "All"
          @jobs = JobHeader.where( "date_due >= ? AND date_due <= ?", date_from, date_to )
        else
          @jobs = JobHeader.where( "job = ? AND date_due >= ? AND date_due <= ?", params[:jobs], date_from, date_to )
        end
      end
      @jobs.each do |j|
        j[:project_type] = j[:project].titleize
        if j.bottom_notes == "1"
          j[:pretty_bottom_notes] = "Recess Bottom 1/2, Removeable"
        elsif j.bottom_notes == "2"
          j[:pretty_bottom_notes] = "Recess Bottom 1/2, Stationary"
        elsif j.bottom_notes == "3"
          j[:pretty_bottom_notes] = "Recess Bottom 1/4, Removeable"
        elsif j.bottom_notes == "4"
          j[:pretty_bottom_notes] = "Recess Bottom 1/4, Stationary"
        else
          j[:pretty_bottom_notes] = ""
        end
      end
      respond_to do |format|
        format.html {}
        format.js {}
        format.json { render :json => @jobs }
      end
    else
      @jobs_list = JobHeader.all(:select => :job, :order => 'job ASC').collect { |j| j.job }
      @jobs_list = @jobs_list.uniq
    end
    return
  end


  def create_job_info(params) 
    job_header = params
    job = job_header[:job]
    wood_type = job_header[:wood_type]
    inside_edge = job_header[:inside_edge]
    outside_edge = job_header[:outside_edge]
    panel_profile = job_header[:panel_profile]
    if job_header[:date_due].nil?
      date_due = ""
    else
      date_due = job_header[:date_due].empty? ? "" : Date.strptime(job_header[:date_due], "%m/%d/%Y")
    end
    drawer_type = job_header[:drawer_type]
    bottom_type = job_header[:bottom_type]
    bottom_notes = job_header[:bottom_selector]
    project = job_header[:project]
    totals = job_header[:txt_totals]
    #get total of rows then subtract 1 so that we can start from 0
    row_tally = job_header[:row_tally].to_i - 1

    if params[:created_job].to_i > 0
      @new_job = JobHeader.find(params[:created_job].to_i)
      @new_job.update_attributes(:project => project, :job => job, :wood_type => wood_type, :inside_edge => inside_edge, :outside_edge => outside_edge, :panel_profile => panel_profile, :date_due => date_due, :drawer_type => drawer_type, :bottom_type => bottom_type, :bottom_notes => bottom_notes, :totals => totals)
      JobDetail.destroy_all(:job_id => params[:created_job].to_i)
    else
      @new_job = JobHeader.create(:job => job) do |j|
        j.project = project
        j.wood_type = wood_type
        j.inside_edge = inside_edge
        j.outside_edge = outside_edge
        j.panel_profile = panel_profile
        j.date_due = date_due
        j.drawer_type = drawer_type
        j.bottom_type = bottom_type
        j.bottom_notes = bottom_notes
        j.totals = totals
      end
    end
    @new_job.save

    job_details = job_header.except(:project, :job, :wood_type, :inside_edge, :outside_edge, :panel_profile, :date_due, :drawer_type, :bottom_type, :bottom_selector, :row_tally, :txt_totals)
    
    (0..row_tally).each do |x|
      i = x.to_s
      nbr = ("nbr_name_" + i).to_sym
      qty = ("qty_name_" + i).to_sym
      size = ("size_name_" + i).to_sym
      style = ("style_select_name_" + i).to_sym
      border = ("border_info_name_" + i).to_sym
      center = ("center_info_name_" + i).to_sym
      note = ("notes_name_" + i).to_sym
      door_no = job_details[nbr]
      door_qty = job_details[qty]
      door_size = job_details[size]
      door_style = job_details[style]
      style_rail = job_details[border]
      panel_info = job_details[center]
      notes = job_details[note]
      #skip blank or invalid lines
      job_details = job_details.except(nbr, qty, size, style, border, center, note)
      if (door_qty.empty? || door_size.empty?)
        next
      end

      @new_detail = JobDetail.create(:job_id => @new_job.id) do |d|
        d.door_no = door_no
        d.door_qty = door_qty
        d.door_size = door_size
        d.door_style = door_style
        d.style_rail_info = style_rail
        d.panel_info = panel_info
        d.notes = notes
      end
    end  
  end

end
