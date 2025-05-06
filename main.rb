@current_save_file_index = 0

@x = 2
@y = 2
@hp = 20
@alive = true

def setup()
  puts "Vänligen välj en spar fil"
  input = gets.chomp
  start_place = File.read
  start()
end

def start()
  puts "=== Välkommen till The Ultimate Challenge ==="
  puts "1. Ladda ett tidigare spel"
  puts "2. Starta ett nytt äventyr"
  puts "Ange 1 eller 2:"
  input = gets.chomp
  while input != "1" && input != "2" 
    input = gets.chomp
    puts "Välj ett giltigt kommando inte #{input}"
  end
  if input.to_i == 2
    @hp = 20 
    @x = 2
    @y = 2
    inventory = []
    save = false
    game(@x, @y, @hp, inventory, save)
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
    ["Rum 0,0", ["höger"], "Du står i ett mörkt och kallt stenrum. Väggarna är fuktiga och du hör droppande vatten. Ett svagt ljus sipprar in från en öppning till höger."],
    ["Rum 0,1", ["ner", "höger", "vänter"], "Ett dammigt bibliotek med trasiga hyllor. En vindpust blåser in från vänster, medan en trappa leder neråt. En gång sträcker sig också till höger."],
    ["Rum 0,2", ["vänster"], "En kammare med en sprucken spegel och blodfläckar på golvet. Det verkar finnas en väg tillbaka åt vänster."],
    ["EMPTY 0,3", [""]],
    ["EMPTY 0,4", [""]]
  ],
  [ 
    ["EMPTY 1,0", [""]],
    ["Rum 1,1", ["upp", "ner"], "Ett tomt stenrum med trasiga rep på marken. En stege leder uppåt och en gång går vidare neråt."],
    ["Rum 1,2", ["ner"], "Här luktar det bränt, och askan yr i luften. Det finns bara en väg neråt."],
    ["EMPTY 1,3", [""]],
    ["EMPTY 1,4", [""]]
  ],
  [ 
    ["Rum 2,0", ["höger"], "En fuktig cell med rostiga galler. Symboler på väggen pekar åt höger där ett järngaller är öppet."],
    ["Rum 2,1", ["upp", "höger", "vänster"], "Skuggor dansar på väggarna från facklor. Du hör steg ovanför dig, ett ljud ekar till vänster och längre fram leder gången högerut."],
    ["Rum 2,2", ["upp", "höger", "vänster"], "Gamla ben täcker golvet. En väg leder uppåt, en annan slingrar sig till vänster. Du ser även en öppning till höger."],
    ["Rum 2,3", ["ner", "höger", "vänster"], "Ett rum fyllt av rostiga vapen. En mörk trappa leder ner, men du kan också gå höger eller vänster."],
    ["Rum 2,4", ["ner", "vänster"], "En trasig dörr hänger på sned. Något har klöst väggarna. Du kan ta dig ner eller smyga åt vänster."]
  ],
  [ 
    ["EMPTY 3,0", [""]],
    ["Rum 3,1", ["ner", "höger"], "En lång gång där klomärken pryder väggarna. Du ser en trappa ner och ett svagt sken från höger."],
    ["Rum 3,2", ["höger", "vänster"], "En stor pelarsal där taket rasat in. Du ser öppningar både till vänster och höger."],
    ["Rum 3,3", ["upp", "höger", "vänster"], "En vind blåser kallt i korridoren. Du anar en stege uppåt och gångar till båda sidor."],
    ["Rum 3,4", ["upp", "ner", "vänster"], "Väggarna är täckta av svart sten. Du kan gå uppåt, fortsätta ner eller ta till vänster."]
  ],
  [ 
    ["Rum 4,0", ["höger"], "Rummet är täckt av spindelväv. Något rör sig där framme, och en gång leder åt höger."],
    ["Rum 4,1", ["upp", "höger", "vänster"], "Ett träd växer genom taket. En väg går tillbaka uppåt, men du ser också stigar åt både vänster och höger."],
    ["Escape rum 4,2", ["vänster"]],
    ["EMPTY 4,3", [""]],
    ["Rum 4,4", ["up"], "En kammare fylld med sarkofager. En trappa leder upp mot mörkret."]
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

@operations = ["ta upp","läs", "upp","höger","ner","lager", "vänster", "spara","hjälp","avsluta"]

def move_player(input)
  info_room = @dungeon_map[@y][@x]
  directions = info_room[1]
  if input == "vänster" && directions.include?("vänster")
    @x -= 1
  elsif input == "höger" && directions.include?("höger")
    @x += 1
  elsif input == "upp" && directions.include?("upp")
    @y-=1
  elsif input == "ner" && directions.include?("ner")
    @y+= 1
  else 
    puts "Du kan inte gå åt det hållet"
    return
  end
  puts "Du går till #{@dungeon_map[@y][@x][0]}"  
  check_room(@y,@x)
  return
end # ska kolla om det finns en möjlighet att gå dit



def check_room(y,x)
  puts "#{@dungeon_map[x][y][2]}" 
  if y == 0 && x == 0
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att, @hp)
    end 
  elsif y == 0 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 0 && x == 2
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 1 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 1 && x == 2
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 2 && x == 0
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 2 && x == 1
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 2 && x == 2
    puts "start"
  elsif y == 2 && x == 3
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 2 && x == 4
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 3 && x == 1
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 3 && x == 2
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 3 && x == 3
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 3 && x == 4
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 4 && x == 0
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 4 && x == 1
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 4 && x == 2
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att,@hp)
    end 
  elsif y == 4 && x == 4
    
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att, @hp)
    end 
  else
  end
