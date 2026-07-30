import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/section.dart';
import '../widgets/reveal_on_scroll.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  void showImageDialog(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => _ImageDialog(
        certificates: certificates,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Palette.heroSurface),
              padding: Space.sectionPad(isMobile),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Space.md),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: Radii.chip,
                        ),
                        child: Icon(
                          LucideIcons.award,
                          size: isMobile ? 40 : 56,
                          color: Palette.n0,
                        ),
                      ),
                      const SizedBox(height: Space.lg),
                      Text(
                        'Certificates & Compliance',
                        style: (isMobile
                                ? Theme.of(context).textTheme.headlineLarge
                                : Theme.of(context).textTheme.displaySmall)
                            ?.copyWith(color: Palette.n0),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Space.sm),
                      Text(
                        'Committed to the highest standards of quality, safety, and compliance in everything we do',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Our Commitment Section
            SectionWrapper(
              background: Palette.n0,
              child: Column(
                children: [
                  const SectionHeader(title: 'Our Commitment to Excellence'),
                  const SizedBox(height: Space.xl),
                  Wrap(
                    spacing: Space.lg,
                    runSpacing: Space.lg,
                    alignment: WrapAlignment.center,
                    children: [
                      RevealOnScroll(
                        delayMs: 0,
                        child: _buildCommitmentCard(
                          context,
                          isMobile,
                          LucideIcons.shieldCheck,
                          'ISO 9001:2015',
                          'Quality Management System certified for consistent, high-quality service delivery',
                          Palette.construction,
                        ),
                      ),
                      RevealOnScroll(
                        delayMs: 60,
                        child: _buildCommitmentCard(
                          context,
                          isMobile,
                          LucideIcons.checkCircle2,
                          'Fully Compliant',
                          'All regulatory requirements met and maintained across all operations',
                          Palette.success,
                        ),
                      ),
                      RevealOnScroll(
                        delayMs: 120,
                        child: _buildCommitmentCard(
                          context,
                          isMobile,
                          LucideIcons.globe2,
                          'Internationally Recognized',
                          'Certifications accepted globally for cross-border operations',
                          Palette.it,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Certificates Section
            SectionWrapper(
              background: Palette.n50,
              maxWidth: 1280,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Our Certifications',
                    subtitle: 'Click on any certificate to view details',
                  ),
                  const SizedBox(height: Space.xxl),
                  Wrap(
                    spacing: Space.lg,
                    runSpacing: Space.lg,
                    children: List.generate(certificates.length, (index) {
                      final cert = certificates[index];
                      return SizedBox(
                        width: isMobile
                            ? double.infinity
                            : isTablet
                                ? (screenWidth - 64) / 2
                                : (screenWidth - 96) / 3,
                        child: RevealOnScroll(
                          delayMs: 60 * index,
                          child: _buildCertificateCard(
                            context,
                            isMobile,
                            cert,
                            () => showImageDialog(context, index),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentCard(
    BuildContext context,
    bool isMobile,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return SizedBox(
      width: isMobile ? double.infinity : 300,
      child: AppCard(
        interactive: false,
        accent: color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconChip(icon: icon, color: color),
            const SizedBox(height: Space.md),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.xs),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard(
    BuildContext context,
    bool isMobile,
    Map<String, dynamic> cert,
    VoidCallback onTap,
  ) {
    // Determine certificate type and color
    final String title = cert['title'] ?? '';
    Color cardColor;
    IconData cardIcon;

    if (title.contains('Building') || title.contains('Construction')) {
      cardColor = Palette.construction;
      cardIcon = LucideIcons.building2;
    } else if (title.contains('Mechanical')) {
      cardColor = Palette.danger;
      cardIcon = LucideIcons.cog;
    } else if (title.contains('Water')) {
      cardColor = const Color(0xFF0891B2);
      cardIcon = LucideIcons.droplet;
    } else if (title.contains('KRA') || title.contains('Tax')) {
      cardColor = Palette.success;
      cardIcon = LucideIcons.fileText;
    } else {
      cardColor = Palette.it;
      cardIcon = LucideIcons.award;
    }

    return AppCard(
      onTap: onTap,
      accent: cardColor,
      padding: EdgeInsets.zero,
      semanticLabel: cert['title'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Certificate Image Preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.lg)),
            child: Stack(
              children: [
                Image.asset(
                  cert['filePath'],
                  width: double.infinity,
                  height: isMobile ? 180 : 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: isMobile ? 180 : 200,
                    color: cardColor.withValues(alpha: 0.1),
                    child: Center(
                      child: Icon(
                        LucideIcons.fileText,
                        size: 48,
                        color: cardColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: Space.sm,
                  right: Space.sm,
                  child: Container(
                    padding: const EdgeInsets.all(Space.xs),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: Radii.chip,
                    ),
                    child: Icon(cardIcon, color: Palette.n0, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Certificate Details
          Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cert['title'],
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.xs),
                if (cert['certificateNo'] != null)
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.hash,
                        size: 14,
                        color: Palette.n400,
                      ),
                      const SizedBox(width: Space.xxs),
                      Expanded(
                        child: Text(
                          cert['certificateNo'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Palette.n500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: Space.xxs + 2),
                if (cert['description'] != null)
                  Text(
                    cert['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Palette.n600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: Space.sm),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.eye,
                            size: 16,
                            color: cardColor,
                          ),
                          const SizedBox(width: Space.xxs + 2),
                          Text(
                            'View Certificate',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: cardColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.arrowRight,
                      size: 20,
                      color: cardColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageDialog extends StatefulWidget {
  final List<Map<String, dynamic>> certificates;
  final int initialIndex;

  const _ImageDialog({
    required this.certificates,
    required this.initialIndex,
  });

  @override
  State<_ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<_ImageDialog> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _nextImage() {
    if (currentIndex < widget.certificates.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void _previousImage() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cert = widget.certificates[currentIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? Space.md : Space.xxl - 8,
        vertical: isMobile ? Space.lg : Space.xxl - 8,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: screenHeight * 0.9,
        ),
        decoration: BoxDecoration(
          color: Palette.n0,
          borderRadius: Radii.card,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(Space.lg),
                  decoration: const BoxDecoration(
                    color: Palette.n50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Radii.lg),
                      topRight: Radius.circular(Radii.lg),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Space.xs),
                            decoration: BoxDecoration(
                              color: Palette.primary.withValues(alpha: 0.1),
                              borderRadius: Radii.chip,
                            ),
                            child: const Icon(
                              LucideIcons.award,
                              color: Palette.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cert['title'],
                                  style: Theme.of(context).textTheme.titleLarge,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (cert['certificateNo'] != null)
                                  Text(
                                    cert['certificateNo'],
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Palette.n500,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (cert['description'] != null) ...[
                        const SizedBox(height: Space.xs),
                        Text(
                          cert['description'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Palette.n600,
                              ),
                        ),
                      ],
                      if (widget.certificates.length > 1) ...[
                        const SizedBox(height: Space.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${currentIndex + 1} of ${widget.certificates.length}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Palette.n400,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Image
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(Space.lg),
                    child: Image.asset(
                      cert['filePath'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        color: Palette.n200,
                        child: const Center(
                          child: Icon(LucideIcons.imageOff, color: Palette.n400, size: 64),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Close Button
            Positioned(
              top: Space.xs,
              right: Space.xs,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(Space.xs),
                  decoration: BoxDecoration(
                    color: Palette.n0,
                    borderRadius: Radii.chip,
                    boxShadow: Elevation.card,
                  ),
                  child: const Icon(LucideIcons.x, color: Palette.ink, size: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Navigation Arrows
            if (widget.certificates.length > 1) ...[
              if (currentIndex > 0)
                Positioned(
                  left: Space.xs,
                  top: screenHeight * 0.4,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(Space.xs),
                      decoration: BoxDecoration(
                        color: Palette.n0,
                        borderRadius: Radii.chip,
                        boxShadow: Elevation.card,
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        color: Palette.ink,
                        size: 24,
                      ),
                    ),
                    onPressed: _previousImage,
                  ),
                ),
              if (currentIndex < widget.certificates.length - 1)
                Positioned(
                  right: Space.xs,
                  top: screenHeight * 0.4,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(Space.xs),
                      decoration: BoxDecoration(
                        color: Palette.n0,
                        borderRadius: Radii.chip,
                        boxShadow: Elevation.card,
                      ),
                      child: const Icon(
                        LucideIcons.chevronRight,
                        color: Palette.ink,
                        size: 24,
                      ),
                    ),
                    onPressed: _nextImage,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> certificates = [
  {
    'title': 'JV Certificate',
    'certificateNo': 'JV ALMA C.I.S',
    'description': 'Incorporation',
    'filePath': 'assets/certificates/jv_certificate.jpg',
  },
  {
    'title': 'KRA Certificate',
    'certificateNo': 'KRA',
    'description': 'Tax Compliance',
    'filePath': 'assets/certificates/kra_certificate.jpg',
  },
  {
    'title': 'Business Permit',
    'certificateNo': 'Business Permit',
    'description': 'Valid',
    'filePath': 'assets/certificates/business_permit.jpg',
  },
  {
    'title': 'Building Works Certificate',
    'certificateNo': 'Building Works Contractor',
    'description': 'Construction',
    'filePath': 'assets/certificates/Building_Works_Certificate_2026.jpg',
  },
  {
    'title': 'Mechanical Service Certificate',
    'certificateNo': 'Mechanical Service Contractor',
    'description': 'Mechanical',
    'filePath': 'assets/certificates/Mechanical_Service_Certificate_2026.jpg',
  },
  {
    'title': 'Water Works Certificate',
    'certificateNo': 'Water Works Contractor',
    'description': 'Water Management',
    'filePath': 'assets/certificates/Water_Works_Certificate_2026.jpg',
  },
  {
    'title': 'Mechanical Service Certificate',
    'certificateNo': 'Mechanical Service Contractor',
    'description': 'Mechanical',
    'filePath': 'assets/certificates/Mechanical_Service_Certificate_2028.jpg',
  },
  {
    'title': 'Water Works Certificate',
    'certificateNo': 'Water Works Contractor',
    'description': 'Water Management',
    'filePath': 'assets/certificates/Water_Works_Certificate_2028.jpg',
  },
];
