// =============================================================================
// File: mock_logistics.dart
// Module: Data / Mock Data
// Description: Mock logistics inventory, deliveries, and supplier data.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/logistics_model.dart';

/// Provides mock logistics and supply chain data.
class MockLogistics {
  MockLogistics._();

  static final List<InventoryItem> inventory = [
    InventoryItem(id: 'INV-001', name: 'Diesel Fuel (JP-8)', category: 'Fuel', currentStock: 45000, maxCapacity: 100000, safeLevel: 25000, unit: 'Liters', lastRestocked: DateTime.now().subtract(const Duration(days: 5))),
    InventoryItem(id: 'INV-002', name: 'Aviation Fuel (Jet-A1)', category: 'Fuel', currentStock: 12000, maxCapacity: 50000, safeLevel: 15000, unit: 'Liters', lastRestocked: DateTime.now().subtract(const Duration(days: 8))),
    InventoryItem(id: 'INV-003', name: '125mm Tank Rounds', category: 'Ammunition', currentStock: 320, maxCapacity: 500, safeLevel: 100, unit: 'Rounds', lastRestocked: DateTime.now().subtract(const Duration(days: 15))),
    InventoryItem(id: 'INV-004', name: '7.62mm NATO', category: 'Ammunition', currentStock: 85000, maxCapacity: 200000, safeLevel: 50000, unit: 'Rounds', lastRestocked: DateTime.now().subtract(const Duration(days: 10))),
    InventoryItem(id: 'INV-005', name: '12.7mm HMG Rounds', category: 'Ammunition', currentStock: 15000, maxCapacity: 50000, safeLevel: 12000, unit: 'Rounds', lastRestocked: DateTime.now().subtract(const Duration(days: 12))),
    InventoryItem(id: 'INV-006', name: 'Track Links (Al-Khalid)', category: 'Spare Parts', currentStock: 48, maxCapacity: 200, safeLevel: 40, unit: 'Units', lastRestocked: DateTime.now().subtract(const Duration(days: 20))),
    InventoryItem(id: 'INV-007', name: 'Engine Oil (MIL-PRF)', category: 'Spare Parts', currentStock: 800, maxCapacity: 2000, safeLevel: 500, unit: 'Liters', lastRestocked: DateTime.now().subtract(const Duration(days: 7))),
    InventoryItem(id: 'INV-008', name: 'Air Filters (Universal)', category: 'Spare Parts', currentStock: 35, maxCapacity: 150, safeLevel: 30, unit: 'Units', lastRestocked: DateTime.now().subtract(const Duration(days: 25))),
    InventoryItem(id: 'INV-009', name: 'Brake Pad Sets', category: 'Spare Parts', currentStock: 22, maxCapacity: 100, safeLevel: 20, unit: 'Sets', lastRestocked: DateTime.now().subtract(const Duration(days: 18))),
    InventoryItem(id: 'INV-010', name: 'Smoke Grenades', category: 'Ammunition', currentStock: 180, maxCapacity: 400, safeLevel: 80, unit: 'Units', lastRestocked: DateTime.now().subtract(const Duration(days: 30))),
  ];

  static final List<DeliveryTracking> deliveries = [
    DeliveryTracking(id: 'DEL-001', description: 'Fuel Tanker - JP-8 Diesel', origin: 'Karachi Port', destination: 'Taxila HIT', status: 'In Transit', estimatedArrival: DateTime.now().add(const Duration(hours: 8)), progress: 0.65, vehicleId: 'FT-012'),
    DeliveryTracking(id: 'DEL-002', description: 'Ammunition Crate - 125mm Rounds', origin: 'POF Wah', destination: 'Kharian Cantt', status: 'In Transit', estimatedArrival: DateTime.now().add(const Duration(hours: 3)), progress: 0.85, vehicleId: 'MT-045'),
    DeliveryTracking(id: 'DEL-003', description: 'Spare Parts - Engine Components', origin: 'MHIL Islamabad', destination: 'Multan Cantt', status: 'Delayed', estimatedArrival: DateTime.now().add(const Duration(hours: 18)), progress: 0.30, vehicleId: 'MT-078'),
    DeliveryTracking(id: 'DEL-004', description: 'Aviation Fuel Supply', origin: 'Attock Refinery', destination: 'Kamra PAC', status: 'Scheduled', estimatedArrival: DateTime.now().add(const Duration(days: 1)), progress: 0.0, vehicleId: 'FT-023'),
    DeliveryTracking(id: 'DEL-005', description: 'Track Links & Brake Pads', origin: 'HIT Taxila', destination: 'Bahawalpur Cantt', status: 'Delivered', estimatedArrival: DateTime.now().subtract(const Duration(hours: 2)), progress: 1.0, vehicleId: 'MT-091'),
  ];

  static final List<SupplierScore> suppliers = [
    SupplierScore(id: 'SUP-001', name: 'Pakistan Ordnance Factories', qualityScore: 95, deliveryScore: 88, overallScore: 92, totalOrders: 156, defectiveOrders: 3),
    SupplierScore(id: 'SUP-002', name: 'HIT Subsidiary - Forgings', qualityScore: 91, deliveryScore: 94, overallScore: 93, totalOrders: 89, defectiveOrders: 2),
    SupplierScore(id: 'SUP-003', name: 'DESTO Components', qualityScore: 87, deliveryScore: 78, overallScore: 83, totalOrders: 67, defectiveOrders: 5),
    SupplierScore(id: 'SUP-004', name: 'AWC Wah Electronics', qualityScore: 93, deliveryScore: 90, overallScore: 92, totalOrders: 112, defectiveOrders: 4),
    SupplierScore(id: 'SUP-005', name: 'GIDS Systems Ltd', qualityScore: 89, deliveryScore: 85, overallScore: 87, totalOrders: 45, defectiveOrders: 3),
  ];
}
