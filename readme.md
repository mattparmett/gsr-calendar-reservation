# GSR Reservations Made Easier

There have been countless times when I need to reserve a GSR but I'm out or not in front of a computer.  Spike has a mobile site, but I'm lazy and it's annoying to have to log in and navigate the GSR reservation section each time I reserve a room.  I wanted to be able to add an event to my calendar and have a GSR automatically booked for that time.

## How it works

With IFTTT ([If This Then That](http://ifttt.com)), it's possible to watch a Google Calendar for new events and take an action when a new event is found (I believe the service checks triggers every 15 minutes).  I take IFTTT one step further and combine it with a plugin called [ifttt-webhook](https://github.com/captn3m0/ifttt-webhook).  This plugin hijacks the Wordpress channel and enables IFTTT to make a call to an arbitrary URL when a trigger is fired.  If you use IFTTT, this makes a lot of cool things possible.

I had already written a Ruby front end to the GSR reservation mobile site, allowing me to programmatically create GSR reservations given a time, duration, and (optionally) desired floor.  I could easily wrap this inside a simple Sinatra webapp, and call that webapp to make a reservation when IFTTT finds a new event called "GSR" in my calendar.

Essentially, that's all that's happening here, even though there are many moving parts.  The only configuration needed is the creation of two Heroku environment variables: `username` and `password`, containing your Spike username and password, through `heroku config:set`.

Simply upload the app to Heroku, create the two variables, and set your `ifttt-webhook` configuration accordingly.   Now you can be lazy and make GSR reservations from your calendar -- killing two birds (making the reservation and making an associated event in your calendar) with one stone.  Only events with titles containing the word "GSR" will be converted into GSR reservations.  Note that the only confirmation of a successful reservation will be Spike's automated email, and because of the 15 minute IFTTT refresh interval that email may not come for 15-20 minutes.

## Misc.

This app also contains a route, `POST /cancel`, that will call the GSR module's `cancel()` function.  This will cancel your closest GSR reservation.  (Beware -- `cancel()` hasn't been tested too rigorously -- just through casual, one-reservation use.)

There is very little error checking included in the GSR module -- this is mostly designed for personal use, and for the most part it's easy to avoid making reservation requests that will result in an error.

## Extensions

If there were a better interface to the GSR reservation site, we could use the event description to perhaps indicate certain Pennkeys to invite to the GSR, or indicate a room preference, etc.

This formula can be extended in an infinite number of ways.  Some examples include making a reservation on OpenTable when a new 'dinner at [restaurant]' event is created, or buying tickets to a movie on Fandango when a 'see [movie]' event is created.