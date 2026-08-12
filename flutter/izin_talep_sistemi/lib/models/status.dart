import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum StatusType {
  pending,
  approved,
  rejected,
  cancelled,
  active,
  inactive,
  expired,
  error,
}

const statusOptions = [
  'PENDING',
  'APPROVED',
  'REJECTED',
  'CANCELLED',
  'EXPIRED',
];
const statusLabels = {
  'PENDING': 'Bekliyor',
  'APPROVED': 'Onaylandı',
  'REJECTED': 'Reddedildi',
  'CANCELLED': 'İptal Edildi',
  'EXPIRED': 'Süresi Doldu',
};

Color getStatusBackgroundColor(StatusType status) {
  switch (status) {
    case StatusType.pending:
      return Colors.orange.shade100;
    case StatusType.approved:
      return Colors.green.shade100;
    case StatusType.rejected:
      return Colors.red.shade100;
    case StatusType.cancelled:
      return Colors.grey.shade300;
    case StatusType.active:
      return Colors.blue.shade100;
    case StatusType.inactive:
      return Colors.grey.shade300;
    case StatusType.expired:
      return Colors.blueGrey;
    default:
      return Colors.red.shade300;
  }
}

Color getStatusTextColor(StatusType status) {
  switch (status) {
    case StatusType.pending:
      return Colors.orange.shade900;
    case StatusType.approved:
      return Colors.green.shade900;
    case StatusType.rejected:
      return Colors.red.shade900;
    case StatusType.cancelled:
      return Colors.grey.shade900;
    case StatusType.active:
      return Colors.blue.shade900;
    case StatusType.inactive:
      return Colors.grey.shade700;
    case StatusType.expired:
      return Colors.white;
    default:
      return Colors.red.shade900;
  }
}

String getStatusLabel(StatusType status) {
  switch (status) {
    case StatusType.pending:
      return 'Bekliyor';
    case StatusType.approved:
      return 'Onaylandı';
    case StatusType.rejected:
      return 'Reddedildi';
    case StatusType.cancelled:
      return 'İptal Edildi';
    case StatusType.expired:
      return 'Süresi Dolmuş';
    case StatusType.active:
      return 'Aktif';
    case StatusType.inactive:
      return 'Pasif';
    default:
      return 'HATA';
  }
}

StatusType convertToStatusType(String status) {
  switch (status) {
    case "APPROVED":
      return StatusType.approved;
    case "PENDING":
      return StatusType.pending;
    case "REJECTED":
      return StatusType.rejected;
    case "CANCELLED":
      return StatusType.cancelled;
    case "EXPIRED":
      return StatusType.expired;
    case "ACTIVE":
      return StatusType.active;
    case "INACTIVE":
      return StatusType.inactive;
    default:
      return StatusType.error;
  }
}

  /* Color _statusColor(StatusType status) {
    switch (status) {
      case StatusType.pending:
        return Colors.yellow.shade900;
      case StatusType.approved:
        return Colors.green.shade900;
      case StatusType.rejected:
        return Colors.red.shade900;
      case StatusType.cancelled:
        return Colors.pink.shade900;
      case StatusType.expired:
        return Colors.grey.shade900;
      default:
        return Colors.white;
    }
  } */

  /* String _statusLabel(StatusType status) {
    switch (status) {
      case 'PENDING':
        return 'Bekliyor · Sv ${request.currentLevel}';
      case 'APPROVED':
        return 'Onaylandı';
      case 'REJECTED':
        return 'Reddedildi';
      case 'CANCELLED':
        return 'İptal Edildi';
      case 'EXPIRED':
        return 'Süresi Doldu';
      default:
        return status;
    }
  } */


  /* Color _statusBg(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade100;
      case 'APPROVED':
        return Colors.green.shade100;
      case 'REJECTED':
        return Colors.red.shade100;
      case 'CANCELLED':
        return Colors.grey.shade400;
      case 'EXPIRED':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade900;
      case 'APPROVED':
        return Colors.green.shade900;
      case 'REJECTED':
        return Colors.red.shade900;
      case 'CANCELLED':
        return Colors.grey.shade900;
      case 'EXPIRED':
        return Colors.white;
      default:
        return Colors.white;
    }
  } */

  /* String _statusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Bekliyor · Sv $currentLevelPlaceholder';
      case 'APPROVED':
        return 'Onaylandı';
      case 'REJECTED':
        return 'Reddedildi';
      case 'CANCELLED':
        return 'İptal Edildi';
      case 'EXPIRED':
        return 'Süresi Doldu';
      default:
        return status;
    }
  } */

  /* Color _statusBg(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade100;
      case 'APPROVED':
        return Colors.green.shade100;
      case 'REJECTED':
        return Colors.red.shade100;
      case 'CANCELLED':
        return Colors.grey.shade400;
      case 'EXPIRED':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade900;
      case 'APPROVED':
        return Colors.green.shade900;
      case 'REJECTED':
        return Colors.red.shade900;
      case 'CANCELLED':
        return Colors.grey.shade900;
      case 'EXPIRED':
        return Colors.white;
      default:
        return Colors.white;
    }
  } */
/* 
  String _statusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Bekliyor · Sv ${request.currentLevel}';
      case 'APPROVED':
        return 'Onaylandı';
      case 'REJECTED':
        return 'Reddedildi';
      case 'CANCELLED':
        return 'İptal Edildi';
      default:
        return status;
    }
  }
 *//* 
  static const _statusOptions = [
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED',
    'EXPIRED',
  ];
  static const _statusLabels = {
    'PENDING': 'Bekliyor',
    'APPROVED': 'Onaylandı',
    'REJECTED': 'Reddedildi',
    'CANCELLED': 'İptal Edildi',
    'EXPIRED': 'Süresi Doldu',
  };
 *//* 
  Color _statusBg(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade100;
      case 'APPROVED':
        return Colors.green.shade100;
      case 'REJECTED':
        return Colors.red.shade100;
      case 'CANCELLED':
        return Colors.grey.shade400;
      case 'EXPIRED':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey.shade900;
      case 'EXPIRED':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

   StatusType _statusType(String status) {
    switch (status) {
      case 'PENDING':
        return StatusType.pending;
      case 'APPROVED':
        return StatusType.approved;
      case 'REJECTED':
        return StatusType.rejected;
      default:
        return StatusType.cancelled;
    }
  }
 *//* 
  static const _statusOptions = [
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED',
    'EXPIRED',
  ];
  static const _statusLabels = {
    'PENDING': 'Bekliyor',
    'APPROVED': 'Onaylandı',
    'REJECTED': 'Reddedildi',
    'CANCELLED': 'İptal Edildi',
    'EXPIRED': 'Süresi Doldu',
  }; */