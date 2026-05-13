// =============================================================================
// File: mock_deals.dart
// Module: Data / Mock Data
// Description: Mock export deals, tenders, and defense events.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import '../../core/models/deal_model.dart';

/// Provides mock export sales data with 6 deals and defense events.
class MockDeals {
  MockDeals._();

  static final List<DealModel> deals = [
    DealModel(id: 'DEAL-001', country: 'Saudi Arabia', product: 'Al-Khalid-I MBT', dealValue: 850000000, stage: 'Negotiation', winProbability: 72, contactPerson: 'Gen. Al-Rashid', proposalSummary: 'Supply of 50 Al-Khalid-I MBTs with full logistics package, training, and 5-year maintenance support contract.', createdDate: DateTime.now().subtract(const Duration(days: 180))),
    DealModel(id: 'DEAL-002', country: 'UAE', product: 'Hamza ASV', dealValue: 120000000, stage: 'Contract', winProbability: 91, contactPerson: 'Col. Al-Maktoum', proposalSummary: 'Delivery of 30 Hamza ASVs configured for urban security operations with communication suite.', createdDate: DateTime.now().subtract(const Duration(days: 120))),
    DealModel(id: 'DEAL-003', country: 'Myanmar', product: 'Talha APC', dealValue: 95000000, stage: 'Quote', winProbability: 45, contactPerson: 'Brig. Than Shwe', proposalSummary: 'Quotation for 40 Talha APCs with basic armament package and operator training.', createdDate: DateTime.now().subtract(const Duration(days: 60))),
    DealModel(id: 'DEAL-004', country: 'Nigeria', product: 'Al-Zarrar MBT', dealValue: 320000000, stage: 'Lead', winProbability: 28, contactPerson: 'Maj. Gen. Okonkwo', proposalSummary: 'Initial interest in 25 Al-Zarrar MBTs for counter-insurgency operations. Early discussions.', createdDate: DateTime.now().subtract(const Duration(days: 30))),
    DealModel(id: 'DEAL-005', country: 'Morocco', product: 'Saad APC', dealValue: 180000000, stage: 'Negotiation', winProbability: 65, contactPerson: 'Col. Bennani', proposalSummary: 'Supply of 60 Saad APCs with desert configuration and NBC protection upgrade.', createdDate: DateTime.now().subtract(const Duration(days: 90))),
    DealModel(id: 'DEAL-006', country: 'Sri Lanka', product: 'Mohafiz ASV', dealValue: 55000000, stage: 'Closed', winProbability: 100, contactPerson: 'Brig. Rajapaksa', proposalSummary: 'Contract signed for 20 Mohafiz ASVs with mine-resistant package. Delivery Q3 2026.', createdDate: DateTime.now().subtract(const Duration(days: 240)), closedDate: DateTime.now().subtract(const Duration(days: 15))),
  ];

  static final List<TenderOpportunity> tenders = [
    TenderOpportunity(id: 'TND-001', title: 'Main Battle Tank Procurement - Phase II', country: 'Bangladesh', category: 'Heavy Armor', estimatedValue: 500000000, deadline: DateTime.now().add(const Duration(days: 45)), status: 'Open'),
    TenderOpportunity(id: 'TND-002', title: 'Armored Personnel Carrier Fleet Renewal', country: 'Azerbaijan', category: 'APC', estimatedValue: 280000000, deadline: DateTime.now().add(const Duration(days: 30)), status: 'Open'),
    TenderOpportunity(id: 'TND-003', title: 'Border Security Vehicle Program', country: 'Kenya', category: 'ASV', estimatedValue: 150000000, deadline: DateTime.now().add(const Duration(days: 60)), status: 'Open'),
    TenderOpportunity(id: 'TND-004', title: 'Infantry Fighting Vehicle Modernization', country: 'Egypt', category: 'IFV', estimatedValue: 720000000, deadline: DateTime.now().subtract(const Duration(days: 5)), status: 'Submitted'),
  ];

  static final List<DefenseEvent> events = [
    DefenseEvent(id: 'EVT-001', name: 'IDEAS 2026', location: 'Karachi, Pakistan', startDate: DateTime(2026, 11, 15), endDate: DateTime(2026, 11, 18), description: 'International Defence Exhibition & Seminar'),
    DefenseEvent(id: 'EVT-002', name: 'DSEI 2027', location: 'London, UK', startDate: DateTime(2027, 9, 12), endDate: DateTime(2027, 9, 15), description: 'Defence and Security Equipment International'),
    DefenseEvent(id: 'EVT-003', name: 'IDEF 2027', location: 'Istanbul, Turkey', startDate: DateTime(2027, 5, 25), endDate: DateTime(2027, 5, 28), description: 'International Defence Industry Fair'),
    DefenseEvent(id: 'EVT-004', name: 'WDS 2027', location: 'Riyadh, Saudi Arabia', startDate: DateTime(2027, 3, 6), endDate: DateTime(2027, 3, 9), description: 'World Defense Show'),
    DefenseEvent(id: 'EVT-005', name: 'EUROSATORY 2026', location: 'Paris, France', startDate: DateTime(2026, 6, 17), endDate: DateTime(2026, 6, 21), description: 'International Land and Airland Defence Exhibition'),
  ];
}
