// =============================================================================
// File: mock_drones.dart
// Module: Data / Mock Data
// Description: Realistic mock data for 12 drones with Pakistani locations.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/drone_model.dart';

/// Provides mock data for 12 drones with varied statuses and locations.
class MockDrones {
  MockDrones._();

  static final List<DroneModel> drones = [
    DroneModel(
      id: 'UAV-001', name: 'Shahpar-I Alpha',
      batteryPercentage: 87, latitude: 33.7738, longitude: 72.3570,
      altitude: 3200, missionStatus: 'Active', cameraOnline: true,
      signalStrength: 92, suspiciousObjectCount: 1, assignedSector: 'Sector-A',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 3)),
      missionHistory: [
        MissionRecord(missionId: 'M-101', description: 'Border patrol - Northern sector',
          startTime: DateTime.now().subtract(const Duration(hours: 4)),
          status: 'In Progress', sector: 'Sector-A'),
        MissionRecord(missionId: 'M-098', description: 'Surveillance sweep Wah Cantt perimeter',
          startTime: DateTime.now().subtract(const Duration(days: 1)),
          endTime: DateTime.now().subtract(const Duration(days: 1, hours: -6)),
          status: 'Completed', sector: 'Sector-A'),
      ],
    ),
    DroneModel(
      id: 'UAV-002', name: 'Burraq Strike-II',
      batteryPercentage: 62, latitude: 33.9960, longitude: 71.4950,
      altitude: 4500, missionStatus: 'Active', cameraOnline: true,
      signalStrength: 78, suspiciousObjectCount: 0, assignedSector: 'Sector-B',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      missionHistory: [
        MissionRecord(missionId: 'M-102', description: 'Reconnaissance over Khyber sector',
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          status: 'In Progress', sector: 'Sector-B'),
      ],
    ),
    DroneModel(
      id: 'UAV-003', name: 'Nescom Anka-III',
      batteryPercentage: 15, latitude: 33.6017, longitude: 73.0480,
      altitude: 1800, missionStatus: 'Returning', cameraOnline: true,
      signalStrength: 45, suspiciousObjectCount: 3, assignedSector: 'Sector-C',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
      missionHistory: [
        MissionRecord(missionId: 'M-100', description: 'Urban surveillance Islamabad perimeter',
          startTime: DateTime.now().subtract(const Duration(hours: 5)),
          status: 'In Progress', sector: 'Sector-C'),
      ],
    ),
    DroneModel(
      id: 'UAV-004', name: 'Shahpar-II Recon',
      batteryPercentage: 45, latitude: 34.0151, longitude: 71.5249,
      altitude: 2800, missionStatus: 'Active', cameraOnline: false,
      signalStrength: 25, suspiciousObjectCount: 2, assignedSector: 'Sector-B',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 8)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-005', name: 'GIDS Ranger',
      batteryPercentage: 98, latitude: 33.7463, longitude: 72.8397,
      altitude: 0, missionStatus: 'Standby', cameraOnline: true,
      signalStrength: 100, suspiciousObjectCount: 0, assignedSector: 'Sector-A',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-006', name: 'Burraq Combat-I',
      batteryPercentage: 33, latitude: 25.3960, longitude: 68.3578,
      altitude: 5200, missionStatus: 'Active', cameraOnline: true,
      signalStrength: 67, suspiciousObjectCount: 1, assignedSector: 'Sector-D',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 4)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-007', name: 'Uqab Tactical',
      batteryPercentage: 0, latitude: 33.7700, longitude: 72.3600,
      altitude: 0, missionStatus: 'Offline', cameraOnline: false,
      signalStrength: 0, suspiciousObjectCount: 0, assignedSector: 'Sector-A',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-008', name: 'Shahpar Recon-IV',
      batteryPercentage: 74, latitude: 35.9200, longitude: 74.3100,
      altitude: 6100, missionStatus: 'Active', cameraOnline: true,
      signalStrength: 55, suspiciousObjectCount: 4, assignedSector: 'Sector-E',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 6)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-009', name: 'Falco Surveillance',
      batteryPercentage: 56, latitude: 30.1575, longitude: 66.9960,
      altitude: 3800, missionStatus: 'Active', cameraOnline: true,
      signalStrength: 81, suspiciousObjectCount: 0, assignedSector: 'Sector-F',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 7)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-010', name: 'NESCOM Scout',
      batteryPercentage: 18, latitude: 34.7740, longitude: 72.3610,
      altitude: 2100, missionStatus: 'Returning', cameraOnline: true,
      signalStrength: 38, suspiciousObjectCount: 1, assignedSector: 'Sector-A',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-011', name: 'Burraq Overwatch',
      batteryPercentage: 91, latitude: 33.6844, longitude: 73.0479,
      altitude: 4000, missionStatus: 'Standby', cameraOnline: true,
      signalStrength: 95, suspiciousObjectCount: 0, assignedSector: 'Sector-C',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
      missionHistory: [],
    ),
    DroneModel(
      id: 'UAV-012', name: 'GIDS Hawk-II',
      batteryPercentage: 42, latitude: 31.5204, longitude: 74.3587,
      altitude: 3500, missionStatus: 'Active', cameraOnline: true,
      signalStrength: 72, suspiciousObjectCount: 2, assignedSector: 'Sector-G',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      missionHistory: [],
    ),
  ];
}
