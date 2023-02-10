# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
size = [ 'S', 'M', 'L', 'XL' ]
size2 = [36, 37, 39, 40, 41, 42]

# Admin
# admin1 = User.new(
#   email: 'nvdatdev@gmail.com',
#   name: 'Nguyen Van Dat',
#   phone: '0327618979',
#   gender: 'male',
#   password: 'd@T24022001@',
#   password_confirmation: 'd@T24022001@',
#   is_admin: true
# )
# admin1.avatar.attach({io: File.open(Rails.root + "app/assets/images/admin/avatars/user.jpg"), filename: "user.jpg"})
# admin1.save
# admin1.roles.create!(name: 'admin')

# admin2 = User.new(
#   email: 'datrepost01@gmail.com',
#   name: 'Nguyen Quang Dat',
#   phone: '0372300544',
#   gender: 'male',
#   password: 'd@T24022001@',
#   password_confirmation: 'd@T24022001@',
#   is_admin: true
# )
# admin2.avatar.attach({io: File.open(Rails.root + "app/assets/images/admin/avatars/user.jpg"), filename: "user.jpg"})
# admin2.save
# admin2.roles.create!(name: 'admin')

# User
# 50.times do
#   user = User.new(
#     email: Faker::Internet.email,
#     name: Faker::Name.name,
#     phone: '0984235062',
#     gender: 'male',
#     password: 'd@T24022001@',
#     password_confirmation: 'd@T24022001@',
#   )
#   user.skip_confirmation!
#   user.avatar.attach({io: File.open(Rails.root + "app/assets/images/admin/avatars/user.jpg"), filename: "user.jpg"})
#   user.save
# end

# Brand.create!([
#   # Men sports shoes
#   { title: 'PUMA' }, { title: 'SFR' }, { title: 'HOTSTYLE' }, { title: 'World Wear Footwear' }, { title: 'BIRDE' },
#   # Men casual shoes
#   { title: 'Nobelite' }, { title: 'RapidBox' }, { title: 'TR' }, { title: 'Magnolia' },
#   # Men formal shoes
#   { title: 'KNIGHT WALKERS' }, { title: 'ACTION' }, { title: 'Kraasa' }, { title: 'aadi' }, { title: 'Bata' },
#   # Men sandals floaters
#   { title: 'Paragon' }, { title: 'VECHLO' },
#   # Men flips flops
#   { title: 'SOLETHREADS' }, { title: 'CALIBREL' }, { title: 'RootBook' },
#   # Men loadfers-type
#   { title: 'Funny Fire' }, { title: 'Krors' }, { title: 'KILLER' },
#   # Men boots
#   { title: 'SamTopShoes' }, { title: 'vipfarmer' },
#   # Men running shoes
#   { title: 'Sparx' }, { title: 'asian' },
#   # Men sneakers
#   { title: 'BRIDE' }, { title: 'Footox' }, { title: 'Labbin' },
#   # Men grooming not brands
#   # Men T Shirts
#   { title: "LEVI'S" }, { title: 'pariferry' }, { title: 'London Hills' }, { title: '3BROS' }, { title: 'NB NICKY BOY' },

