import os
import math
import datetime
import pandas as pd

# ─── Coordinates mapping for 24 Pune Areas ────────────────────────────────────
AREA_COORDINATES = {
    "Alankar": {"lat": 18.5083, "lng": 73.8186, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\NandedCity_crime_analysis_summary1.xlsx"},
    "Ambegaon": {"lat": 18.4552, "lng": 73.8340, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Ambegaon_crime_analysis_summary1.xlsx"},
    "Bharti Vidyapeeth": {"lat": 18.4575, "lng": 73.8502, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\BHARTI_VIDYAPEETH_crime_analysis_summary1.xlsx"},
    "Baner": {"lat": 18.5590, "lng": 73.7797, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Baner_crime_analysis_summary1.xlsx"},
    "Bibvewadi": {"lat": 18.4695, "lng": 73.8643, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Bibvewadi_crime_analysis_summary1.xlsx"},
    "Chandannagar": {"lat": 18.5626, "lng": 73.9315, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\CHANDANNAGAR POLICE STATION_crime_analysis.xlsx"},
    "Deccan": {"lat": 18.5168, "lng": 73.8441, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Deccan.xlsx"},
    "Faraskhana": {"lat": 18.5181, "lng": 73.8562, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\FARASKHANAcrime_analysis_summary - Copy.xlsx"},
    "Fursungi": {"lat": 18.4800, "lng": 73.9700, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Fursungi_crime_analysis_summary1.xlsx"},
    "Koregaon Park": {"lat": 18.5362, "lng": 73.8930, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\KOREGAON PARKcrime_analysis_summary.xlsx"},
    "Kothrud": {"lat": 18.5074, "lng": 73.8077, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\KOTHURUD_crime_analysis.xlsx"},
    "Kalepadal": {"lat": 18.4900, "lng": 73.9280, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Kalepadal_crime_analysis_summary1.xlsx"},
    "Kondhwa": {"lat": 18.4784, "lng": 73.8911, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Kondhwa_crime_analysis_summary1.xlsx"},
    "Marketyard": {"lat": 18.4880, "lng": 73.8680, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Marketyard_crime_analysis_summary1.xlsx"},
    "Nanded City": {"lat": 18.4638, "lng": 73.7915, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\NandedCity_crime_analysis_summary1.xlsx"},
    "Sahakar Nagar": {"lat": 18.4897, "lng": 73.8519, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\SAHAKAR NAGARcrime_analysis_summary.xlsx"},
    "Samarth": {"lat": 18.5200, "lng": 73.8700, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\SAMARTHcrime_analysis_summary.xlsx"},
    "Swargate": {"lat": 18.5018, "lng": 73.8629, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\SWARGATEcrime_analysis_summary.xlsx"},
    "Shivaji Nagar": {"lat": 18.5314, "lng": 73.8446, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\ShivajiNagar_crime_analysis_summary1.xlsx"},
    "Uttamnagar": {"lat": 18.4800, "lng": 73.7700, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\Uttamnagar_crime_analysis_summary1.xlsx"},
    "Vishrantwadi": {"lat": 18.5683, "lng": 73.8741, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\VISHRANTWADIcrime_analysis_summary.xlsx"},
    "Wanvadi": {"lat": 18.5022, "lng": 73.8983, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\WANVADI_crime_analysis.xlsx"},
    "Kharadi": {"lat": 18.5513, "lng": 73.9348, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\kharadi_crime_analysis_summary1.xlsx"},
    "Wagholi": {"lat": 18.5793, "lng": 73.9689, "file": r"C:\Users\parth\OneDrive\Desktop\EDI_SEM4\wagholi_crime_analysis_summary1.xlsx"}
}

class CrimeService:

    @staticmethod
    def haversine_distance(lat1, lon1, lat2, lon2):
        """Calculates distance between two coordinates in kilometers."""
        R = 6371.0  # Earth's radius in km
        dlat = math.radians(lat2 - lat1)
        dlon = math.radians(lon2 - lon1)
        a = (math.sin(dlat / 2) ** 2 + 
             math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2) ** 2)
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return R * c

    @staticmethod
    def get_closest_area(lat, lng):
        """Finds the closest Pune suburb and its database filename."""
        closest_name = None
        min_dist = float('inf')
        
        for name, info in AREA_COORDINATES.items():
            dist = CrimeService.haversine_distance(lat, lng, info["lat"], info["lng"])
            if dist < min_dist:
                min_dist = dist
                closest_name = name
                
        return closest_name, min_dist

    @staticmethod
    def get_time_period(time_str):
        """Parses ISO time string to determine Morning, Afternoon, Evening, or Night."""
        try:
            # Parse ISO 8601 e.g. 2026-05-21T15:23:38+05:30
            # Clean string time offset
            if "+" in time_str:
                time_str = time_str.split("+")[0]
            dt = datetime.datetime.fromisoformat(time_str.replace("Z", ""))
            hour = dt.hour
        except Exception:
            hour = datetime.datetime.now().hour

        if 6 <= hour < 12:
            return "Morning", 6, 12
        elif 12 <= hour < 17:
            return "Afternoon", 12, 17
        elif 17 <= hour < 22:
            return "Evening", 17, 22
        else:
            return "Night", 22, 6

    @staticmethod
    def find_database_dir():
        """Walks up parent directories to find where the Excel files are located."""
        current_dir = os.path.abspath(os.path.dirname(__file__))
        for _ in range(5):
            if os.path.exists(os.path.join(current_dir, "Alankar.xlsx")):
                return current_dir
            current_dir = os.path.dirname(current_dir)
        return r"d:\SAFEHER"

    @staticmethod
    def get_crime_stats(area_name, time_period, start_hour, end_hour):
        """Reads excel logs and computes localized stats for a matched suburb."""
        db_dir = CrimeService.find_database_dir()
        filename = AREA_COORDINATES[area_name]["file"]
        file_path = os.path.join(db_dir, filename)

        fallback_stats = {
            "total_crimes": 0,
            "period_crimes": 0,
            "top_category": "Unknown",
            "breakdown": {}
        }

        if not os.path.exists(file_path):
            return fallback_stats

        try:
            df = pd.read_excel(file_path)
            if df.empty:
                return fallback_stats

            total_crimes = len(df)

            # Extract hour helper
            def get_hour(t):
                if not isinstance(t, str):
                    return None
                try:
                    return int(t.split(":")[0])
                except Exception:
                    return None

            df['Hour'] = df['Time'].apply(get_hour)

            # Filter by period hour range
            if start_hour == 22:  # Night crosses midnight (22:00 to 06:00)
                period_df = df[(df['Hour'] >= 22) | (df['Hour'] < 6)]
            else:
                period_df = df[(df['Hour'] >= start_hour) & (df['Hour'] < end_hour)]

            period_crimes = len(period_df)

            # Crime breakdown by category
            category_counts = df['Crime_Category'].value_counts().to_dict()
            top_category = "Unknown"
            if category_counts:
                top_category = max(category_counts, key=category_counts.get)

            return {
                "total_crimes": total_crimes,
                "period_crimes": period_crimes,
                "top_category": str(top_category),
                "breakdown": {str(k): int(v) for k, v in category_counts.items()}
            }

        except Exception as e:
            print(f"Error reading crime Excel file {file_path}: {e}")
            return fallback_stats

    @staticmethod
    def get_crime_summary(start_lat, start_lng, end_lat, end_lng, current_time=None):
        """Generates the unified crime summary analysis for route planning."""
        start_area, start_dist = CrimeService.get_closest_area(start_lat, start_lng)
        end_area, end_dist = CrimeService.get_closest_area(end_lat, end_lng)

        period_name, start_hr, end_hr = CrimeService.get_time_period(current_time)

        start_stats = CrimeService.get_crime_stats(start_area, period_name, start_hr, end_hr)
        end_stats = CrimeService.get_crime_stats(end_area, period_name, start_hr, end_hr)

        # Calculate Overall Safety Rating
        overall_crimes = start_stats["total_crimes"] + end_stats["total_crimes"]
        period_crimes_sum = start_stats["period_crimes"] + end_stats["period_crimes"]

        if overall_crimes >= 400 or period_crimes_sum >= 50 or period_name == "Night":
            safety_rating = "Caution Advised"
        elif overall_crimes >= 200 or period_crimes_sum >= 20:
            safety_rating = "Moderate Safety"
        else:
            safety_rating = "High Safety"

        # Construct customized safety tip
        if period_name == "Night":
            safety_tip = (f"Caution: Late hours travel detected. Police Station {end_area} reports "
                          f"{end_stats['period_crimes']} incidents during night shifts. Stick to well-lit "
                          f"main streets and keep your emergency contacts updated.")
        elif safety_rating == "Caution Advised":
            safety_tip = (f"Moderate high activity in {end_area} ({end_stats['total_crimes']} crimes registered). "
                          f"Ensure you share your live location with a contact via SafeHer SOS.")
        else:
            safety_tip = (f"Route through {start_area} to {end_area} appears highly secure under current "
                          f"{period_name} hours. Travel with peace of mind!")

        # Blend breakdown categories of start and end
        combined_breakdown = {}
        for cat, val in start_stats["breakdown"].items():
            combined_breakdown[cat] = combined_breakdown.get(cat, 0) + val
        for cat, val in end_stats["breakdown"].items():
            combined_breakdown[cat] = combined_breakdown.get(cat, 0) + val

        # Sorted category breakdown
        sorted_breakdown = dict(sorted(combined_breakdown.items(), key=lambda item: item[1], reverse=True)[:5])

        return {
            "success": True,
            "current_time_period": period_name,
            "overall_safety_rating": safety_rating,
            "safety_tip": safety_tip,
            "start_area": {
                "name": start_area,
                "total_crimes": start_stats["total_crimes"],
                "period_crimes": start_stats["period_crimes"],
                "top_category": start_stats["top_category"],
                "distance_km": round(start_dist, 2)
            },
            "end_area": {
                "name": end_area,
                "total_crimes": end_stats["total_crimes"],
                "period_crimes": end_stats["period_crimes"],
                "top_category": end_stats["top_category"],
                "distance_km": round(end_dist, 2)
            },
            "crime_breakdown": sorted_breakdown
        }

    @staticmethod
    def get_route_suburbs(coordinates):
        """Samples up to 15 coordinate pairs along the route and finds matched suburbs."""
        if not coordinates:
            return []

        num_points = len(coordinates)
        sample_indices = []
        if num_points <= 15:
            sample_indices = list(range(num_points))
        else:
            sample_indices = [int(i * (num_points - 1) / 14) for i in range(15)]

        matched_suburbs = set()
        for idx in sample_indices:
            coord = coordinates[idx]
            # Coordinates are [lng, lat] from OpenRouteService geojson
            lng, lat = coord[0], coord[1]
            suburb, dist = CrimeService.get_closest_area(lat, lng)
            if dist <= 2.5:
                matched_suburbs.add(suburb)

        return list(matched_suburbs)

    @staticmethod
    def calculate_route_safety(suburbs, current_time=None):
        """Calculates safety rating and details based on crime frequency & station count."""
        if not suburbs:
            return {
                "safety_score": 80.0,
                "police_stations_count": 0,
                "period_crimes": 0,
                "safety_rating": "Moderate Safety",
                "suburbs": [],
                "police_stations": []
            }

        period_name, start_hr, end_hr = CrimeService.get_time_period(current_time)

        total_crimes_along = 0
        period_crimes_along = 0

        for suburb in suburbs:
            stats = CrimeService.get_crime_stats(suburb, period_name, start_hr, end_hr)
            total_crimes_along += stats["total_crimes"]
            period_crimes_along += stats["period_crimes"]

        # Factor 1: Normalized Crime density penalty
        # Average the crimes across the suburbs to get density, then scale it
        crimes_per_suburb = period_crimes_along / len(suburbs)
        crime_penalty = min(35.0, crimes_per_suburb * 0.75)

        # Factor 2: Police station density bonus (more stations along the route = safer)
        police_stations_count = len(suburbs)
        police_bonus = min(20.0, police_stations_count * 5.0)

        # Mathematical score calculation
        base_score = 85.0
        safety_score = base_score - crime_penalty + police_bonus

        # Time factors
        if period_name == "Night":
            safety_score -= 8.0

        # Cap safety score realistically between 40% and 98%
        safety_score = max(40.0, min(98.0, safety_score))

        # Determine safety rating descriptor
        if safety_score >= 80.0:
            safety_rating = "High Safety"
        elif safety_score >= 60.0:
            safety_rating = "Moderate Safety"
        else:
            safety_rating = "Caution Advised"

        police_stations = []
        for suburb in suburbs:
            if suburb in AREA_COORDINATES:
                police_stations.append({
                    "name": f"{suburb} Police Station",
                    "lat": AREA_COORDINATES[suburb]["lat"],
                    "lng": AREA_COORDINATES[suburb]["lng"]
                })

        return {
            "safety_score": round(safety_score, 1),
            "police_stations_count": police_stations_count,
            "period_crimes": period_crimes_along,
            "safety_rating": safety_rating,
            "suburbs": suburbs,
            "police_stations": police_stations
        }

