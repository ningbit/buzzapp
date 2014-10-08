require 'eventmachine'

class QuestionsController < ApplicationController
   before_filter :get_topic_id

   @@speed = 250

  def get_topic_id
    @topic = Topic.find(params[:topic_id])
  end

  # GET /questions
  # GET /questions.json
  def index
    @questions = @topic.questions

    render layout: false
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    speak @question.title

    render :text => 'Speaking', :status => '200'
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    # @question = Question.new

    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @question }
    # end

    question = { title: params[:title],
          choice_a: params[:choice_a],
          choice_b: params[:choice_b],
          choice_c: params[:choice_c],
          choice_d: params[:choice_d],
          answer:   params[:answer]
        }

    if @topic.questions.create(question) && question[:title] != ""
      render :text => 'Created', :status => '200'
    else
      render :text => 'Failed', :status => '404'
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  def speak(string)

    string = string[/[a-zA-Z0-9\s]*/]

    EM.run do
      EM.defer( proc do
        eval "system \"say #{string} -r #{@@speed}\""
      end)
    end
  end
end