#   ## Men Formal Shirts
#   { title: 'VeBNoR' }, { title: 'GHPC' }, { title: 'MILDIN' }, { title: 'WOXEN' }, { title: 'LF Fashion' },
#   # Men Casual Shirts
#   { title: 'TRIPR' }, { title: 'Surhi' }, { title: 'Jai Textiles' }, { title: 'FUBAR' }, { title: 'VTEXX' },
#   # Men Jeans
#   { title: 'U.S. Polo Assn. Denim Co.' }, { title: 'U.S. POLO ASSN.' }, { title: 'Lzard' }, { title: 'PROVOGUE' }, { title: 'FOSEN' },
#   # Men's Casual Trousers
#   { title: 'Raymond' }, { title: 'CYPHUS' }, { title: 'MOONVELLY' },
#   # Men Formal Trousers
#   { title: 'METRONAUT By Flipkart' }, { title: 'SREY' }, { title: 'PARK AVENUE' },
#   # Men's Track Pants
#   { title: 'AVOLT' }, { title: 'Foxter' }, { title: 'IRHA' }, { title: 'QFABRIX' },
#   # Men shorts
#   { title: 'Simmaa' }, { title: 'INDICLUB' },
#   # Men's Cargos
#   { title: 'GYRFALCON' }, { title: 'BLIVE' }, { title: 'Plus91' }, { title: 'HIGHLANDER' },
#   # Men's Three Fourths
#   { title: 'FEEL TRACK' }, { title: 'Diwazzo' }, { title: 'Guide' }, { title: 'FastColors' }, { title: 'Jhanjari' },
#   # Men's Sweatshirts
#   { title: 'EyeBogler' }, { title: 'REGALIA PROCOT' }, { title: 'VAN HEUSEN' }, { title: 'Alan Jones' },

#   ## Men's Jackets
#   { title: 'RED TAPE' }, { title: 'MONTREZ' }, { title: 'Fort Collins' },
#   # Men's Sweaters
#   { title: 'Indian Threads' }, { title: 'hanifa crystals' }, { title: 'Roadster' }, { title: 'BASE 41' }, { title: 'Mast & Harbour' },
#   # Men's Tracksuits
#   { title: 'XYXX' }, { title: 'Chrome & Coral' }, { title: 'KZALCON' },
#   # Men's Kurtas
#   { title: 'DADUSAG' }, { title: 'TIGERSNAKE' }, { title: 'Tap in' }, { title: 'CHENECLOTH' },
#   #
#   # { title: '' }, { title: '' }, { title: '' }, { title: '' }, { title: '' },
# ])

# parent_categories = [
#   { title: 'Men Footwear',    meta_title: 'Footwear',    content: 'Men Footwear' },
#   { title: 'Men Grooming',    meta_title: 'Grooming',    content: 'Men Grooming' },
#   { title: 'Men Top wear',    meta_title: 'Top wear',    content: 'Men Topwear' },
#   { title: 'Men Bottom wear', meta_title: 'Bottom wear', content: 'Men Bottomwear' },
#   { title: 'Men Winter wear', meta_title: 'Winter wear', content: 'Men Winterwear' },
#   { title: 'Men Ethnic wear', meta_title: 'Ethnic wear', content: 'Men Ethnic wear'},

#   { title: 'Women Western & Maternity wear', meta_title: 'Western & Maternity wear', content: 'Women Western & Maternity wear' },
#   { title: 'Women Lingerie & Sleepwear',     meta_title: 'Lingerie & Sleepwear',     content: 'Women Lingerie & Sleepwear' },
#   { title: 'Women Ethnic wear',              meta_title: 'Ethnic wear',              content: 'Women Ethnic wear' },
#   { title: 'Women Ethnic bottoms',           meta_title: 'Ethnic bottoms',           content: 'Women Ethnic bottoms' },
#   { title: 'Women Shoes',                    meta_title: 'Shoes',                    content: 'Women Shoes' },
#   { title: 'Women Beauty & Grooming',        meta_title: 'Beauty & Grooming',        content: 'Women Beauty & Grooming' }
# ]
# Category.create!(parent_categories)
# child_categories = [
#   # Men Footwear id: 1
#   { title: 'Men Sports Shoes',       meta_title: 'Sports Shoes',       content: 'Men Sports Shoes',       category_id: 1 },
#   { title: 'Men Casual Shoes',       meta_title: 'Casual Shoes',       content: 'Men Casual Shoes',       category_id: 1 },
#   { title: 'Men Formal Shoes',       meta_title: 'Formal Shoes',       content: 'Men Formal Shoes',       category_id: 1 },
#   { title: 'Men Sandals & Floaters', meta_title: 'Sandals & Floaters', content: 'Men Sandals & Floaters', category_id: 1 },
#   { title: 'Men Flip-Flops',         meta_title: 'Flip-Flops',         content: 'Men Flip-Flops',         category_id: 1 },
#   { title: 'Men Loafers',            meta_title: 'Loafers',            content: 'Men Loafers',            category_id: 1 },
#   { title: 'Men Boots',              meta_title: 'Boots',              content: 'Men Boots',              category_id: 1 },
#   { title: 'Men Running Shoes',      meta_title: 'Running Shoes',      content: 'Men Running Shoes',      category_id: 1 },
#   { title: 'Men Sneakers',           meta_title: 'Sneakers',           content: 'Men Sneakers',           category_id: 1 },

