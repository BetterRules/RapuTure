class VariablesSearchService < FortyFacets::FacetSearch
  model 'Variable' # which model to search for
  text :name # filter by a generic string entered by the user
  text :description
  # scope :classics   # only return movies which are in the scope 'classics'
  # range :price, name: 'Price' # filter by ranges for decimal fields
  facet :namespace, name: 'Namespace'
  # facet :studio, name: 'Studio', order: :name
  # facet :genres, name: 'Genre' # generate a filter with all values of 'genre' occuring in the result
  # facet [:studio, :country], name: 'Country' # generate a filter several belongs_to 'hops' away
  # orders 'Name' => :name
end