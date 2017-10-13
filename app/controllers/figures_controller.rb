class FiguresController < ApplicationController
  set :views, Proc.new { File.join(root, "../views/") }

  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    @landmarks = Landmark.all
    @titles = Title.all

    erb :'/figures/new'
  end

  post '/figures' do
    #create new figure from input
    @figure = Figure.create(name: params[:figure][:name])

    #enumerate through title_ids, adding to new figure titles
    if !params[:figure][:title_ids].nil?
      params[:figure][:title_ids].each do |title_id|

        title = Title.find_by_id(title_id)
        @figure.titles << title
      end
    end


    #if title is created but already exists in db and is NOT selected already, add title to figure titles
    if Title.all.any? {|title| title.name == params[:title][:name]}

      duplicate_title = Title.all.detect {|title| title.name == params[:title][:name]}
      @figure.titles << duplicate_title unless @figure.titles.include? duplicate_title
    end

    #create new title if present in field box, prevents duplicate titles from being created
    if params[:title][:name] != "" && !Title.all.any? {|title| title.name == params[:title][:name]}
      new_title = Title.create(params[:title])
      @figure.titles << new_title
    end


    #enumerate through landmark_ids, adding to new figure landmarks
    if !params[:figure][:landmark_ids].nil?
      params[:figure][:landmark_ids].each do |landmark_id|
        landmark = Landmark.find_by_id(landmark_id)
        @figure.landmarks << landmark
      end
    end


    #if landmark is created but already exists in db and is NOT selected already, add landmark to figure landmarks
    if Landmark.all.any? {|landmark| landmark.name == params[:landmark][:name]}
      duplicate_landmark = Landmark.all.detect {|landmark| landmark.name == params[:landmark][:name]}
      @figure.landmarks << duplicate_landmark unless @figure.landmarks.include? duplicate_landmark
    end


    #create new landmark if present in field box, prevents duplicate landmarks from being created
    if params[:landmark][:name] != "" && !Landmark.all.any? {|landmark| landmark.name == params[:landmark][:name]}
      new_landmark = Landmark.create(params[:landmark])
      @figure.landmarks << new_landmark
    end

    @figure.save

    redirect to ("/figures/#{@figure.id}")
  end

  get '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])

    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find_by_id(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/edit'
  end

  patch '/figures/:id' do

    @figure = Figure.find_by_id(params[:id])

    #update name for figure
    @figure.name = params[:figure][:name]

    #update titles based on checkbox selection
    @figure.titles.clear
    if !params[:figure][:title_ids].nil?
      params[:figure][:title_ids].each do |title_id|
        title = Title.find_by_id(title_id)
        @figure.titles << title
      end
    end

    #if a new title has been submitted, check for duplicate entry before creating
    if !params[:title][:name] == "" && !Title.all.any?{|title| title.name == params[:title][:name]}
      title = Title.create(params[:title])
      @figure.titles << title
    end

    #update landmarks based on checkbox selection
    @figure.landmarks.clear
    if !params[:figure][:landmark_ids].nil?
      params[:figure][:landmark_ids].each do |landmark_id|
        landmark = Landmark.find_by_id(landmark_id)
        @figure.landmarks << landmark
      end
    end

    #if a new landmark has been submitted, check for duplicate entry before creating
    if !params[:landmark][:name] != "" && !Landmark.all.any?{|landmark| landmark.name == params[:landmark][:name]}
      landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed])
      @figure.landmarks << landmark
    end

    #save changes to DB
    @figure.save

    redirect to ("/figures/#{@figure.id}")
  end


end
