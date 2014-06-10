class MasterController < ApplicationController

  layout 'master'

  before_action :authenticate_user!

end
