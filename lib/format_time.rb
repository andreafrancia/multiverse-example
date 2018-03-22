def format_time time
  return 'Rang!' if time < 0
  '%02d:%02d' % [ time / 60, time % 60 ]
end
