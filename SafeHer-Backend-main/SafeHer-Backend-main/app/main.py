from flask import Flask, request
from flask_cors import CORS
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_talisman import Talisman

from routes.emergency_api import emergency_bp
from routes.auth_api import auth_bp
from routes.route_api import route_bp
from routes.monitoring_api import monitoring_bp
from config.firebase_config import *
from dotenv import load_dotenv
import os
from routes.ai_api import ai_bp
from routes import route_api
from routes.guardians_api import guardians_bp
from routes.heatmap_api import heatmap_bp
from routes.fcm_api import fcm_bp

load_dotenv()  # This loads the variables from your .env file

def create_app():

    app = Flask(__name__)

    # 1. CORS Configuration (Allows all temporarily, but setup to restrict if needed)
    CORS(app, resources={r"/api/*": {"origins": "*"}}) # Update origins to your actual frontend domain in production

    # 2. HTTP Security Headers
    Talisman(app, content_security_policy=None) # CSP is None for API, but forces HTTPS & adds HSTS

    # 3. Rate Limiting
    limiter = Limiter(
        get_remote_address,
        app=app,
        default_limits=["200 per day", "50 per hour"],
        storage_uri="memory://"
    )

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(route_bp, url_prefix="/api")
    app.register_blueprint(emergency_bp, url_prefix="/api/agent/emergency")
    app.register_blueprint(ai_bp, url_prefix="/api")
    app.register_blueprint(monitoring_bp, url_prefix="/api/monitoring")
    app.register_blueprint(guardians_bp, url_prefix="/api/guardians")
    app.register_blueprint(heatmap_bp, url_prefix="/api/heatmap")
    app.register_blueprint(fcm_bp, url_prefix="/api/fcm")

    return app
# def create_app():
#     app = Flask(__name__)
#     CORS(app)

#     app.register_blueprint(auth_bp, url_prefix="/api/auth")

#     @app.route("/")
#     def home():
#         return {"message": "SafeHer Backend Running"}

#     return app

# from flask import Blueprint, jsonify

# auth_bp = Blueprint("auth", __name__)

# @auth_bp.route("/test", methods=["GET"])
# def test_auth():
#     return jsonify({
#         "message": "Auth API working",
#         "status": "success"
#     })
if __name__ == "__main__":
    app = create_app()
    debug_mode = os.getenv("FLASK_DEBUG", "True").lower() in ("true", "1")
    app.run(debug=debug_mode, port=5000)
