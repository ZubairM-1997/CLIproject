$goodbyes ={
    1 => "May the Force be with you.",
    2 => "After all, tomorrow is another day.",
    3 => "I'll be back.",
    4 => "Hasta la vista, baby.",
    5 => "In case I don't see you - good afternoon, good evening, and goodnight!",
    6 => "All right, folks, you've seen enough. Come on. Move along. Now, come on, clear the sidewalk.",
    7 => "The hardest choices require the strongest wills."
}


$greetings = {
    1 => "Say hello to my little friend!",
    2 => "Heeeeere's Johnny!",
    3 => "I want to play a game.",
    4 => "To infinity and beyond!",
    5 => "It's clobberin time!",
    6 => "Youve got to ask yourself one question, 'Do I feel lucky?' - well, do ya punk?",
    7 => "The first rule of Fight Club is, you do not talk about Fight Club.",
    8 => "All we have to decide is what to do with the time that is given to us.",
    9 => "Great men are not born great, they grow great.",
    10 => "The truth is... I am Iron Man.",
    11 => "Great Scott!",
    12 => "Luke, I am your father!",
    13 => "Look at me. I'm the captain now."
}


$errors = {
    1 => "Do, or do not, there is no try.",
    2 => "Never give up, never surrender!",
    3 => "Toto, I have a feeling we're not in Kansas anymore.",
    4 => "Why do we fall, sir? So that we can learn to pick ourselves up.",
    5 => "Why so serious?",
    6 => "Fasten your seatbelts. It's going to be a bumpy night.",
    7 => "You're gonna need a bigger boat",
    8 => "Houston, we have a problem.",
    9 => "I'm going to have to science the **** out of this.",
    10 => "I am Groot!",
    11 => "You shall not pass!",
    12 => "What we've got here is a failure to communicate!"
}



def random_quotes_generator(type)
        puts type[rand(1..type.length)]
end 



