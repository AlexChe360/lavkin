module AdminHelper
  def admin_nav_class(path, exact: false)
    active =
      if exact
        request.path == path
      else
        request.path == path ||
          request.path.start_with?("#{path}/")
      end

    base =
      "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-bold transition"

    if active
      "#{base} bg-[#d9d9d9] text-[#303030]"
    else
      "#{base} text-[#616161] hover:bg-black/5 hover:text-black"
    end
  end
end
