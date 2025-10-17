# Custom error used when a conversion operation fails for known reasons.
class ConversionError < StandardError
  attr_reader :reason, :details

  def initialize(reason, details = {})
    @reason = reason.to_sym
    @details = details
    super(reason.to_s)
  end
end
