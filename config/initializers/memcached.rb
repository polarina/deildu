ActionController::Base.cache_store = :mem_cache_store, "localhost"

class CheckForIceland
  alias old_is_icelandic is_icelandic?
  
  def is_icelandic?(address)
    cache = ActionController::Base.cache_store.read "checkforiceland/#{address.to_s}"
    
    return true if cache == "t"
    return false if cache == "f"
    
    icelandic = old_is_icelandic address
    
    ActionController::Base.cache_store.write "checkforiceland/#{address.to_s}", icelandic.to_s[0], :raw => true unless icelandic.nil?
    icelandic
  end
end
