import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/dashboard_providers.dart';

class GlobalSearchDelegateSheet extends ConsumerStatefulWidget {
  const GlobalSearchDelegateSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const GlobalSearchDelegateSheet(),
    );
  }

  @override
  ConsumerState<GlobalSearchDelegateSheet> createState() =>
      _GlobalSearchDelegateSheetState();
}

class _GlobalSearchDelegateSheetState
    extends ConsumerState<GlobalSearchDelegateSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(globalSearchResultsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search customers, vehicles, registration…',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (v) =>
                  ref.read(globalSearchQueryProvider.notifier).state = v,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: resultsAsync.when(
                loading: () => const Center(child: LoadingIndicator()),
                error: (e, _) => Text(e.toString()),
                data: (results) {
                  if (_controller.text.trim().length < 2) {
                    return Text(
                      'Type at least 2 characters',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    );
                  }
                  if (results.isEmpty) {
                    return Text(
                      'No matches found',
                      style: AppTextStyles.bodyMedium,
                    );
                  }
                  return ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text('${item.category} · ${item.subtitle}'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.pop(context);
                          context.push(item.route);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
