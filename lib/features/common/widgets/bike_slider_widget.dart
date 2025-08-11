import 'package:flutter/material.dart';
import 'dart:async';

class BikeSliderWidget extends StatefulWidget {
  final List<BikeSlide> slides;
  final double height;
  final Function(int)? onSlideChanged;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const BikeSliderWidget({
    Key? key,
    required this.slides,
    this.height = 200,
    this.onSlideChanged,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<BikeSliderWidget> createState() => _BikeSliderWidgetState();
}

class _BikeSliderWidgetState extends State<BikeSliderWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlayIfNeeded();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlayIfNeeded() {
    if (!widget.autoPlay || widget.slides.isEmpty) return;
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (!mounted) return;
      final int next = (_currentIndex + 1) % widget.slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Bike image slider
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                widget.onSlideChanged?.call(index);
              },
              itemCount: widget.slides.length,
              itemBuilder: (context, index) {
                final slide = widget.slides[index];
                return _buildSlide(slide);
              },
            ),
          ),
          // Description console overlay
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: IgnorePointer(child: _buildDescriptionConsole()),
          ),
          // Slider indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: IgnorePointer(child: _buildSliderIndicators()),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(BikeSlide slide) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: slide.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: slide.imageUrl!.startsWith('assets/')
                  ? Image.asset(
                      slide.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderBike(),
                    )
                  : Image.network(
                      slide.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderBike(),
                    ),
            )
          : _buildPlaceholderBike(),
    );
  }

  Widget _buildPlaceholderBike() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.pedal_bike,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDescriptionConsole() {
    final currentSlide = widget.slides[_currentIndex];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentSlide.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentSlide.description,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.slides.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentIndex ? 24 : 8,
          height: 4,
          decoration: BoxDecoration(
            color: index == _currentIndex 
                ? const Color(0xFFD4FF3F) 
                : Colors.grey[600],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class BikeSlide {
  final String? imageUrl;
  final String title;
  final String description;

  const BikeSlide({
    this.imageUrl,
    required this.title,
    required this.description,
  });
}
