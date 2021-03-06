# map tags to posts and store generated data to site.pages variable
# here this data is being used to render all posts under each tags on a seperate page

# module Jekyll
#   # this plugin comes under 'Generator' category of jekyll plugins
#   class TagGenerator < Generator
#     def generate(site)
#       # variable that will contain all mapping data
#       tagdata = {}

#       # loop over all posts
#       site.posts.each do |post|
#         # loop over all tags for a post
#         post.tags.each do |tag|
#           # add metadata about post to tagdata
#           if tagdata.has_key?(tag)
#             tagdata[tag] << {"url"=>post.url, "title"=>post.title}
#           else
#             tagdata[tag] = [{"url"=>post.url, "title"=>post.title}]
#           end
#         end
#       end

#       # add tagdata to site.pages variable for global use
#       site.pages <<  TagPage.new(site, site.source, "tags", "index.html", tagdata)
#     end
#   end

#   class TagPage < Page
#     def initialize(site, base, dir, name, tagdata)
#       super(site, base, dir, name)
#       self.data['tagdata'] = tagdata
#     end
#   end
# end

module Jekyll

  class CategoryIndex < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category
      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryGenerator < Generator
    safe true
    
    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.keys.each do |category|
          write_category_index(site, File.join(dir, category), category)
        end
      end
    end
  
    def write_category_index(site, dir, category)
      index = CategoryIndex.new(site, site.source, dir, category)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
    end
  end

end