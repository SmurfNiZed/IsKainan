String getDayRange(List<bool> days) {
  List<String> ranges = [];

  bool inRange = false;
  String currentRangeStart = '';

  for (int i = 0; i < days.length; i++) {
    if (days[i]) {
      if (!inRange) {
        currentRangeStart = _getDayName(i);
        inRange = true;
      }
    } else {
      if (inRange) {
        String currentRangeEnd = _getDayName(i - 1);
        ranges.add(_formatRange(currentRangeStart, currentRangeEnd));
        inRange = false;
      }
    }
  }

  if (inRange) {
    String currentRangeEnd = _getDayName(6);
    ranges.add(_formatRange(currentRangeStart, currentRangeEnd));
  }

  return ranges.join(', ');
}

String _getDayName(int index) {
  List<String> dayNames = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];
  return dayNames[index];
}

String _formatRange(String start, String end) {
  if (start == end) {
    return start;
  } else {
    return '$start-$end';
  }
}