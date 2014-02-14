require 'spec_helper'

describe EventsController do
  let!(:user){ create(:user) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "shows all events" do
      event = create(:event, host_id: user.id)
      get 'index'
      expect(assigns(:events)).to eq([event])
    end
  end #end GET index

  describe "GET 'show'" do
    let(:event){ create(:event, host_id: user.id)}
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
        expect(response).to redirect_to root_path
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
      let(:valid_attributes){ build(:event).attributes }

      context 'with valid fields' do
        it 'redirects to event show' do
          post :create, event: create(:event, host_id: user.id).attributes 
          expect(response).to redirect_to event_path(assigns(:event).id) 
        end

        it 'sets flash message' do
          post :create, event: create(:event, host_id: user.id).attributes 
          expect(flash[:notice]).to eq "Event added!"
        end

        # it 'increases user event count by 1' do
        #   expect { post :create, event: build(:event).attributes }.to change(user.events, :count).by(1)
        # end

        it 'changes event count by 1' do
          expect {post :create, event: build(:event, host_id: user.id).attributes }.to change(Event, :count).by(1)
        end

        it 'assigns current user as event host' do
          post :create, event: build(:event, host_id: user.id).attributes 
          expect(assigns(:event).host_id).to eq session[:user_id]
        end

        it "adds event to current user's events" do
          post :create, event: valid_attributes
          expect(user.events).to include assigns(:event) 
        end

      end

      context 'with invalid fields' do
        let(:invalid_attributes) { {name: ""} }

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
        expect(response).to redirect_to root_path
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
    let(:event){create(:event, host_id: user.id) }

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

        it 'sets flash notice' do
          get :edit, id: event.id
          expect(flash[:notice]).to eq "You are not authorized to edit this event!" 
        end
      end

    end

    context 'if not logged in' do
      it "redirects to sign in" do
        get :edit, id: event.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :edit, id: event.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end # end GET edit

  describe "PATCH 'update'" do
    let!(:event){create(:event, host_id: user.id) }

    context 'if logged in' do
      context 'if valid user' do
        before(:each) do
          session[:user_id] = user.id
        end

        context 'with valid fields' do
          let!(:valid_attributes){ { venue:"New Venue" } }
          
          it 'redirects to event show page' do
            patch :update, id: event.id, event: valid_attributes
            expect(response).to redirect_to event_path(event)
          end

          it 'does not add event to database' do
            expect {patch :update, id: event.id, event: valid_attributes }.to change(Event, :count).by(0)
          end

        end

        context 'with invalid fields' do
          let(:invalid_attributes){ { venue: "", description: ""} }
          it 'renders edit' do
            patch :update, id: event.id, event: invalid_attributes
            expect(response).to render_template :edit
          end

          it 'does not add event' do
            expect { patch :update, id: event.id, event: invalid_attributes }.to change(Event, :count).by(0)
          end

        end
      end

      context 'if invalid user' do
        before(:each) do
          session[:user_id] = 1
        end

         it 'is redirects to event show' do
          patch :update, id: event.id
          expect(response).to redirect_to events_path
        end

        it 'sets flash message' do
          patch :update, id: event.id
          expect(flash[:notice]).to eq "You are not authorized to edit this event!" 
        end
      end
    end

    context 'if not logged in' do
      it "redirects to sign in" do
        get :edit, id: event.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :edit, id: event.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end

  end #end patch update

  describe 'DELETE destroy' do
    let!(:event){ create(:event, host_id: user.id) }

    context 'if logged in' do
      context 'if valid user' do
        before(:each) do
          session[:user_id] = user.id
        end

        it 'removes event from db' do
          expect {delete :destroy, id: event.id}.to change(Event, :count).by(-1)
        end

        it 'redirects to events page' do
          delete :destroy, id: event.id
          expect(response).to redirect_to events_path
        end
      end

      context 'if invalid user' do
        before(:each) do
          session[:user_id] = 1
        end

        it 'does not remove event from db' do
          expect {delete :destroy, id: event.id}.to change(Event, :count).by(0)
        end

        it 'sets flash message' do
          delete :destroy, id: event.id
          expect(flash[:notice]). to eq "You are not authorized to edit this event!" 
        end
      end
    end

    context 'if not logged in' do
      before(:each) do
        session[:user_id] = nil
      end

      it "redirects to sign in" do
        delete :destroy, id: event.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        delete :destroy, id: event.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end
  end

  describe 'GET rsvp' do
    let!(:event){ create(:event, host_id: user.id) }

    context 'if not logged in' do
      before(:each) do
        session[:user_id] = nil
      end

      it "redirects to sign in" do
        get :rsvp, id: event.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :rsvp, id: event.id
        expect(flash[:notice]).to eq "You must be signed in."
      end

      it 'does not add event to user' do
        expect { get :rsvp, id: event.id }.to change(user.events, :count).by(0)
      end

      it 'does not create RSVP' do
        expect { get :rsvp, id: event.id }.to change(Rsvp, :count).by(0)
      end
    end

    context 'if logged in' do
      let(:participant){ create(:user) }

      before(:each) do
        session[:user_id] = participant.id
      end

      context 'if not already RSVPd' do

        it 'redirects to event page' do
          get :rsvp, id: event.id
          expect(response).to redirect_to event_path(event)
        end

        it 'sets flash message' do
          get :rsvp, id: event.id
          expect(flash[:notice]).to eq "You have successfully RSVPd for this event!"
        end

        it "adds event to user's events" do
          get :rsvp, id: event.id
          expect(participant.events).to include event
        end

        it 'adds rsvp to db' do
          expect { get :rsvp, id: event.id }.to change(Rsvp, :count).by(1)
        end

        it 'adds user to event rsvps' do
          get :rsvp, id: event.id
          expect(event.users).to include participant
        end
      end

      context 'if already RSVPd' do
        let!(:rsvp){ create(:rsvp, user_id: participant.id, event_id: event.id) }
        
        it 'does not create RSVP' do
          expect { get :rsvp, id: event.id }.to change(Rsvp, :count).by(0)
        end

        it 'sets flash message' do
          get :rsvp, id: event.id
          expect(flash[:notice]).to eq "You have already RSVP'd for this event!"
        end
      end

      context 'if hosting' do
        let!(:rsvp){ create(:rsvp, user_id: user.id, event_id: event.id) }

        before(:each) do
          session[:user_id] = user.id
        end

        it 'does not add RSVP to db' do
          expect{ get :rsvp, id: event.id }.to change(Rsvp, :count).by(0)
        end

        it 'does not add RSVP to db' do
          expect{ get :rsvp, id: event.id }.to change(user.events, :count).by(0)
        end

        it 'sets flash message' do
          get :rsvp, id: event.id
          expect(flash[:notice]).to eq "You have already RSVP'd for this event!"
        end

      end
    end
  end

  describe 'GET flake_out' do
    let!(:event){ create(:event, host_id: user.id) }

    context 'if not logged in' do
      before(:each) do
        session[:user_id] = nil
      end

      it "redirects to sign in" do
        get :flake, id: event.id
        expect(response).to redirect_to root_path
      end

      it 'sets flash message' do
        get :flake, id: event.id
        expect(flash[:notice]).to eq "You must be signed in."
      end
    end

    context 'if logged in' do
      context "if already RSVP'd" do
      end

      context "if not already RSVP'd" do
      end      

      context 'if hosting event' do
      end
    end
    
  end
    
end
