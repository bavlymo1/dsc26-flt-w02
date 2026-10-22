import 'package:flutter/material.dart';

import '../../../data/repositories/alert_repository.dart';
import '../../../domain/models/stock_alert.dart';
import '../view_models/alerts_view_model.dart';

class NourShelfApp extends StatefulWidget {
  const NourShelfApp({super.key, required this.repository});

  final AlertRepository repository;

  @override
  State<NourShelfApp> createState() => _NourShelfAppState();
}

class _NourShelfAppState extends State<NourShelfApp> {
  late final AlertsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AlertsViewModel(repository: widget.repository)..load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlertsScreen(viewModel: _viewModel),
    );
  }
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key, required this.viewModel});

  final AlertsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch alerts'),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.loading) {
            return const Center(
              child: CircularProgressIndicator(key: Key('alerts-loading')),
            );
          }

          final alerts = viewModel.visibleAlerts;
          final countText = alerts.length == 1
              ? '1 alert'
              : '${alerts.length} alerts';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  key: const Key('search-field'),
                  decoration: const InputDecoration(
                    labelText: 'Search alerts',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: viewModel.setQuery,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: Severity.values.map((s) {
                    final isSelected = viewModel.activeFilters.contains(s);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        key: Key('filter-${s.name}'),
                        label: Text(s.name),
                        selected: isSelected,
                        onSelected: (_) => viewModel.toggleFilter(s),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  countText,
                  key: const Key('alerts-count'),
                ),
              ),
              Expanded(
                child: alerts.isEmpty
                    ? const Center(
                        child: Text(
                          'No alerts found',
                          key: Key('alerts-empty'),
                        ),
                      )
                    : ListView.builder(
                        key: const Key('alerts-list'),
                        itemCount: alerts.length,
                        itemBuilder: (context, index) {
                          final alert = alerts[index];
                          return ListTile(
                            key: Key('alert-${alert.id}'),
                            title: Text(
                              '${alert.medicineNameEn} / ${alert.medicineNameAr}',
                            ),
                            subtitle: Text(
                              'Severity: ${alert.severity.name} | Days: ${alert.daysOfCover}',
                            ),
                            trailing: !alert.acknowledged
                                ? IconButton(
                                    key: Key('ack-${alert.id}'),
                                    icon: const Icon(Icons.check),
                                    onPressed: () =>
                                        viewModel.acknowledge(alert.id),
                                  )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}