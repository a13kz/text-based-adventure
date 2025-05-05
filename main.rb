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
    ["Rum -2,0", ["right"], "Du står i ett mörkt och kallt stenrum. Väggarna är fuktiga och du hör droppande vatten. Ett svagt ljus sipprar in från en öppning till höger."],
    ["Rum -2,1", ["down", "right", "left"], "Ett dammigt bibliotek med trasiga hyllor. En vindpust blåser in från vänster, medan en trappa leder neråt. En gång sträcker sig också till höger."],
    ["Rum -2,2", ["left"], "En kammare med en sprucken spegel och blodfläckar på golvet. Det verkar finnas en väg tillbaka åt vänster."],
    ["EMPTY -2,3", [""]],
    ["EMPTY -2,4", [""]]
  ],
  [ 
    ["EMPTY -1,0", [""]],
    ["Rum -1,1", ["up", "down"], "Ett tomt stenrum med trasiga rep på marken. En stege leder uppåt och en gång går vidare neråt."],
    ["Rum -1,2", ["down"], "Här luktar det bränt, och askan yr i luften. Det finns bara en väg neråt."],
    ["EMPTY -1,3", [""]],
    ["EMPTY -1,4", [""]]
  ],
  [ 
    ["Rum 0,0", ["right"], "En fuktig cell med rostiga galler. Symboler på väggen pekar åt höger där ett järngaller är öppet."],
    ["Rum 0,1", ["up", "right", "left"], "Skuggor dansar på väggarna från facklor. Du hör steg ovanför dig, ett ljud ekar till vänster och längre fram leder gången högerut."],
    ["Rum 0,2", ["up", "right", "left"], "Gamla ben täcker golvet. En väg leder uppåt, en annan slingrar sig till vänster. Du ser även en öppning till höger."],
    ["Rum 0,3", ["down", "right", "left"], "Ett rum fyllt av rostiga vapen. En mörk trappa leder ner, men du kan också gå höger eller vänster."],
    ["Rum 0,4", ["down", "left"], "En trasig dörr hänger på sned. Något har klöst väggarna. Du kan ta dig ner eller smyga åt vänster."]
  ],
  [ 
    ["EMPTY 1,0", [""]],
    ["Rum -1,1", ["down", "right"], "En lång gång där klomärken pryder väggarna. Du ser en trappa ner och ett svagt sken från höger."],
    ["Rum 1,2", ["right", "left"], "En stor pelarsal där taket rasat in. Du ser öppningar både till vänster och höger."],
    ["Rum 1,3", ["up", "right", "left"], "En vind blåser kallt i korridoren. Du anar en stege uppåt och gångar till båda sidor."],
    ["Rum 1,4", ["up", "down", "left"], "Väggarna är täckta av svart sten. Du kan gå uppåt, fortsätta ner eller ta till vänster."]
  ],
  [ 
    ["Rum 2,0", ["right"], "Rummet är täckt av spindelväv. Något rör sig där framme, och en gång leder åt höger."],
    ["Rum 2,1", ["up", "right", "left"], "Ett träd växer genom taket. En väg går tillbaka uppåt, men du ser också stigar åt både vänster och höger."],
    ["Escape rum 2,2", ["left"]],
    ["EMPTY 2,3", [""]],
    ["Rum 2,4", ["up"], "En kammare fylld med sarkofager. En trappa leder upp mot mörkret."]
  ]
] #AI har skrivit beskrivningen till rumen

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
  if y == 0 && x == 0
  elsif y == 0 && x == 1
  elsif y == 0 && x == 2
  elsif y == 1 && x == 1
  elsif y == 1 && x == 2
  elsif y == 2 && x == 0
  elsif y == 2 && x == 1
  elsif y == 2 && x == 2
  elsif y == 2 && x == 3
  elsif y == 2 && x == 4
  elsif y == 3 && x == 1
  elsif y == 3 && x == 2
  elsif y == 3 && x == 3
  elsif y == 3 && x == 4
  elsif y == 4 && x == 0
  elsif y == 4 && x == 1
  elsif y == 4 && x == 2
  elsif y == 4 && x == 4
  else
  end
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
      return ["Golem", 10, 1..3]
    elsif what_mons == 2
      return ["Goblin", 6,  1..2]
    elsif what_mons == 3
      return ["Jätte", 15, 2..3]
    else
      return ["Björn", 8, 1..3]
    end  #name, hp, attack
  else 
    return nil
  end 
end 

def attack(monster_inf)
  mons_name = monster_inf[0]
  mons_hp = monster_inf[1]
  puts "En #{mons_name} attackerar dig!"
  puts "Skriv attack om för att attackera fienden"
end # Du ska kunna attackera den attackerar och du kan skada den och jag kan bli skadad

start()

# attackera
# spara en fil
# Avslut med en nyckel för att komma ut
# 
#