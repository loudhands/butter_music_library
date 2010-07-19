module ActsAsSolr
  module PaginationExtension   

    def paginate_search(query, page, per_page)
      pager = WillPaginate::Collection.new(page, per_page)
      result = result = find_by_solr(query)
      returning WillPaginate::Collection.new(page, per_page, result.total_hits) do |pager|
        pager.replace result.docs
      end
    end

  end
end

module ActsAsSolr::ClassMethods
  include ActsAsSolr::PaginationExtension
end