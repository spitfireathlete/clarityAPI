object @collaboration
attributes :project_id, :user_id, :created_at, :updated_at

glue :user do
	attributes :email, :first_name, :last_name
end