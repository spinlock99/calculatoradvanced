class Calculatoradvanced
  attr_reader :expr

  def expr=(expression='')
    @expr = expression
    validate_expression
  end

  alias_method :initialize, :expr=

  def add
    @values.inject(&:+)
  end

  def diff
    @values.inject(&:-)
  end

  def prod
    @values.inject(&:*)
  end

  def div
    @values.inject(&:/)
  end

  private

  def validate_expression
    if @expr =~ /,\n/ || @expr =~ /\n,/
      raise "Consecutive Delimiters"
    end

    split_string = ",\n"

    if match = @expr.match(/\/\/([^\n]*)\n(.*)/m)
      delimeters, @expr = match.captures
      delimeters = delimeters.split(/[\[\]]/)
      delimeters.reject! { |delimeter| delimeter == '' }
      split_string = "#{Regexp.escape(delimeters.join)}" + split_string
    end

    @values = @expr.split(/[#{split_string}]/).map(&:to_i)

    @negatives = @values.select { |value| value < 0 }
    if (@negatives && @negatives.any?)
      raise "negatives not allowed: #{@negatives.join(', ')}"
    end
  end
end
