def game()
    meny()
end 


def meny()
  operations = ["s","q"]
  puts "---meny---"
  puts "välj kommando"
  puts "1. - start"
  puts "2. - quit"
  input = gets.chomp
  valid_checker_in2(input)
    if input == 1
        start()
    else 
        return
    end 
end

def quit(cause)
  if cause == "home"
    puts "Du valde att stanna hemma."
    puts "Din resa slutar här"
  end
end

def start()
    puts "Vaknar upp hemma..."
    puts "Välj mellan gå till skolan och stanna hemma"
    puts "1. - gå till skolan"
    puts "2. - stanna hemma"
    input = gets.chomp
    valid_checker_in2(input)
    if input.to_i == 1
      puts "fortsätt"
    else
      quit("home")
    end
end 

def valid_checker_in2(input)
    while input.to_i.to_s != input
        puts "Vänligen välj ett nummer. Inte #{input}"
        input = gets.chomp
        valid_checker_in2(input)
    end

    while input.to_i > 2 || input.to_i < 1
        puts "Vänligen välj mellan kommandon, 1 eller 2. Inte #{input}
        "
        input = gets.chomp
        valid_checker_in2(input)
    end
    return input
end


def save_game(name, place)
  new_row = "#{name}, #{plats}"
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
  
  File.write("save.txt", "#{name}, #{plats}")
  puts "Spelet har sparats" 
end 

def load_game #Välja mellan vilken fil man kan använda

end 

start()