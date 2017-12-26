function sec = time2sec(time,ref)
sec = (datenum(time)-ref)*24*60*60;
end