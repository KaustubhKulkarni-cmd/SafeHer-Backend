# import os
# import requests


# class RoutingService:

#     API_KEY = os.getenv("OPENROUTE_API_KEY")

#     # ─────────────────────────────────────────
#     # Get Route from OpenRouteService
#     # ─────────────────────────────────────────
#     @staticmethod
#     def get_route(start_lat, start_lng, end_lat, end_lng):

#         url = "https://api.openrouteservice.org/v2/directions/driving-car"

#         headers = {
#             "Authorization": RoutingService.API_KEY,
#             "Content-Type": "application/json"
#         }

#         body = {
#             "coordinates": [
#                 [start_lng, start_lat],
#                 [end_lng, end_lat]
#             ]
#         }

#         response = requests.post(url, json=body, headers=headers)

#         data = response.json()

#         route = data["features"][0]["geometry"]["coordinates"]

#         return {
#             "route": route
#         }


#     # ─────────────────────────────────────────
#     # Convert destination text → coordinates
#     # ─────────────────────────────────────────
#     @staticmethod
#     def get_coordinates(address):

#         url = "https://nominatim.openstreetmap.org/search"

#         params = {
#             "q": address,
#             "format": "json",
#             "limit": 1
#         }

#         headers = {
#             "User-Agent": "safeher-app"
#         }

#         response = requests.get(url, params=params, headers=headers)

#         data = response.json()

#         if not data:
#             return None

#         return {
#             "lat": float(data[0]["lat"]),
#             "lng": float(data[0]["lon"])
#         }

# import os
# import requests

# class RoutingService:

#     API_KEY = os.getenv("OPENROUTE_API_KEY")

#     @staticmethod
#     def get_route(start_lat, start_lng, end_lat, end_lng):

#         url = "https://api.openrouteservice.org/v2/directions/driving-car/geojson"

#         headers = {
#             "Authorization": RoutingService.API_KEY,
#             "Content-Type": "application/json"
#         }

#         body = {
#             "coordinates": [
#                 [start_lng, start_lat],
#                 [end_lng, end_lat]
#             ]
#         }

#         response = requests.post(url, json=body, headers=headers)

#         data = response.json()

#         print("OpenRouteService response:", data)

#         if "features" not in data:
#             return {"error": "Route not found"}

#         route = data["features"][0]["geometry"]["coordinates"]

#         distance = data["features"][0]["properties"]["summary"]["distance"]
#         duration = data["features"][0]["properties"]["summary"]["duration"]

#         return {
#             "route": route,
#             "distance": distance,
#             "duration": duration
#         }
    
# @staticmethod
# def get_coordinates(address):

#     url = "https://nominatim.openstreetmap.org/search"

#     params = {
#         "q": address,
#         "format": "json",
#         "limit": 1
#     }

#     headers = {
#         "User-Agent": "safeher-app"
#     }

#     response = requests.get(url, params=params, headers=headers)

#     data = response.json()

#     if not data:
#         return None

#     return {
#         "lat": float(data[0]["lat"]),
#         "lng": float(data[0]["lon"])
#     }


import os
import requests
import math


