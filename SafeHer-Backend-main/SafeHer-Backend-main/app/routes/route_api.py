# from flask import Blueprint, request, jsonify
# from app.services.routing_service import RoutingService

# route_bp = Blueprint('route_api', __name__)

# @route_bp.route("/get-route", methods=["POST"])
# def get_route():

#     data = request.json

#     start_lat = data.get("start_lat")
#     start_lng = data.get("start_lng")
#     end_lat = data.get("end_lat")
#     end_lng = data.get("end_lng")

#     route_data = RoutingService.get_route(
#         start_lat,
#         start_lng,
#         end_lat,
#         end_lng
#     )

#     return jsonify(route_data)

from flask import Blueprint, request, jsonify
from services.routing_service import RoutingService
from services.crime_service import CrimeService

route_bp = Blueprint('route_api', __name__)




# ─────────────────────────────────────
# Convert destination text → coordinates
# ─────────────────────────────────────
@route_bp.route("/destination", methods=["POST"])
def get_destination():

    data = request.json
    address = data.get("address")

    coords = RoutingService.get_coordinates(address)

    if not coords:
        return jsonify({"error": "Location not found"}), 404

    return jsonify(coords)

@route_bp.route("/get-route", methods=["POST"])
def get_route():

    data = request.json

    start_lat = data.get("start_lat")
    start_lng = data.get("start_lng")
    end_lat = data.get("end_lat")
    end_lng = data.get("end_lng")
    current_time = data.get("current_time")

    route_data = RoutingService.get_route(
        start_lat,
        start_lng,
        end_lat,
        end_lng
    )

    if "error" in route_data:
        return jsonify(route_data), 400

    # Enrich alternate routes with real-time safety scores
    routes_list = []
    for r in route_data["routes"]:
        suburbs = CrimeService.get_route_suburbs(r["route"])
        safety_details = CrimeService.calculate_route_safety(suburbs, current_time)
        r.update(safety_details)
        routes_list.append(r)

    # Sort routes: Safest route first
    routes_list.sort(key=lambda x: x["safety_score"], reverse=True)

    # Compile the suburb baseline crime summary
    try:
        crime_summary = CrimeService.get_crime_summary(
            float(start_lat),
            float(start_lng),
            float(end_lat),
            float(end_lng),
            current_time
        )
    except Exception as e:
        crime_summary = {"success": False, "error": str(e)}

    return jsonify({
        "routes": routes_list,
        "crime_summary": crime_summary
    }), 200



@route_bp.route("/crime-summary", methods=["POST"])
def get_crime_summary():

    data = request.json

    start_lat = data.get("start_lat")
    start_lng = data.get("start_lng")
    end_lat = data.get("end_lat")
    end_lng = data.get("end_lng")
    current_time = data.get("current_time")

    if not all([start_lat, start_lng, end_lat, end_lng]):
        return jsonify({"error": "Missing coordinates"}), 400

    try:
        summary = CrimeService.get_crime_summary(
            float(start_lat),
            float(start_lng),
            float(end_lat),
            float(end_lng),
            current_time
        )
        return jsonify(summary), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


@route_bp.route("/current-safety", methods=["POST"])
def get_current_safety():
    data = request.json
    lat = data.get("lat")
    lng = data.get("lng")
    current_time = data.get("current_time")

    if lat is None or lng is None:
        return jsonify({"error": "Missing coordinates"}), 400

    try:
        suburb, dist = CrimeService.get_closest_area(float(lat), float(lng))
        
        # If the closest suburb is too far, say > 10km, it might be out of range, but we still score it
        safety_details = CrimeService.calculate_route_safety([suburb], current_time)

        return jsonify({
            "success": True,
            "suburb": suburb,
            "distance_km": round(dist, 2),
            "safety_score": safety_details["safety_score"],
            "safety_rating": safety_details["safety_rating"],
            "period_crimes": safety_details["period_crimes"],
            "police_stations_count": safety_details["police_stations_count"]
        }), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500