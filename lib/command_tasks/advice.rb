require './lib/methods.rb'
require './lib/constants.rb'

class Advice

  POSITIVE = [
      'Бесспорно',
      'Предрешено',
      'Никаких сомнений',
      'Определённо да',
      'Можешь быть уверен в этом'
  ]

  HESITANTLY_POSITIVE = [
      'Мне кажется — «да»',
      'Вероятнее всего',
      'Хорошие перспективы',
      'Знаки говорят — «да»',
      'Да'
  ]

  NEUTRAL = [
      'Пока не ясно, попробуй снова',
      'Спроси позже',
      'Лучше не рассказывать',
      'Сейчас нельзя предсказать',
      'Сконцентрируйся и спроси опять'
  ]

  NEGATIVE = [
      'Даже не думай',
      'Мой ответ — «нет»',
      'По моим данным — «нет»',
      'Перспективы не очень хорошие',
      'Весьма сомнительно'
  ]

  ANSWERS = [ POSITIVE, HESITANTLY_POSITIVE, NEUTRAL, NEGATIVE ]

  def initialize(id, argument, token)
    @id = id
    @argument = argument
    @token = token
  end

  def run
    message = "Вопрос: #{@argument}\n💫✨💫\n#{answer} 🔮"
    Methods.send_message(@id, message, @token)
  end

  def answer
    r = Random.new
    ANSWERS[r.rand(4)][r.rand(5)]
  end

end