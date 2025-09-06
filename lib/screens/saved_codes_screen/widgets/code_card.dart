import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

class CodeCard extends ConsumerWidget {
  const CodeCard({super.key, required this.codeData, required this.onTap});
  final CodeData codeData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
              colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and type
              Row(
                children: [
                  // Code type icon with badge
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      codeData.codeType == CodeType.qrCode
                          ? FontAwesomeIcons.qrcode
                          : FontAwesomeIcons.barcode,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlatformText(
                          codeData.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        PlatformText(
                          codeData.codeType == CodeType.qrCode
                              ? 'QR Code'
                              : 'Barcode',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Date and delete button
                  Row(
                    children: [
                      PlatformText(
                        _formatDate(codeData.createdAt ?? DateTime.now()),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                          size: 22,
                        ),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref
                              .read(codesProvider.notifier)
                              .deleteCode(codeData.id!);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Content with preview and data
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Code preview with modern container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _BuildCodePreview(
                        codeData: codeData,
                        onTap: onTap,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Data content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlatformText(
                          'Data',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PlatformText(
                            codeData.data,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 13,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // Handle future dates (edge case)
    if (difference.isNegative) {
      return '${date.day}/${date.month}/${date.year}';
    }

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes${minutes == 1 ? ' min' : ' mins'} ago';
    }

    if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours${hours == 1 ? ' hour' : ' hours'} ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days${days == 1 ? ' day' : ' days'} ago';
    }

    // Format date as DD/MM/YYYY (pad single digits)
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _BuildCodePreview extends StatelessWidget {
  const _BuildCodePreview({required this.codeData, required this.onTap});
  final CodeData codeData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: codeData.codeType == CodeType.qrCode
          ? QrImageView(
              data: codeData.data,
              version: QrVersions.auto,
              size: 60,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            )
          : BarcodeWidget(
              barcode: Barcode.code128(),
              data: codeData.data,
              width: 60,
              height: 60,
              drawText: false,
              color: Colors.black,
              backgroundColor: Colors.white,
            ),
    );
  }
}
