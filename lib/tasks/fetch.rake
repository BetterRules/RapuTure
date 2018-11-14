namespace :fetch do
  desc "Fetch Variables"
  # usage: rake growstuff:admin_user name=skud

  task variables: :environment do
    Variable.new.fetch_all!
    Variable.all.each do |v|
      puts v.name
      v.fetch!
    end
  end
end
