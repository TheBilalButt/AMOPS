// =============================================================================
// File: app_strings.dart
// Module: Core / Constants
// Description: All string constants used throughout the AMOPS application.
//              No hardcoded strings should exist outside this file.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Centralized string constants for the AMOPS application.
/// All user-facing strings are defined here to ensure consistency.
class AppStrings {
  AppStrings._();

  // ── App Info ────────────────────────────────────────────────────────────
  static const String appName = 'AMOPS';
  static const String appFullName = 'Autonomous Military Operations Platform System';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Centralized AI-powered command center for managing defense assets '
      'including drones, tanks, armored vehicles, threat intelligence, '
      'predictive maintenance, logistics, manufacturing, and export sales.';
  static const String organization1 = 'Heavy Industries Taxila (HIT)';
  static const String organization2 = 'Margalla Heavy Industries Limited (MHIL)';
  static const String country = 'Pakistan';

  // ── Navigation Labels ──────────────────────────────────────────────────
  static const String navDashboard = 'Dashboard';
  static const String navFleet = 'Fleet';
  static const String navThreats = 'Threats';
  static const String navLogistics = 'Logistics';
  static const String navMore = 'More';
  static const String navDrones = 'Drones';
  static const String navVehicles = 'Vehicles';
  static const String navMaintenance = 'Maintenance';
  static const String navManufacturing = 'Manufacturing';
  static const String navSales = 'Sales';
  static const String navAiAssistant = 'AI Assistant';
  static const String navSettings = 'Settings';

  // ── Dashboard ──────────────────────────────────────────────────────────
  static const String dashboardTitle = 'Command Dashboard';
  static const String activeDrones = 'Active Drones';
  static const String activeTanks = 'Active Tanks';
  static const String underMaintenance = 'Under Maintenance';
  static const String criticalAlerts = 'Critical Alerts';
  static const String threatLevel = 'AI Threat Level';
  static const String fleetHealth = 'Fleet Health';
  static const String recentAlerts = 'Recent Alerts';
  static const String quickStats = 'Quick Stats';
  static const String aiBriefing = 'AI Daily Briefing';
  static const String assetActivity = 'Asset Activity (7 Days)';
  static const String fuelAverage = 'Fuel Avg';
  static const String batteryAverage = 'Battery Avg';
  static const String ammoStatus = 'Ammo Status';

  // ── Drone Module ───────────────────────────────────────────────────────
  static const String droneFleetTitle = 'Drone Fleet Control';
  static const String droneId = 'Drone ID';
  static const String battery = 'Battery';
  static const String altitude = 'Altitude';
  static const String gpsCoords = 'GPS Coordinates';
  static const String missionStatus = 'Mission Status';
  static const String cameraStatus = 'Camera Status';
  static const String signalStrength = 'Signal Strength';
  static const String launchDrone = 'Launch';
  static const String returnToBase = 'Return To Base';
  static const String abortMission = 'Abort Mission';
  static const String missionHistory = 'Mission History';
  static const String batteryPrediction = 'Battery Prediction';
  static const String estimatedFlightTime = 'Estimated Flight Time Remaining';

  // ── Vehicle Module ─────────────────────────────────────────────────────
  static const String vehicleFleetTitle = 'Tank & Armored Vehicle Fleet';
  static const String vehicleId = 'Vehicle ID';
  static const String vehicleType = 'Type';
  static const String fuelLevel = 'Fuel Level';
  static const String ammoCount = 'Ammunition';
  static const String engineHours = 'Engine Hours';
  static const String deploymentLocation = 'Deployment Location';
  static const String operationalStatus = 'Status';
  static const String maintenanceHistory = 'Maintenance History';
  static const String aiReadinessScore = 'AI Readiness Score';
  static const String deploymentRecommendation = 'Deployment Recommendation';
  static const String deploymentOptimizer = 'AI Deployment Optimizer';

