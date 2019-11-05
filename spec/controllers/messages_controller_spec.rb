require 'rails_helper'

describe MessagesController do
  #letを利用して、テスト中使用するインスタンスを定義
  #letは遅延評価で、メソッド が呼ばれて初めて実行される。
  #beforeメソッド は各exampleの実行前に毎回処理を行うのに対し、letは初回の呼び出しのみ実行される
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do

    context 'log in' do
      #beforeブロックに記述された処理は、各exampleが実行される直前に毎回実行される
      before do
        login user
        get :index, params: { group_id: group.id }
      end
      #ログインしている時のテストを記述
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_new(Message)
        #インスタンスに代入されたオブジェクトを、assignsメソッド で参照。
        #@messageを参照して、be_a_newマッチャを利用
        #@messageはMessage.newで定義された新しいMessageクラスのインスタンス
        #be_a_newマッチャでは、対象が引数で指定したクラスのインスタンスかつ
        #未保存のレコードであるかどうかを確かめることができる。
      end

      it 'assigns @group' do
        expect(assigns(:group)).to eq group
        #eqマッチャを使用して、assigns(:group)とgroupが同一であることを確かめる。
        #groupはletで定義したインスタンス。
      end

      it 'renders index' do
        expect(response).to render_template :index
      end
    end

    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
      end
      #ログインしていない場合のテストを記述
      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
        #redirect_toマッチャは引数にとったプレフィックスにリダイレクトした際の情報を返すマッチャ
      end

    end
  end

  describe '#create' do
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }
    #createアクションを擬似的にリクエストする際に、引数として渡すためのparams
    #attributes_forはcreate、build同様にFactoryBotによって定義されるメソッド 。
    #オブジェクトを生成せずにハッシュを生成する
    #ここでは、messageのcontent、imageがハッシュオブジェクトで返り値となる

    #この中にログインしている場合のテストを記述
    context 'log in' do
      before do
        login user
      end

      context 'can save' do
        subject {
          post :create,
          params: params
        }
        #この中にメッセージの保存に成功した場合のテストを記述
        it 'count up message' do
          expect{ subject }.to change(Message, :count).by(1)
          #expectの引数としてsubjectを定義。expectの引数が長くなるときは、切り出せる。
          #subjectはpostメソッド でcreateアクションを擬似的にリクエストした結果の意
          #changeマッチャは引数が変化したかどうかを確かめるために利用できるマッチャ
          #change(Message, :count).by(1)で、Messageモデルのレコード総数が1増えたかどうか確かめている。
        end

        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
          #groupはsubjectで擬似的に生成されたオブジェクト。
        end
      end

      context 'can not save' do
        #この中にメッセージの保存に失敗した場合のテストを記述
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content:nil, image: nil) } }
        #invalid_params定義の際に、attributes_forの引数にcontent: nilとimage: nilを記述。
        #擬似的にcreateアクションをリクエストする際に、invalid_paramsを渡して保存を失敗させる。
        subject{
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          expect{subject}.not_to change(Message, :count)
          #Rspecで「~であること」を期待する場合はto
          #「~でないこと」を期待する場合はnot_toを使用。
          #not_to change(Message, :count)で、メッセージモデルのレコード数が変化しないことを確かめられる。
        end
      end
    end

    context 'not log in' do
      #この中にログインしていない場合のテストを記述
      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
        #example内でリクエストが行われた後の遷移先ビューの情報をもつresponse
        #post :create,params: paramsの結果のビューがresponseに入る。
      end


    end
  end
end