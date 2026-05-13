// =============================================================================
// File: deal_model.dart
// Module: Core / Models
// Description: Models for export sales deals, tenders, and defense events.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

/// Represents an export sales deal in the pipeline.
class DealModel {
  final String id;
  final String country;
  final String product;
  final double dealValue;
  final String stage; // Lead, Quote, Negotiation, Contract, Closed
  final double winProbability;
  final String contactPerson;
  final String proposalSummary;
  final DateTime createdDate;
  final DateTime? closedDate;

  const DealModel({
    required this.id,
    required this.country,
    required this.product,
    required this.dealValue,
    required this.stage,
    required this.winProbability,
    required this.contactPerson,
    required this.proposalSummary,
    required this.createdDate,
    this.closedDate,
  });

  int get stageIndex {
    const stages = ['Lead', 'Quote', 'Negotiation', 'Contract', 'Closed'];
    return stages.indexOf(stage);
  }
}

/// Represents a defense show / exhibition event.
class DefenseEvent {
  final String id;
  final String name;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const DefenseEvent({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.description,
  });
}

/// International tender opportunity.
class TenderOpportunity {
  final String id;
  final String title;
  final String country;
  final String category;
  final double estimatedValue;
  final DateTime deadline;
  final String status; // Open, Submitted, Closed

  const TenderOpportunity({
    required this.id,
    required this.title,
    required this.country,
    required this.category,
    required this.estimatedValue,
    required this.deadline,
    required this.status,
  });
}
