module PeopleHelper
  def xfinger_image(person)
    image_tag("http://www.csc.kth.se/hacks/new/xfinger/image.php?user=#{person.login}", class: "xfinger", alt: "xfinger", title: "xfinger")
  end
end