#   # Men Grooming id: 2
#   { title: 'Men Deodorants',            meta_title: 'Deodorants',            content: 'Men Deodorants',            category_id: 2 },
#   { title: 'Men Perfumes',              meta_title: 'Perfumes',              content: 'Men Perfumes',              category_id: 2 },
#   { title: 'Men Beard Care & Grooming', meta_title: 'Beard Care & Grooming', content: 'Men Beard Care & Grooming', category_id: 2 },
#   { title: 'Men Shaving & Aftershare',  meta_title: 'Shaving & Aftershare',  content: 'Men Shaving & Aftershare',  category_id: 2 },
#   { title: 'Men Sexual Wellness',       meta_title: 'Sexual Wellness',       content: 'Men Sexual Wellness',       category_id: 2 },

#   # Men Top wear id: 3
#   { title: 'Men T-Shirts',      meta_title: 'T-Shirts',      content: 'Men T-Shirts', category_id: 3 },
#   { title: 'Men Formal Shirts', meta_title: 'Formal Shirts', content: 'Men Formal Shirts', category_id: 3 },
#   { title: 'Men Casual Shirts', meta_title: 'Casual Shirts', content: 'Men Casual Shirts', category_id: 3 },

#   # Men Bottom wear id: 4
#   { title: 'Men Jeans',           meta_title: 'Jeans',           content: 'Men Jeans',           category_id: 4 },
#   { title: 'Men Casual Trousers', meta_title: 'Casual Trousers', content: 'Men Casual Trousers', category_id: 4 },
#   { title: 'Men Formal Trousers', meta_title: 'Formal Trousers', content: 'Men Formal Trousers', category_id: 4 },
#   { title: 'Men Track pants',     meta_title: 'Track pants',     content: 'Men Track pants',     category_id: 4 },
#   { title: 'Men Shorts',          meta_title: 'Shorts',          content: 'Men Shorts',          category_id: 4 },
#   { title: 'Men Cargos',          meta_title: 'Cargos',          content: 'Men Cargos',          category_id: 4 },
#   { title: 'Men Three Fourths',   meta_title: 'Three Fourths',   content: 'Men Three Fourths',   category_id: 4 },

#   # Men Winter wear id: 5
#   { title: 'Men Sweatshirts', meta_title: 'Sweatshirts', content: 'Men Sweatshirts', category_id: 5 },
#   { title: 'Men Jackets',     meta_title: 'Jackets',     content: 'Men Jackets',     category_id: 5 },
#   { title: 'Men Sweater',     meta_title: 'Sweater',     content: 'Men Sweater',     category_id: 5 },
#   { title: 'Men Tracksuits',  meta_title: 'Tracksuits',  content: 'Men Tracksuits',  category_id: 5 },

#   # Men Ethnic wear id: 6
#   { title: 'Men Kurta',         meta_title: 'Kurta',         content: 'Men Kurta',         category_id: 6 },
#   { title: 'Men Ethnic Sets',   meta_title: 'Ethnic Sets',   content: 'Men Ethnic Sets',   category_id: 6 },
#   { title: 'Men Sherwanis',     meta_title: 'Sherwanis',     content: 'Men Sherwanis',     category_id: 6 },
#   { title: 'Men Ethnic Pyjama', meta_title: 'Ethnic Pyjama', content: 'Men Ethnic Pyjama', category_id: 6 },
#   { title: 'Men Dhoti',         meta_title: 'Dhoti',         content: 'Men Dhoti',         category_id: 6 },
#   { title: 'Men Lungi',         meta_title: 'Lungi',         content: 'Men Lungi',         category_id: 6 },

