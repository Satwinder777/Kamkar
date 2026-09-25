import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';

class FaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final IconData categoryIcon;
  final RxBool isExpanded;
  final RxnBool userHelpful; // null = unvoted, true = yes, false = no

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.categoryIcon = Icons.help_outline_rounded,
    bool expanded = false,
  })  : isExpanded = expanded.obs,
        userHelpful = RxnBool();
}

class TicketMessage {
  final String sender;
  final String message;
  final DateTime time;
  final bool isAgent;

  TicketMessage({
    required this.sender,
    required this.message,
    required this.time,
    this.isAgent = true,
  });
}

class SupportTicket {
  final String id;
  final String category;
  final String description;
  final String priority;
  final RxString status;
  final DateTime createdAt;
  final String? attachedFileName;
  final RxList<TicketMessage> messages;
  final RxBool isExpanded;

  SupportTicket({
    required this.id,
    required this.category,
    required this.description,
    required this.priority,
    required String status,
    required this.createdAt,
    this.attachedFileName,
    List<TicketMessage>? initialMessages,
  })  : status = status.obs,
        messages = (initialMessages ?? []).obs,
        isExpanded = false.obs;
}

class LiveChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  LiveChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class HelpSupportController extends GetxController with GetSingleTickerProviderStateMixin {
  final authRepo = Get.find<AuthRepository>();

  late TabController tabController;
  final RxInt selectedTabIndex = 0.obs;

  final RxString selectedFaqCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  final ticketCategory = 'Booking & Scheduling'.obs;
  final ticketPriority = 'Standard'.obs;
  final ticketDescriptionController = TextEditingController();
  final RxString attachedFile = ''.obs;
  final RxBool isSubmitting = false.obs;

