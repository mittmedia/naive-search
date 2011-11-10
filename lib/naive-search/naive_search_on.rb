module NaiveSearch
  module NaiveSearchOn
    extend ActiveSupport::Concern
    
    included do
    end
    
    module ClassMethods
      def naive_search_on(*fields)
        if fields.size.zero?
          raise "No arguments given, please specify which fields should be indexed and searched."
        end
        options = (fields).extract_options!
        @order = options[:order] || "id desc"
        @limit = options[:limit] || 100
                
        cattr_accessor :naive_search_fields
        cattr_accessor :naive_search_index_field
        self.naive_search_fields = fields
        self.naive_search_index_field = options[:naive_search_index_field] || :naive_search_index
        self.before_save :update_naive_search_index
      end

      def search_for(query, page_no = 1, page_size = nil)
        words = query.to_s.split " "
        conditions = words.map do |w|
          replace_bind_variables("#{self.naive_search_index_field} like ?", ["%#{w}%"])
        end.join " OR "
        
        page_size ||= @limit
        offset = (page_no * page_size) - page_size
                
        self.where(conditions).order(@order).limit(page_size).offset(offset).sort do |a,b|
          b.relevance_for(query) <=> a.relevance_for(query)
        end
      end
    end
    
    def relevance_for(query)
      query = query.to_s.downcase
      @naive_relevance ||= {}
      return @naive_relevance[query] if @naive_relevance[query]
      words = query.split " "
      
      score = self.naive_search_fields.map do |field|
        content = self.send(field).to_s.downcase
        words.map do |w|
          # one point for partial word matches
          (content.scan(w).size + 
          # one point for partial query matches
           content.scan(query).size + 
          # two points for exact word match
           (content == w ? 2 : 0) + 
          # two points for exact query match
           (content == query ? 2 : 0))
        end.sum
      end.sum

      @naive_relevance[query] = score
    end
    
    private
    def update_naive_search_index
      full_text = self.naive_search_fields.map do |field|
        self.send(field)
      end.join "\n"
      self.send "#{self.naive_search_index_field}=", full_text
    end
    
  end
end

ActiveRecord::Base.send :include, NaiveSearch::NaiveSearchOn