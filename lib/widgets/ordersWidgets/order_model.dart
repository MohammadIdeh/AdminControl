import 'dart:ui';

import 'package:flutter/material.dart';

enum OrderStatus { pending, assigned, inProgress, completed, cancelled }

enum ServiceType {
  plumbing,
  electrical,
  cleaning,
  hvac,
  gardening,
  painting,
  carpentry,
  appliance,
  pest,
  locksmith,
}

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String? m3lmId;
  final String? m3lmName;
  final String? m3lmPhone;
  final String? m3lmAvatar;
  final ServiceType serviceType;
  final String serviceDescription;
  final double price;
  final double platformFee;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final double? rating;
  final String? review;
  final List<String> images;
  final String location;
  final double latitude;
  final double longitude;
  final String notes;
  final bool isPaid;
  final String paymentMethod;
  final String? promoCode;
  final double discount;
  final int estimatedDuration; // in minutes
  final bool isUrgent;
  final String priority; // 'low', 'normal', 'high', 'urgent'

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    this.m3lmId,
    this.m3lmName,
    this.m3lmPhone,
    this.m3lmAvatar,
    required this.serviceType,
    required this.serviceDescription,
    required this.price,
    required this.platformFee,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.rating,
    this.review,
    this.images = const [],
    required this.location,
    required this.latitude,
    required this.longitude,
    this.notes = '',
    required this.isPaid,
    required this.paymentMethod,
    this.promoCode,
    this.discount = 0.0,
    required this.estimatedDuration,
    this.isUrgent = false,
    required this.priority,
  });

  String get serviceDisplayName {
    switch (serviceType) {
      case ServiceType.plumbing:
        return 'Plumbing';
      case ServiceType.electrical:
        return 'Electrical';
      case ServiceType.cleaning:
        return 'Cleaning';
      case ServiceType.hvac:
        return 'HVAC';
      case ServiceType.gardening:
        return 'Gardening';
      case ServiceType.painting:
        return 'Painting';
      case ServiceType.carpentry:
        return 'Carpentry';
      case ServiceType.appliance:
        return 'Appliance Repair';
      case ServiceType.pest:
        return 'Pest Control';
      case ServiceType.locksmith:
        return 'Locksmith';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.assigned:
        return 'Assigned';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.assigned:
        return const Color(0xFF8B5CF6);
      case OrderStatus.inProgress:
        return const Color(0xFF3B82F6);
      case OrderStatus.completed:
        return const Color(0xFF10B981);
      case OrderStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }

  IconData get serviceIcon {
    switch (serviceType) {
      case ServiceType.plumbing:
        return Icons.plumbing;
      case ServiceType.electrical:
        return Icons.electrical_services;
      case ServiceType.cleaning:
        return Icons.cleaning_services;
      case ServiceType.hvac:
        return Icons.ac_unit;
      case ServiceType.gardening:
        return Icons.grass;
      case ServiceType.painting:
        return Icons.format_paint;
      case ServiceType.carpentry:
        return Icons.carpenter;
      case ServiceType.appliance:
        return Icons.kitchen;
      case ServiceType.pest:
        return Icons.bug_report;
      case ServiceType.locksmith:
        return Icons.lock;
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 'urgent':
        return const Color(0xFFEF4444);
      case 'high':
        return const Color(0xFFF59E0B);
      case 'normal':
        return const Color(0xFF3B82F6);
      case 'low':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String get formattedDuration {
    if (estimatedDuration < 60) {
      return '${estimatedDuration}min';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
    }
  }

  bool get canBeTracked {
    return status == OrderStatus.assigned || status == OrderStatus.inProgress;
  }

  bool get isActive {
    return status != OrderStatus.completed && status != OrderStatus.cancelled;
  }

  double get netAmount {
    return totalAmount - platformFee;
  }
}
