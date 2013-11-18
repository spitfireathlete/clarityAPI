object @project
attributes :id, :topic, :details, :created_at, :updated_at


child :priority do
	attributes :id, :name, :salesforce_id
end

child :user do
	attributes :id, :email, :first_name, :last_name
end


child :ideas do
	
	attributes :id, :text, :upvotes, :downvotes
	node do |idea|
		u = idea.user
		author_attrs = {:author_email => u.email, :author_first_name => u.first_name, :author_last_name => u.last_name}
	end

	
	child :comments do
		attributes :text, :upvotes, :downvotes
		node do |comment|
			u = comment.user
			author_attrs = {:author_email => u.email, :author_first_name => u.first_name, :author_last_name => u.last_name}
		end
	end
	
end
	
 