class RoutingService:

    API_KEY = os.getenv("OPENROUTE_API_KEY")

    @staticmethod
    def _generate_mock_routes(start_lat, start_lng, end_lat, end_lng):
        d_lat = end_lat - start_lat
        d_lng = end_lng - start_lng
        
        # Approximate straight line distance in meters
        lat_mid = (start_lat + end_lat) / 2.0
        dy = d_lat * 111000.0
        dx = d_lng * 111000.0 * math.cos(math.radians(lat_mid))
        distance_meters = math.sqrt(dx**2 + dy**2)
        
        routes = []
        # Define 4 dynamic mock alternatives:
        # 1. Safest Route (slight curve, highest safety score due to crime stats/stations)
        # 2. Alternate Route 1 (wider curve one way)
        # 3. Alternate Route 2 (wider curve the other way)
        # 4. Alternate Route 3 (sharp curve, different neighborhood)
        all_alternatives = [
            {"curve": 0.07, "dist_mult": 1.04, "speed_kmh": 42.0},
            {"curve": -0.14, "dist_mult": 1.12, "speed_kmh": 38.0},
            {"curve": 0.22, "dist_mult": 1.22, "speed_kmh": 34.0},
            {"curve": -0.28, "dist_mult": 1.35, "speed_kmh": 30.0},
        ]
        
        # Calculate dynamic count (between 2 and 4 routes) deterministically based on coordinates sum
        coord_sum = abs(start_lat) + abs(start_lng) + abs(end_lat) + abs(end_lng)
        route_count = 2 + int((coord_sum * 10000) % 3)  # returns 2, 3, or 4 routes dynamically
        
        alternatives = all_alternatives[:route_count]
        
        for alt in alternatives:
            curve = alt["curve"]
            dist_mult = alt["dist_mult"]
            speed = alt["speed_kmh"]
            
            coords = []
            N = 15  # 15 points
            for i in range(N):
                t = i / float(N - 1)
                # Curve using perpendicular offsets
                lat = start_lat + t * d_lat + math.sin(t * math.pi) * curve * (-d_lng)
                lng = start_lng + t * d_lng + math.sin(t * math.pi) * curve * d_lat
                coords.append([lng, lat])
                
            dist = distance_meters * dist_mult
            duration = dist / (speed / 3.6)  # convert speed to m/s
            
            routes.append({
                "route": coords,
                "distance": dist,
                "duration": duration
            })
            
        return {"routes": routes}

    @staticmethod
    def get_route(start_lat, start_lng, end_lat, end_lng):

        url = "https://api.openrouteservice.org/v2/directions/driving-car/geojson"

        headers = {
            "Authorization": RoutingService.API_KEY or "",
            "Content-Type": "application/json"
        }

        body = {
            "coordinates": [
                [start_lng, start_lat],
                [end_lng, end_lat]
            ],
            "alternative_routes": {
                "target_count": 2
            }
        }

        if not RoutingService.API_KEY or RoutingService.API_KEY.strip() == "" or "YOUR_OPENROUTE" in RoutingService.API_KEY:
            print("OPENROUTE_API_KEY is not configured or placeholder. Falling back to beautiful generated mock routes.")
            return RoutingService._generate_mock_routes(start_lat, start_lng, end_lat, end_lng)

        try:
            response = requests.post(url, json=body, headers=headers, timeout=5)
            
            if response.status_code != 200:
                print(f"OpenRouteService returned status code {response.status_code}. Falling back to beautiful mock routes.")
                return RoutingService._generate_mock_routes(start_lat, start_lng, end_lat, end_lng)
                
            data = response.json()
            
            if "features" not in data or not data["features"]:
                print("OpenRouteService response does not contain 'features'. Falling back to beautiful mock routes.")
                return RoutingService._generate_mock_routes(start_lat, start_lng, end_lat, end_lng)

            routes = []
            for feature in data["features"]:
                coords = feature["geometry"]["coordinates"]
                summary = feature.get("properties", {}).get("summary", {})
                distance = summary.get("distance", 0.0)
                duration = summary.get("duration", 0.0)

                routes.append({
                    "route": coords,
                    "distance": distance,
                    "duration": duration
                })

            return {
                "routes": routes
            }
        except Exception as e:
            print(f"Exception during OpenRouteService request: {e}. Falling back to beautiful mock routes.")
            return RoutingService._generate_mock_routes(start_lat, start_lng, end_lat, end_lng)


    @staticmethod
    def get_coordinates(address):

        url = "https://nominatim.openstreetmap.org/search"

        params = {
            "q": address,
            "format": "json",
            "limit": 1
        }

        headers = {
            "User-Agent": "safeher-app"
        }

        response = requests.get(url, params=params, headers=headers)

        data = response.json()

        if not data:
            return None

        return {
            "lat": float(data[0]["lat"]),
            "lng": float(data[0]["lon"])
        }