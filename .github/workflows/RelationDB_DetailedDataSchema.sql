/* Видалення таблиць з каскадним видаленням */
DROP TABLE IF EXISTS AppUser CASCADE;
DROP TABLE IF EXISTS TemperatureRequest CASCADE;
DROP TABLE IF EXISTS NetatmoWeatherStation CASCADE;
DROP TABLE IF EXISTS TemperatureData CASCADE;
DROP TABLE IF EXISTS DataArchive CASCADE;

CREATE TABLE AppUser (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(200) CHECK (contact_info ~ '^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,6}$' OR contact_info ~ '^\\+?[0-9\\s]+$'), -- обмеження на email або номер телефону
    is_authorized BOOLEAN NOT NULL
);

CREATE TABLE TemperatureRequest (
    request_id SERIAL PRIMARY KEY,
    request_date DATE CHECK (request_date >= CURRENT_DATE), -- дата не в минулому
    request_time TIME NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES AppUser (user_id)
);

CREATE TABLE NetatmoWeatherStation (
    station_id SERIAL PRIMARY KEY,
    api_key VARCHAR(100) NOT NULL
);

CREATE TABLE TemperatureData (
    data_id SERIAL PRIMARY KEY,
    temperature_value FLOAT CHECK (temperature_value BETWEEN -50 AND 50), -- діапазон температури
    timestamp TIMESTAMP NOT NULL,
    location VARCHAR(100),
    station_id INT NOT NULL,
    FOREIGN KEY (station_id) REFERENCES NetatmoWeatherStation (station_id)
);

CREATE TABLE DataArchive (
    database_id SERIAL PRIMARY KEY,
    temperature_data_id INT[],
    FOREIGN KEY (temperature_data_id) REFERENCES TemperatureData (data_id)
);
