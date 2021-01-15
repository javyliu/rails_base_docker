module Api
  module V1
    class ArticlesController < Api::ApplicationController
      def index
        articles = Article.page(params[:page]).per(10)
        articles = articles.map do |art|
          {id: art.id, title: art.title}
        end
        render json: {results: articles, cur_page: params[:page] || 1}, status: :ok
      end

    end
  end
end
