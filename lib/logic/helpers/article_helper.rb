def replace_br_tags(content)
  content.gsub( /<br\/?>/, "\n")
end