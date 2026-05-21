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

    route_data = RoutingService.get_route(
        start_lat,
        start_lng,
        end_lat,
        end_lng
    )

    if "error" in route_data:
        return jsonify(route_data), 400

    return jsonify(route_data), 200