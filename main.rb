def game()
    meny()
end

@pick_up_versions = ["ta up","ta","plocka upp"]
@inventory_versions = ["lager","inventory","väska"]
@operations = ["ta upp","läs", "up","höger","ner","lager", "vänster", ""]

#def meny()
#  operations = ["s","q"]
#  puts "---meny---"
#  puts "välj kommando"
#  puts "1. - start"
#  puts "2. - quit"
#  puts "3. - load save file"
#  input = gets.chomp
#    if input == 1
#      start()
#    elsif input == 2
#      return
#    elsif input == 3
#      rows = File.readlines("save.txt")
#      i = 0
#      while i < rows.length
#         puts "#{i}: #{rows[i]}"
#         i += 1
#      end 
#        = gets.chomp
#      if 
#    else 
#      puts "Skriv ett fungerande kommando, inte #{input}"
#    end 
#end

def quit(cause)
  if cause == "home"
    puts "Du valde att stanna hemma."
    puts "Din resa slutar här"
  end
end

def find_i(arr, item)
  i = 0
  while i < arr.length
    if arr[i] == item
      return i
    end
    i+=1
  end
end

def start()
  hp = 20 
  rooms = "0"
  inventory = []
  
  
  puts "Du vaknar upp i en grotta"
  puts "Du minns ingenting..."
  puts "Du ser ett skrynkligt papper på golvet"
  input = gets.chomp.downcase

  while !@operations.include?(input) && !@pick_up_versions.include?(input) && @inventory_versions.include?(input)
    puts "Du kan inte göra så"
    puts "gör någonting som du kan göra"
    input = gets.chomp
  end
  current_op_index = find_i(@operations,input)
  info = ["Du tar upp pappret från marken","du har ingenting du kan läsa
  ", "Du undersökte rummet uppåt, men du kanske skulle läst den där lappen
  "]
  results = ["info", "igen"]
  items = ["papper"]
  if current_op_index == 0
    inventory << items[current_op_index]
  end
  
  room = [0,1,2,3]
  current_room = room[current_op_index]
  puts info[current_op_index]
  
  input = gets.chomp.downcase
  while !@operations.include?(input)
    puts "Du kan inte göra så"
    puts "gör någonting som du kan göra"
    input = gets.chomp
  end
  current_op_index = find_i(@operations,input)
  info = ["Du kan inte ta upp något","JAG HAR KIDNAPPAT DIG OCH PLACERAT DIG I DÖSKALLEGROTTAN. MUHAHAHAHA,
  ", "Du undersökte rummet uppåt, men du kanske skulle läst den där lappen
  "]
  results = ["info", "igen"]
  items = ["papper"]
  if current_op_index == 0
    inventory << items[current_op_index]
  end
  
  room = [0,1,2,3]
  current_room = room[current_op_index]
  puts info[current_op_index]
  
  if input == "help"
    i = 0
    while i < @operations.length
      puts @operations[i]    
    end
    i += 1
  end
    
    #valid_checker_in2(input)
    #if input.to_i == 1
    #  puts "fortsätt"
    #else
    #  quit("home")
    #end
end 

#def valid_checker_in2(input)
#    while input.to_i.to_s != input
#        puts "Vänligen välj ett nummer. Inte #{input}"
#        input = gets.chomp
#        valid_checker_in2(input)
#    end
#
#    while input.to_i > 2 || input.to_i < 1
#        puts "Vänligen välj mellan kommandon, 1 eller 2. Inte #{input}
#        "
#        input = gets.chomp
#        valid_checker_in2(input)
#    end
#    return input
#end


def save_game(name, place, hp, inventory)
  new_row = "#{name}, #{plats}, #{hp}, #{inventory}"
  old_row = []
  old_row = File.readlines("save.txt")
  all_rows = [new_row] + old_row
  all_rows = all_rows[0, 3]
  file = File.open("save.txt", "w")
  i = 0
  while 1 < all_rows.length
    File.write(all_rows[i])
    i += 1
  end 
  File.close
  
  File.write("save.txt", "#{name}, #{plats}, #{hp}, #{inventory}")
  puts "Spelet har sparats" 
end 

def load_game #Välja mellan vilken fil man kan använda

end 




start()