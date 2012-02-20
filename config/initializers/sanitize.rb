# -*- encoding : utf-8 -*-
Sanitize::Config::FOOTBALL_ARTICLE = {
  :elements => [
    'a', 'b', 'blockquote', 'br', 'cite', 'dd', 'dl', 'dt', 'em',
    'i', 'li', 'ol', 'p', 'q', 'strike', 'strong', 'sub',
    'sup', 'u', 'ul', 'img', 'div', 'object', 'embed', 'param',
    'h3', 'h4', 'span', 'iframe'],
  :attributes => {
    'a' => ['href', 'title'],
    'blockquote' => ['cite'],
    'col' => ['span', 'width'],
    'colgroup' => ['span', 'width'],
    'img' => ['align', 'alt', 'height', 'src', 'title', 'width', 'style'],
    'ol' => ['start', 'type'],
    'q' => ['cite'],
    'div' => ['style'],
    'table' => ['summary', 'width'],
    'td' => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
    'th' => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
    'ul' => ['type'],
    'embed'  => ['allowfullscreen', 'allowscriptaccess', 'height', 'src', 'type', 'width'],
    'object' => ['height', 'width'],
    'param'  => ['name', 'value'],
    'iframe' => ["width", "height", "src", "frameborder", "allowfullscreen"], 
    'span'   => ['style']
  },
  :protocols => {
    'a' => {'href' => ['ftp', 'http', 'https', 'mailto',:relative]},
    'blockquote'   => {'cite' => ['http', 'https', :relative]},
    'q' => {'cite' => ['http', 'https', :relative]}
  }
}
