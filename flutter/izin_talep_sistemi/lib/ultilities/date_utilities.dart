int leaveDayCount(DateTime start, DateTime end) =>
    end.difference(start).inDays + 1;