#   # Women Western & Maternity wear id: 7
#   { title: 'Women Topwear',           meta_title: 'Topwear',           content: 'Women Topwear',           category_id: 7 },
#   { title: 'Women Dresses',           meta_title: 'Dresses',           content: 'Women Dresses',           category_id: 7 },
#   { title: 'Women Jeans',             meta_title: 'Jeans',             content: 'Women Jeans',             category_id: 7 },
#   { title: 'Women Shorts',            meta_title: 'Shorts',            content: 'Women Shorts',            category_id: 7 },
#   { title: 'Women Skirts',            meta_title: 'Skirts',            content: 'Women Skirts',            category_id: 7 },
#   { title: 'Women Jeggings & Tights', meta_title: 'Jeggings & Tights', content: 'Women Jeggings & Tights', category_id: 7 },
#   { title: 'Women Trousers & Capris', meta_title: 'Trousers & Capris', content: 'Women Trousers & Capris', category_id: 7 },

#   # # Women Lingerie & Sleepwear id: 8
#   { title: 'Women Bras',                     meta_title: 'Bras',                     content: 'Women Bras',                     category_id: 8 },
#   { title: 'Women Panties',                  meta_title: 'Panties',                  content: 'Women Panties',                  category_id: 8 },
#   { title: 'Women Lingerie Sets',            meta_title: 'Lingerie Sets',            content: 'Women Lingerie Sets',            category_id: 8 },
#   { title: 'Women Night Dresses & Nighties', meta_title: 'Night Dresses & Nighties', content: 'Women Night Dresses & Nighties', category_id: 8 },
#   { title: 'Women Shapewear',                meta_title: 'Shapewear',                content: 'Women Shapewear',                category_id: 8 },
#   { title: 'Women Camisoles & Slips',        meta_title: 'Camisoles & Slips',        content: 'Women Camisoles & Slips',        category_id: 8 },

#   # Women Ethnic wear id: 9
#   { title: 'Women Sarees',                    meta_title: 'Sarees',                    content: 'Women Sarees',                    category_id: 9 },
#   { title: 'Women Kurtas& Kurtis',            meta_title: 'Kurtas& Kurtis',            content: 'Women Kurtas& Kurtis',            category_id: 9 },
#   { title: 'Women Dress Material',            meta_title: 'Dress Material',            content: 'Women Dress Material',            category_id: 9 },
#   { title: 'Women Lehenga Choli',             meta_title: 'Lehenga Choli',             content: 'Women Lehenga Choli',             category_id: 9 },
#   { title: 'Women Blouse',                    meta_title: 'Blouse',                    content: 'Women Blouse',                    category_id: 9 },
#   { title: 'Women Kurta Sets & Salwar Suits', meta_title: 'Kurta Sets & Salwar Suits', content: 'Women Kurta Sets & Salwar Suits', category_id: 9 },
#   { title: 'Women Gowns',                     meta_title: 'Gowns',                     content: 'Women Gowns',                     category_id: 9 },
#   { title: 'Women Dupattas',                  meta_title: 'Dupattas',                  content: 'Women Dupattas',                  category_id: 9 },

#   # Women Ethnic bottoms id: 10
#   { title: 'Women Leggings & Churidars',         meta_title: 'Leggings & Churidars',         content: 'Women Leggings & Churidars',         category_id: 10 },
#   { title: 'Women Palazzos',                     meta_title: 'Palazzos',                     content: 'Women Palazzos',                     category_id: 10 },
#   { title: 'Women Shararas',                     meta_title: 'Shararas',                     content: 'Women Shararas',                     category_id: 10 },
#   { title: 'Women Salwars & Patiala',            meta_title: 'Salwars & Patiala',            content: 'Women Salwars & Patiala',            category_id: 10 },
#   { title: 'Women Dhoti Pants',                  meta_title: 'Dhoti Pants',                  content: 'Women Dhoti Pants',                  category_id: 10 },
#   { title: 'Women Ethnic Trousers',              meta_title: 'Ethnic Trousers',              content: 'Women Ethnic Trousers',              category_id: 10 },
#   { title: 'Women Saree Shapewear & Petticoats', meta_title: 'Saree Shapewear & Petticoats', content: 'Women Saree Shapewear & Petticoats', category_id: 10 },

