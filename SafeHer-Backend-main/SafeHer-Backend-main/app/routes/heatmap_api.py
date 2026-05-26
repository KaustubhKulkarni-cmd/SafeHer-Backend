import os
import pandas as pd
from flask import Blueprint, jsonify
from services.crime_service import CrimeService, AREA_COORDINATES

heatmap_bp = Blueprint("heatmap", __name__)

@heatmap_bp.route("/crimes", methods=["GET"])
def get_heatmap_crimes():
    heat_points = []
    
    db_dir = CrimeService.find_database_dir()
    
    for area_name, info in AREA_COORDINATES.items():
        file_path = os.path.join(db_dir, os.path.basename(info["file"]))
        
        total_crimes = 0
        if os.path.exists(file_path):
            try:
                df = pd.read_excel(file_path)
                total_crimes = len(df)
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
        
        heat_points.append({
            "station": area_name,
            "lat": info["lat"],
            "lng": info["lng"],
            "count": total_crimes
        })
    
    # Calculate relative weights (0.0 to 1.0) for the heatmap
    if heat_points:
        max_crimes = max(hp["count"] for hp in heat_points)
        if max_crimes == 0:
            max_crimes = 1 # Avoid division by zero
            
        for hp in heat_points:
            hp["weight"] = hp["count"] / max_crimes
            
    return jsonify({"success": True, "data": heat_points})
