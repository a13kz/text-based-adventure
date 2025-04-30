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
  if input == 1
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
    input = gets.chomp
    load_game(input)
  end 
end

@dungeon_map = 
[
  [ 
    ["Rum 0,0", ["right", "down"]],
    ["Rum 0,1", ["left", "down"]],
    ["Rum 0,2", ["down"]]
  ],
  [ 
    ["Rum 1,0", ["up", "right"]],
    ["Rum 1,1", ["up", "down", "right", "left"]],
    ["Rum 1,2", ["up", "left"]]
  ],
  [ 
    ["Rum 2,0", ["rigth"]],
    ["Rum 2,1", ["left", "rigth"]],
    ["Rum 2,2", ["left"]]
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
    
  else
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


def move_player()
  
end # ska kolla om det finns en möjlighet att gå dit

start()

# Fixa dongeon map
# attackera
# spara en fil
# Avslut med en nyckel för att komma ut
# 
#