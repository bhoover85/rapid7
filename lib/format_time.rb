module FormatTime

  # Calculates time passed in days, hours, mins, sec
  def self.time(elapsed)
    mm, ss = elapsed.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    
    return "%d days, %d hours, %d minutes and %d seconds" % [dd, hh, mm, ss]
  end

end
