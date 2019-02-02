# frozen_string_literal: true

namespace :fetch do
  desc 'Fetch Variables'
  # usage: rake growstuff:admin_user name=skud

  task variables: :environment do
    VariablesFetchService.fetch_all do |v|
      puts v.name
    end
  end
  task entities: :environment do
    EntitiesFetchService.fetch_all
  end
end
