import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/confirmation_bottom_sheet.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/repositories/auth_repository.dart';

class WorkerProfileView extends StatefulWidget {
  const WorkerProfileView({super.key});

  @override
  State<WorkerProfileView> createState() => _WorkerProfileViewState();
}

class _WorkerProfileViewState extends State<WorkerProfileView> {
  final RxBool isAvailable = true.obs;
  final RxDouble hourlyRate = 45.0.obs;
  final RxDouble walletBalance = 3840.0.obs;
  final RxInt coverageRadiusKm = 15.obs;
  final RxList<String> skills = <String>[
    '⚡ Main Panel Installation',
    '🔍 Fault Diagnostics',
    '🔌 Commercial Rewiring',
    '💡 LED Lighting Setup',
    '🚗 EV Home Chargers',
    '🚨 24/7 Emergency Repairs',
  ].obs;

  @override
  Widget build(BuildContext context) {
    final authRepo = Get.find<AuthRepository>();
    final userData = authRepo.userData ?? {};
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = userData['fullName']?.toString() ?? 'Rajesh Sharma';
    final email = userData['email']?.toString() ?? 'pro@kamkar.com';
    final phone = userData['phoneNumber']?.toString() ?? '+1 (555) 349-8201';
    final workerType = userData['workerType']?.toString() ?? 'Master Electrician';
    final experience = userData['yearsOfExperience']?.toString() ?? '8';

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Craftsman Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Support Desk',
            onPressed: () => Get.toNamed(AppRoutes.helpSupport),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: const Icon(
                Icons.headset_mic_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 18,
                color: isDark ? Colors.white70 : const Color(0xFF475569),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Craftsman Profile Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Trade Gradient Banner
                    Container(
                      height: 75,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4F46E5),
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                      ),
                    ),

                    // Overlapping Avatar & Verified Badge
                    Transform.translate(
                      offset: const Offset(0, -42),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? AppColors.surfaceDark : Colors.white,
                                  border: Border.all(
                                    color: isDark ? AppColors.surfaceDark : Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.18),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      name.isNotEmpty
                                          ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                                          : 'RS',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark ? AppColors.surfaceDark : Colors.white,
                                    width: 2.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Worker Name
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                              letterSpacing: -0.4,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Trade Specialty Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.primary.withValues(alpha: 0.25)
                                  : const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.primary.withValues(alpha: 0.4)
                                    : const Color(0xFFC7D2FE),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.electric_bolt_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  workerType.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Stats Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Obx(
                          () => Row(
                            children: [
                              _buildStatColumn('Hourly Rate', '\$${hourlyRate.value.toInt()}/hr', isDark,
                                  valueColor: AppColors.primary),
                              _buildVerticalDivider(isDark),
                              _buildStatColumn('Rating', '4.9 ★', isDark, valueColor: const Color(0xFFF59E0B)),
                              _buildVerticalDivider(isDark),
                              _buildStatColumn('Jobs Done', '42', isDark),
                              _buildVerticalDivider(isDark),
                              _buildStatColumn('Experience', '${experience}y+', isDark),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Availability Status Switch Card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isAvailable.value
                                ? const Color(0xFF10B981).withValues(alpha: isDark ? 0.15 : 0.08)
                                : const Color(0xFF64748B).withValues(alpha: isDark ? 0.15 : 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isAvailable.value
                                  ? const Color(0xFF10B981).withValues(alpha: 0.3)
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isAvailable.value ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAvailable.value ? 'Online & Available' : 'Offline / On Break',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: isAvailable.value
                                            ? const Color(0xFF10B981)
                                            : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                                      ),
                                    ),
                                    Text(
                                      isAvailable.value
                                          ? 'Ready to receive immediate customer dispatches'
                                          : 'You will not receive new booking requests',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: isAvailable.value,
                                activeTrackColor: const Color(0xFF10B981),
                                activeThumbColor: Colors.white,
                                onChanged: (val) {
                                  HapticFeedback.lightImpact();
                                  isAvailable.value = val;
                                  Get.snackbar(
                                    val ? 'You are Online' : 'You are Offline',
                                    val
                                        ? 'Customers in Dubai Marina can now discover and book your services.'
                                        : 'Availability turned off. Enjoy your break!',
                                    duration: const Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(16),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),

              const SizedBox(height: 22),

              // Section 1: Earnings & Payout Bank Account (UAE IBAN)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Text(
                  'Earnings Wallet & Payouts',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF064E3B), const Color(0xFF065F46)]
                        : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available for Payout',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => Text(
                                'AED ${walletBalance.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : const Color(0xFF064E3B),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _handleInstantCashout(context),
                          icon: const Icon(Icons.flash_on_rounded, size: 16),
                          label: const Text('Cashout', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_rounded, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Emirates NBD • IBAN: AE29 0330 •••• 8831',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF065F46),
                              ),
                            ),
                          ),
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 22),

