# Превращает произвольный текст (в том числе кириллицу) в slug для URL.
#
#   Slugifier.call("Желтоксан 156") # => "zheltoksan-156"
#   Slugifier.call("Test Store")    # => "test-store"
module Slugifier
  MAP = {
    "а" => "a", "б" => "b", "в" => "v", "г" => "g", "д" => "d",
    "е" => "e", "ё" => "yo", "ж" => "zh", "з" => "z", "и" => "i",
    "й" => "y", "к" => "k", "л" => "l", "м" => "m", "н" => "n",
    "о" => "o", "п" => "p", "р" => "r", "с" => "s", "т" => "t",
    "у" => "u", "ф" => "f", "х" => "kh", "ц" => "ts", "ч" => "ch",
    "ш" => "sh", "щ" => "shch", "ъ" => "", "ы" => "y", "ь" => "",
    "э" => "e", "ю" => "yu", "я" => "ya",
    # казахские буквы
    "ә" => "a", "ғ" => "g", "қ" => "k", "ң" => "n", "ө" => "o",
    "ұ" => "u", "ү" => "u", "һ" => "h", "і" => "i"
  }.freeze

  CYRILLIC = /[#{Regexp.escape(MAP.keys.join)}]/

  def self.call(text)
    text.to_s
        .downcase
        .gsub(CYRILLIC) { |char| MAP[char] }
        .parameterize
  end
end
