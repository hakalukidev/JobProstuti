import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../app/theme.dart';
import '../../widgets/common/custom_button.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({super.key, required this.url, required this.title});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfController;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          IconButton(
            onPressed: () {
              // Download
            },
            icon: const Icon(Icons.download_outlined),
            tooltip: 'ডাউনলোড',
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.url,
            controller: _pdfController,
            onDocumentLoaded: (detail) {
              setState(() {
                _isLoading = false;
                _totalPages = detail.document.pages.count;
              });
            },
            onPageChanged: (detail) {
              setState(() => _currentPage = detail.newPageNumber);
            },
            onDocumentLoadFailed: (detail) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PDF লোড হয়নি: ${detail.description}'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
          ),
          if (_isLoading)
            const LoadingWidget(
              fullScreen: true,
              message: 'PDF লোড হচ্ছে...',
            ),
        ],
      ),
      bottomNavigationBar: _totalPages > 1
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _currentPage > 1
                  ? () => _pdfController.previousPage()
                  : null,
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
            Text('$_currentPage / $_totalPages', style: AppTextStyles.bodyMedium),
            const SizedBox(width: 16),
            IconButton(
              onPressed: _currentPage < _totalPages
                  ? () => _pdfController.nextPage()
                  : null,
              icon: const Icon(Icons.arrow_forward_ios),
              color: AppColors.primary,
            ),
          ],
        ),
      )
          : null,
    );
  }
}