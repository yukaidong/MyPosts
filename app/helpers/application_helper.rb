module ApplicationHelper
	#Return the full title of a page
	def full_title(page_title)
		base_title = "My Posts"
		if params[:controller] == "posts"&&params[:action] == "show"
			base_title = Post.find(params[:id]).user.name
		end
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
