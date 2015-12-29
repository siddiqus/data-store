require 'fileutils'

class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  before_action :allow_iframe

  def allow_iframe
    response.headers.delete('X-Frame-Options')
  end

  def user_profile
    @user = User.find(params[:id])
  end

  def users
    @users = User.all.ordered_by_username
  end

  def promote
    toggle_privilidges(params[:username], params[:role], :promote)
  end

  def demote
    toggle_privilidges(params[:username], params[:role], :demote)
  end

  def disable
    user = User.by_username(params[:username]);
    disabled = params[:disabled].to_i == 1
    if user
      user.update_attribute(:disabled, disabled)
      if (disabled)
        render :text => "<a href=\"#\" class=\"disable\" data-username=\"#{user.username}\">disabled</span>"
      else
        render :text => "<a href=\"#\" class=\"enable\" data-username=\"#{user.username}\">enabled</span>"
      end
    else
      render :text => "User not found"
    end
  end

  def approve
    user = User.where(:username => params[:username]).first
    if user
      user.update_attribute(:approved, true)
      render :text => "true"
    else
      render :text => "User not found"
    end
  end

  def delete_user
    @user = User.find(params[:id])
    if User.count == 1
      redirect_to :action => :users, notice: "Cannot remove sole user"
    elsif @user.admin?
      redirect_to :action => :users, notice: "Cannot remove administrator"
    else
      @user.destroy
      redirect_to :action => :users
    end
  end

  private

  def toggle_privilidges(username, role, direction)
    user = User.by_username username

    if user
      if direction == :promote
        user.update_attribute(role, true)
        render :text => "Yes - <a href=\"#\" class=\"demote\" data-role=\"#{role}\" data-username=\"#{username}\">revoke</a>"
      else
        user.update_attribute(role, false)
        render :text => "No - <a href=\"#\" class=\"promote\" data-role=\"#{role}\" data-username=\"#{username}\">grant</a>"
      end
    else
      render :text => "User not found"
    end
  end

  def validate_authorization!
    authorize! :admin, :users
  end
end
