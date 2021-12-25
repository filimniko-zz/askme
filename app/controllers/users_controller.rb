class UsersController < ApplicationController

  before_action :load_user, except: [:index, :new, :create]
  before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    @users = User.all
  end

  def new
    redirect_to user_path(@user), notice: 'Вы уже залогинены' if current_user.present?
    @user = User.new
  end

  def create
    redirect_to user_path(@user), notice: 'Вы уже залогинены' if current_user.present?
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: 'Пользователь успешно зарегистрирован!'
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    @questions = @user.questions.order(created_at: :desc)
    @new_question = @user.questions.build
    @questions_count = @user.questions.count
    @questions_with_answer = @user.questions.count(&:answer)
    @questions_without_answer = @questions_count - @questions_with_answer
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Данные успешно обновлены!'
    else
      render 'edit'
    end    
  end

  def destroy
    session[:user_id] = nil
    load_user.destroy
    redirect_to root_url, notice: 'Пользователь успешно удален!'
  end

  private

  def authorize_user
    reject_user unless @user == current_user
  end

  def load_user
    @user ||= User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, 
                                  :name, :username, :avatar_url, :user_bg_color)
  end
end
