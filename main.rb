@current_save_file_index = 0

@x = 2
@y = 2
@hp = 20
@alive = true

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
    puts "\n=== Laddade sparfiler ==="
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
    puts "Vänligen välj det nummer av sparfil att fortsätta ditt äventyr med (1-3):"
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
    ["Rum 4,4", ["upp"], "En kammare fylld med sarkofager. En trappa leder upp mot mörkret."]
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
    puts "\n=== Samma rum ==="
    puts "Du kan inte gå åt det hållet. En vägg blockerar vägen."
    return
  end
  puts "\n=== #{@dungeon_map[@y][@x][0]} ==="  
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
puts "\n === Spelet börjar ==="
  #Ska kanske vara någon annan stans
  if save == true
    puts "\n---Välkommen tillbaka!---"
    puts "Du har #{@hp} HP"
    puts "Du befinner dig i: #{@dungeon_map[y][x][0]}"
    puts "#{@dungeon_map[y][x][2]}"
  else
    puts "\nDu vaknar upp i en grotta. Du minns ingenting..."
    puts "Ett skrynkligt papper ligger på marken framför dig."
    input = gets.chomp.downcase

    while !@operations.include?(input)
      puts "Du kan inte göra så"
      puts "gör någonting som du kan göra
      "
      input = gets.chomp.downcase
    end
    i = 0    
    
    info = ["\nDu tar upp pappret. Det kanske går att läsa...","du har ingenting du kan läsa. Kanske borde du ta upp pappret från marken.
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

    info = ["Du kan inte ta upp något","\nPå det skrynkliga pappret står det med darrig handstil:
  Jag har kidnappat dig och släpat dig till Döskalleslottets djupaste grotta... MUHAHAHAHA!  
  Du kommer aldrig att ta dig härifrån.

  Visst, du kan försöka utforska grottan – gå åt höger, vänster, upp eller ner...  
  Plocka upp vad du hittar om du vill...

  ...men det är fullständigt meningslöst.  
  HIHIHIHI.
  ~TEXT\n", "Du undersökte rummet uppåt, men du kanske skulle läst den där lappen
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
    puts "#{info[1]}"
    puts "Du tittar först nu runt i rummet och ser: #{@dungeon_map[y][x][2]}"
  end

  update()
end 

def save_game()
  puts "Ange namn för sparfil:"
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
  puts "\n--------"
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
  @x = row_parts[1].to_i
  @y = row_parts[2].to_i
  @hp = row_parts[3].to_i
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
  puts "\nDu hamnade i en strid"
  puts "----STRID----"
  mons_name = monster_inf[0]
  mons_hp = monster_inf[1]
  puts "En #{mons_name} dyker fram ur skuggorna och anfaller dig!\n\n"
  while 0 < mons_hp
    puts "#{mons_name} har #{mons_hp} HP kvar."
    damage = rand(monster_inf[2])
    @hp -= damage
    puts "#{mons_name} attackerar dig och orsakar #{damage} skada!"
    puts "Du har #{@hp}HP kvar."

    if @hp < 0
      puts "Du föll i striden... Spelet är över."
      @alive = false
      return
    end

    puts "Skriv 'slå' för att slå tillbaka!"
    input = gets.chomp
    puts ""
    while input != "slå"
      puts "Skriv slå, inte #{input}"
      input = gets.chomp
    end
    p_damage = rand(2..6)
    mons_hp -= p_damage
    puts "Du gjorde #{p_damage} skada"

    if mons_hp < 0
      puts "Du besegrat #{mons_name}!"
    end

  end 
  if @hp > 15
    puts "Du klarade dig bra – #{@hp} HP kvar."
  elsif @hp >= 7
    puts "Du klarade det, men du är sårad – #{@hp} HP kvar. Var försiktigare nästa gång!"
  else
    puts "Du är nära döden – endast #{@hp} HP kvar! Hitta en läkande dryck omedelbart!"
  end 
  puts "----Slaget är över----"
  puts "\n#{@dungeon_map[@x][@y][2]}"
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
    input = gets.chomp
    if input == @operations[0]
      ta_upp()
    elsif input == @operations[1]
      read()
    elsif input == @operations[2]
      move_player(input)
    elsif input == @operations[3]
      move_player(input)
    elsif input == @operations[4]
      move_player(input)
    elsif input == @operations[5]
    elsif input == @operations[6]
      move_player("vänster")
    elsif input == @operations[7]
      save_game()
    elsif input == @operations[8]
      help_list()
    elsif input == @operations[9]
      puts "\nTack för att du spelade!"
      exit
    else
      puts "Ogiltigt kommando: #{input}. Skriv 'hjälp' för en lista."
    end
  end
end
# spara en fil
# Avslut med en nyckel för att komma ut

#check_room(4,4)
start()