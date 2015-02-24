#encoding: utf-8
Message.delete_all
Category.delete_all

b = Category.create(:name => "Business")
s = Category.create(:name => "Self Help")
h = Category.create(:name => "Health")

Message.create([
                   {
                       :content => "Business 1",
                       :category_id => b.id
                   },
                   {
                       :content => "Business 2",
                       :category_id => b.id
                   },
                   {
                       :content => "Business 3",
                       :category_id => b.id
                   }
               ]
)

Message.create([
                   {
                       :content => "Self Help 1",
                       :category_id => s.id
                   },
                   {
                       :content => "Self Help 2",
                       :category_id => s.id
                   },
                   {
                       :content => "Self Help 3",
                       :category_id => s.id
                   }
               ]
)

Message.create([
                   {
                       :content => "Health 1",
                       :category_id => h.id
                   },
                   {
                       :content => "Health 2",
                       :category_id => h.id
                   },
                   {
                       :content => "Health 3",
                       :category_id => h.id
                   }
               ]
)