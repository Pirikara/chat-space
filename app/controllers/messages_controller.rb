class MessagesController < ApplicationController
  before_action :set_group

  def index
    @message = Message.new
    @messages = @group.messages.includes(:user)
    #@groupにひもづくメッセージ一覧と、それらにひもづくuserをまとめて取得する。
  end

  def create
    @message = @group.messages.new(message_params)
    if @message.save
      redirect_to group_messages_path(@group), notice: 'メッセージが送信されました'
    else
      @messages = @group.messages.includes(:user)
      #groupにひもづくメッセージとそのユーザーを取得。
      flash.now[:alert] = 'メッセージを入力してください'
      #flashは次のアクションにまで反映させる。
      #flash.nowは次のアクションに移行した時点で消える。
      render :index
    end
  end

  private
    def message_params
      params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
    end

    def set_group
      @group = Group.find(params[:group_id])
    end
end