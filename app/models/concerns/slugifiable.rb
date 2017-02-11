module Slugifiable
  module ClassMethods
    def find_by_slug(slugified_name)
      self.all.find {|instance| instance.slug == slugified_name}
    end

  end

  module InstanceMethods
    def slug
      username.downcase.gsub(" ","-")
    end
  end
end
