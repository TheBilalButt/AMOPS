// =============================================================================
// File: mock_production.dart
// Module: Data / Mock Data
// Description: Mock manufacturing production orders and R&D projects.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/production_model.dart';

/// Provides mock manufacturing data with 8 production orders and R&D projects.
class MockProduction {
  MockProduction._();

  static final List<ProductionOrder> orders = [
    ProductionOrder(id: 'PO-001', vehicleType: 'Tank', orderName: 'Al-Khalid-I Batch 12', quantity: 8, progressPercentage: 72, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 120)), estimatedCompletion: DateTime.now().add(const Duration(days: 45)), qualityScore: 96, defectsFound: 1, assignedLine: 'Line A - Heavy Assembly'),
    ProductionOrder(id: 'PO-002', vehicleType: 'APC', orderName: 'Talha APC Batch 7', quantity: 12, progressPercentage: 45, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 60)), estimatedCompletion: DateTime.now().add(const Duration(days: 90)), qualityScore: 93, defectsFound: 2, assignedLine: 'Line B - Medium Assembly'),
    ProductionOrder(id: 'PO-003', vehicleType: 'ASV', orderName: 'Hamza ASV Batch 4', quantity: 6, progressPercentage: 88, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 150)), estimatedCompletion: DateTime.now().add(const Duration(days: 15)), qualityScore: 98, defectsFound: 0, assignedLine: 'Line C - Light Assembly'),
    ProductionOrder(id: 'PO-004', vehicleType: 'Tank', orderName: 'Al-Zarrar Upgrade Batch 3', quantity: 5, progressPercentage: 30, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 30)), estimatedCompletion: DateTime.now().add(const Duration(days: 120)), qualityScore: 91, defectsFound: 3, assignedLine: 'Line A - Heavy Assembly'),
    ProductionOrder(id: 'PO-005', vehicleType: 'APC', orderName: 'Saad APC Export Batch', quantity: 10, progressPercentage: 15, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 15)), estimatedCompletion: DateTime.now().add(const Duration(days: 150)), qualityScore: 95, defectsFound: 0, assignedLine: 'Line B - Medium Assembly'),
    ProductionOrder(id: 'PO-006', vehicleType: 'Tank', orderName: 'Al-Khalid-II Prototype', quantity: 2, progressPercentage: 60, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 200)), estimatedCompletion: DateTime.now().add(const Duration(days: 60)), qualityScore: 82, defectsFound: 5, assignedLine: 'Line D - R&D Assembly'),
    ProductionOrder(id: 'PO-007', vehicleType: 'ASV', orderName: 'Mohafiz ASV Batch 6', quantity: 8, progressPercentage: 95, status: 'In Progress', startDate: DateTime.now().subtract(const Duration(days: 180)), estimatedCompletion: DateTime.now().add(const Duration(days: 5)), qualityScore: 97, defectsFound: 1, assignedLine: 'Line C - Light Assembly'),
    ProductionOrder(id: 'PO-008', vehicleType: 'APC', orderName: 'Talha APC Export Batch', quantity: 15, progressPercentage: 5, status: 'On Hold', startDate: DateTime.now().subtract(const Duration(days: 5)), estimatedCompletion: DateTime.now().add(const Duration(days: 200)), qualityScore: 0, defectsFound: 0, assignedLine: 'Line B - Medium Assembly'),
  ];

  static final List<RDProject> rdProjects = [
    RDProject(id: 'RD-001', name: 'Al-Khalid-II MBT Development', description: 'Next-gen main battle tank with improved armor and fire control', completionPercentage: 62, status: 'Active', startDate: DateTime.now().subtract(const Duration(days: 730)), targetDate: DateTime.now().add(const Duration(days: 365))),
    RDProject(id: 'RD-002', name: 'Haider Tank Program', description: 'Advanced MBT with composite armor and autoloader', completionPercentage: 25, status: 'Active', startDate: DateTime.now().subtract(const Duration(days: 365)), targetDate: DateTime.now().add(const Duration(days: 730))),
    RDProject(id: 'RD-003', name: 'UCAV Integration Module', description: 'Armed drone integration for armored formations', completionPercentage: 78, status: 'Active', startDate: DateTime.now().subtract(const Duration(days: 500)), targetDate: DateTime.now().add(const Duration(days: 90))),
    RDProject(id: 'RD-004', name: 'Active Protection System', description: 'Hard-kill APS for Al-Khalid series', completionPercentage: 45, status: 'Active', startDate: DateTime.now().subtract(const Duration(days: 400)), targetDate: DateTime.now().add(const Duration(days: 200))),
  ];
}
