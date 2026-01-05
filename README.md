// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table users {
  id int [pk, increment]
  email varchar [unique, not null]
  password varchar [not null]
  profile_id int [unique, not null]
  created_at timestamp
}

Table profile {
  id int [pk, increment]
  first_name varchar
  last_name varchar
  phone_number varchar
}

Table movies {
  id int [pk, increment]
  title varchar [not null]
  genre_id int [not null]
  duration int [not null]
  release_date date [not null]
  director_id int [not null]
  cast_id int [not null]
  synopsis text
  image varchar
  backdrop_image varchar
  created_at timestamp
  updated_at timestamp
}

Table movie_cast {
  movie_id int
  cast_id int
}

Table cast {
  id int [pk, increment]
  name varchar
}

Table movie_genre {
  movie_id int
  genre_id int
}

Table genres {
  id int [pk, increment]
  name varchar
}

Table directors {
  id int [pk, increment]
  name varchar
}

Table schedules {
  id int [pk, increment]
  movie_id int [not null]
  cinema_id varchar [not null]
  date date [not null]
  start_time time [not null]
  price int [not null]
}

Table cinemas {
  id int [pk, increment]
  name varchar
  city_id int [not null]
}

Table city {
  id int [pk, increment]
  name varchar
}

Table seats {
  id int [pk, increment]
  seat_code varchar [not null]
}

Table orders {
  id int [pk, increment]
  user_id int [not null]
  schedule_id int [not null]
  payment_method_id int [not null]
  total_price int [not null]
  payment_status varchar
  full_name varchar [not null]
  email varchar [not null]
  phone varchar
  created_at timestamp
  updated_at timestamp
}

Table payment_method {
  id int [pk, increment]
  name varchar
}

Table order_items {
  order_id int [not null]
  seat_id int [not null]
}

Table subscribes {
  id int [pk, increment]
  firstname varchar [not null]
  email varchar [unique, not null]
}

Ref: profile.id - users.profile_id
Ref: schedules.movie_id > movies.id
Ref: movies.id < movie_genre.movie_id
Ref: genres.id < movie_genre.genre_id
Ref: movies.director_id < directors.id
Ref: movies.id < movie_cast.movie_id
Ref: cast.id < movie_cast.cast_id
Ref: schedules.cinema_id > cinemas.id
Ref: cinemas.city_id < city.id
Ref: orders.payment_method_id < payment_method.id
Ref: orders.user_id > users.id
Ref: orders.schedule_id > schedules.id
Ref: order_items.order_id > orders.id
Ref: order_items.seat_id > seats.id
