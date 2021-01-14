module Api
  module V1
    class ArticlesController < Api::ApplicationController
      def index
        articles = Article.all
        articles = articles.map do |art|
          {id: art.id, title: art.title}
        end
        render json: {results: articles}.to_json, status: :ok
      end

    end
  end
end
