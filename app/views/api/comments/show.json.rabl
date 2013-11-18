object @comment
attributes :id, :text, :upvotes, :downvotes, :idea_id, :created_at, :updated_at

glue :user do
	attributes :id => :author_id, :email => :author_email, :first_name => :author_first_name, :last_name => :author_last_name
end