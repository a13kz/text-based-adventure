@current_save_file_index = 0

@x = 2
@y = 2
@hp = 20
@name = ""
@damage = 1..3
@alive = true
@inventory = []

def start()
  puts "=== Välkommen till The Ultimate Challenge ==="
  puts "1. Starta ett nytt äventyr"
  puts "2. Ladda ett tidigare spel"
  puts "Ange 1 eller 2:"
  input = gets.chomp
  while input != "1" && input != "2" 
    puts "Välj ett giltigt kommando inte #{input}"
    input = gets.chomp
  end
  if input.to_i == 1
    @hp = 20 
    @x = 2
    @y = 2
    inventory = []
    save = false
    character_create()
    game(save)
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
      puts "Välj ett giltigt kommando inte #{input}"
      input = gets.chomp
    end
    load_game(input)
  end 
end


# Array för hur spelplanen ser ut
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

@operations = ["ta upp","läs", "upp","höger","ner","lager", "vänster", "spara","hjälp","avsluta"]

# Beskrivning: Funktionen beräknar med strängen 'argument1' vart spelaren är och genom en array 'directions' vilka riktningar som är tillåtna för spelaren att röra sig i.
# Argument1: Sträng - anger riktningen spelaren rör sig i.
# Return: förändring av @x eller @y
# Exempel:         
# move_player("vänster") ==> global variabel '@x' förändras ifall arrayen 'directions' tillåter det
# move_player("upp") ==> global variabel '@y' förändras ifall arrayen 'directions' tillåter det
# Datum: 2025-05-09
# Namn: Alexander, Sebastian

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
end 

def find_key()
  puts "Nu kan du ta nyckeln"
  input = gets.chomp.downcase
  if input == "ta upp"
    puts "Du tog upp nyckeln"
    @inventory << "key"
  else
    puts "Ta upp nyckeln så du kan komma ut"
  end

end

def escape()
  if @inventory.include?("key")
    puts "YAY! Du flydde från grottan."
  end
end

# Beskrivning: Funktionen beräknar genom spelarens koordinater dess position och kallar på funktionen 'spawn_monster' för att beräkna ifall ett 'monster' ska skapas samt ifall spelaren befinner sig i rum viktiga för spelet
# Argument1: Integer - anger spelarens nuvarande x-koordinat
# Argument2: Integer - anger spelarens nuvarande y-koordinat
# Return: Sträng - beskrivning av position
# Exempel:         
# check_room(0,0) ==> Gamla ben täcker golvet. En väg leder uppåt, en annan slingrar sig till vänster. Du ser även en öppning till höger.
# check_room(3,1) ==> En lång gång där klomärken pryder väggarna. Du ser en trappa ner och ett svagt sken från höger.
# Datum: 2025-05-09
# Namn: Alexander, Sebastian
def check_room(y,x)
  puts "#{@dungeon_map[@y][@x][2]}"
  if y == 0 && x == 0
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end
  elsif y == 0 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 
  elsif y == 0 && x == 2
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 
    puts "Wow en nyckel! Nu kanske du kan komma härifrån"
    find_key()
  elsif y == 1 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end
  elsif y == 1 && x == 2
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end  
  elsif y == 2 && x == 0
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 

  elsif y == 2 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 

  elsif y == 2 && x == 2 

  elsif y == 2 && x == 3
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 

  elsif y == 2 && x == 4
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end

  elsif y == 3 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end    

  elsif y == 3 && x == 2
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 
  
  elsif y == 3 && x == 3
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 

  elsif y == 3 && x == 4
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 

  elsif y == 4 && x == 0
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 
  
  elsif y == 4 && x == 1
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 
    
  elsif y == 4 && x == 2
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end
    escape()

  elsif y == 4 && x == 4
    there_att = spawn_monster()
    if there_att != nil
      attack(there_att)
    end 
    
  else
  end
end

def game(save)
puts "\n === Spelet börjar ==="
  if save == true
    puts "\n---Välkommen tillbaka #{@name}!---"
    puts "Du har #{@hp} HP"
    puts "Du befinner dig i: #{@dungeon_map[@y][@x][0]}"
    puts "#{@dungeon_map[@y][@x][2]}"
  else
    puts "\nDu vaknar upp i en grotta. Du minns ingenting..."
    puts "Ett skrynkligt papper ligger på marken framför dig. (Testa att `ta upp` pappret)"
    input = gets.chomp.downcase 

    while !@operations.include?(input)
      puts "Du kan inte göra så"
      puts "gör någonting som du kan göra
      "
      input = gets.chomp.downcase
    end
    i = 0    
    while input != @operations[0]
      puts "Nja sådär borde du inte göra... Du borde VERKLIGEN ta upp den lappen."
      input = gets.chomp
    end
    puts "\nDu tar upp pappret. Det kanske går att läsa..."
    
    input = gets.chomp.downcase
    while !@operations.include?(input)
      puts "Du kan inte göra så"
      puts "gör någonting som du kan göra"
      input = gets.chomp
    end
    while input != @operations[1]
      puts "Nja, du borde VERKLIGEN läsa den lappen"
      input = gets.chomp
    end
    puts "\nPå det skrynkliga pappret står det med darrig handstil:
  Jag har kidnappat dig #{@name} och släpat dig till Döskalleslottets djupaste grotta... MUHAHAHAHA!  
  Du kommer aldrig att ta dig härifrån.

  Visst #{@name}, du kan försöka utforska grottan – gå åt höger, vänster, upp eller ner...  
  Plocka upp vad du hittar om du vill...

  ...men det är fullständigt meningslöst.  
  HIHIHIHI.
  ~TEXT\n"

    puts "Du tittar först nu runt i rummet och ser: #{@dungeon_map[@y][@x][2]}"
  end

  update()
