require 'pry'
require 'pg'
require 'sinatra'
require 'sinatra/reloader' if development? 

# Create a list of videos. Resources are videos
#   1) Main page ('/videos') shows title and video frame, 
#   GET all items on '/videos', and redirect '/' to /videos
#   2) Click Upload to send me to page where can upload a new video  
#   GET '/videos/upload' to give the form 
#   3) Submit a new video with the form
#   POST on '/videos'
#   4) click on title to SHOW specific video page
#   GET on '/videos/:id'
#   ONCE SHOWN WE CAN DO EDIT OR DELETE FROM THE SHOW PAGE
  #   5) Edit a video
  #   send me to the form for editing: GET '/videos/:id/edit'
  #   6) Update the video
  #   POST 'videos'/:id
  #   7) Delete an item: click the button delete
  #   DELETE on '/videos/:id'


get '/' do 
  redirect to ('/videos')
end
get '/videos' do 
  sql = "SELECT * FROM videos"
  @videos = run_sql(sql)
  erb :videos
end

get '/videos/upload' do
  erb :upload
end

post '/videos' do
  url_embed = format_for_embed(params['url'])
  sql = "INSERT INTO videos (title, description, url, url_embed, genre) values ('#{params['title']}', '#{params['description']}', '#{params['url']}', '#{url_embed}', '#{params['genre']}' )"
  run_sql(sql)
  redirect to ('/videos')
end

get '/videos/:id' do
  sql = "select * from videos where id = #{params['id']}"
  @video = run_sql(sql).first
  erb :show

end

get 'videos/:id/edit' do
  sql = "select * from videos where id = #{params['id']}"
  run_sql(sql).first
  erb :edit
end

delete '/videos/:id/delete' do 
  sql = "delete from videos where id = '#{params['id']}'"
  run_sql(sql)
  redirect to ('/videos')
end


def format_for_embed(url)
  url.gsub('watch?v=', 'embed/')
end
def sql_string(value)
  "'#{value.gsub("'","''")}'"
end




private

def run_sql(sql)
  connect = PG.connect(dbname: 'videos', host: 'localhost')
  begin
    connect.exec(sql)
  ensure
    connect.close
  end
end