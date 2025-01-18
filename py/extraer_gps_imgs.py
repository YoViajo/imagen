import os
import random
import exifread
from math import radians, sin, cos, sqrt, atan2
from collections import Counter
import sys

def extract_gps_coordinates(filepath):
    try:
        with open(filepath, 'rb') as f:
            tags = exifread.process_file(f, stop_tag='GPS')
            gps_latitude = tags.get('GPS GPSLatitude')
            gps_latitude_ref = tags.get('GPS GPSLatitudeRef')
            gps_longitude = tags.get('GPS GPSLongitude')
            gps_longitude_ref = tags.get('GPS GPSLongitudeRef')

            if gps_latitude and gps_longitude:
                lat = [float(x.num) / float(x.den) for x in gps_latitude.values]
                lon = [float(x.num) / float(x.den) for x in gps_longitude.values]

                latitude = lat[0] + lat[1] / 60 + lat[2] / 3600
                longitude = lon[0] + lon[1] / 60 + lon[2] / 3600

                if gps_latitude_ref.values[0] == 'S':
                    latitude = -latitude
                if gps_longitude_ref.values[0] == 'W':
                    longitude = -longitude

                return latitude, longitude
    except Exception as e:
        print(f"Error al leer los datos EXIF de {filepath}: {e}")
    return None

def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # Radio de la Tierra en kilómetros
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat / 2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return R * c

def find_nearest_city(lat, lon, cities):
    min_distance = float('inf')
    nearest_city = "Fuera de Bolivia"
    for city in cities:
        city_name, city_lat, city_lon = city
        distance = haversine(lat, lon, city_lat, city_lon)
        if distance < min_distance:
            min_distance = distance
            nearest_city = city_name
    return nearest_city

def process_directory(base_dir, cities):
    results = []

    for subdir in os.listdir(base_dir):
        subdir_path = os.path.join(base_dir, subdir)
        if os.path.isdir(subdir_path):
            image_files = [f for f in os.listdir(subdir_path) if f.lower().endswith(('.jpg', '.jpeg'))]
            if image_files:
                random_file = random.choice(image_files)
                file_path = os.path.join(subdir_path, random_file)
                coordinates = extract_gps_coordinates(file_path)
                if coordinates:
                    nearest_city = find_nearest_city(coordinates[0], coordinates[1], cities)
                    results.append((subdir, coordinates, nearest_city))
                else:
                    results.append((subdir, "Sin datos GPS", "N/A"))

    return results

def summarize_results(results):
    city_counter = Counter([city for _, _, city in results if city != "N/A"])
    summary = city_counter.most_common()
    return summary

def list_non_santa_cruz_visits(results):
    non_santa_cruz = [(directory, city) for directory, _, city in results if city != "Santa Cruz" and city != "N/A"]
    return non_santa_cruz

def save_and_display(base_dir, year, output, stats, non_santa_cruz_visits):
    filename = os.path.join(base_dir, f"{year}_resumen.txt")
    with open(filename, "w", encoding="utf-8") as f:
        f.write("Resultados del análisis:\n")
        print("Resultados del análisis:")
        for directory, data, city in output:
            line = f"Directorio: {directory}, Datos: {data}, Ciudad más cercana: {city}\n"
            f.write(line)
            print(line.strip())

        f.write("\nEstadísticas por ciudad:\n")
        print("\nEstadísticas por ciudad:")
        for city, count in stats:
            line = f"Ciudad: {city}, Días con capturas: {count}\n"
            f.write(line)
            print(line.strip())

        f.write("\nFechas con visitas a ciudades distintas de Santa Cruz:\n")
        print("\nFechas con visitas a ciudades distintas de Santa Cruz:")
        for directory, city in non_santa_cruz_visits:
            line = f"Fecha: {directory}, Ciudad: {city}\n"
            f.write(line)
            print(line.strip())

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python script.py <ruta_carpeta_raiz>")
        sys.exit(1)

    base_directory = sys.argv[1].strip('"')  # Limpia las comillas si están presentes

    # Lista de capitales departamentales de Bolivia con sus coordenadas (nombre, latitud, longitud)
    bolivia_cities = [
        ("Sucre", -19.0333, -65.2627),
        ("La Paz", -16.5000, -68.1500),
        ("Cochabamba", -17.3833, -66.1667),
        ("Oruro", -17.9833, -67.1500),
        ("Potosí", -19.5836, -65.7531),
        ("Tarija", -21.5355, -64.7296),
        ("Santa Cruz", -17.7833, -63.1833),
        ("Trinidad", -14.8333, -64.9000),
        ("Cobija", -11.0333, -68.7333)
    ]

    output = process_directory(base_directory, bolivia_cities)
    year = os.path.basename(base_directory).split('_')[-1]  # Extract year from folder name if applicable

    stats = summarize_results(output)
    non_santa_cruz_visits = list_non_santa_cruz_visits(output)

    save_and_display(base_directory, year, output, stats, non_santa_cruz_visits)
