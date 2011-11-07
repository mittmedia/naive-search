module NaiveSearch
  module NaiveSearchOn
    extend ActiveSupport::Concern
    
    included do
      before_save :add_fields_to_naive_search
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
      end

      def search_for(query)
        words = query.split " "
        conditions = words.map do |w|
          replace_bind_variables("#{self.naive_search_index_field} like ?", ["%#{w}%"])
        end.join " OR "
        self.where(conditions).order(@order).limit(@limit).sort do |a,b|
          b.relevance_for(query) <=> a.relevance_for(query)
        end
      end
    end
    
    def relevance_for(query)
      @naive_relevance ||= {}
      return @naive_relevance[query] if @naive_relevance[query]

      words = query.split " "
      score = self.naive_search_fields.map do |field|
        words.map{|w| self.send(field).downcase.scan(w.downcase).size}.sum +
        words.map{|w| self.send(field).downcase.scan(query.downcase).size}.sum +
        words.map{|w| self.send(field).downcase == w.downcase ? 1 : 0 }.sum +
        words.map{|w| self.send(field).downcase == query.downcase ? 1 : 0 }.sum
      end.sum

      @naive_relevance[query] = score
    end
    
    private
    def add_fields_to_naive_search
      full_text = self.naive_search_fields.map do |field|
        self.send(field)
      end.join "\n"
      self.send "#{self.naive_search_index_field}=", full_text
    end
    
  end
end

ActiveRecord::Base.send :include, NaiveSearch::NaiveSearchOn