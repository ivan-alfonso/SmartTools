json.extract! video, :id, :competition_id, :nombreAutor, :apellidoAutor, :email, :comentario, :created_at, :updated_at
json.url video_url(video, format: :json)