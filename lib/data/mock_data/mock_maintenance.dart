// =============================================================================
// File: mock_maintenance.dart
// Module: Data / Mock Data
// Description: Mock maintenance, health, work order, and fault data.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/maintenance_model.dart';

/// Provides mock maintenance and health data for all vehicles.
class MockMaintenance {
  MockMaintenance._();

  static final List<VehicleHealth> vehicleHealthList = [
    VehicleHealth(vehicleId: 'TK-001', vehicleName: 'Al-Khalid MBT-01', vehicleType: 'Tank', healthScore: 92, predictedFailureDate: DateTime.now().add(const Duration(days: 180)), predictedFailureType: 'Track wear', maintenanceCostEstimate: 85000, faultHistory: [
      FaultRecord(id: 'F-001', vehicleId: 'TK-001', faultType: 'Track Tension', description: 'Left track tension below spec', severity: 'Minor', detectedDate: DateTime.now().subtract(const Duration(days: 60)), resolvedDate: DateTime.now().subtract(const Duration(days: 58)), technicianAssigned: 'Tech Sgt. Ahmed'),
    ]),
    VehicleHealth(vehicleId: 'TK-002', vehicleName: 'Al-Khalid MBT-02', vehicleType: 'Tank', healthScore: 35, predictedFailureDate: DateTime.now().add(const Duration(days: 12)), predictedFailureType: 'Engine overheating', maintenanceCostEstimate: 320000),
    VehicleHealth(vehicleId: 'TK-003', vehicleName: 'Al-Zarrar MBT-01', vehicleType: 'Tank', healthScore: 78, predictedFailureDate: DateTime.now().add(const Duration(days: 90)), predictedFailureType: 'Turret hydraulics', maintenanceCostEstimate: 150000),
    VehicleHealth(vehicleId: 'TK-004', vehicleName: 'Al-Khalid-I Enhanced', vehicleType: 'Tank', healthScore: 97, predictedFailureDate: DateTime.now().add(const Duration(days: 365)), predictedFailureType: 'None predicted', maintenanceCostEstimate: 25000),
    VehicleHealth(vehicleId: 'TK-005', vehicleName: 'Al-Zarrar MBT-02', vehicleType: 'Tank', healthScore: 22, predictedFailureDate: DateTime.now().add(const Duration(days: 5)), predictedFailureType: 'Transmission failure', maintenanceCostEstimate: 450000),
    VehicleHealth(vehicleId: 'APC-001', vehicleName: 'Talha APC-01', vehicleType: 'APC', healthScore: 88, predictedFailureDate: DateTime.now().add(const Duration(days: 150)), predictedFailureType: 'Brake pads', maintenanceCostEstimate: 65000),
    VehicleHealth(vehicleId: 'APC-002', vehicleName: 'Saad APC-01', vehicleType: 'APC', healthScore: 71, predictedFailureDate: DateTime.now().add(const Duration(days: 55)), predictedFailureType: 'Cooling system', maintenanceCostEstimate: 120000),
    VehicleHealth(vehicleId: 'APC-003', vehicleName: 'Talha APC-02', vehicleType: 'APC', healthScore: 28, predictedFailureDate: DateTime.now().add(const Duration(days: 8)), predictedFailureType: 'Engine seizure risk', maintenanceCostEstimate: 380000),
    VehicleHealth(vehicleId: 'ASV-001', vehicleName: 'Hamza ASV-01', vehicleType: 'ASV', healthScore: 84, predictedFailureDate: DateTime.now().add(const Duration(days: 120)), predictedFailureType: 'Suspension wear', maintenanceCostEstimate: 75000),
    VehicleHealth(vehicleId: 'ASV-002', vehicleName: 'Mohafiz ASV-01', vehicleType: 'ASV', healthScore: 55, predictedFailureDate: DateTime.now().add(const Duration(days: 35)), predictedFailureType: 'Electrical system', maintenanceCostEstimate: 200000),
  ];

  static final List<WorkOrder> workOrders = [
    WorkOrder(id: 'WO-001', vehicleId: 'TK-002', vehicleName: 'Al-Khalid MBT-02', description: 'Emergency engine overhaul - overheating detected', priority: 'Critical', status: 'In Progress', createdDate: DateTime.now().subtract(const Duration(days: 2)), assignedTechnician: 'Chief Tech. Bilal', estimatedCost: 320000, requiredParts: ['Engine gaskets', 'Coolant pump', 'Thermostat assembly']),
    WorkOrder(id: 'WO-002', vehicleId: 'TK-005', vehicleName: 'Al-Zarrar MBT-02', description: 'Transmission rebuild - grinding noise reported', priority: 'High', status: 'Open', createdDate: DateTime.now().subtract(const Duration(days: 1)), assignedTechnician: 'Tech Sgt. Farhan', estimatedCost: 450000, requiredParts: ['Transmission gears', 'Clutch plates', 'Bearings']),
    WorkOrder(id: 'WO-003', vehicleId: 'APC-003', vehicleName: 'Talha APC-02', description: 'Complete engine service and fuel system flush', priority: 'High', status: 'In Progress', createdDate: DateTime.now().subtract(const Duration(days: 3)), assignedTechnician: 'Tech Sgt. Hassan', estimatedCost: 180000, requiredParts: ['Fuel injectors', 'Fuel filter', 'Oil']),
    WorkOrder(id: 'WO-004', vehicleId: 'APC-001', vehicleName: 'Talha APC-01', description: 'Scheduled brake pad replacement', priority: 'Medium', status: 'Open', createdDate: DateTime.now(), assignedTechnician: 'Tech Cpl. Usman', estimatedCost: 45000, requiredParts: ['Brake pads (set of 8)']),
    WorkOrder(id: 'WO-005', vehicleId: 'ASV-002', vehicleName: 'Mohafiz ASV-01', description: 'Electrical diagnostics - intermittent power loss', priority: 'Medium', status: 'Open', createdDate: DateTime.now().subtract(const Duration(hours: 12)), assignedTechnician: 'Tech Sgt. Imran', estimatedCost: 95000, requiredParts: ['Wiring harness', 'Alternator']),
  ];
}
