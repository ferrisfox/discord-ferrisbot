﻿# frozen_string_literal: true
require 'discordrb'
require 'yaml'
require 'dotenv'
Dotenv.load('Key.env')

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], prefix: '!'

puts "This bot's invite URL is: #{bot.invite_url}"



BOT_ADMINS = YAML.load(File.open('Config.conf', 'r').read)['Admins']

def is_admin (user)
    return BOT_ADMINS.include? user
end




bot.command(:eval, help_available: false) do |event, *args|
    break unless is_admin(event.user)

    eval args.join(' ')
end

bot.command(:status, help_available: false) do |event, *args|
    break unless is_admin(event.user)

    bot.update_status('online', args.join(' '), nil)
end




bot.mention() do |event|
    break unless event.content.length <= 21
    event << "Hey #{event.user.mention} You can use !help for a list of what I can do"
end


bot.command(:ping, description: 'Check if I\'m online') do |event|
    event.message.react "👋"
end

bot.command(:roll, description: 'Roll a dice') do |_event, sides|
    sides = 6 unless sides.to_i >= 1
    return "Rolled a #{(rand(sides.to_i) + 1).to_s}."
end

bot.command(:coin, description: 'Flip a coin') do |_event|
    return "Landed on #{['heads', 'tails'][rand(2)]}."
end

bot.command(:rps) do |event, player_choice|
    bot_int = rand(3)
    event << "I chose #{['rock', 'paper', 'scissors'][bot_int]}!"

    player_int = {'rock' => 0, 'r' => 0, 'paper' => 1, 'p' => 1, 'scissors' => 2, 's' => 2}[player_choice.to_s.downcase]
    if player_int == nil
        event << 'But I am unsure what option you chose'
        return 'Please chose Rock, Paper or Scissors! (or R, P or S)'
    end

    ['That\'s a draw!', 'You Win!', 'I win!'][(bot_int - player_int) % 3]
end




bot.run true

STARTUP = YAML.load(File.open('Config.conf', 'r').read)['Startup']

bot.update_status('online', STARTUP['Status'], nil)

for each in BOT_ADMINS 
    bot.send_temporary_message(bot.users[each].pm, STARTUP['Message'], STARTUP['Time'])
end

bot.join