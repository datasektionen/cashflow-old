module PeopleHelper
  def xfinger_image(person)
    size = '80x80'
    url = 'http://dumnaglar.datasektionen.se/'
    image_tag(
      "#{url}/#{person.login}/#{size}",
      class: 'xfinger',
      alt: 'xfinger',
      title: 'xfinger'
    )
  end
end
