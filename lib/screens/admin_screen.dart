import 'package:flutter/material.dart';

import '../main.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!requested) {
      requested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) AppScope.of(context).loadAdminStatistics();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final statistics = state.adminStatistics;
    if (state.account?.isAdmin != true) {
      return const SafeArea(
        child: Center(child: Text('دسترسی مدیر برای این حساب فعال نیست.')),
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: state.loadAdminStatistics,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFF3B256B),
                  child: Icon(Icons.admin_panel_settings_rounded, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'پنل مدیریت',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        state.account!.email,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'به‌روزرسانی آمار',
                  onPressed: state.loadingAdminStatistics
                      ? null
                      : state.loadAdminStatistics,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'آمار سیستم',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            if (state.loadingAdminStatistics && statistics == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.adminStatisticsError != null && statistics == null)
              _AdminError(
                message: state.adminStatisticsError!,
                retry: state.loadAdminStatistics,
              )
            else if (statistics != null)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _StatisticCard(
                    icon: Icons.people_alt_outlined,
                    label: 'کاربران',
                    value: statistics.users,
                    color: const Color(0xFF60A5FA),
                  ),
                  _StatisticCard(
                    icon: Icons.movie_filter_outlined,
                    label: 'رسانه‌های کش‌شده',
                    value: statistics.cachedMedia,
                    color: const Color(0xFFA78BFA),
                  ),
                  _StatisticCard(
                    icon: Icons.rate_review_outlined,
                    label: 'نظرهای ثبت‌شده',
                    value: statistics.reviews,
                    color: const Color(0xFF34D399),
                  ),
                  _StatisticCard(
                    icon: Icons.report_gmailerrorred_outlined,
                    label: 'گزارش‌های باز',
                    value: statistics.openReports,
                    color: const Color(0xFFFBBF24),
                  ),
                ],
              ),
            if (state.loadingAdminStatistics && statistics != null) ...[
              const SizedBox(height: 18),
              const LinearProgressIndicator(minHeight: 2),
            ],
            if (state.adminStatisticsError != null && statistics != null) ...[
              const SizedBox(height: 18),
              Text(
                state.adminStatisticsError!,
                style: const TextStyle(color: Colors.amber),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 22),
            const Card(
              child: ListTile(
                leading: Icon(Icons.security_rounded),
                title: Text('دسترسی محافظت‌شده'),
                subtitle: Text(
                  'این آمار مستقیماً از مسیر مدیریتی Backend و با توکن مدیر دریافت می‌شود.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const Spacer(),
          Text(
            '$value',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

class _AdminError extends StatelessWidget {
  const _AdminError({required this.message, required this.retry});

  final String message;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 36),
    child: Column(
      children: [
        const Icon(Icons.cloud_off_rounded, size: 52, color: Colors.amber),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: retry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('تلاش مجدد'),
        ),
      ],
    ),
  );
}
