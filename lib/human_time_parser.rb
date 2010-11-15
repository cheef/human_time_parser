require 'chronic18n'

Dir[File.join(File.dirname(__FILE__), '..', 'dics', '') + "*.yml"].each do |filepath|
  Chronic18n::DICS.merge! YAML.load(File.read(filepath))
end

module Chronic18n

  def self.parse(txt, lang = "en")
    stringify_date = lang != "en" ? Translator.new(txt, lang).work : txt
    interval = TimeInterval.parse(stringify_date)
    interval ? interval.map {|d| Chronic.parse(d) } : Chronic.parse(stringify_date)
  end

  class Translator

    def work
      # Return the text if we don't have the dictionary
      return @txt unless dic = DICS[@lang]

      # Regex gsub!
      if rxp = DICS["#{@lang}_regex"]
        rxp.each { |k, v| @txt.gsub!(k, v)}
      end

      # Match phrase
      return dic[@txt] if dic[@txt]

      # Match translate
      @txt.split(/\s/).map { |w| dic[w] || w }.join(" ")
    end

  end

end

module TimeInterval

  def self.parse(txt)
    return ["#{$1} #{$2}", "#{$1} #{$3}"] if txt =~ /(.*)from (.*) to (.*)/
    return ["#{$1} saturday 00:00", "#{$1} sunday 23:59:59"] if txt =~ /(.*)weekend/
  end

end

module HumanTimeParser

  def self.locale=(label)
    @locale = label
  end

  def self.parse(time_string)
    Chronic18n.parse(time_string, @locale || 'en') rescue nil
  end

end