end 


# Beskrivning: Gör om alla globala värden som ska sparas till en gemensam sträng. Skriver över strängen till save.txt  
# Argument 1: Sträng - input från användaren för namn på för ny fil
# Return: nil/information om användarens input
# Exempel:
# save_game ==> Ange namn för sparfil: 'save_fil_1' ==> Spelet har sparats
# ...  ...  ...  ...
# ...  ...  ...  ...
# ...  ...  ...  ...               
# Datum: 2025-05-09
# Namn: Alexander, Sebastian

def save_game()
  puts "Ange namn för sparfil:"
  name = gets.chomp
  new_row = "#{name}, #{@x}, #{@y}, #{@hp}, #{@inventory}, #{@damage}, #{@name}\n"
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

# Beskrivning: Hämtar data från save.txt för definition av x,y,hp,inventory,damage och name. Dessa värden tilldelas til respektive global variabel.
# Argument 1: Sträng - användarinput för index av filen som ska väljas
#
# Return: tilldelar värde till globala variabler @x,@y,@hp,@inventory,@damage,@name
# Exempel:         
# load_game(1) => @x = row_parts[1].to_i, @y = row_parts[2].to_i, @hp = row_parts[3].to_i, inventory = row_parts[4], @damage = row_parts[5].to_i, @name = row_parts[6]           
# Datum: 2025-05-09
# Namn: Alexander, Sebastian

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
  @inventory = row_parts[4]
  @damage = row_parts[5].to_i
  @name = row_parts[6]
  game(save)
end

# Beskrivning: Funktionen beräknar sannolikheten att ett 'monster' skapas och returnerar dess egenskaper eller ifall en 'helningsdryck' ska skapas
# Argument: inga argument tas
# Return: array/nil: array med sträng för beskrivning av 'monstret' och integers för dess egenskaper, förändrar globala variablen @hp eller nil ifall monster ej skapas
# Exempel:         
# p spawn_monster() ==> Du hittade en helnings dyck! Du fick 2 HP
# p spawn_monster() ==> nil
# p spawn_monster() ==> ["jätte", 15, 2..3]
# Datum: 2025-05-09
# Namn: Alexander, Sebastian

def spawn_monster()
  slu = rand(1..4)
  if slu == 2 || slu == 1
    what_mons = rand(1..4)
    if what_mons == 1
      return ["golem", 10, 1..3]
    elsif what_mons == 2
      return ["goblin", 6, 1..2]
    elsif what_mons == 3
      return ["jätte", 15, 2..3]
    else
      return ["björn", 8, 1..3]
    end
  elsif slu == 3
    amount_hp = rand(2..3)
    puts "Du hittade en helnings dyck!"
    puts "Du fick #{amount_hp} HP"
    @hp += amount_hp
    return
  else 
    return nil
  end 
end 


def attack(monster_inf)
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

    if @hp <= 0
      puts "=== Du förlorade all din hälsa ==="
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
    p_damage = rand(@damage)
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
   puts "#{@dungeon_map[@y][@x][2]}"
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

def character_create
  puts "--- Karaktär skapande ---"
  puts "Namn på karaktär:"
  @name = gets.chomp
  puts "\nVilken klass vill du att #{@name} ska vara? "
  puts "1 - Warrior: (Medium hälsa, medium skada)"
  puts "2 - Assasin: (Lite hälsa, mycket skada)"
  puts "3 - Tank: (Mycket hälsa, lite skada)"
  puts "Ange 1, 2 eller 3:"
  input = gets.chomp

    while input != "1" && input != "2" && input != "3"
      puts "Välj ett giltigt kommando inte #{input}"
      input = gets.chomp
    end 
  if input == "1"
    @hp = 20
    @damage =  2..6
    puts "Du skapade Warrior-karaktären #{@name} med #{@hp} HP och 2-6 i skada."
  elsif input == "2"
    @hp = 15
    @damage =  3..8
    puts "Du skapade Assasin-karaktären #{@name} med #{@hp} HP och 3-8 i skada."
  else
    @hp = 25
    @damage = 1..4
    puts "Du skapade Tank-karaktären #{@name} med #{@hp} HP och 1-4 i skada."
  end 
  return
end 

def update()
  while @alive
    input = gets.chomp
    if input == @operations[0]
    elsif input == @operations[1]
    elsif input == @operations[2]
      move_player(input)
    elsif input == @operations[3]
      move_player(input)
    elsif input == @operations[4]
      move_player(input)
    elsif input == @operations[5]
    elsif input == @operations[6]
      move_player(input)
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

start()