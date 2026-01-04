Table users {
  id int [pk, increment]
  email varchar [unique, not null]
  password varchar [not null]
  created_at timestamp
}

Table movies {
  id int [pk, increment]
  title varchar [not null]
  genre varchar [not null]
  duration int [not null]
  release_date date [not null]
  synopsis text
  image varchar
  created_at timestamp
}

Table schedules {
  id int [pk, increment]
  movie_id int [not null]
  cinema varchar [not null]
  date date [not null]
  start_time time [not null]
  end_time time [not null]
  price int [not null]
}

Table seats {
  id int [pk, increment]
  schedule_id int [not null]
  seat_code varchar [not null]
  is_booked boolean
}

Table orders {
  id int [pk, increment]
  user_id int [not null]
  schedule_id int [not null]
  total_price int [not null]
  payment_status varchar
  created_at timestamp
}

Table order_items {
  id int [pk, increment]
  order_id int [not null]
  seat_id int [not null]
}

Table order_payments {
  id int [pk, increment]
  order_id int [not null]
  full_name varchar [not null]
  email varchar [not null]
  phone varchar
  payment_method varchar
  created_at timestamp
}

Ref: schedules.movie_id > movies.id
Ref: seats.schedule_id > schedules.id
Ref: orders.user_id > users.id
Ref: orders.schedule_id > schedules.id
Ref: order_items.order_id > orders.id
Ref: order_items.seat_id > seats.id
Ref: order_payments.order_id > orders.id
