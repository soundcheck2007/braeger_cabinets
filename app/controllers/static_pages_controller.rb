class StaticPagesController < ApplicationController
  def home
  end

  def cabinets
    if request.method == "POST"
      create_job_info(params)
      respond_to do |format|
        if @new_job.save && @new_detail.save
          format.html {}
          format.js {}
          format.json { render :json => @new_job }
        end
      end
    end
    return
  end

  def drawer_fronts
    if request.method == "POST"
      create_job_info(params)
      respond_to do |format|
        if @new_job.save && @new_detail.save
          format.html {}
          format.js {}
          format.json { render :nothing => true }
        end
      end
    end
    return
  end

  def dovetail_drawers
    if request.method == "POST"
      create_job_info(params)
      respond_to do |format|
        if @new_job.save && @new_detail.save
          format.html {}
          format.js {}
          format.json { render :nothing => true }
        end
      end
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
    date_due = job_header[:date_due]
    drawer_type = job_header[:drawer_type]
    bottom_type = job_header[:bottom_type]
    bottom_notes = job_header[:bottom_notes]
    totals = job_header[:txt_totals]
    #get total of rows then subtract 1 so that we can start from 0
    row_tally = job_header[:row_tally].to_i - 1

    if params[:created_job].to_i > 0
      @new_job = JobHeader.find(params[:created_job].to_i)
      @new_job.update_attributes(:job => job, :wood_type => wood_type, :inside_edge => inside_edge, :outside_edge => outside_edge, :panel_profile => panel_profile, :date_due => date_due, :drawer_type => drawer_type, :bottom_type => bottom_type, :bottom_notes => bottom_notes, :totals => totals)
      JobDetail.destroy_all(:job_id => params[:created_job].to_i)
    else
      @new_job = JobHeader.create(:job => job) do |j|
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

    job_details = job_header.except(:job, :wood_type, :inside_edge, :outside_edge, :panel_profile, :date_due, :drawer_type, :bottom_type, :bottom_notes, :row_tally, :txt_totals)
    
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
