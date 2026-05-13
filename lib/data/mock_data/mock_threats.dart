// =============================================================================
// File: mock_threats.dart
// Module: Data / Mock Data
// Description: 20 realistic threat events across different sectors and levels.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/threat_model.dart';

/// Provides mock threat intelligence data.
class MockThreats {
  MockThreats._();

  static final List<ThreatModel> threats = [
    ThreatModel(id: 'THR-001', type: 'Aerial Intrusion', riskLevel: 'Critical',
      sector: 'Sector-A', location: 'Northern Border - Waziristan',
      latitude: 33.05, longitude: 70.33, description: 'Unidentified UAV detected crossing border airspace at 4500m altitude.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)), isPatternMatch: true),
    ThreatModel(id: 'THR-002', type: 'Ground Movement', riskLevel: 'High',
      sector: 'Sector-B', location: 'Khyber Pass Approach',
      latitude: 34.10, longitude: 71.10, description: 'Unusual vehicle convoy detected moving toward checkpoint.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 42))),
    ThreatModel(id: 'THR-003', type: 'Cyber Probe', riskLevel: 'Medium',
      sector: 'Sector-C', location: 'AMOPS Network Node 7',
      latitude: 33.68, longitude: 73.04, description: 'Multiple failed authentication attempts on secure channel.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ThreatModel(id: 'THR-004', type: 'Suspicious Activity', riskLevel: 'Low',
      sector: 'Sector-D', location: 'Hyderabad Outskirts',
      latitude: 25.39, longitude: 68.37, description: 'Civilian drone spotted near restricted airspace boundary.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    ThreatModel(id: 'THR-005', type: 'Ground Movement', riskLevel: 'Critical',
      sector: 'Sector-A', location: 'LoC Sector - Neelum Valley',
      latitude: 34.59, longitude: 73.90, description: 'Heavy artillery repositioning detected along LoC.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)), isPatternMatch: true),
    ThreatModel(id: 'THR-006', type: 'Aerial Intrusion', riskLevel: 'High',
      sector: 'Sector-A', location: 'Sialkot Air Defense Zone',
      latitude: 32.50, longitude: 74.53, description: 'Fast-moving aerial object detected on radar. IFF negative.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4))),
    ThreatModel(id: 'THR-007', type: 'IED Threat', riskLevel: 'High',
      sector: 'Sector-B', location: 'South Waziristan Route',
      latitude: 32.30, longitude: 69.97, description: 'Intelligence report indicates possible IED placement on supply route.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5))),
    ThreatModel(id: 'THR-008', type: 'Signal Jamming', riskLevel: 'Medium',
      sector: 'Sector-E', location: 'Gilgit-Baltistan',
      latitude: 35.92, longitude: 74.31, description: 'Intermittent signal jamming affecting drone communications.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6))),
    ThreatModel(id: 'THR-009', type: 'Maritime Alert', riskLevel: 'Low',
      sector: 'Sector-F', location: 'Gwadar Port Vicinity',
      latitude: 25.12, longitude: 62.33, description: 'Unregistered vessel loitering near port approach.',
      timestamp: DateTime.now().subtract(const Duration(hours: 7))),
    ThreatModel(id: 'THR-010', type: 'Ground Movement', riskLevel: 'Medium',
      sector: 'Sector-A', location: 'Wagah Border',
      latitude: 31.60, longitude: 74.57, description: 'Increased military vehicle activity observed on opposite side.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8))),
    ThreatModel(id: 'THR-011', type: 'Cyber Attack', riskLevel: 'Critical',
      sector: 'Sector-C', location: 'HIT Network Infrastructure',
      latitude: 33.74, longitude: 72.84, description: 'Advanced persistent threat detected targeting manufacturing systems.',
      timestamp: DateTime.now().subtract(const Duration(hours: 9)), isPatternMatch: true),
    ThreatModel(id: 'THR-012', type: 'Suspicious Activity', riskLevel: 'Low',
      sector: 'Sector-D', location: 'Karachi Port Area',
      latitude: 24.85, longitude: 67.00, description: 'Unauthorized photography reported near naval installation.',
      timestamp: DateTime.now().subtract(const Duration(hours: 10))),
    ThreatModel(id: 'THR-013', type: 'Aerial Intrusion', riskLevel: 'High',
      sector: 'Sector-E', location: 'Skardu Airbase Perimeter',
      latitude: 35.33, longitude: 75.54, description: 'Small drone detected at low altitude near airbase.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12))),
    ThreatModel(id: 'THR-014', type: 'Ground Movement', riskLevel: 'Medium',
      sector: 'Sector-B', location: 'Torkham Border Crossing',
      latitude: 34.09, longitude: 71.09, description: 'Suspicious cargo movement reported by border intel.',
      timestamp: DateTime.now().subtract(const Duration(hours: 14))),
    ThreatModel(id: 'THR-015', type: 'Signal Intelligence', riskLevel: 'High',
      sector: 'Sector-A', location: 'LoC Sector - Poonch',
      latitude: 33.77, longitude: 73.99, description: 'Encrypted radio communications spike detected from hostile side.',
      timestamp: DateTime.now().subtract(const Duration(hours: 16)), isGeoFenceViolation: true),
    ThreatModel(id: 'THR-016', type: 'IED Threat', riskLevel: 'Medium',
      sector: 'Sector-F', location: 'Balochistan Highway',
      latitude: 30.15, longitude: 66.99, description: 'Routine patrol discovered disturbed road surface.',
      timestamp: DateTime.now().subtract(const Duration(hours: 18))),
    ThreatModel(id: 'THR-017', type: 'Cyber Probe', riskLevel: 'Low',
      sector: 'Sector-C', location: 'AMOPS Satellite Link',
      latitude: 33.69, longitude: 73.03, description: 'Port scan activity detected on external firewall.',
      timestamp: DateTime.now().subtract(const Duration(hours: 20))),
    ThreatModel(id: 'THR-018', type: 'Ground Movement', riskLevel: 'High',
      sector: 'Sector-A', location: 'Rajasthan Border',
      latitude: 28.00, longitude: 70.50, description: 'Troop exercise activity detected near international border.',
      timestamp: DateTime.now().subtract(const Duration(hours: 22))),
    ThreatModel(id: 'THR-019', type: 'Suspicious Activity', riskLevel: 'Medium',
      sector: 'Sector-G', location: 'Lahore Cantt Perimeter',
      latitude: 31.52, longitude: 74.35, description: 'Repeated surveillance of military installation reported.',
      timestamp: DateTime.now().subtract(const Duration(hours: 24))),
    ThreatModel(id: 'THR-020', type: 'Aerial Intrusion', riskLevel: 'Low',
      sector: 'Sector-D', location: 'Jacobabad Airbase',
      latitude: 28.28, longitude: 68.45, description: 'Weather balloon mistakenly entered restricted zone.',
      timestamp: DateTime.now().subtract(const Duration(hours: 30))),
  ];

  static final List<RadarAlert> radarAlerts = [
    RadarAlert(id: 'RAD-001', type: 'Unidentified Aircraft', bearing: 'NNE 045°', distance: 120, timestamp: DateTime.now().subtract(const Duration(minutes: 8)), status: 'Active'),
    RadarAlert(id: 'RAD-002', type: 'Helicopter', bearing: 'E 090°', distance: 85, timestamp: DateTime.now().subtract(const Duration(minutes: 25)), status: 'Monitoring'),
    RadarAlert(id: 'RAD-003', type: 'Fast Mover', bearing: 'NW 315°', distance: 200, timestamp: DateTime.now().subtract(const Duration(hours: 1)), status: 'Resolved'),
    RadarAlert(id: 'RAD-004', type: 'Slow Mover - Possible UAV', bearing: 'SW 225°', distance: 45, timestamp: DateTime.now().subtract(const Duration(minutes: 5)), status: 'Active'),
  ];
}
