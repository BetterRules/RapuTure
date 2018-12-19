# frozen_string_literal: true

namespace :fetch do
  desc 'Fetch Variables'
  # usage: rake growstuff:admin_user name=skud

  task variables: :environment do
    VariablesFetchService.fetch_all
    Variable.all.each do |v|
      puts v.name
      VariablesFetchService.fetch(v)
    end
  end
  task entities: :environment do
    EntitiesFetchService.fetch_all
    # Entity.all.each do |v|
    #   puts v.name
    #   EntitiesFetchService.fetch(v)
    # end
  end
end
