import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/chat_model.dart';
import 'chat_controller.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({super.key});

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final controller = Get.find<ChatController>();
  late String threadId;
  late String workerName;
  late double initialRate;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    threadId = args['threadId']?.toString() ?? 't-1';
    workerName = args['workerName']?.toString() ?? 'Skilled Worker';
    initialRate = (args['hourlyRate'] as num?)?.toDouble() ?? 45.0;
    controller.currentNegotiatedRate.value = initialRate;
    controller.loadThreadMessages(threadId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(workerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Obx(
              () => Text(
                'Rate: \$${controller.currentNegotiatedRate.value.toStringAsFixed(0)}/hr',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.handshake_outlined, color: AppColors.primary),
            tooltip: 'Propose Rate Offer',
            onPressed: () => _showOfferModal(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return _buildMessageBubble(context, msg, isDark);
                  },
                ),
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(
                  top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: TextField(
                        controller: controller.messageInputController,
                        onSubmitted: (_) => controller.sendMessage(threadId),
                        style: TextStyle(
                          fontSize: 14.5,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => controller.sendMessage(threadId),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, bool isDark) {
    final isMine = msg.isMine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMine ? 20 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 20),
          ),
          border: isMine
              ? null
              : Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (msg.proposedRate != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isMine
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.handshake_rounded,
                      size: 13,
                      color: isMine ? Colors.white : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'OFFER: \$${msg.proposedRate!.toInt()}/hr',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: isMine ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Text(
              msg.message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isMine
                    ? Colors.white
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(msg.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMine
                    ? Colors.white.withValues(alpha: 0.7)
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 150.ms).slideY(begin: 0.05, end: 0);
  }

  void _showOfferModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double proposed = controller.currentNegotiatedRate.value;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Propose Counter Offer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Suggest an hourly rate for this service task',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '\$${proposed.toInt()}/hr',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                Slider(
                  value: proposed,
                  min: 20.0,
                  max: 150.0,
                  divisions: 26,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setModalState(() {
                      proposed = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Submit Offer (\$${proposed.toInt()}/hr)',
                  onPressed: () {
                    controller.proposeOffer(threadId, proposed);
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
