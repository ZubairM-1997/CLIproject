def glasses_animation

    
        i = 1 
        while i < 43
            print "\033[2J"
            File.foreach("ascii_animation/#{i}.rb") { |f| puts f }
            sleep(0.05)
            i += 1
        end 
    
end 