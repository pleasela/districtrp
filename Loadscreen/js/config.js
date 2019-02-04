var config =
{    
    /*
        Do we want to show the image?
        Note that imageSize still affects the size of the image and where the progressbars are located.
    */
    enableImage: true,
 
    /*
        Relative path the the logo we want to display.
    */
    image: "img/logo.png",

    /*
        Cursor image
    */
    cursorImage: "img/cursor.png",
 
    /*
        How big should the logo be?
        The values are: [width, height].
        Recommended to use square images less than 1024px.
    */
    imageSize: [512, 512],
 
    /*
        Define the progressbar type
            0 = Single progressbar
            1 = Multiple progressbars
            2 = Collapsed progressbars
     */
    progressBarType: 0,
 
    /*
        Here you can disable some of progressbars.
        Only applys if `singleProgressbar` is false.
    */
    progressBars:
    {
        "INIT_CORE": {
            enabled: false, //NOTE: Disabled because INIT_CORE seems to not get called properly. (race condition).
        },
 
        "INIT_BEFORE_MAP_LOADED": {
            enabled: true,
        },
 
        "MAP": {
            enabled: true,
        },
 
        "INIT_AFTER_MAP_LOADED": {
            enabled: true,
        },
 
        "INIT_SESSION": {
            enabled: true,
        }
    },
 
    /*
        Loading messages will be randomly picked from the array.
        The message is located on the left side above the progressbar.
        The text will slowly fade in and out, each time with another message.
        You can use UTF-8 emoticons inside loading messages!
    */
    loadingMessages:
    [
        "Never break character!... &#x1f40c;",
        "Always keep the new life rule in mind... &#x1f40c;",
        "Found a hacker? report them on the Discord &#x1f528;",
        "Remember that you need a microphone to play here... &#x1f462;",
        "Please educate yourself on the server rules in the Discord... &#x1f41a;",
        "No Cop Baiting of any kind, it will result in a kick/ban... &#x1f3cf;",
        "Check out #server-help on the discord to view the rest of the keybinds... &#x1f9e0;",
        "If you find a bug, report it. Don't get yourself banned. &#x1f956;",
        "No cheating is tolerated whatsoever, you'll be perm-banned. &#x1f374;",
        "Always value your life in rp scenarios! &#x1f60d;",
        "Biiiiiiig Oooooof! &#x1f9e0;",
        "No- Meta-gaming is allowed whatsoever... &#x1f697;",
        "Don't afk whitelisted jobs just to earn money... &#x1f3cc;",
        "Ls is our god. &#x1f4f1;",
        "No squirrels were hurt during this loadscreen. &#x1f691;",
    ],
 
    /*
        Rotate the loading message every 5000 milliseconds (default value).
    */
    loadingMessageSpeed: 5 * 1000,
 
    /*
        Array of music id's to play in the loadscreen.
        Enter your youtube video id's here. In order to obtain the video ID
        Take whats after the watch?v= on a youtube link.
        https://www.youtube.com/watch?v=<videoid>
        Do not include the playlist id or anything, it should be a 11 digit code.
       
        Do not use videos that:
            - Do not allow embedding.
            - Copyrighted music (youtube actively blocks this).
    */
    music:
    [
        "OZcoDQybozk", "9mcDA-zPMDY", "H0h6GEFek5w",
        "RbkVhl6IObc", "yKpRy6kSDkc",
        "OZcoDQybozk", "sVWqxgdMutM", "hDCeAWNWhfU",
        "vWdjWYhEONA", "yehwi5yBylk", "8sV6AT6jVuI",
    ],
 
 
    /*
        Set to false if you do not want any music.
    */
    enableMusic: true,
 
    /*
        Default volume for the player. Please keep this under 50%, to not blowout someones eardrums x)
     */
    musicVolume: 30,
 
    /*
        Should the background change images?
        True: it will not change backgrounds.
        False: it will change backgrounds.
    */
    staticBackground: true,
   
    /*
        Array of images you'd like to display as the background.
        Provide a path to a local image, using images via url is not recommended.
    */
    background:
    [
        "img/bg1.png",
        "img/bg2.png",
        "img/bg3.png",
    ],
 
    /*
        Time in milliseconds on how fast the background
        should swap images.
     */
    backgroundSpeed: 10 * 1000,

    /*
        Which style of animation should the background transition be?
        zoom = background zooms in and out.
        slide = transtion backgrounds from sliding right and back again.
        fade = fade the background out and back in.
    */
    backgroundStyle: "zoom",

    /*
        Should the log be visible? Handy for debugging!
    */
    enableLog: true,
}
