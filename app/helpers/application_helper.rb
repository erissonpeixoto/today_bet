module ApplicationHelper
  def club_logo(club, size: "w-8 h-8")
    if club&.logo_url.present?
      image_tag club.logo_url, alt: club.name,
        class: "#{size} object-contain",
        onerror: "this.style.display='none';this.nextElementSibling.style.display='flex'"
    end
  end
end
