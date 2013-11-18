object @idea
attributes :id, :text, :upvotes, :downvotes, :project_id, :created_at, :updated_at


child :comments do
	attributes :text, :upvotes, :downvotes
end

child :user do
	attributes :id, :email, :first_name, :last_name
end