#   # Women Shoes id: 11
#   { title: 'Women Sports Shoes', meta_title: 'Sports Shoes', content: 'Women Sports Shoes', category_id: 11 },
#   { title: 'Women Casual Shoes', meta_title: 'Casual Shoes', content: 'Women Casual Shoes', category_id: 11 },
#   { title: 'Women Boots',        meta_title: 'Boots',        content: 'Women Boots',        category_id: 11 },

#   # Women Beauty & Grooming id: 12
#   { title: 'Women Make Up',               meta_title: 'Make Up',               content: 'Women Make Up',               category_id: 12 },
#   { title: 'Women Skin Care',             meta_title: 'Skin Care',             content: 'Women Skin Care',             category_id: 12 },
#   { title: 'Women Hair Care',             meta_title: 'Hair Care',             content: 'Women Hair Care',             category_id: 12 },
#   { title: 'Women Bath & Spa',            meta_title: 'Bath & Spa',            content: 'Women Bath & Spa',            category_id: 12 },
#   { title: 'Women Deodorants & Perfumes', meta_title: 'Deodorants & Perfumes', content: 'Women Deodorants & Perfumes', category_id: 12 },
# ]
# Category.create!(child_categories)

# # Product 1
# pr1 = Product.new(
#   title: 'FAST Trenddy Tainer Lace-ups Sporty Casuals Running Shoes For Men',
#   meta_title: 'FAST Trenddy Tainer Lace-ups Sporty Casuals Running Shoes For Men',
#   price: 13,
#   discount: 0.62,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:show]
# )
# (2..7).each do |i|
#   pr1.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr1/#{i}.jpeg"), filename: "#{i}.jpeg"])
# end

# attribute_11 = pr1.product_attributes.build(name: 'color')
# attribute_12 = pr1.product_attributes.build(name: 'size')
# attribute_11.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr1/1.jpeg"), filename: "1.jpeg"])

# attribute_11.save!
# attribute_12.save!

# pr1.product_categories.create!(category_id: 13)
# quantity1 = 0
# size2.each do |size|
#   quantity = rand(1..20)
#   quantity1 += quantity
#   attribute_value = AttributeValue.create!(
#     attribute_1: 'White',
#     attribute_2: size,
#     price_attribute_product: 13,
#     discount_attribute_product: 0.62,
#     stock: quantity
#   )
#   attribute_11.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   attribute_12.product_attribute_values.create!(attribute_value_id: attribute_value.id)
# end
# pr1.quantity = quantity1 unless quantity1.zero?
# pr1.save!

# # Product 2
# pr2 = Product.new(
#   title: 'Running Shoes For Men',
#   meta_title: 'Running Shoes For Men',
#   price: 12.3,
#   discount: 0.6,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:show]
# )
# (2..5).each do |i|
#   pr2.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr2/#{i}.jpeg"), filename: "#{i}.jpeg"])
# end

# attribute_21 = pr2.product_attributes.build(name: 'color')
# attribute_22 = pr2.product_attributes.build(name: 'size')
# attribute_21.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr2/1.jpeg"), filename: "1.jpeg"])

# attribute_21.save!
# attribute_22.save!

# pr2.product_categories.create!(category_id: 13)
# quantity2 = 0
# size2.each do |size|
#   quantity = rand(1..20)
#   quantity2 += quantity
#   attribute_value = AttributeValue.create!(
#     attribute_1: 'Black',
#     attribute_2: size,
#     price_attribute_product: 12.3,
#     discount_attribute_product: 0.6,
#     stock: quantity
#   )
#   attribute_21.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   attribute_22.product_attribute_values.create!(attribute_value_id: attribute_value.id)
# end
# pr2.quantity = quantity2 unless quantity2.zero?
# pr2.save!