              // Section 2: Trade Skills & Certifications
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Verified Skills & Trade License',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                        letterSpacing: 0.2,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showEditTradeModal(context),
                      child: const Text('Edit Trade', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // License Status Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UAE Trade Board License #UAE-EL-8842',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Government verified background & technical assessment',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Skill Badges
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills.map((s) => _SkillChip(s)).toList(),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms),

              const SizedBox(height: 22),

              // Section 3: Contact & Service Coverage
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Text(
                  'Contact & Service Area',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    _buildModernInfoRow(
                      context,
                      icon: Icons.mail_outline_rounded,
                      iconBg: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF4F46E5),
                      label: 'Registered Email',
                      value: email,
                      isDark: isDark,
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: email));
                        Get.snackbar('Copied', 'Email copied to clipboard',
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(16));
                      },
                    ),
                    Divider(height: 24, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                    _buildModernInfoRow(
                      context,
                      icon: Icons.phone_iphone_rounded,
                      iconBg: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      label: 'Direct Phone',
                      value: phone,
                      isDark: isDark,
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: phone));
                        Get.snackbar('Copied', 'Phone number copied to clipboard',
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(16));
                      },
                    ),
                    Divider(height: 24, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                    Obx(
                      () => _buildModernInfoRow(
                        context,
                        icon: Icons.location_on_outlined,
                        iconBg: const Color(0xFFFEF3C7),
                        iconColor: const Color(0xFFD97706),
                        label: 'Active Service Region',
                        value: 'Dubai Marina & JLT (${coverageRadiusKm.value} km Radius)',
                        isDark: isDark,
                        onTap: () => _showEditTradeModal(context),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 22),

              // Section 4: Support & Preferences
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Text(
                  'Support & Preferences',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    // Help & Customer Support Tile
                    _buildSettingsTile(
                      icon: Icons.headset_mic_rounded,
                      iconBg: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF4F46E5),
                      title: 'Craftsman Support & Dispute Center',
                      subtitle: '24/7 payout assistance, instant chat & job resolution',
                      isDark: isDark,
                      trailingBadge: '24/7 Live',
                      onTap: () => Get.toNamed(AppRoutes.helpSupport),
                    ),

                    Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),

                    // Dark Mode Switch
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                              color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isDark ? 'Dark theme enabled' : 'Clean light theme enabled',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isDark,
                            activeTrackColor: AppColors.primary,
                            activeThumbColor: Colors.white,
                            onChanged: (val) {
                              final storage = Get.find<SecureStorageService>();
                              final mode = val ? 'dark' : 'light';
                              storage.setThemeMode(mode);
                              Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                            },
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),

                    // Settings & Languages
                    _buildSettingsTile(
                      icon: Icons.tune_rounded,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF9333EA),
                      title: 'Settings & Language',
                      subtitle: 'App preferences, language & notification alerts',
                      isDark: isDark,
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),

                    Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),

                    // App Tour
                    _buildSettingsTile(
                      icon: Icons.auto_awesome_rounded,
                      iconBg: const Color(0xFFFFFBEB),
                      iconColor: const Color(0xFFD97706),
                      title: 'Worker App Tour',
                      subtitle: 'Review features & guidelines for accepting jobs',
                      isDark: isDark,
                      onTap: () => Get.toNamed(AppRoutes.onboarding),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 250.ms),

              const SizedBox(height: 28),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {
                    final confirmed = await ConfirmationBottomSheet.show(
                      context: context,
                      title: 'Sign Out?',
                      message: 'Are you sure you want to sign out? You will need to log back in to receive customer dispatches.',
                      confirmText: 'Sign Out',
                      cancelText: 'Stay Logged In',
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFEF4444),
                      confirmButtonColor: const Color(0xFFEF4444),
                      isDestructive: true,
                    );
                    if (confirmed == true) {
                      await authRepo.logout();
                      Get.offAllNamed(AppRoutes.login);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.5) : const Color(0xFFFCA5A5),
                      width: 1.5,
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFFEF4444).withValues(alpha: 0.08)
                        : const Color(0xFFFEF2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 18),

              // Footer
              Center(
                child: Text(
                  'Kamkar Pro Network • UAE Licensed Craftsman',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, bool isDark, {Color? valueColor}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: valueColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      width: 1,
      height: 28,
      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildModernInfoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
    VoidCallback? onCopy,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: Icon(
                Icons.copy_rounded,
                size: 17,
                color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
              ),
              onPressed: onCopy,
              tooltip: 'Copy',
            ),
          if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    String? trailingBadge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? iconColor.withValues(alpha: 0.15) : iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      if (trailingBadge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            trailingBadge,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  // MODAL ACTIONS
  Future<void> _handleInstantCashout(BuildContext context) async {
    final confirmed = await ConfirmationBottomSheet.show(
      context: context,
      title: 'Instant Cashout?',
      message: 'Transfer AED ${walletBalance.value.toStringAsFixed(2)} to Emirates NBD IBAN ending in 8831?',
      confirmText: 'Withdraw AED ${walletBalance.value.toInt()}',
      cancelText: 'Cancel',
      icon: Icons.account_balance_rounded,
      iconColor: const Color(0xFF10B981),
      confirmButtonColor: const Color(0xFF10B981),
    );

    if (confirmed == true) {
      walletBalance.value = 0.0;
      Get.snackbar(
        'Payout Initiated',
        'AED 3,840.00 is being transferred to your Emirates NBD account. Ref: WTH-99201.',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _showEditTradeModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double tempRate = hourlyRate.value;
    int tempRadius = coverageRadiusKm.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Edit Trade & Pricing Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Hourly Service Rate: \$${tempRate.toInt()}/hr',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
              Slider.adaptive(
                value: tempRate,
                min: 25,
                max: 150,
                divisions: 25,
                activeColor: AppColors.primary,
                label: '\$${tempRate.toInt()}',
                onChanged: (val) {
                  setSheetState(() => tempRate = val);
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Coverage Radius: $tempRadius km from Dubai Marina',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
              Slider.adaptive(
                value: tempRadius.toDouble(),
                min: 5,
                max: 50,
                divisions: 9,
                activeColor: const Color(0xFF10B981),
                label: '$tempRadius km',
                onChanged: (val) {
                  setSheetState(() => tempRadius = val.toInt());
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Save Trade Preferences',
                icon: Icons.check_circle_outline_rounded,
                onPressed: () {
                  hourlyRate.value = tempRate;
                  coverageRadiusKm.value = tempRadius;
                  Navigator.pop(ctx);
                  Get.snackbar('Trade Updated', 'Your hourly rate & coverage area have been updated.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip(this.label);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white70 : const Color(0xFF334155),
        ),
      ),
    );
  }
}
