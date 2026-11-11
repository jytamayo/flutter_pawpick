import 'package:flutter/material.dart';

void main() {
  runApp(const PawpickApp());
}

class PawpickApp extends StatelessWidget {
  const PawpickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawpick / Little Joy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B4279),
          primary: const Color(0xFF3B4279),
          surface: const Color(0xFFFAF4ED),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF4ED),
      ),
      home: const HomePage(),
    );
  }
}

// -----------------------------------------------------------------------------
// CONSTANTS & COLORS
// -----------------------------------------------------------------------------
class AppColors {
  static const Color creamBg = Color(0xFFFAF4ED);
  static const Color navyText = Color(0xFF3B4279);
  static const Color secondaryText = Color(0xFF6B7094);
  static const Color bannerPink = Color(0xFFF7C5D5);
  static const Color promoYellow = Color(0xFFFFF1A8);
  static const Color testimonialPink = Color(0xFFFCE6EE);
  static const Color footerBlue = Color(0xFFD6E8F6);
  static const Color cardBg = Color(0xFFF4EDE5);
  static const Color buttonNavy = Color(0xFF3B4279);
  static const Color accentPink = Color(0xFFF8D3E0);
}

// -----------------------------------------------------------------------------
// CUSTOM SCALLOPED CLIPPER
// -----------------------------------------------------------------------------
class ScallopedTopClipper extends CustomClipper<Path> {
  final double scallopWidth;
  final double scallopHeight;

