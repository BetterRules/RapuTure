# frozen_string_literal: true

namespace :fetch do
  desc 'Fetch Resources'
  # usage: rake growstuff:admin_user name=skud
  task fetchall: [:variables, :entities] do
    # This runs after all the above tasks have run
    puts 'Your database has now been populated with variables and entities!'
  end
  task variables: :environment do
    VariablesFetchService.fetch_all do |v|
      puts v.name
    end
  end
  task entities: :environment do
    EntitiesFetchService.fetch_all
  end
end
