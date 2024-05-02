# Crypto-App-IOS
This application is the framework for an IOS App that can parse json data from coin gecko's public api and display it to a device's screen.

## Set-up
The set-up is pretty simple. All you have to do is clone the project and then launch it via XCode. Then set up whatever necessary configurations you want in the project manager.

## Limitations of the app

Since we've been working with threads, I've attempted to optimize the code as best as I could. For example, using `dispatchqueue` and `async` properties seemed to make my app 
start to run really quickly. I've never had any issues with performance on the app, however, the application is still relatively small and it would be interesting to see how it would
run on a larger scale setting. 

Starting to adventure into having clients that use the app, it would be beneficial to store information to the cloud for ease of use. Another limitation would be how to get the application working. Typically, a regular client won't know how to clone a project and GitHub and won't want to do that. Finding a way to deploy the application through a container with all the essential libraries would be the best for any type of application.

Another limitation I feel is if I could better utilize shared data across the files. For example, there was some redudencies on calling objects where data was stored twice and I couldn't figure out a better way to do that. That's mostly due to the syntax. However, I did find a better way to do it but it looked to be pretty time-consuming.

There is perhaps better ways to decode json data and format it, including libraries that I probably haven't heard of.

One of the biggest issues was time. I wish I had more time to work on this project and understand how XCode worked a bit better.

## Features that were not completed
Notifications that are sent to your screen if the crypto price reaches a certain point. The reason why this didn't get completed is because notifications are a whole larger area of XCode. I attempted to get the absolute bare-bones of a notification to work but it wasn't playing nice. I setup the notification and applied a 5 second timer that every 5 seconds would send a notification to the top of the page (like IOS does) and it would not work for some reason. Whether its the simulator or otherwise, I'm not sure.

Better UI. I felt as if the application is pretty basic in some ways and I would've liked to overhaul the design to be a bit more user friendly, but it does get the job done and does what it needs to do.

Fixing the trendlines of the crypto data. Unfortunately the charts were a pain to work with, especially with the parsed data from json and reading into it from the charts. I was easily able to get the charts to work and display but the way I wanted it to be was to be a linear growth from $0 all the way up to the current price. However, the realistic way that these charts are formatted with crypto is over long periods of time, showing the price updated every day. I was suggested to use Firebase and to store the data externally and update the trends through that way, but there wasn't enough time.

## Future plans

Ideally, seeing the features that weren't completed would be a massive milestone for the project. Completing these things could actually turn the app into something a consumer might want. I would've liked to also implement a full log-in system so users can store their data on the cloud or a database.

Unfortunately, since I'm not a mac user, I have very limited time and only school provides Mac hardware, so this project will progress very slowly over time.

### Conclusion

All in all, I'm very happy with how the project turned out and the features that I was able to implement. Although it's a pretty basic app, it's a good start in the right direction
and helped me understand XCode syntax much more. I thought I wouldn't have liked the XCode IDE but it started to grow on me. Perhaps in the future when I inevitably make the move to a MacOS (like most programmers do), this will be a project I can look back on and refine into something much better.
