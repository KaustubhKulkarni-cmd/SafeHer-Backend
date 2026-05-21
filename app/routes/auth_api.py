from flask import Blueprint, request, jsonify
from services.auth_service import login_user, signup_user

auth_bp = Blueprint("auth_api", __name__)


@auth_bp.route("/login", methods=["POST"])
def login():

    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify(False), 400

    result = login_user(email, password)

    print("Login Result:", result)

    return jsonify(result)

@auth_bp.route("/signup", methods=["POST"])
def signup():

    data = request.get_json()

    name = data.get("name")
    email = data.get("email")
    phone = data.get("phone")
    password = data.get("password")

    # Validation
    if not name or not email or not phone or not password:
        return jsonify({
            "success": False,
            "message": "All fields are required"
        }), 400

    result = signup_user(email, password, name, phone)

    print("Signup Result:", result)

    return jsonify(result)

