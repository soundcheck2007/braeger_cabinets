class StaticPagesController < ApplicationController
  def home
  end

  def cabinets
    if request.method == "POST"
        Rails.logger.info "\n\n\n\n Params: #{params} \n\n\n\n\n"
    end
    return
  end

  def drawer_fronts
  end

  def dovetail_drawers
  end

end