  // Live Chat state
  final liveChatInputController = TextEditingController();
  final RxBool isAgentTyping = false.obs;
  final RxList<LiveChatMessage> chatMessages = <LiveChatMessage>[
    LiveChatMessage(
      text: 'Hello! Welcome to Kamkar 24/7 UAE Support Desk. How can we help you today with your bookings, craftsmen, or invoices?',
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ].obs;

  final RxList<SupportTicket> activeTickets = <SupportTicket>[
    SupportTicket(
      id: 'KMK-84920',
      category: 'Billing & Payouts',
      description: 'Inquiry regarding automated weekend payout schedule and VAT tax receipt download.',
      priority: 'Standard',
      status: 'In Progress',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      initialMessages: [
        TicketMessage(
          sender: 'Kamkar Support System',
          message: 'Ticket received and assigned to UAE Accounts Desk.',
          time: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        TicketMessage(
          sender: 'Sarah (Finance Lead)',
          message: 'Hello, your payout batch is queued for Monday 10:00 AM Gulf Standard Time. Invoices can be downloaded in PDF format.',
          time: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
  ].obs;

  late final List<FaqItem> allFaqs;

  bool get isWorker => authRepo.userRole.toLowerCase() == 'worker';
  bool get isAdmin => authRepo.userRole.toLowerCase() == 'admin';

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
    _initFaqs();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    tabController.animateTo(index);
  }

  void _initFaqs() {
    if (isWorker) {
      ticketCategory.value = 'Payout & Bank IBAN';
      allFaqs = [
        FaqItem(
          id: 'w1',
          category: 'Payouts & Earnings',
          categoryIcon: Icons.account_balance_wallet_rounded,
          question: 'How and when do I receive payouts for completed jobs?',
          answer:
              'Payouts are credited directly to your registered UAE IBAN bank account. Instant withdrawals are processed within 30 minutes, and standard batch payouts occur every Monday without extra fees.',
        ),
        FaqItem(
          id: 'w2',
          category: 'Safety & Verification',
          categoryIcon: Icons.verified_user_rounded,
          question: 'How do I renew or update my UAE Trade Board License?',
          answer:
              'Navigate to your Craftsman Profile, tap on your License badge or Trade details, and upload your renewed municipality/trade certification card. Verification takes less than 24 hours.',
        ),
        FaqItem(
          id: 'w3',
          category: 'Job Dispatches',
          categoryIcon: Icons.location_on_rounded,
          question: 'What if a customer is not at the job location or cancels last minute?',
          answer:
              'If you have already arrived within the scheduled time window, tap "Report Customer Absence". You will be compensated a guaranteed call-out fee of AED 65 automatically.',
        ),
        FaqItem(
          id: 'w4',
          category: 'Tools & Equipment',
          categoryIcon: Icons.handyman_rounded,
          question: 'Are materials and spare parts reimbursed through the app?',
          answer:
              'Yes! When quoting on a job or completing service, you can attach receipts for parts purchased. The customer approves the material invoice directly in-app and it gets added to your payout.',
        ),
        FaqItem(
          id: 'w5',
          category: 'Safety & Verification',
          categoryIcon: Icons.health_and_safety_rounded,
          question: 'What should I do in case of an on-site hazardous emergency?',
          answer:
              'Immediately use the Emergency SOS button located at the top right of the Support Hub to connect with our 24/7 Safety Dispatch & UAE Civil Defense (997) hotline.',
        ),
      ];
    } else {
      ticketCategory.value = 'Booking & Scheduling';
      allFaqs = [
        FaqItem(
          id: 'c1',
          category: 'Bookings & Orders',
          categoryIcon: Icons.calendar_month_rounded,
          question: 'How do I book a verified craftsman on Kamkar?',
          answer:
              'Explore trades (Plumbing, Electrical, Carpentry, HVAC, Painting), select your preferred verified pro or request an instant dispatch, pick your preferred time slot, and confirm securely.',
        ),
        FaqItem(
          id: 'c2',
          category: 'Payments & Refunds',
          categoryIcon: Icons.credit_card_rounded,
          question: 'When is my card charged for a booked service?',
          answer:
              'Your payment is safely held in escrow when booking. It is only released to the craftsman after you inspect and sign off on the completed work to ensure complete peace of mind.',
        ),
        FaqItem(
          id: 'c3',
          category: 'Guarantee & Shield',
          categoryIcon: Icons.shield_rounded,
          question: 'Is there a guarantee or warranty on completed repairs?',
          answer:
              'Yes! All work performed by Kamkar Verified Craftsmen comes with our 30-Day Kamkar Shield Guarantee covering workmanship, free re-work, and verified part replacements.',
        ),
        FaqItem(
          id: 'c4',
          category: 'Cancellations',
          categoryIcon: Icons.cancel_rounded,
          question: 'Can I reschedule or cancel my booking without penalty?',
          answer:
              'You can reschedule or cancel free of charge up to 2 hours before the technician\'s arrival time directly from your Bookings tab with instant full refund.',
        ),
        FaqItem(
          id: 'c5',
          category: 'Safety & Verification',
          categoryIcon: Icons.verified_rounded,
          question: 'Are all craftsmen background-checked and licensed?',
          answer:
              '100% of our craftsmen undergo stringent UAE Trade Board certification, government background checks, and identity verification before accepting jobs.',
        ),
      ];
    }
  }

  List<FaqItem> get filteredFaqs {
    return allFaqs.where((faq) {
      final matchesCategory =
          selectedFaqCategory.value == 'All' || faq.category == selectedFaqCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          faq.question.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          faq.answer.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<String> get availableCategories {
    final categories = {'All'};
    for (final f in allFaqs) {
      categories.add(f.category);
    }
    return categories.toList();
  }

  List<String> get ticketCategoryOptions {
    if (isWorker) {
      return [
        'Payout & Bank IBAN',
        'Job Dispatch & Location',
        'Customer Dispute',
        'Trade License Verification',
        'App Technical Issue',
        'Safety & Emergency Report',
      ];
    }
    return [
      'Booking & Scheduling',
      'Payment & Escrow Refund',
      'Craftsman Quality & Dispute',
      'Invoice & Tax Receipt',
      'App Technical Issue',
      'Safety & Trust Concern',
    ];
  }

  void rateFaqHelpful(FaqItem faq, bool isHelpful) {
    faq.userHelpful.value = isHelpful;
    HapticFeedback.lightImpact();
    Get.snackbar(
      isHelpful ? 'Thank you!' : 'Feedback Noted',
      isHelpful ? 'Glad this answer was helpful to you.' : 'We will improve this guide for better clarity.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isHelpful ? const Color(0xFF10B981) : const Color(0xFF64748B),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
    );
  }

  Future<void> sendLiveChatMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    liveChatInputController.clear();
    chatMessages.add(
      LiveChatMessage(text: cleanText, isUser: true, time: DateTime.now()),
    );
    HapticFeedback.lightImpact();

    isAgentTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));

    isAgentTyping.value = false;
    String botReply = 'Thank you for reaching out. A Kamkar Support specialist is reviewing your query regarding "$cleanText". We will assist you immediately!';
    if (cleanText.toLowerCase().contains('refund') || cleanText.toLowerCase().contains('payment')) {
      botReply = 'All Kamkar escrow refunds are processed within 2-4 business hours to your original payment method. You can track this under Bookings > Payment Details.';
    } else if (cleanText.toLowerCase().contains('cancel') || cleanText.toLowerCase().contains('reschedule')) {
      botReply = 'You can easily cancel or reschedule your service up to 2 hours before the visit from the Active Bookings screen without any penalty.';
    }

    chatMessages.add(
      LiveChatMessage(text: botReply, isUser: false, time: DateTime.now()),
    );
    HapticFeedback.selectionClick();
  }

  Future<void> submitSupportTicket(BuildContext context) async {
    final desc = ticketDescriptionController.text.trim();
    if (desc.isEmpty) {
      Get.snackbar(
        'Details Required',
        'Please describe your issue or concern in detail.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
      return;
    }

    isSubmitting.value = true;
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 800));

    final newId = 'KMK-${10000 + (DateTime.now().millisecondsSinceEpoch % 89999)}';
    final ticket = SupportTicket(
      id: newId,
      category: ticketCategory.value,
      description: desc,
      priority: ticketPriority.value,
      status: 'Submitted',
      attachedFileName: attachedFile.value.isNotEmpty ? attachedFile.value : null,
      createdAt: DateTime.now(),
      initialMessages: [
        TicketMessage(
          sender: 'Kamkar Automated Concierge',
          message: 'Your ticket has been logged and assigned to priority queue.',
          time: DateTime.now(),
        ),
      ],
    );

    activeTickets.insert(0, ticket);
    isSubmitting.value = false;
    ticketDescriptionController.clear();
    attachedFile.value = '';

    if (context.mounted) {
      _showTicketCreatedDialog(context, ticket);
    }
  }

  void _showTicketCreatedDialog(BuildContext context, SupportTicket ticket) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                color: Color(0xFF10B981),
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Ticket Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Reference: ${ticket.id}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Our 24/7 UAE support desk has received your request. A senior support specialist will review it within 15 minutes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      changeTab(2); // Switch to My Tickets
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View Tickets',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    ticketDescriptionController.dispose();
    liveChatInputController.dispose();
    super.onClose();
  }
}
