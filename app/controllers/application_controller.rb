# Author:: Sambhav Sharma
class ApplicationController < ActionController::Base
  include ExceptionHelper

  protect_from_forgery with: :exception
end
