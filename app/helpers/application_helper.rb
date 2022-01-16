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
      return  "#{array.length} вопросов"
    else
      num = num % 10
      case num
      when 1
        return  "#{array.length} вопрос"
      when 2, 3, 4
        return "#{array.length} вопроса"
      else
        return "#{array.length} вопросов"
      end
    end  
  end

  # Хелпер, рисующий span тэг с иконкой из font-awesome
  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def author_username(question)
    if question.author.present?
      question.author.username
    else
      'Гость'
    end
  end

  def author_path(question)
    if question.author.present?
      question.author_id
    else
      @user.id
    end
  end
end
