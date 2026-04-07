-- Task 1: Populate Sample Dataset
INSERT INTO cities (name) VALUES 
('Addis Ababa'), 
('Adama'), 
('Hawassa');

INSERT INTO users (full_name, city_id, phone) VALUES 
('Abel', 1, pgp_pub_encrypt('251911111111'::bytea, 'public_key_example'::bytea)),
('Sara', 2, pgp_pub_encrypt('251922222222'::bytea, 'public_key_example'::bytea)),
('Dawit', 3, pgp_pub_encrypt('251933333333'::bytea, 'public_key_example'::bytea));

INSERT INTO drivers (full_name, vehicle_model, license_plate, city_id, status, current_location) VALUES
('Bekele', 'Toyota Vitz', 'ABC-123', 1, 'available', ST_MakePoint(38.74, 9.03)::geography),
('Tesfaye', 'Suzuki Alto', 'XYZ-456', 2, 'busy', ST_MakePoint(39.29, 8.54)::geography);
