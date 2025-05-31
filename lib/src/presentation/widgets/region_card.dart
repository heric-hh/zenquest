import 'package:flutter/material.dart';
import 'package:zenquest/src/presentation/regions/region_intro_screen.dart';

class RegionCardSwiper extends StatefulWidget {
  const RegionCardSwiper({super.key});

  @override
  State<RegionCardSwiper> createState() => _RegionCardSwiperState();
}

class _RegionCardSwiperState extends State<RegionCardSwiper> {
  final PageController _controller = PageController(viewportFraction: 0.75);

  final List<String> regions = const [
    'Bosque del Ruido',
    'Montaña del Miedo',
    'Llanura del Recuerdo',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: regions.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = 1.0;
            if (_controller.position.haveDimensions) {
              value = _controller.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            }

            return Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RegionIntroScreen(regionName: regions[index]),
                    ),
                  );
                },
                child: Transform.scale(
                  scale: Curves.easeOut.transform(value),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B335B),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        regions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