# # Product 3
# pr3 = Product.new(
#   title: "ROCKY Sports Shoes For Men's Running Shoes For Men ",
#   meta_title: "ROCKY Sports Shoes For Men's Running Shoes For Men ",
#   price: 7.3,
#   discount: 0.5,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:hide]
# )
# (2..5).each do |i|
#   pr3.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr3/#{i}.jpeg"), filename: "#{i}.jpeg"])
# end

# attribute_31 = pr3.product_attributes.build(name: 'color')
# attribute_32 = pr3.product_attributes.build(name: 'size')
# attribute_31.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr3/1.jpeg"), filename: "1.jpeg"])

# attribute_31.save!
# attribute_32.save!

# pr3.product_categories.create!(category_id: 13)
# quantity3 = 0
# size2.each do |size|
#   quantity = rand(1..20)
#   quantity3 += quantity
#   attribute_value = AttributeValue.create!(
#     attribute_1: 'Black',
#     attribute_2: size,
#     price_attribute_product: 7.3,
#     discount_attribute_product: 0.5,
#     stock: quantity
#   )
#   attribute_31.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   attribute_32.product_attribute_values.create!(attribute_value_id: attribute_value.id)
# end
# pr3.quantity = quantity3 unless quantity3.zero?
# pr3.save!

# # Product 4
# pr4 = Product.new(
#   title: '2003 Trenddy Fashion Sporty Casuals Sneakers Running Shoes Walking Shoes For Men',
#   meta_title: '2003 Trenddy Fashion Sporty Casuals Sneakers Running Shoes Walking Shoes For Men',
#   price: 8.2,
#   discount: 0.45,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:show]
# )
# (2..6).each do |i|
#   pr4.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr4/#{i}.jpeg"), filename: "#{i}.jpeg"])
# end

# attribute_41 = pr4.product_attributes.build(name: 'color')
# attribute_42 = pr4.product_attributes.build(name: 'size')
# attribute_41.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr4/1.jpeg"), filename: "1.jpeg"])

# attribute_41.save!
# attribute_42.save!

# pr4.product_categories.create!(category_id: 13)
# quantity4 = 0
# size2.each do |size|
#   quantity = rand(1..20)
#   quantity4 += quantity
#   attribute_value = AttributeValue.create!(
#     attribute_1: 'White',
#     attribute_2: size,
#     price_attribute_product: 8.2,
#     discount_attribute_product: 0.45,
#     stock: quantity
#   )
#   attribute_41.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   attribute_42.product_attribute_values.create!(attribute_value_id: attribute_value.id)
# end
# pr4.quantity = quantity4 unless quantity4.zero?
# pr4.save!

# # Product 5
# pr5 = Product.new(
#   title: 'Training & Gym Shoes For Men',
#   meta_title: 'Training & Gym Shoes For Men',
#   price: 10.9,
#   discount: 0.58,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:show]
# )
# (2..4).each do |i|
#   pr5.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr5/black_#{i}.jpeg"), filename: "black_#{i}.jpeg"])
# end
# (2..3).each do |i|
#   pr5.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr5/blue_#{i}.jpeg"), filename: "blue_#{i}.jpeg"])
# end
# (2..4).each do |i|
#   pr5.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr5/grey_#{i}.jpeg"), filename: "grey_#{i}.jpeg"])
# end

# attribute_51 = pr5.product_attributes.build(name: 'color')
# attribute_52 = pr5.product_attributes.build(name: 'size')
# ['black', 'blue', 'grey'].each do |color|
#   attribute_51.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr5/#{color}_1.jpeg"), filename: "#{color}_1.jpeg"])
# end

# attribute_51.save!
# attribute_52.save!