end

def game(x,y, hp, inventory, save)

  #Ska kanske vara någon annan stans
  if save == true
    puts
    puts "---Save---"
    puts "Välkommen tillbaka!"
    #puts "Du är i #{@x,@y} och har #{@hp} HP"
    puts "Du har: #{@inventory}"
    puts @inventory
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
    while input != @operations[0]
      input = gets.chomp
      while i < @operations.length
        if input == @operations[i]        
          #puts info[i]
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

  update()
end 

def save_game()
  puts "What do you want the file to be named?"
  name = gets.chomp
  new_row = "#{name}, #{@x}, #{@y}, #{@hp}, #{@inventory}\n"
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
  puts "Spelet har sparats
  " 
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
  row_parts = row.split(",")
  @x = row_parts[1]
  @y = row_parts[2]
  @hp = row_parts[3]
  inventory = row_parts[4]

  game(@x,@y, @hp, inventory, save) #"name,place,{hp},inventory"
end

def spawn_monster()
  slu = rand(1..7)
  if slu == 1 || slu == 2
    what_mons = rand(1..4)
    if what_mons == 1
      return ["golem", 10, 1..3]
    elsif what_mons == 2
      return ["goblin", 6, 1..2]
    elsif what_mons == 3
      return ["jätte", 15, 2..3]
    else
      return ["björn", 8, 1..3]
    end  #name, hp, attack
  elsif slu == 3
    amount_hp = rand(3..4)
    puts "Du hittade en helnings dyck"
    puts "Du fick #{amount_hp}hp"
    
    return
  else 
    return nil
  end 
end 

def attack(monster_inf, hp) #20 == hp
  puts "----STRID----"
  mons_name = monster_inf[0]
  mons_hp = monster_inf[1]
  puts "En #{mons_name} attackerar dig!\n\n"
  while 0 < mons_hp
    puts "#{mons_name} har #{mons_hp}hp"
    damage = rand(monster_inf[2])
    @hp -= damage
    puts "Du tog #{damage} skada!"
    puts "Du har #{@hp}hp kvar."
    if @hp < 0
      puts "Du dog, spelet är över :("
      @alive = false
      return
    end
    puts "Skriv 'slå' om för att attackera fienden."
    input = gets.chomp
    puts ""
    while input != "slå"
      puts "skriv slå inte #{input}"
      input = gets.chomp
    end
    p_damage = rand(2..6)
    mons_hp -= p_damage
    puts "Du gjorde #{p_damage} skada"
    if mons_hp < 0
      puts "Du besegrade en #{mons_name}!"
    end
  end 
  if @hp > 15
    puts "Du har #{@hp}hp kvar"
  elsif @hp >= 7
    puts "Du har #{@hp}hp kvar. Var mer försiktig nästa gång"
  else
    puts "Du måste hitta en läkande dryck NU!! Du har endast #{@hp}hp kvar!"
  end 
  puts "----Slaget är över----"
end # Du ska kunna attackera den attackerar och du kan skada den och jag kan bli skadad

def help_list
  puts "\n === KOMMANDON DU KAN ANVÄNDA ==="
  puts "- upp / ner / höger / vänster: Flytta dig"
  puts "- ta upp: Plocka upp föremål"
  puts "- läs: Läs föremål som du plockat upp"
  puts "- lager: Visa din inventarie"
  puts "- spara: Spara spelet"
  puts "- hjälp: Visa denna lista"
  puts "- avsluta: Avsluta spelet
  "
end 

def take()
  
end

def read()

end


def quit()
  
end

def update()
  while @alive
    puts "update"
    input = gets.chomp
    if input == @operations[0]
      ta_upp()
    elsif input == @operations[1]
      read()
    elsif input == @operations[2]
      puts "upp"
      move_player(input)
    elsif input == @operations[3]
      puts "höger"
      move_player(input)
    elsif input == @operations[4]
      puts "ner"
      move_player(input)
    elsif input == @operations[5]
      puts "lager"
    elsif input == @operations[6]
      puts "vänster"
      move_player("vänster")
    elsif input == @operations[7]
      puts "spara"
      save_game()
    elsif input == @operations[8]
      help_list()
    elsif input == @operations[9]
      puts "avsluta"
      exit
    else
      puts "du kan inte göra så"
      puts "gör något man kan göra"
    end
  end
end
# spara en fil
# Avslut med en nyckel för att komma ut

#check_room(4,4)
start()