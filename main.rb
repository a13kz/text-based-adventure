@current_save_file_index = 0
def setup()
  puts "Vänligen välj en spar fil"
  input = gets.chomp
  start_place = File.read
  start()
    #meny()
end

def start()
  puts "Välkommen till The Ultimate Challenge"
  puts "Vill du ladda en gammal sparfil - (1) eller starta ett nytt äventyr - (2)? "
  input = gets.chomp
  while input != "1" && input != "2" 
    input = gets.chomp
    puts "Välj ett giltigt kommando inte #{input}"
  end
  if input.to_i == 2
    hp = 20 
    room = "0"
    inventory = []
    save = false
    game(room, hp, inventory, save)
  else 
    puts "Vänligen välj det nummer av sparfil att fortsätta ditt äventyr med"
    i=0
    lines = File.readlines("save.txt")
    while i < lines.length
      if lines[i] == "\n"
        puts "#{i+1} tom sparfil"
      else
        puts "#{i+1}: #{lines[i]}"
      end        
      i += 1
    end
    while input != "1" && input != "2" && input != "3" 
      input = gets.chomp
      puts "Välj ett giltigt kommando inte #{input}"
    end
    load_game(input)
  end 
end

@dungeon_map = 
[
  [ 
    ["Rum -2,0", ["right"]],["Rum -2,1", ["down", "right", "left"]],["Rum -2,2", ["left"]],["EMPTY -2,3", [""]],["EMPTY -2,4", [""]]
  ],
  [ 
    ["EMPTY -1,0", [""]],["Rum -1,1", ["up", "down"]],["Rum -1,2", ["down"]],["EMPTY -1,3", [""]],["EMPTY -1,4", [""]]
  ],
  [ 
    ["Rum 0,0", ["right"]],["Rum 0,1", ["up", "right", "left"]],["Rum 0,2", ["up", "right", "left"]],["Rum 0,3", ["down", "right", "left"]],["Rum 0,4", ["down", "left"]]
  ],
  [ 
    ["EMPTY 1,0", [""]],["Rum -1,1", ["down", "right"]],["Rum 1,2", ["right", "left"]],["Rum 1,3", ["up", "right", "left"]],["Rum 1,4", ["up", "down", "left"]]
  ],
  [ 
    ["Rum 2,0", ["right"]],["Rum 2,1", ["up", "right", "left"]],["Escape rum 2,2", ["left"]],["EMPTY 2,3", [""]],["Rum 2,4", ["up"]]
  ]
] #använda denna för att veta var man är och var man får gå

@pick_up_versions = ["ta up","ta","plocka upp"]
@inventory_versions = ["lager","inventory","väska"]
@operations = ["ta upp","läs", "up","höger","ner","lager", "vänster", "spara"]

def find_i(arr, item)
  i = 0
  while i < arr.length
    if arr[i] == item
      return i
    end
    i+=1
  end
end

def game(place, hp, inventory, save)

  #Ska kanske vara någon annan stans
  if save == true
    puts
    puts "---Save---"
    puts "Välkommen tillbaka!"
    puts "Du är i #{place} och har #{hp} HP"
    puts "Du har: #{inventory}"
    @inventory = inventory
  else
    puts "Du vaknar upp i en grotta"
    puts "Du minns ingenting..."
    puts "Du ser ett skrynkligt papper på golvet"
    input = gets.chomp.downcase

    while !@operations.include?(input)
      puts "Du kan inte göra så"
      puts "gör någonting som du kan göra
      "
      input = gets.chomp.downcase
    end
    i = 0    
    
    info = ["Du tar upp pappret från marken. Undrar om du kan läsa den","du har ingenting du kan läsa. Kanske borde du ta upp pappret från marken.
    ", "Du undersökte rummet uppåt, men du kanske skulle läst den där lappen
    "]
    while i < @operations.length
      if input == @operations[i]
        puts info[i]
      end
      i+=1
    end

    while input != @operations[0]
      input = gets.chomp
      while i < @operations.length
        if input == @operations[i]
          puts info[i]
        end
        i+=1
      end
    end
    puts info[0]

    input = gets.chomp.downcase
    while !@operations.include?(input)
      puts "Du kan inte göra så"
      puts "gör någonting som du kan göra"
      input = gets.chomp
    end

    info = ["Du kan inte ta upp något","JAG HAR KIDNAPPAT DIG OCH PLACERAT DIG I DÖSKALLEGROTTAN. MUHAHAHAHA. DU KOMMER ALRIG KOMMA HÄR IFRÅN. Du kan försöka utforska grottan genom att gå höger, vänster, up och ner samt plocka upp saker du stötter på mmr. MEN EGENTLIGEN ÄR DET MENINGSLÖST HIHIHIHI.
    ", "Du undersökte rummet uppåt, men du kanske skulle läst den där lappen
    "]
    while i < @operations.length
      if input == @operations[i]
        puts info[i]
      end
      i+=1
    end
    while input != @operations[1]
      input = gets.chomp
      while i < @operations.length
        if input == @operations[i]
          puts info[i]
        end
        i+=1
      end
    end
    puts info[1]
  end
  if input == "help"
    i = 0
    while i < @operations.length
      puts @operations[i]  
      i += 1  
    end
  end

end 

def save_game(place, hp, inventory)
  puts "What do you want the file to be named?"
  name = gets.chomp
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
  puts "--------"
  puts "Spelet har sparats" 
  return # avsluta spelet
end 

def load_game(save_file)

  while save_file != "1" && save_file != "2" && save_file != "3"
    puts "Skriv ett giltigt kommando, inte #{save_file}"
    save_file = gets.chomp
    puts ""
  end
  lines = File.readlines("save.txt")
  save = true
  index = save_file.to_i - 1
  row = lines[index].chomp
  row_parts = row.split(", ")
  place = row_parts[1]
  hp = row_parts[2]
  inventory = row_parts[3]

  game(place, hp, inventory, save)
end

def move_player(input, x_pos, y_pos)
  info_room = @dungeon_map[x_pos][y_pos]
  directions = info_room[1]
  if input == left && directions.include?(left)
    n_y = y_pos - 1
  elsif input == right && directions(right)
    n_y = y_pos + 1
  elsif input == up && directions(up)
    n_x = x_pos + 1
  elsif input == down && directions(down)
    n_x = x_pos - 1
  else 
    puts "Du kan inte gå åt det hållet"
    return [pos_x, pos_y]
  end  

  puts "Du går till #{@dungeon_map[n_y][n_x][0]}"
  return [n_x, n_y]
end # ska kolla om det finns en möjlighet att gå dit

def spawn_monster()
  slu = rand(1..4)
  if slu == 1
    what_mons = rand(1..4)
    if what_mons == 1
      return ["Golem", 10, ]
    elsif what_mons == 2
      return ["Goblin", 6, ]
    elsif what_mons == 3
      return ["Gigant", 15, ]
    else
      return ["Bear", 8, ]
    end  #name, hp, attack
  else 
    return nil
  end 
end 

def attack()
end # Du ska kunna attackera den attackerar och du kan skada den och jag kan bli skadad

start()

# attackera
# spara en fil
# Avslut med en nyckel för att komma ut
# 
#