# pr5.product_categories.create!(category_id: 13)
# color5s = ['Black', 'Blue', 'Grey']
# quantity5 = 0
# color5s.each do |color|
#   size2.each do |size|
#     quantity = rand(1..20)
#     quantity5 += quantity
#     attribute_value = AttributeValue.create!(
#       attribute_1: color,
#       attribute_2: size,
#       price_attribute_product: 10.9,
#       discount_attribute_product: 0.58,
#       stock: quantity
#     )
#     attribute_51.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#     attribute_52.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   end
# end
# pr5.quantity = quantity5 unless quantity5.zero?
# pr5.save!

# # Product 6
# pr6 = Product.new(
#   title: '2007 Trenddy Tainer Lace-ups Sporty Casuals Running Shoes For Men',
#   meta_title: '2007 Trenddy Tainer Lace-ups Sporty Casuals Running Shoes For Men',
#   price: 11.9,
#   discount: 0.6,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:show]
# )
# (2..4).each do |i|
#   pr6.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr6/black_#{i}.jpeg"), filename: "black_#{i}.jpeg"])
# end
# (2..4).each do |i|
#   pr6.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr6/grey_#{i}.jpeg"), filename: "grey_#{i}.jpeg"])
# end

# attribute_61 = pr6.product_attributes.build(name: 'color')
# attribute_62 = pr6.product_attributes.build(name: 'size')
# ['black', 'grey'].each do |color|
#   attribute_61.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr6/#{color}_1.jpeg"), filename: "#{color}_1.jpeg"])
# end

# attribute_61.save!
# attribute_62.save!

# pr6.product_categories.create!(category_id: 13)
# color6s = ['Black', 'Grey']
# quantity6 = 0
# color6s.each do |color|
#   size2.each do |size|
#     quantity = rand(1..20)
#     quantity6 += quantity
#     attribute_value = AttributeValue.create!(
#       attribute_1: color,
#       attribute_2: size,
#       price_attribute_product: 11.9,
#       discount_attribute_product: 0.6,
#       stock: quantity
#     )
#     attribute_61.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#     attribute_62.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   end
# end
# pr6.quantity = quantity6 unless quantity6.zero?
# pr6.save!

# # Product 7
# pr7 = Product.new(
#   title: 'Sport Shoes | Casual Lace up Running Training Gym Lightweight Shoes Training & Gym Shoes For Men',
#   meta_title: 'Sport Shoes | Casual Lace up Running Training Gym Lightweight Shoes Training & Gym Shoes For Men',
#   price: 24.5,
#   discount: 0.7,
#   content: Faker::Lorem.paragraphs,
#   brand_id: 2,
#   product_type: Product::TYPES[:hide]
# )
# (2..5).each do |i|
#   pr7.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr7/black_#{i}.jpeg"), filename: "black_#{i}.jpeg"])
# end
# (2..6).each do |i|
#   pr7.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr7/grey_#{i}.jpeg"), filename: "grey_#{i}.jpeg"])
# end
# (2..6).each do |i|
#   pr7.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr7/blue_#{i}.jpeg"), filename: "blue_#{i}.jpeg"])
# end

# attribute_71 = pr7.product_attributes.build(name: 'color')
# attribute_72 = pr7.product_attributes.build(name: 'size')
# ['black', 'grey', 'blue'].each do |color|
#   attribute_71.images.attach([io: File.open(Rails.root + "app/assets/images/home/products/pr7/#{color}_1.jpeg"), filename: "#{color}_1.jpeg"])
# end

# attribute_71.save!
# attribute_72.save!

# pr7.product_categories.create!(category_id: 13)
# color7s = ['Black', 'Grey', 'Blue']
# quantity7 = 0
# color7s.each do |color|
#   size2.each do |size|
#     quantity = rand(1..20)
#     quantity7 += quantity
#     attribute_value = AttributeValue.create!(
#       attribute_1: color,
#       attribute_2: size,
#       price_attribute_product: 24.5,
#       discount_attribute_product: 0.7,
#       stock: quantity
#     )
#     attribute_71.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#     attribute_72.product_attribute_values.create!(attribute_value_id: attribute_value.id)
#   end
# end
# pr7.quantity = quantity7 unless quantity7.zero?
# pr7.save!
