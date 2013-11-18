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
	child :comments do
		attributes :text, :upvotes, :downvotes
	end
end 