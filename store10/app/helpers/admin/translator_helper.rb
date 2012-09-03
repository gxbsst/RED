module Admin::TranslatorHelper
  def msgstr_to_html(string)
    unescape(h(string)).gsub(/\n/, "<br />\n")
  end

  def unescape(string)
    string.gsub(/\\n/, "\n")
  end
  
  def decode_reference_to_html(key, string)
    if %{RICH_CONTENT TEXT CONTENT}.include?(key.split('|').last)
      RedCloth.new(string, [:no_span_caps]).to_html
    else
      msgstr_to_html(string)
    end
  end
end
