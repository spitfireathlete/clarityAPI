object @projects
attributes :id, :topic, :details, :created_at, :updated_at


child :priority do
	attributes :id, :name, :salesforce_id
end

child :user do
	attributes :id, :email, :first_name, :last_name
end
	