  ScallopedTopClipper({this.scallopWidth = 24.0, this.scallopHeight = 10.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, scallopHeight);

    final count = (size.width / scallopWidth).ceil();
    final actualWidth = size.width / count;

    for (int i = 0; i < count; i++) {
      final startX = i * actualWidth;
      final midX = startX + actualWidth / 2;
      final endX = (i + 1) * actualWidth;
      path.quadraticBezierTo(midX, 0, endX, scallopHeight);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// -----------------------------------------------------------------------------
// MAIN HOME PAGE
// -----------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartCount = 0;
  final Set<int> favorites = {};

  void toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
  }

  void addToCart() {
    setState(() {
      cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to bag! 🎉'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AnnouncementBar(),
            HeaderNavBar(cartCount: cartCount),
            const HeroSection(),
            const ValuePropsBar(),
            const CategorySection(),
            CrowdPleasersSection(
              favorites: favorites,
              onToggleFavorite: toggleFavorite,
              onAddToCart: addToCart,
            ),
            const PromoBannerSection(),
            const BrandStorySection(),
            const TestimonialsSection(),
            const CommunityGallerySection(),
            const NewsletterSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. ANNOUNCEMENT BAR
// -----------------------------------------------------------------------------
class AnnouncementBar extends StatelessWidget {
  const AnnouncementBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bannerPink,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          const Text(
            'A little welcome treat: 15% off your first order with JOY15',
            style: TextStyle(
              color: AppColors.navyText,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Text(
              'Shop happy →',
              style: TextStyle(
                color: AppColors.navyText,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. HEADER NAVIGATION BAR
// -----------------------------------------------------------------------------
class HeaderNavBar extends StatelessWidget {
  final int cartCount;
  const HeaderNavBar({super.key, required this.cartCount});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      color: AppColors.creamBg,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isDesktop)
            const Row(
              children: [
                _NavLink('Shop all'),
                SizedBox(width: 24),
                _NavLink('New arrivals'),
                SizedBox(width: 24),
                _NavLink('Gifts under \$30'),
                SizedBox(width: 24),
                _NavLink('Our story'),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.navyText),
              onPressed: () {},
            ),

          const Text(
            'pawpick',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.navyText,
              letterSpacing: -0.5,
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.navyText),
                onPressed: () {},
              ),
              if (isDesktop) ...[
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_outline, color: AppColors.navyText, size: 20),
                  label: const Text(
                    'Sign in',
                    style: TextStyle(color: AppColors.navyText, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.navyText),
                  onPressed: () {},
                ),
              ],
              IconButton(
                icon: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.navyText),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  const _NavLink(this.title);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.navyText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. HERO SECTION
// -----------------------------------------------------------------------------
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      color: AppColors.creamBg,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 40,
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(child: _buildHeroText(context)),
                const SizedBox(width: 60),
                Expanded(child: _buildHeroImage()),
              ],
            )
          : Column(
              children: [
                _buildHeroText(context),
                const SizedBox(height: 40),
                _buildHeroImage(),
              ],
            ),
    );
  }

  Widget _buildHeroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFF6C8EEF), size: 18),
            SizedBox(width: 8),
            Text(
              'YOUR DAILY DOSE OF HAPPY',
              style: TextStyle(
                color: Color(0xFF5A7CD9),
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Little things.\nBig joy.',
          style: TextStyle(
            fontSize: 56,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: AppColors.navyText,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Huggable pals, happy spaces, and cozy little things.\nMeet gifts that feel like a warm hug.',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Find your happy', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Explore new arrivals',
                style: TextStyle(
                  color: AppColors.navyText,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Row(
          children: [
            Text('★★★★★', style: TextStyle(color: AppColors.navyText, fontSize: 14)),
            SizedBox(width: 8),
            Text(
              '4.9/5 from 1,200+ happy humans',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(200)),
          child: Container(
            height: 480,
            color: const Color(0xFFE8DACB),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_sunny_rounded, size: 90, color: Color(0xFFFFD54F)),
                  SizedBox(height: 16),
                  Icon(Icons.card_giftcard, size: 50, color: Color(0xFF8D6E63)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          right: -10,
          child: Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFFBE698),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, color: AppColors.navyText, size: 24),
                SizedBox(height: 4),
                Text(
                  'Gifting,\nbut happier.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyText,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. VALUE PROPOSITIONS BAR
// -----------------------------------------------------------------------------
class ValuePropsBar extends StatelessWidget {
  const ValuePropsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ScallopedTopClipper(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 40, bottom: 30, left: 24, right: 24),
        child: const Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 30,
          runSpacing: 20,
          children: [
            _ValuePropItem(icon: Icons.local_shipping_outlined, title: 'Free US shipping over \$60'),
            _ValuePropItem(icon: Icons.card_giftcard_outlined, title: 'Gift-ready, always'),
            _ValuePropItem(icon: Icons.favorite_outline, title: 'Made with a little extra love'),
            _ValuePropItem(icon: Icons.refresh_outlined, title: 'Easy 30-day returns'),
          ],
        ),
      ),
    );
  }
}

class _ValuePropItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ValuePropItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.navyText),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navyText,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 5. CATEGORY SECTION
// -----------------------------------------------------------------------------
class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    return Container(
      color: AppColors.creamBg,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          const Text(
            'A LITTLE SOMETHING FOR EVERYONE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pick your kind of happy',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.navyText,
            ),
          ),
          const SizedBox(height: 40),
          isDesktop
              ? const Row(
                  children: [
                    Expanded(
                      child: _CategoryCard(
                        title: 'Plush pals',
                        subtitle: 'Your new emotional support cutie',
                        bgColor: Color(0xFFEADBCE),
                        icon: Icons.pets,
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _CategoryCard(
                        title: 'Candles & little comforts',
                        subtitle: 'A happy glow for your happy place',
                        bgColor: Color(0xFFE9E4CE),
                        icon: Icons.wb_incandescent_outlined,
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _CategoryCard(
                        title: 'Cozy handmade things',
                        subtitle: 'Soft, slow-made, and full of heart',
                        bgColor: Color(0xFFC7D7E6),
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                  ],
                )
              : const Column(
                  children: [
                    _CategoryCard(
                      title: 'Plush pals',
                      subtitle: 'Your new emotional support cutie',
                      bgColor: Color(0xFFEADBCE),
                      icon: Icons.pets,
                    ),
                    SizedBox(height: 24),
                    _CategoryCard(
                      title: 'Candles & little comforts',
                      subtitle: 'A happy glow for your happy place',
                      bgColor: Color(0xFFE9E4CE),
                      icon: Icons.wb_incandescent_outlined,
                    ),
                    SizedBox(height: 24),
                    _CategoryCard(
                      title: 'Cozy handmade things',
                      subtitle: 'Soft, slow-made, and full of heart',
                      bgColor: Color(0xFFC7D7E6),
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final IconData icon;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(140)),
          child: Container(
            height: 300,
            width: double.infinity,
            color: bgColor,
            child: Icon(icon, size: 80, color: const Color(0x993B4279)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.navyText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 6. CROWD-PLEASERS (PRODUCT GRID)
// -----------------------------------------------------------------------------
class CrowdPleasersSection extends StatelessWidget {
  final Set<int> favorites;
  final Function(int) onToggleFavorite;
  final VoidCallback onAddToCart;

  const CrowdPleasersSection({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.creamBg,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LOVED, HUGGED & ADDED TO BAG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'The crowd-pleasers',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navyText,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Shop all favorites'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navyText,
                  side: const BorderSide(color: AppColors.navyText),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1000
                  ? 4
                  : (constraints.maxWidth > 650 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 0.68,
                children: [
                  _ProductCard(
                    index: 0,
                    badge: 'BESTSELLER',
                    badgeColor: const Color(0xFFFBE698),
                    title: 'Sunny Side plush',
                    price: '\$28.00',
                    subtitle: 'One very huggable ray of sunshine',
                    icon: Icons.wb_sunny_rounded,
                    isFav: favorites.contains(0),
                    onFav: () => onToggleFavorite(0),
                    onAdd: onAddToCart,
                  ),
                  _ProductCard(
                    index: 1,
                    badge: 'SMALL BATCH',
                    badgeColor: const Color(0xFFF7C5D5),
                    title: 'The Wiggle candle',
                    price: '\$22.00',
                    subtitle: 'Hand-poured • Peony & soft vanilla',
                    icon: Icons.waves,
                    isFav: favorites.contains(1),
                    onFav: () => onToggleFavorite(1),
                    onAdd: onAddToCart,
                  ),
                  _ProductCard(
                    index: 2,
                    badge: 'HANDMADE',
                    badgeColor: const Color(0xFFC7D7E6),
                    title: 'Daisy Days crochet tote',
                    price: '\$38.00',
                    subtitle: 'Handmade, for your everyday joys',
                    icon: Icons.local_florist,
                    isFav: favorites.contains(2),
                    onFav: () => onToggleFavorite(2),
                    onAdd: onAddToCart,
                  ),
                  _ProductCard(
                    index: 3,
                    badge: 'NEW FRIEND',
                    badgeColor: const Color(0xFFC6E6C7),
                    title: 'Berry bestie plush',
                    price: '\$24.00',
                    subtitle: 'Your pocket-sized pick-me-up',
                    icon: Icons.energy_savings_leaf,
                    isFav: favorites.contains(3),
                    onFav: () => onToggleFavorite(3),
                    onAdd: onAddToCart,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final int index;
  final String badge;
  final Color badgeColor;
  final String title;
  final String price;
  final String subtitle;
  final IconData icon;
  final bool isFav;
  final VoidCallback onFav;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.index,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.icon,
    required this.isFav,
    required this.onFav,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(icon, size: 70, color: const Color(0x803B4279)),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navyText,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : AppColors.navyText,
                    ),
                    onPressed: onFav,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navyText),
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navyText),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 6),
        const Text(
          '★★★★★ (48 happy reviews)',
          style: TextStyle(fontSize: 11, color: AppColors.navyText),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPink,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Add to bag +',
              style: TextStyle(color: AppColors.navyText, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 7. PROMO BANNER SECTION
// -----------------------------------------------------------------------------
class PromoBannerSection extends StatelessWidget {
  const PromoBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ScallopedTopClipper(),
      child: Container(
        color: AppColors.promoYellow,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD3A4DC),
                    shape: BoxShape.circle,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '15%',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navyText,
                        ),
                      ),
                      Text(
                        'FIRST ORDER',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navyText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A little treat for your first hello.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navyText,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Take 15% off your first order. Use code JOY15 at checkout.\nFirst orders only. Excludes gift cards. Cannot be combined with other offers.',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Treat yourself', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 8. BRAND STORY SECTION
// -----------------------------------------------------------------------------
class BrandStorySection extends StatelessWidget {
  const BrandStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      color: AppColors.creamBg,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(child: _buildStoryImage()),
                const SizedBox(width: 60),
                Expanded(child: _buildStoryText()),
              ],
            )
          : Column(
              children: [
                _buildStoryImage(),
                const SizedBox(height: 40),
                _buildStoryText(),
              ],
            ),
    );
  }

  Widget _buildStoryImage() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(200)),
          child: Container(
            height: 420,
            width: double.infinity,
            color: const Color(0xFFD7CCC8),
            child: const Center(
              child: Icon(Icons.volunteer_activism, size: 90, color: Color(0xFF8D6E63)),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accentPink,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Made slowly. Loved daily.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.navyText,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A SMALL SHOP WITH A BIG HEART',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Not just things.\nLittle pick-me-ups.',
          style: TextStyle(
            fontSize: 42,
            height: 1.1,
            fontWeight: FontWeight.w900,
            color: AppColors.navyText,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'We believe everyday life deserves a sprinkle of lovely. So we find the softest pals, the sweetest shapes, and the makers who care about every stitch.',
          style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 16),
        const Text(
          'Chosen with care. Packed with love. Made to turn an ordinary Tuesday into a tiny celebration.',
          style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text('A little about us'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.navyText,
            side: const BorderSide(color: AppColors.navyText),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 9. TESTIMONIALS SECTION
// -----------------------------------------------------------------------------
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ScallopedTopClipper(),
      child: Container(
        color: AppColors.testimonialPink,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          children: [
            const Text(
              '★★★★★ 4.9/5 FROM OUR JOY-FILLED COMMUNITY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.navyText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Good things. Happy humans.',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.navyText,
              ),
            ),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isDesktop = constraints.maxWidth > 800;
                return isDesktop
                    ? const Row(
                        children: [
                          Expanded(
                            child: _TestimonialCard(
                              quote: '"Bought her as a gift. Kept her for myself. Had to order another. Zero regrets."',
                              author: 'Mia L.',
                              product: 'Berry bestie plush',
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: _TestimonialCard(
                              quote: '"The cutest little candle! My shelf finally has the main-character energy it deserves."',
                              author: 'Sophie R.',
                              product: 'The Wiggle candle',
                            ),
                          ),
                          SizedBox(width: 24),
                          Expanded(
                            child: _TestimonialCard(
                              quote: '"You can feel the love in every stitch. Even the packaging made my whole day."',
                              author: 'Jules T.',
                              product: 'Daisy Days crochet tote',
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          _TestimonialCard(
                            quote: '"Bought her as a gift. Kept her for myself. Had to order another. Zero regrets."',
                            author: 'Mia L.',
                            product: 'Berry bestie plush',
                          ),
                          SizedBox(height: 20),
                          _TestimonialCard(
                            quote: '"The cutest little candle! My shelf finally has the main-character energy it deserves."',
                            author: 'Sophie R.',
                            product: 'The Wiggle candle',
                          ),
                          SizedBox(height: 20),
                          _TestimonialCard(
                            quote: '"You can feel the love in every stitch. Even the packaging made my whole day."',
                            author: 'Jules T.',
                            product: 'Daisy Days crochet tote',
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  final String product;

  const _TestimonialCard({
    required this.quote,
    required this.author,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('★★★★★', style: TextStyle(color: Color(0xFF5C6BC0), fontSize: 16)),
          const SizedBox(height: 16),
          Text(
            quote,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: AppColors.navyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '$author ',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navyText),
              ),
              const Icon(Icons.check_circle, color: Colors.green, size: 14),
              const Text(
                ' Verified buyer',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            product,
            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 10. COMMUNITY GALLERY
// -----------------------------------------------------------------------------
class CommunityGallerySection extends StatelessWidget {
  const CommunityGallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.creamBg,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LITTLE MOMENTS, OUT IN THE WORLD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Joy looks good on you',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navyText,
                    ),
                  ),
                ],
              ),
              Text(
                '@littlejoy.shop ↗',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              int count = constraints.maxWidth > 900 ? 4 : 2;
              return GridView.count(
                crossAxisCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: List.generate(4, (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: const Color(0xFFE2D6C5),
                      child: Icon(
                        [Icons.bed, Icons.nightlight_round, Icons.local_mall, Icons.card_giftcard][index],
                        size: 60,
                        color: const Color(0x803B4279),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Tag your little moments with #MyLittleJoy. We love seeing where the happy goes.',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 11. NEWSLETTER SECTION
// -----------------------------------------------------------------------------
class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.promoYellow,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              const Text(
                'A happy little inbox.',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navyText,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'New cuties, small-batch drops, and treats just for our joy club.\nThe good kind of mail. Pinky promise.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Your email address',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Count me in', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'By subscribing, you agree to our Privacy Policy. Unsubscribe whenever.',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 12. FOOTER SECTION
// -----------------------------------------------------------------------------
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    return ClipPath(
      clipper: ScallopedTopClipper(),
      child: Container(
        color: AppColors.footerBlue,
        padding: const EdgeInsets.only(top: 60, bottom: 30, left: 40, right: 40),
        child: Column(
          children: [
            isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBrandCol(),
                      _buildLinkCol('Find your joy', ['All the good stuff', 'Plush pals', 'Candles & home', 'Cozy accessories']),
                      _buildLinkCol('Here to help', ['Shipping & returns', 'Care guide', 'FAQs', 'Contact us']),
                      _buildLinkCol('A little more', ['Our story', 'Meet the makers', 'My account', 'Gift cards']),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandCol(),
                      const SizedBox(height: 30),
                      _buildLinkCol('Find your joy', ['All the good stuff', 'Plush pals', 'Candles & home', 'Cozy accessories']),
                      const SizedBox(height: 30),
                      _buildLinkCol('Here to help', ['Shipping & returns', 'Care guide', 'FAQs', 'Contact us']),
                      const SizedBox(height: 30),
                      _buildLinkCol('A little more', ['Our story', 'Meet the makers', 'My account', 'Gift cards']),
                    ],
                  ),
            const SizedBox(height: 50),
            const Divider(color: Colors.black12),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 Little Joy. A little love in every order.',
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
                Text(
                  'Privacy policy  •  Terms of service  •  USD \$',
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'little joy',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.navyText),
        ),
        const SizedBox(height: 12),
        const Text(
          'Small things. Big happy feelings.\nThoughtful gifts for you and your favorite people.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Icon(Icons.camera_alt_outlined, color: AppColors.navyText, size: 20),
            SizedBox(width: 12),
            Icon(Icons.music_note, color: AppColors.navyText, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkCol(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.navyText),
        ),
        const SizedBox(height: 12),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                link,
                style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
              ),
            )),
      ],
    );
  }
}