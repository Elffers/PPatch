require 'spec_helper'

describe EventsController do
  let(:user){ create(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "shows all events" do
      event = create(:event)
      get 'index'
      expect(assigns(:events)).to eq([event])
    end
  end #end GET index

  describe "GET 'show'" do
    let(:event){ create(:event)}
    it "returns http success" do
      get 'show', id: event.id
      response.should be_success
    end

    it 'shows event' do
      get 'show', id: event.id
      expect(assigns(:event)).to_not be_nil
    end

  end #end GET show

  describe "GET 'new'" do
    context 'if logged in' do
      before(:each) do
        session[:user_id] = user.id
      end

      it "returns http success" do
        get :new
        response.should be_success
      end
    end

    context 'if not logged in' do
      it "redirects to sign in" do
        get :new
        expect(response).to redirect_to sign_in_path
      end

      it 'sets flash message' do
        get :new
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end # end GET new

  describe "POST 'create'" do
    context 'if logged in' do
      before(:each) do
        session[:user_id] = user.id
      end
      context 'with valid fields' do
        it 'redirects to event show' do
          post :create, event: create(:event).attributes 
          expect(response).to redirect_to event_path(assigns(:event).id) 
        end

        it 'sets flash message' do
          post :create, event: create(:event).attributes 
          expect(flash[:notice]).to eq "Event added!"
        end

        it 'increases user event count by 1' do
          expect { post :create, event: build(:event).attributes }.to change(user.events, :count).by(1)
        end

        it 'changes event count by 1' do
          expect {post :create, event: build(:event).attributes }.to change(Event, :count).by(1)
        end

        it 'assigns event to current user' do
          post :create, event: build(:event).attributes 
          expect(assigns(:event).user_id).to eq user.id
        end

      end

      context 'with invalid fields' do
        let(:invalid_attributes) { {name: nil, user_id: nil} }

        it 'renders new' do
          post :create, event: invalid_attributes
          expect(response).to render_template :new
        end

        it 'does not add event' do
          expect {post :create, event: invalid_attributes }.to change(Event, :count).by(0)
        end
      end

    end

    context 'if not logged in' do
      it "redirects to sign in" do
        get :new
        expect(response).to redirect_to sign_in_path
      end

      it 'sets flash message' do
        get :new
        expect(flash[:notice]).to eq "You must be signed in."
      end

      it 'does not add event' do
        expect {post :create, event: build(:event).attributes }.to change(Event, :count).by(0)
      end
    end
  end #end POST create

  describe "GET 'edit'" do
    let(:event){create(:event, user_id: user.id) }

    context 'if logged in' do
      context 'if valid user' do
        before(:each) do
          session[:user_id] = user.id
        end
       
        it 'renders edit' do
          get :edit, id: event.id
          expect(response).to render_template :edit
        end

        it 'instantiates new event' do
          get :edit, id: event.id
          expect(assigns(:event)).to_not be_nil
        end
      end
      context 'if invalid user' do
        before(:each) do
          session[:user_id] = 1
        end

        it 'redirects to index' do
          get :edit, id: event.id
          expect(response).to redirect_to events_path
        end
      end

    end

    context 'if not logged in' do
      it "redirects to sign in" do
        get :edit, id: event.id
        expect(response).to redirect_to sign_in_path
      end

      it 'sets flash message' do
        get :edit, id: event.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end # end GET edit


end
