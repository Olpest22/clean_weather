import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/city_search/city_search_bloc.dart';
import '../widgets/presentation_extensions.dart';
import '../widgets/status_message.dart';

/// Экран поиска города. Выбранный город возвращается через Navigator.pop.
class CitySearchPage extends StatefulWidget {
  const CitySearchPage({super.key});

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search(String query) {
    context.read<CitySearchBloc>().add(CitySearchQueryChanged(query));
  }

  void _clear() {
    _queryController.clear();
    _search('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Название города',
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
        actions: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _queryController,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Очистить',
                    icon: const Icon(Icons.close),
                    onPressed: _clear,
                  ),
          ),
        ],
      ),
      body: BlocBuilder<CitySearchBloc, CitySearchState>(
        builder: (context, state) {
          return switch (state.status) {
            CitySearchStatus.initial => const StatusMessage(
                emoji: '🔎',
                title: 'Поиск города',
                message: 'Введите хотя бы 2 буквы названия, '
                    'например «Москва» или «Amsterdam».',
              ),
            CitySearchStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            CitySearchStatus.failure => StatusMessage(
                emoji: '⚠️',
                title: 'Ошибка поиска',
                message: state.errorMessage ?? 'Попробуйте ещё раз.',
                actionLabel: 'Повторить',
                onAction: () => _search(state.query),
              ),
            CitySearchStatus.success when state.locations.isEmpty =>
              StatusMessage(
                emoji: '🤷',
                title: 'Город не найден',
                message: 'По запросу «${state.query}» ничего не нашлось. '
                    'Проверьте написание.',
              ),
            CitySearchStatus.success => _LocationList(state: state),
          };
        },
      ),
    );
  }
}

class _LocationList extends StatelessWidget {
  const _LocationList({required this.state});

  final CitySearchState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.locations.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final location = state.locations[index];
            return ListTile(
              leading: Text(
                location.flagEmoji,
                style: const TextStyle(fontSize: 28),
              ),
              title: Text(location.name),
              subtitle:
                  location.subtitle.isEmpty ? null : Text(location.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pop(location),
            );
          },
        ),
      ),
    );
  }
}
