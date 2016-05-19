require 'octocore'

module ApplicationHelper

  def counters_text
    mapping_as_choice Octo::Counter::Helper.counter_text
  end

  # Converts a hash mapping into choices ready for UX
  # @return [Array<Hash{Symbol => String }>] The hash containing key :text
  #   as the text to display, and another key :id as the id to be used
  #   as reference while communicating
  def mapping_as_choice(map)
    map.inject([]) do | choices, pair |
      key, val = pair
      choices << { text: val, id: key }
    end
  end

  # Get the first enterprise object for debugging
  def get_enterprise
    Octo::Enterprise.first
  end

end

