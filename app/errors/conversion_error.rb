# Custom error used when a conversion operation fails for known reasons.
class ConversionError < StandardError
  attr_reader :reason

  def initialize(reason)
    @reason = reason.to_sym
    super(reason.to_s)
  end
end
