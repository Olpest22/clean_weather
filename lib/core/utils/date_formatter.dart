const _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
const _months = [
  'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
  'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// «14:05»
String formatTime(DateTime time) =>
    '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';

/// «14:00»
String formatHour(DateTime time) => '${_twoDigits(time.hour)}:00';

/// «Сегодня», «Завтра» или «Пт, 3 окт».
String formatDayLabel(DateTime date, {required DateTime today}) {
  // Сравниваем только даты в UTC, чтобы переход на летнее время
  // не влиял на разницу в днях.
  final day = DateTime.utc(date.year, date.month, date.day);
  final todayDate = DateTime.utc(today.year, today.month, today.day);
  final difference = day.difference(todayDate).inDays;

  if (difference == 0) return 'Сегодня';
  if (difference == 1) return 'Завтра';
  return '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';
}
