class String
  def blank?
    self =~ /\A\s*\z/
  end
end

