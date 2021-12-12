module ApplicationHelper
  def user_avatar (user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def inclinator(array)
    num = array.length % 100
  
    if (num >= 11 && num <=19)
      return  "вопросов"
    else
      num = num % 10
      case num
      when 1
        return  "вопрос"
      when 2, 3, 4
        return "вопроса"
      else
        return "вопросов"
      end
    end  
  end
end
