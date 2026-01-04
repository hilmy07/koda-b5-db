CREATE TABLE "users"(
    "id" SERIAL PRIMARY KEY,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW()
);

CREATE TABLE "movies"(
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR(255) NOT NULL,
    "genre" VARCHAR(100) NOT NULL,
    "duration" INTEGER NOT NULL,
    "release_date" DATE NOT NULL,
    "synopsis" TEXT,
    "image" VARCHAR(255),
    "created_at" TIMESTAMP DEFAULT NOW()
);

CREATE TABLE "schedules"(
    "id" SERIAL PRIMARY KEY,
    "movie_id" INT REFERENCES movies(id) ON DELETE CASCADE,
    "cinema" VARCHAR(100) NOT NULL,
    "date" DATE NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "price" INT NOT NULL
);

CREATE TABLE "seats" (
    "id" SERIAL PRIMARY KEY,
    "schedule_id" INT REFERENCES schedules(id) ON DELETE CASCADE,
    "seat_code" VARCHAR(10) NOT NULL,
    "is_booked" BOOLEAN DEFAULT FALSE
);

CREATE TABLE "orders" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INT REFERENCES users(id) ON DELETE CASCADE,
    "schedule_id" INT REFERENCES schedules(id) ON DELETE CASCADE,
    "total_price" INT NOT NULL,
    "payment_status" VARCHAR(20) DEFAULT 'pending',
    "created_at" TIMESTAMP DEFAULT NOW()
);

CREATE TABLE "order_items" (
    "id" SERIAL PRIMARY KEY,
    "order_id" INT REFERENCES orders(id) ON DELETE CASCADE,
    "seat_id" INT REFERENCES seats(id) ON DELETE CASCADE
);

CREATE TABLE order_payments (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Popular movie
-- SELECT movies.title, COUNT(order_items.id) AS total_sold
-- FROM movies
-- JOIN schedules ON schedules.movie_id = movies.id
-- JOIN orders ON orders.schedule_id = schedules.id
-- JOIN order_items ON order_items.order_id = orders.id
-- GROUP BY movies.id
-- ORDER BY total_sold DESC
-- LIMIT 5;

-- Upcoming movie
-- SELECT * FROM movies
-- WHERE release_date > CURRENT_DATE
-- ORDER BY release_date ASC;

-- Halaman homepage

-- Popular movie
SELECT 
    m.id,
    m.title,
    m.genre,
    m.duration,
    m.image,
    COUNT(oi.id) AS total_sold
FROM movies m
JOIN schedules s ON s.movie_id = m.id
JOIN orders o ON o.schedule_id = s.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY m.id
ORDER BY total_sold DESC
LIMIT 4;

-- upcoming movie
SELECT 
    id,
    title,
    genre,
    duration,
    release_date,
    image
FROM movies
WHERE release_date > CURRENT_DATE
ORDER BY release_date ASC;

-- Halaman movie detail

-- bagian atas
SELECT 
    id,
    title,
    genre,
    duration,
    release_date,
    synopsis,
    image
FROM movies
WHERE id = $1;

-- bagian bawah
SELECT
    s.id AS schedule_id,
    s.cinema,
    s.date,
    s.start_time,
    s.end_time,
    s.price
FROM schedules s
WHERE s.movie_id = $1
  AND s.date >= CURRENT_DATE
ORDER BY s.date, s.start_time;

-- halaman choose seats
SELECT
    id,
    seat_code,
    is_booked
FROM seats
WHERE schedule_id = $1
ORDER BY seat_code;

-- halaman payment

-- bagian atas
SELECT
    o.id AS order_id,
    m.title,
    m.image,
    s.cinema,
    s.date,
    s.start_time,
    s.end_time,
    s.price,
    o.total_price,
    o.payment_status
FROM orders o
JOIN schedules s ON s.id = o.schedule_id
JOIN movies m ON m.id = s.movie_id
WHERE o.id = $1;

-- bagian bawah 1
SELECT
    st.seat_code
FROM order_items oi
JOIN seats st ON st.id = oi.seat_id
WHERE oi.order_id = $1;

-- bagian bawah 2
SELECT
    full_name,
    email,
    phone,
    payment_method
FROM order_payments
WHERE order_id = $1;

-- halaman order history
SELECT
    o.id AS order_id,
    m.title,
    s.cinema,
    s.date,
    o.total_price,
    o.payment_status,
    o.created_at
FROM orders o
JOIN schedules s ON s.id = o.schedule_id
JOIN movies m ON m.id = s.movie_id
WHERE o.user_id = $1
ORDER BY o.created_at DESC;

-- halaman detail order history

-- bagian 1
SELECT
    o.id AS order_id,
    m.title,
    m.image,
    s.cinema,
    s.date,
    s.start_time,
    s.end_time,
    o.total_price,
    o.payment_status,
    o.created_at
FROM orders o
JOIN schedules s ON s.id = o.schedule_id
JOIN movies m ON m.id = s.movie_id
WHERE o.id = $1;

-- bagian 2
SELECT
    st.seat_code
FROM order_items oi
JOIN seats st ON st.id = oi.seat_id
WHERE oi.order_id = $1;