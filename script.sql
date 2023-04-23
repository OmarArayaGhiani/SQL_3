-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido
DROP DATABASE "desafio_3_sergio_araya_ghiani_999";
CREATE DATABASE "desafio_3_sergio_araya_ghiani_999";
\c "desafio_3_sergio_araya_ghiani_999"

CREATE TABLE usuarios (id SERIAL, nombre VARCHAR, apellido VARCHAR, email VARCHAR, rol VARCHAR);
INSERT INTO usuarios (nombre, apellido, email, rol) VALUES ('sergio', 'araya', 'sergio.araya@email.com', 'administrador');
INSERT INTO usuarios (nombre, apellido, email, rol) VALUES ('liliana', 'perez', 'liliana.perez@email.com', 'usuario');
INSERT INTO usuarios (nombre, apellido, email, rol) VALUES ('catalina', 'fuentes', 'cata.fuentes@email.com', 'usuario');
INSERT INTO usuarios (nombre, apellido, email, rol) VALUES ('luis', 'cornejo', 'luis.cornejo@email.com', 'usuario');
INSERT INTO usuarios (nombre, apellido, email, rol) VALUES ('maria', 'castro', 'maria.castro@email.com', 'usuario');

CREATE TABLE posts (id SERIAL, titulo VARCHAR, contenido TEXT, fecha_creacion TIMESTAMP, fecha_actualizacion TIMESTAMP, destacado BOOLEAN, usuario_id BIGINT);
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('titluo 1', 'contenido 1', '2-8-2022', '3-8-2022', true, 1);
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('titluo 2', 'contenido 2', '2-9-2022', '3-9-2022', true, 1);
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('titluo 3', 'contenido 3', '2-10-2022', '3-10-2022', false, 3);
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('titluo 4', 'contenido 4', '2-2-2023', '3-2-2023', true, 5);
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado) VALUES ('titluo 5', 'contenido 5', '2-4-2023', '3-4-2023', false);

CREATE TABLE comentarios (id SERIAL, contenido TEXT, fecha_creacion TIMESTAMP, post_id BIGINT, usuario_id BIGINT);
INSERT INTO comentarios (contenido, fecha_creacion, post_id, usuario_id) VALUES ('comentario 1', '4-8-2022', 1, 1);
INSERT INTO comentarios (contenido, fecha_creacion, post_id, usuario_id) VALUES ('comentario 2', '5-8-2022', 1, 2);
INSERT INTO comentarios (contenido, fecha_creacion, post_id, usuario_id) VALUES ('comentario 3', '6-8-2022', 1, 3);
INSERT INTO comentarios (contenido, fecha_creacion, post_id, usuario_id) VALUES ('comentario 4', '28-9-2022', 2, 1);
INSERT INTO comentarios (contenido, fecha_creacion, post_id, usuario_id) VALUES ('comentario 5', '29-9-2022', 2, 2);

-- 2. Cruza los datos de la tabla usuarios y posts mostrando las columnas nombre e email del usuario junto al título y contenido del post.
SELECT u.nombre, u.email, p.titulo, p.contenido FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id; 

-- 3. Muestra el id, título y contenido de los posts de los administradores.
SELECT u.nombre, u.rol, p.id, p.titulo, p.contenido FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id WHERE rol = 'administrador'; 

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT u.id, u.email, COUNT(p.usuario_id) AS cantidad_posts FROM usuarios u LEFT JOIN posts p ON u.id = p.usuario_id GROUP BY u.id, u.email ORDER BY u.id;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email FROM usuarios u INNER JOIN (SELECT usuario_id, COUNT(id) FROM posts GROUP BY usuario_id ORDER BY COUNT DESC LIMIT 1) AS p ON u.id = p.usuario_id;

-- 6. Muestra la fecha del último post de cada usuario.
-- NOTA: En esta punto no me quedó claro si la pregunta excluia o no el post sin usuario_id, por lo que entrego dos respuestas,
-- la primera donde solo indico las fechas de los posts con sus respectivos usuarios, excluyendo el post sin usuario_id
-- y la segunta donde si lo incluyo.
SELECT u.nombre, MAX(p.fecha_creacion) FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id GROUP BY u.nombre;
SELECT u.nombre, MAX(p.fecha_creacion) FROM posts p LEFT JOIN usuarios u ON u.id = p.usuario_id GROUP BY u.nombre;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.
SELECT p.titulo, p.contenido, c.COUNT AS cantidad_comentarios FROM posts p INNER JOIN (SELECT post_id, COUNT(id) FROM comentarios GROUP BY post_id ORDER BY COUNT DESC LIMIT 1) AS c ON p.id = c.post_id;

-- 8. Muestra el título y contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió. 
-- NOTA: LA pregunta no especifíca si el email corresponde a quien escribió el post o el comentario por lo que entrego ambas respuestas,
-- en la primera indica quién escribió el post y la segunda quien escribió el comentario.
SELECT u.email AS email_autor_post, p.titulo, p.contenido, c.contenido FROM posts p LEFT JOIN comentarios c ON p.id = c.post_id LEFT JOIN usuarios u ON u.id = p.usuario_id;
SELECT p.titulo, p.contenido, c.contenido, u.email AS email_autor_comentario FROM posts p LEFT JOIN comentarios c ON p.id = c.post_id LEFT JOIN usuarios u ON u.id = c.usuario_id;

-- 9. Muestra el contenido del último comentario de cada usuario.
SELECT u.nombre, c.contenido, f.MAX FROM usuarios u INNER JOIN comentarios c ON u.id = c.usuario_id INNER JOIN (SELECT usuario_id, MAX(fecha_creacion) FROM comentarios GROUP BY usuario_id) AS f ON c.fecha_creacion = f.MAX; 

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT u.email, COUNT(c.id) AS cantidad_posts FROM usuarios u LEFT JOIN comentarios c ON u.id = c.usuario_id GROUP BY u.email HAVING COUNT(c.id) = 0;