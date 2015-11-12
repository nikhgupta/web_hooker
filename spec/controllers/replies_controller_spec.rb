require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe RepliesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Reply. As you add validations to Reply, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RepliesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all replies as @replies" do
      reply = Reply.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:replies)).to eq([reply])
    end
  end

  describe "GET #show" do
    it "assigns the requested reply as @reply" do
      reply = Reply.create! valid_attributes
      get :show, {:id => reply.to_param}, valid_session
      expect(assigns(:reply)).to eq(reply)
    end
  end

  describe "GET #new" do
    it "assigns a new reply as @reply" do
      get :new, {}, valid_session
      expect(assigns(:reply)).to be_a_new(Reply)
    end
  end

  describe "GET #edit" do
    it "assigns the requested reply as @reply" do
      reply = Reply.create! valid_attributes
      get :edit, {:id => reply.to_param}, valid_session
      expect(assigns(:reply)).to eq(reply)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Reply" do
        expect {
          post :create, {:reply => valid_attributes}, valid_session
        }.to change(Reply, :count).by(1)
      end

      it "assigns a newly created reply as @reply" do
        post :create, {:reply => valid_attributes}, valid_session
        expect(assigns(:reply)).to be_a(Reply)
        expect(assigns(:reply)).to be_persisted
      end

      it "redirects to the created reply" do
        post :create, {:reply => valid_attributes}, valid_session
        expect(response).to redirect_to(Reply.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved reply as @reply" do
        post :create, {:reply => invalid_attributes}, valid_session
        expect(assigns(:reply)).to be_a_new(Reply)
      end

      it "re-renders the 'new' template" do
        post :create, {:reply => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested reply" do
        reply = Reply.create! valid_attributes
        put :update, {:id => reply.to_param, :reply => new_attributes}, valid_session
        reply.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested reply as @reply" do
        reply = Reply.create! valid_attributes
        put :update, {:id => reply.to_param, :reply => valid_attributes}, valid_session
        expect(assigns(:reply)).to eq(reply)
      end

      it "redirects to the reply" do
        reply = Reply.create! valid_attributes
        put :update, {:id => reply.to_param, :reply => valid_attributes}, valid_session
        expect(response).to redirect_to(reply)
      end
    end

    context "with invalid params" do
      it "assigns the reply as @reply" do
        reply = Reply.create! valid_attributes
        put :update, {:id => reply.to_param, :reply => invalid_attributes}, valid_session
        expect(assigns(:reply)).to eq(reply)
      end

      it "re-renders the 'edit' template" do
        reply = Reply.create! valid_attributes
        put :update, {:id => reply.to_param, :reply => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested reply" do
      reply = Reply.create! valid_attributes
      expect {
        delete :destroy, {:id => reply.to_param}, valid_session
      }.to change(Reply, :count).by(-1)
    end

    it "redirects to the replies list" do
      reply = Reply.create! valid_attributes
      delete :destroy, {:id => reply.to_param}, valid_session
      expect(response).to redirect_to(replies_url)
    end
  end

end