  // ── Threat Module ──────────────────────────────────────────────────────
  static const String threatIntelTitle = 'Threat Intelligence Engine';
  static const String liveThreatMap = 'Live Threat Map';
  static const String threatFeed = 'Threat Feed';
  static const String detectionCounter = 'Detection Counter';
  static const String suspiciousMovement = 'Suspicious Movement Log';
  static const String radarAlerts = 'Radar Alerts';
  static const String geoFenceAlert = 'Geo-Fence Alert';
  static const String commanderNotify = 'Commander Notification';

  // ── Maintenance Module ─────────────────────────────────────────────────
  static const String maintenanceTitle = 'Predictive Maintenance & Fault Intelligence';
  static const String vehicleHealthScores = 'Vehicle Health Scores';
  static const String failureTimeline = 'Predicted Failure Timeline';
  static const String faultHistory = 'Fault History';
  static const String technicianAssignment = 'Technician Assignments';
  static const String partsReplacement = 'Parts Replacement';
  static const String workOrders = 'Work Orders';
  static const String failurePrediction = 'Failure Prediction';
  static const String maintenanceCost = 'Maintenance Cost Estimate';

  // ── Logistics Module ───────────────────────────────────────────────────
  static const String logisticsTitle = 'Logistics & Supply Chain';
  static const String fuelInventory = 'Fuel Inventory';
  static const String ammoStock = 'Ammunition Stock';
  static const String spareParts = 'Spare Parts Inventory';
  static const String fuelTrucks = 'Fuel Truck Locations';
  static const String deliveryTracking = 'Delivery Tracking';
  static const String supplierScores = 'Supplier Performance';
  static const String demandForecast = 'Demand Forecast';
  static const String resupplySuggestion = 'Auto Resupply Suggestion';

  // ── Manufacturing Module ───────────────────────────────────────────────
  static const String manufacturingTitle = 'Manufacturing & Quality Control';
  static const String productionProgress = 'Production Line Progress';
  static const String activeOrders = 'Active Production Orders';
  static const String qualityAlerts = 'Quality Defect Alerts';
  static const String batchQuality = 'Batch Quality Scores';
  static const String shiftPerformance = 'Shift Performance';
  static const String supplierQuality = 'Supplier Component Quality';
  static const String rdTracker = 'R&D Project Tracker';

  // ── Sales Module ───────────────────────────────────────────────────────
  static const String salesTitle = 'Export Sales Intelligence';
  static const String dealPipeline = 'Deal Pipeline';
  static const String tenderOpportunities = 'Tender Opportunities';
  static const String productCatalog = 'Product Catalog';
  static const String defenseShows = 'Defense Show Calendar';
  static const String revenueForecast = 'Revenue Forecast';
  static const String winProbability = 'Win Probability';

  // ── AI Assistant ───────────────────────────────────────────────────────
  static const String aiAssistantTitle = 'AI Command Assistant';
  static const String typeMessage = 'Type a message...';
  static const String suggestedQuestions = 'Suggested Questions';

  // ── Settings ───────────────────────────────────────────────────────────
  static const String settingsTitle = 'Settings & Profile';
  static const String userProfile = 'User Profile';
  static const String notificationPrefs = 'Notification Preferences';
  static const String themeToggle = 'Theme';
  static const String alertThresholds = 'Alert Thresholds';
  static const String aboutAmops = 'About AMOPS';
  static const String logout = 'Logout';

  // ── Status Labels ──────────────────────────────────────────────────────
  static const String active = 'Active';
  static const String returning = 'Returning';
  static const String standby = 'Standby';
  static const String offline = 'Offline';
  static const String operational = 'Operational';
  static const String critical = 'Critical';
  static const String maintenance = 'Maintenance';
  static const String online = 'Online';

  // ── Misc ───────────────────────────────────────────────────────────────
  static const String noData = 'No data available';
  static const String loading = 'Loading...';
  static const String error = 'An error occurred';
  static const String retry = 'Retry';
}
