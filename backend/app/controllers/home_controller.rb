# frozen_string_literal: true

class HomeController < ApplicationController
  include ParamsSearch

  add_breadcrumb 'Home', :root_path

  def index
    @incidents = can?(:read, Incident) ? Incident.visible_to(current_user) : Incident.none
  end

  private

  def params_return
    if !set_polo.empty?
      { courses: set_polo }
    else
      set_polo
    end
  end
end
