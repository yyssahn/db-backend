db project but backend


for saving in db for 20 minutes, I just did an event on mysql with command

CREATE DEFINER=`root`@`localhost` EVENT `myevent` ON SCHEDULE EVERY 1 MINUTE STARTS '2017-07-30 18:24:44' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM products WHERE updated_at < (NOW() + INTERVAL 7 HOUR - INTERVAL 20 MINUTE)
