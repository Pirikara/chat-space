class GroupsController < ApplicationController
  def index
  end
  
  def new
    #Groupモデルの新しいインスタンスを作成
    #現在ログイン中のユーザーを新規作成したグループに追加
    @group = Group.new
    @group.users << current_user
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_ro root_path, notice: 'グループを作成しました'
    else
      render :new
    end
  end

  def edit
  end
  
  def update
  end

  private

    def group_params
      params.require(:group).permit(:name, user_ids: [])
    end
end
