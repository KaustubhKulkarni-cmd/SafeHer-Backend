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


class RoutingService:

    API_KEY = os.getenv("OPENROUTE_API_KEY")

    @staticmethod
    def get_route(start_lat, start_lng, end_lat, end_lng):

        url = "https://api.openrouteservice.org/v2/directions/driving-car/geojson"

        headers = {
            "Authorization": RoutingService.API_KEY,
            "Content-Type": "application/json"
        }

        body = {
            "coordinates": [
                [start_lng, start_lat],
                [end_lng, end_lat]
            ]
        }

        response = requests.post(url, json=body, headers=headers)

        data = response.json()

        if "features" not in data:
            return {"error": "Route not found"}

        route = data["features"][0]["geometry"]["coordinates"]

        return {
            "route": route
        }

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