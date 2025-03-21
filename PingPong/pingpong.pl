:- dynamic have_sent/1, % message state: to track if we've sent messages
           have_received/1, % message state: to track if we've received messages
	   sent_ping/0, % used for goals
	   wait_for_pong/0. % used for goals