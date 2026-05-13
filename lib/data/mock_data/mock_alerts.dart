// =============================================================================
// File: mock_alerts.dart
// Module: Data / Mock Data
// Description: Mock alert/notification data for the dashboard.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/alert_model.dart';

/// Provides mock alert data for the dashboard and notification system.
class MockAlerts {
  MockAlerts._();

  static final List<AlertModel> alerts = [
    AlertModel(id: 'ALT-001', title: 'CRITICAL: UAV-003 Battery Low', message: 'Drone UAV-003 battery at 15%. Auto-returning to base.', severity: 'Critical', module: 'Drones', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    AlertModel(id: 'ALT-002', title: 'Aerial Intrusion Detected', message: 'Unidentified UAV crossing border airspace in Sector-A.', severity: 'Critical', module: 'Threats', timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
    AlertModel(id: 'ALT-003', title: 'Al-Khalid MBT-02 Maintenance Required', message: 'Engine hours exceeded 500hrs. Last service 120 days ago.', severity: 'Warning', module: 'Vehicles', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    AlertModel(id: 'ALT-004', title: 'Aviation Fuel Below Safe Level', message: 'Jet-A1 stock at 12,000L (below 15,000L threshold).', severity: 'Warning', module: 'Logistics', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    AlertModel(id: 'ALT-005', title: 'Cyber Probe Detected', message: 'APT detected targeting HIT manufacturing network.', severity: 'Critical', module: 'Threats', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
    AlertModel(id: 'ALT-006', title: 'UAV-008 HIGH RISK', message: 'Suspicious object count reached 4 in Sector-E.', severity: 'Warning', module: 'Drones', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
    AlertModel(id: 'ALT-007', title: 'Quality Alert: PO-006', message: 'Al-Khalid-II prototype quality score dropped to 82%.', severity: 'Warning', module: 'Manufacturing', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
    AlertModel(id: 'ALT-008', title: 'Delivery Delayed', message: 'Spare parts shipment DEL-003 delayed by 6 hours.', severity: 'Info', module: 'Logistics', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
    AlertModel(id: 'ALT-009', title: 'UAE Deal Progress', message: 'Hamza ASV contract moved to final approval stage.', severity: 'Info', module: 'Sales', timestamp: DateTime.now().subtract(const Duration(hours: 8))),
    AlertModel(id: 'ALT-010', title: 'UAV-004 Signal Risk', message: 'Signal strength at 25% in Sector-B. Mission at risk.', severity: 'Warning', module: 'Drones', timestamp: DateTime.now().subtract(const Duration(hours: 10))),
  ];
}
