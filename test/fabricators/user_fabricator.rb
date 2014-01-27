Fabricator(:user) do

  name do
    sequence(:name) do |i|
      "iannance#{i}"
    end  
  end

  email do
    sequence(:email) do |i|
      "iannance#{i}@example.com"
    end
  end

  password "password123"
  password_confirmation "password123"
  
end
