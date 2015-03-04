#encoding: utf-8
Message.delete_all
Category.delete_all

s = Category.create(:name => "Self Help")
h = Category.create(:name => "Motivation")

Message.create([
                   {
                       :content => "Hang in there! Don't lose hope",
                       :category_id => s.id
                   },
                   {
                       :content => "Doing what you say gets you what you want.",
                       :category_id => s.id
                   },
                   {
                       :content => "Doing what I say gets me what I want.",
                       :category_id => s.id
                   },
                   {
                       :content => "I am enough. What I do is enough.",
                       :category_id => s.id
                   },
                   {
                       :content => "What matters most is how YOU see yourself.",
                       :category_id => s.id
                   },
                   {
                       :content => "What matters most is how I see myself.",
                       :category_id => s.id
                   },
                   {
                       :content => "Don't let your fears stand in the way of your dreams!",
                       :category_id => s.id
                   },
                   {
                       :content => "I am beautiful, inside and out.",
                       :category_id => s.id
                   },
                   {
                       :content => "I am worthy of love and I love myself.",
                       :category_id => s.id
                   },
                   {
                       :content => "I am grateful for all that I have.",
                       :category_id => s.id
                   },
                   {
                       :content => "My thoughts create my reality.",
                       :category_id => s.id
                   }

               ]
)


Message.create([
                   {
                       :content => "If you get knocked down 7 times, get up 8 times.",
                       :category_id => h.id
                   },
                   {
                       :content => "Either you run the day or the day runs you. -Jim Rohn",
                       :category_id => h.id
                   },
                   {
                       :content => "Effort only fully releases its reward after a person refuses to quit. -Napoleon Hill",
                       :category_id => h.id
                   },
                   {
                       :content => "Be miserable. Or motivate yourself. Whatever has to be done, it's always your choice. --Wayne Dyer",
                       :category_id => h.id
                   }
               ]
)