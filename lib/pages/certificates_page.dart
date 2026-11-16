import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
// services.dart: keyboard shortcuts in the document viewer.
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/hoverable.dart';

/// One document in the library. [label] and [description] are shown as
/// given; nothing on this page asserts validity, numbers or dates beyond
/// what each document itself states.
class CertificateDocument {
  const CertificateDocument({
    required this.title,
    required this.asset,
    this.label,
    this.description,
  });

  final String title;
  final String asset;
  final String? label;
  final String? description;
}

class CertificateSection {
  const CertificateSection({
    required this.title,
    required this.intro,
    required this.documents,
  });

  final String title;
  final String intro;
  final List<CertificateDocument> documents;
}

/// The document library.
///
/// All files live directly in `assets/certificates/` (declared in
/// pubspec.yaml). Software certificates are named `<platform>.jpg`
/// (lowercase, no spaces); the Data Processor Certificate is
/// `data_processor.jpg`. Every entry here must have its file in that folder
/// (enforced by test/certificates_page_test.dart).
const certificateSections = <CertificateSection>[
  CertificateSection(
    title: 'ISO Certificate',
    intro: 'Company ISO documentation.',
    documents: [
      // Existing entries, carried over unchanged.
      CertificateDocument(
        title: 'JV Certificate',
        label: 'JV ALMA C.I.S',
        description: 'Incorporation',
        asset: 'assets/certificates/iso_2027.jpg',
      ),
      /*CertificateDocument(
        title: 'KRA Certificate',
        label: 'KRA',
        description: 'Tax Compliance',
        asset: 'assets/certificates/kra_certificate.jpg',
      ),
      CertificateDocument(
        title: 'Business Permit',
        label: 'Business Permit',
        description: 'Valid',
        asset: 'assets/certificates/business_permit.jpg',
      ),*/
    ],
  ),
  CertificateSection(
    title: 'Company & Operational Certificates',
    intro: 'NCA contractor documents.',
    documents: [
      CertificateDocument(
        title: 'Building Works Certificate',
        label: 'Building Works Contractor',
        description: 'Construction',
        asset: 'assets/certificates/Building_Works_Certificate_2026.jpg',
      ),
      CertificateDocument(
        title: 'Mechanical Service Certificate',
        label: 'Mechanical Service Contractor',
        description: 'Mechanical',
        asset: 'assets/certificates/Mechanical_Service_Certificate_2028.jpg',
      ),
      CertificateDocument(
        title: 'Water Works Certificate',
        label: 'Water Works Contractor',
        description: 'Water Management',
        asset: 'assets/certificates/Water_Works_Certificate_2028.jpg',
      ),
    ],
  ),
  CertificateSection(
    title: 'Software Copyright Certificates',
    intro: 'Copyright registration certificates for the software platforms developed by the '
        'IT Division.',
    documents: [
      CertificateDocument(
        title: 'Kilimo Mkononi',
        label: 'Copyright registration certificate',
        asset: 'assets/certificates/kilimomkononi.jpg',
      ),
      CertificateDocument(
        title: 'CoffeeCore',
        label: 'Copyright registration certificate',
        asset: 'assets/certificates/coffeecore.jpg',
      ),
      CertificateDocument(
        title: 'AlmaWorks',
        label: 'Copyright registration certificate',
        asset: 'assets/certificates/almaworks.jpg',
      ),
      CertificateDocument(
        title: 'AlmaSafety',
        label: 'Copyright registration certificate',
        asset: 'assets/certificates/almasafety.jpg',
      ),
      CertificateDocument(
        title: 'AlmaHub',
        label: 'Copyright registration certificate',
        asset: 'assets/certificates/almahub.jpg',
      ),
      CertificateDocument(
        title: 'NyumbaSmart',
        label: 'Copyright registration certificate',
        asset: 'assets/certificates/nyumbasmart.jpg',
      ),
    ],
  ),
  CertificateSection(
    title: 'Data Protection',
    intro: 'Documentation relating to how the company processes personal data.',
    documents: [
      CertificateDocument(
        title: 'Data Processor Certificate',
        label: 'Registration as a data processor',
        asset: 'assets/certificates/data_processor.jpg',
      ),
    ],
  ),
];

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    // Every listed document is shown straight away; nothing waits on the
    // asset manifest. A file that fails to load shows a neutral frame, and
    // the test suite fails if a listed file is missing from the folder.
    final documents = [for (final s in certificateSections) ...s.documents];

    void open(CertificateDocument doc) {
      showDialog(
        context: context,
        builder: (_) => _DocumentViewer(
          documents: documents,
          initialIndex: documents.indexOf(doc),
        ),
      );
    }

    Widget column(Widget child, EdgeInsets padding) => Container(
          width: double.infinity,
          color: Palette.n0,
          padding: padding.add(EdgeInsets.symmetric(horizontal: isMobile ? 20 : Space.lg)),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        );

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            column(
              const _Intro(),
              EdgeInsets.only(
                top: isMobile ? Space.xxl : Space.section - Space.lg,
                bottom: isMobile ? Space.xl : Space.xxl,
              ),
            ),
            for (final section in certificateSections)
              if (section.documents.isNotEmpty)
                column(
                  _SectionBlock(
                    section: section,
                    documents: section.documents,
                    onOpen: open,
                  ),
                  EdgeInsets.only(bottom: isMobile ? Space.xxl : Space.xxxl),
                ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Certificates & Compliance',
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 32, max: 48),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Explore our company registrations, operational certificates, software copyright '
            'documentation and data-protection credentials.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).width < 600 ? Space.xl : Space.xxl),
        const Divider(height: 1, thickness: 1, color: Palette.ink),
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.section,
    required this.documents,
    required this.onOpen,
  });

  final CertificateSection section;

  /// The section's documents whose files are bundled.
  final List<CertificateDocument> documents;
  final void Function(CertificateDocument doc) onOpen;

  @override
  Widget build(BuildContext context) {
    final count = documents.length;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: Space.sm,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              section.title,
              style: AppType.theme.headlineMedium?.copyWith(
                fontSize: AppType.fluid(context, min: 22, max: 26),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                count == 1 ? '1 document' : '$count documents',
                style: AppType.theme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.xs),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(section.intro, style: AppType.theme.bodyMedium),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Two columns even on phones: document previews are compact,
        // and one per row makes the library a very long scroll.
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 320
                ? 2
                : 1;
        final gap = columns == 2 && constraints.maxWidth < 480 ? Space.md : Space.lg;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        // A single document sits beside the heading on wide screens, at the
        // same size as the others, instead of alone in an otherwise empty row.
        if (count == 1 && columns == 3) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: heading),
              SizedBox(width: gap),
              SizedBox(
                width: width,
                child: _DocumentTile(doc: documents.first, onOpen: () => onOpen(documents.first)),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading,
            const SizedBox(height: Space.lg),
            Wrap(
              spacing: gap,
              runSpacing: Space.xl,
              children: [
                for (final doc in documents)
                  SizedBox(
                    width: width,
                    child: _DocumentTile(doc: doc, onOpen: () => onOpen(doc)),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// A document preview: the whole page shown within a neutral frame
/// (contain, never cropped), then title, label and description.
class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.doc, required this.onOpen});

  final CertificateDocument doc;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final meta = [doc.label, doc.description].whereType<String>().join(' · ');

    return Hoverable(
      onTap: onOpen,
      scale: 1.0,
      lift: 0,
      semanticLabel: 'View ${doc.title}${meta.isEmpty ? '' : ', $meta'}',
      builder: (hovered) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Motion.fast,
            curve: Motion.hover,
            decoration: BoxDecoration(
              color: Palette.n50,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(color: hovered ? Palette.primary : Palette.n200),
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: ExcludeSemantics(
                  child: Image.asset(
                    doc.asset,
                    fit: BoxFit.contain,
                    // Decode near display size; previews are small.
                    cacheWidth: (360 * MediaQuery.devicePixelRatioOf(context)).round(),
                    errorBuilder: (_, __, ___) => const _Placeholder(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.sm),
          Text(
            doc.title,
            style: text.titleMedium?.copyWith(color: hovered ? Palette.primary : Palette.ink),
          ),
          if (meta.isNotEmpty) ...[
            const SizedBox(height: Space.xxs),
            Text(meta, style: text.bodySmall),
          ],
          const SizedBox(height: Space.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(LucideIcons.maximize2, size: 14, color: Palette.primary),
              ),
              const SizedBox(width: Space.xs),
              // Wraps in narrow two-column tiles instead of overflowing.
              Flexible(
                child: Text(
                  'View document',
                  style: text.labelMedium?.copyWith(color: Palette.primary, height: 1.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Neutral stand-in, shown only if a bundled document fails to load.
class _Placeholder extends StatelessWidget {
  const _Placeholder({this.large = false});

  final bool large;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.fileText, size: large ? 48 : 32, color: Palette.n300),
          if (large) ...[
            const SizedBox(height: Space.md),
            Text(
              'This document could not be displayed.',
              style: AppType.theme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-size viewer: the whole document (contain, pinch/scroll to zoom),
/// title and label in a header that wraps, previous/next between the
/// available documents, and arrow-key navigation.
class _DocumentViewer extends StatefulWidget {
  const _DocumentViewer({required this.documents, required this.initialIndex});

  final List<CertificateDocument> documents;
  final int initialIndex;

  @override
  State<_DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<_DocumentViewer> {
  late int _index = widget.initialIndex;

  bool get _hasPrevious => _index > 0;
  bool get _hasNext => _index < widget.documents.length - 1;

  void _go(int delta) {
    final next = _index + delta;
    if (next >= 0 && next < widget.documents.length) setState(() => _index = next);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 600;
    final doc = widget.documents[_index];
    final meta = [doc.label, doc.description].whereType<String>().join(' · ');
    final many = widget.documents.length > 1;
    final text = Theme.of(context).textTheme;

    Widget navButton(IconData icon, String tooltip, VoidCallback? onPressed) => IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          color: Palette.ink,
          disabledColor: Palette.n300,
          style: IconButton.styleFrom(
            side: const BorderSide(color: Palette.n200),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.sm)),
          ),
        );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _go(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _go(1),
      },
      child: Focus(
        autofocus: true,
        child: Dialog(
          backgroundColor: Palette.n0,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.all(isMobile ? Space.sm : Space.xl),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000, maxHeight: size.height * 0.92),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: title wraps rather than truncating.
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? Space.md : Space.lg,
                    Space.md,
                    Space.xs,
                    Space.md,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.title, style: text.titleLarge),
                            if (meta.isNotEmpty) ...[
                              const SizedBox(height: Space.xxs),
                              Text(meta, style: text.bodySmall),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(LucideIcons.x, size: 20, color: Palette.ink),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Palette.n200),

                // The document, whole.
                Flexible(
                  child: Container(
                    color: Palette.n50,
                    padding: EdgeInsets.all(isMobile ? Space.sm : Space.lg),
                    child: InteractiveViewer(
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(
                          doc.asset,
                          key: ValueKey(doc.asset),
                          fit: BoxFit.contain,
                          semanticLabel: doc.title,
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 280,
                            child: _Placeholder(large: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Footer: position and previous/next.
                if (many) ...[
                  const Divider(height: 1, thickness: 1, color: Palette.n200),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
                    child: Row(
                      children: [
                        navButton(
                          LucideIcons.chevronLeft,
                          'Previous document',
                          _hasPrevious ? () => _go(-1) : null,
                        ),
                        Expanded(
                          child: Text(
                            '${_index + 1} of ${widget.documents.length}',
                            textAlign: TextAlign.center,
                            style: text.bodySmall,
                          ),
                        ),
                        navButton(
                          LucideIcons.chevronRight,
                          'Next document',
                          _hasNext ? () => _go(1) : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
