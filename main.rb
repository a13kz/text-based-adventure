def game()
    meny()
end

@dungeon_map = 
[
  []
  []
  []
  []
] #använda denna för att veta var man är
@pick_up_versions = ["ta up","ta","plocka upp"]
@inventory_versions = ["lager","inventory","väska"]
@operations = ["ta upp","läs", "up","höger","ner","lager", "vänster", "spara"]

def meny()
  operations = ["s","q"]
  puts "---meny---"
  puts "välj kommando"
  puts "1. - start"
  puts "2. - quit"
  puts "3. - load save file"
  input = gets.chomp

  while input != "1" && input != "2" && input != "3"
    puts "Skriv ett giltigt kommando, inte #{input}"
    input = gets.chomp
  end    

  if input == "1"
    hp = 20 
    room = "0"
    inventory = []
    save = false

    start(room, hp, inventory, save)

  elsif input == "2"
    puts
    puts "Spelet avslutas"
    return
  else 
    if File.empty?("save.txt")
      puts "Finns inga sparfiler"
      meny()
      return
    end 

    puts 
    lines = File.readlines("save.txt")
    i = 0
    while i < lines.length
       puts "#{i}: #{lines[i]}"
       i += 1
    end 

    puts "Välj vilken sparfil du vill ladda (1-3):"
    save_file = gets.chomp
    puts 
    while save_file != "1" && save_file != "2" && save_file != "3"
      puts "Skriv ett giltigt kommando, inte #{save_file}"
      save_file = gets.chomp
      puts ""
    end    

    save = true
    index = save_file.to_i - 1
    row = lines[index]
    row = row.chomp
    row_parts = row.split(", ")
    place = row_parts[1]
    hp = row_parts[2]
    inventory = row_parts[3]
    puts "#{place}"
    puts "#{hp}"
    puts "#{inventory}"

    start(place, hp, inventory, save)

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

def start(place, hp, inventory, save)  

  #Ska kanske vara någon annan stans
  #if save == true
  #  puts
  #  puts "---Save---"
  #  puts "Välkommen tillbaka!"
  #  puts "Du är i #{plats} och har #{hp} HP"
  #  puts "Du har: #{inventory}"
  #end 

  puts
  puts "Du vaknar upp i en grotta"
  puts "Du minns ingenting..."
  puts "Du ser ett skrynkligt papper på golvet"
  input = gets.chomp.downcase

  while !@operations.include?(input) && !@pick_up_versions.include?(input) && @inventory_versions.include?(input)
    puts "Du kan inte göra så"
    puts "gör någonting som du kan göra
    "
    input = gets.chomp.downcase
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
  info = ["Du kan inte ta upp något","JAG HAR KIDNAPPAT DIG OCH PLACERAT DIG I DÖSKALLEGROTTAN. MUHAHAHAHA. DU KOMMER ALRIG KOMMA HÄR IFRÅN. Du kan försöka utforska grottan genom att gå höger, vänster, up och ner samt plocka upp saker du stötter på mmr. MEN EGENTLIGEN ÄR DET MENINGSLÖST HIHIHIHI.
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
      i += 1  
    end
  end

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
  new_row = "#{name}, #{place}, #{hp}, #{inventory}"
  old_row = []
  old_row = File.readlines("save.txt")
  all_rows = [new_row] + old_row
  all_rows = all_rows[0, 3]
  file = File.open("save.txt", "w")
  i = 0
  while i < all_rows.length
    file.write(all_rows[i])
    i += 1
  end 
  file.close
  
  puts "Spelet har sparats" 
end 

game()