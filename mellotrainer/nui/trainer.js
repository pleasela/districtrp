/** CONFIG **/
var resourcename = "mellotrainer";  // Resource Name
var maxVisibleItems = 10;           // Max amount of items in 1 menu (before autopaging kicks in)


// DO NOT TOUCH ANTYHING BELOW HERE!!! CONTACT THESTONEDTURTLE IF ANY ISSUES
// DO NOT TOUCH ANTYHING BELOW HERE!!! CONTACT THESTONEDTURTLE IF ANY ISSUES
// DO NOT TOUCH ANTYHING BELOW HERE!!! CONTACT THESTONEDTURTLE IF ANY ISSUES
// DO NOT TOUCH ANTYHING BELOW HERE!!! CONTACT THESTONEDTURTLE IF ANY ISSUES
// DO NOT TOUCH ANTYHING BELOW HERE!!! CONTACT THESTONEDTURTLE IF ANY ISSUES


/***
 *     __      __                 _           _       _            _____                  _                          _     _                 
 *     \ \    / /                (_)         | |     | |          |  __ \                | |                        | |   (_)                
 *      \ \  / /    __ _   _ __   _    __ _  | |__   | |   ___    | |  | |   ___    ___  | |   __ _   _ __    __ _  | |_   _    ___    _ __  
 *       \ \/ /    / _` | | '__| | |  / _` | | '_ \  | |  / _ \   | |  | |  / _ \  / __| | |  / _` | | '__|  / _` | | __| | |  / _ \  | '_ \ 
 *        \  /    | (_| | | |    | | | (_| | | |_) | | | |  __/   | |__| | |  __/ | (__  | | | (_| | | |    | (_| | | |_  | | | (_) | | | | |
 *         \/      \__,_| |_|    |_|  \__,_| |_.__/  |_|  \___|   |_____/   \___|  \___| |_|  \__,_| |_|     \__,_|  \__| |_|  \___/  |_| |_|
 *                                                                                                                                           
 *                                                                                                                                           
 */



// Trainer Memory for pages & options. Only works backwards.
var memoryTree = {};    // Holds the memory for every menu in the trainer
var currentMemory = {}; // Holds the memory for the current menu
var counter;            // Current Trainer Option
var maxamount;          // Max Amount of Options for Current Menu
var currentpage;        // Current Page Number
var content;            // Current Menu Content (Shown Menu Information)
var container;          // Trainer Container Div
var speedContainer;     // Speedometer Container Div
var speedText;          // Speedometer Text Div
var voiceContainer;     // Voice Menu Container Div
var voicePlayers;       // Container Div for Talking Players
var menus = {};         // Holds detached HTML elements of each menu (each div)
var menuLoaded = [];    // Dynamic Menu IDs are added/removed from here to prevent excess server requests
var dynamicIDs = {};    // Key:Value pair of action:menu created by JS
var dynamicMenus = {};  // Holds the original version of all dynamicMenus.



// Text/html variable templates
var trainerOption = "<p class='traineroption'></p>";    // Default traineroption p tag



// Variable to add to the `data-sub` attr to ensure you get the correct menu
var variablesToAdd = {"wheeltype":0,"wheelindex":0};




/***
 *      _____           _   _       _______                  _                       
 *     |_   _|         (_) | |     |__   __|                (_)                      
 *       | |    _ __    _  | |_       | |     _ __    __ _   _   _ __     ___   _ __ 
 *       | |   | '_ \  | | | __|      | |    | '__|  / _` | | | | '_ \   / _ \ | '__|
 *      _| |_  | | | | | | | |_       | |    | |    | (_| | | | | | | | |  __/ | |   
 *     |_____| |_| |_| |_|  \__|      |_|    |_|     \__,_| |_| |_| |_|  \___| |_|   
 *                                                                                   
 *                                                                                   
 */


// Called as soon as the page is ready
$(function() {
    // Update container variable for use throughout project.
    container = $("#trainercontainer");

    /** Containers for Speedometer **/
    speedContainer = $("#speedcontainer");
    speedText = $(".speedtext");


    /** Container for the voice menu **/
    voiceContainer = $("#voicecontainer")
    voicePlayers = $("#voiceActive")

    // Initialize the trainer (Retrieve JSON)
    GetMelloTrainerJSON(init)
    

    // Listen for messages from lua.
    window.addEventListener("message", function(event) {
        var item = event.data;
        
        /***
         *      _   _                _                _    _               
         *     | \ | |              (_)              | |  (_)              
         *     |  \| |  __ _ __   __ _   __ _   __ _ | |_  _   ___   _ __  
         *     | . ` | / _` |\ \ / /| | / _` | / _` || __|| | / _ \ | '_ \ 
         *     | |\  || (_| | \ V / | || (_| || (_| || |_ | || (_) || | | |
         *     |_| \_| \__,_|  \_/  |_| \__, | \__,_| \__||_| \___/ |_| |_|
         *                               __/ |                             
         *                              |___/                              
         */

        //showtrainer
        if (item.showtrainer) {
            resetTrainer();            
            container.show();
            playSound("YES");
        }

        // Hide Trainer
        if (item.resettrainer) {
            resetTrainer()
            container.hide();
            playSound("NO");
        }

        // Hide Trainer
        if (item.hidetrainer) {
            container.hide();
            playSound("NO");
        }
        
        // Select Options
        if (item.trainerenter) {
            handleSelectedOption(false);
        }

        // Previous Menu
        if (item.trainerback) {
            trainerBack();
        }
        
        // Up Option
        if (item.trainerup) {
            trainerUp();
        } 

        // Down Option
        if (item.trainerdown) {
            trainerDown();
        }
        
        // Previous Page
        if (item.trainerleft) {
            trainerPrevPage();
        } 

        // Next Page
        if (item.trainerright) {
            trainerNextPage();
        }

        // Flip the toggle back if there was an error executing.
        if (item.toggleerror){
            toggleError();
        }

        // If they passed the security check access the menu and skip the check
        if (item.vehicleaccess || item.adminaccess || item.customprivilegecheck){
            handleSelectedOption(true);
        }

        // Update Speedometer Speed
        if (item.showspeed) {
            speedContainer.fadeIn();
            speedText.text(item.speed.toString().split(".")[0]);
        } 

        // Hide Speedometer
        if (item.hidespeed) {
           speedContainer.fadeOut();
        }

        if(item.hidevoice){
            voiceContainer.fadeOut()
            
        }

        if(item.showvoice){
            voiceContainer.fadeIn()
            var results = JSON.parse(item.talkingplayers)
            updateVoices(results);
        }

        if(item.statetoggles){
            var results = JSON.parse(item.statesdata)
            updateStateToggles(results,item.menuid)
        }


        /***
         *      __  __                             ____            _     _                       
         *     |  \/  |                           / __ \          | |   (_)                      
         *     | \  / |   ___   _ __    _   _    | |  | |  _ __   | |_   _    ___    _ __    ___ 
         *     | |\/| |  / _ \ | '_ \  | | | |   | |  | | | '_ \  | __| | |  / _ \  | '_ \  / __|
         *     | |  | | |  __/ | | | | | |_| |   | |__| | | |_) | | |_  | | | (_) | | | | | \__ \
         *     |_|  |_|  \___| |_| |_|  \__,_|    \____/  | .__/   \__| |_|  \___/  |_| |_| |___/
         *                                                | |                                    
         *                                                |_|                                    
         */

        // Create a menu with JSON Data from the server.  // Dynamic Menus
        if (item.createmenu){
            var newObject = JSON.parse(item.menudata);
            menuLoaded.push(item.menuName);
            createDynamicMenu(newObject,item.menuName);
            
            // Remove from loaded menu array to always recreate the menu
            if(item.autorefreshmenu){
                menuLoaded.splice(menuLoaded.indexOf(item.menuName), 1);
            }
        }

        // Used to update the wheel categories for vehicles.
        if (item.updateVariables){
            var newObject = JSON.parse(item.data);
            variablesToAdd['wheeltype'] = Number(newObject.wheeltype);
            variablesToAdd['wheelindex'] = Number(newObject.wheelindex);
        }

        // Resets the required dynamic menus so they refresh on next request.
        if (item.resetmenus){
            var items = item.resetmenus.split(" ");
            for(var i=0;i < items.length; i++){
                menuLoaded.splice(menuLoaded.indexOf(items[i]), 1);
            }
        }


        // Reshow Current Menu
        if(item.reshowmenu){

            // If Current menu is a Dynamic Menu then request updated information.
            var text = $(content.menu).attr("data-dynamicmenu");
            if(text){
                //sendData("debug","Reshowing Menu: "+text)
                menuLoaded.splice(menuLoaded.indexOf(text), 1);

                // Trigger NUI Callback for this menu
                sendData(text);
                return;
            }

            showMenu(menus[$(content.menu).attr("id")],false)
        }


        // Remove Selected Class from element.
        if(item.removeSelectedClass){
            $(".traineroption").eq(counter).removeClass("selected");
        }

    });
});



/***
 *       _____                           ______                          _     _                       
 *      / ____|                         |  ____|                        | |   (_)                      
 *     | |        ___    _ __    ___    | |__     _   _   _ __     ___  | |_   _    ___    _ __    ___ 
 *     | |       / _ \  | '__|  / _ \   |  __|   | | | | | '_ \   / __| | __| | |  / _ \  | '_ \  / __|
 *     | |____  | (_) | | |    |  __/   | |      | |_| | | | | | | (__  | |_  | | | (_) | | | | | \__ \
 *      \_____|  \___/  |_|     \___|   |_|       \__,_| |_| |_|  \___|  \__| |_|  \___/  |_| |_| |___/
 *                                                                                                     
 *                                                                                                     
 */


// Send data to lua for processing.
function sendData(name, data) {
    $.post("http://" + resourcename + "/" + name, JSON.stringify(data), function(datab) {
        if (datab != "ok"){
            console.log(datab);
        }            
    });
}


// Used to play a specific sound to the player.
function playSound(sound) {
    sendData("playsound", {name: sound});
}




// Create the Trainer.
function init() {
    // Create all Necessary Static Menus before splitting the HTML into "Menus"
    createStaticMenus();

    // Add the Menu and State Classes to all necessary elements.
    updateMenuClasses();
    updateStateClasses();

    // TODO: Apply user settings via state syncing


    // Find all elements that should be turned into menus.
    convertToMenus();


    // Update all state toggles to correct values.
    requestAllStates();
}

/***
 *      _______                  _                           _    _   _     _   _   _   _     _              
 *     |__   __|                (_)                         | |  | | | |   (_) | | (_) | |   (_)             
 *        | |     _ __    __ _   _   _ __     ___   _ __    | |  | | | |_   _  | |  _  | |_   _    ___   ___ 
 *        | |    | '__|  / _` | | | | '_ \   / _ \ | '__|   | |  | | | __| | | | | | | | __| | |  / _ \ / __|
 *        | |    | |    | (_| | | | | | | | |  __/ | |      | |__| | | |_  | | | | | | | |_  | | |  __/ \__ \
 *        |_|    |_|     \__,_| |_| |_| |_|  \___| |_|       \____/   \__| |_| |_| |_|  \__| |_|  \___| |___/
 *                                                                                                           
 *                                                                                                           
 */


// Adds the menuText class to any option that links to a menu.
function updateMenuClasses(){
    $(".traineroption").each(function(i, obj){
        if( $(this).attr('data-sub') ){
            if(!$(this).hasClass("menuText")){
                $(this).addClass("menuText");
            }
        }
    });
}


// Updates the class of toggle options based on the state of the toggle.
function updateStateClasses(){
    $(".traineroption").each(function(i, obj){
        if( $(this).attr('data-state') ){
            if ($(this).data("state") == "ON") {
                $(this).removeClass("stateOFF");
                if (!$(this).hasClass("stateON")){
                    $(this).addClass("stateON");
                }
            } else {
                $(this).removeClass("stateON");
                if (!$(this).hasClass("stateOFF")){
                    $(this).addClass("stateOFF");
                }
            }
        }
    });
}


// Toggle error, revert state of a toggle to previous value.
function toggleError(){
    var item = $(".traineroption.selected");

    if (item.attr("data-state") == "ON") {
        item.attr("data-state", "OFF");
        item.removeClass("stateON");
        item.addClass("stateOFF");
    } else if (item.attr("data-state") == "OFF") {
        item.attr("data-state", "ON");
        item.removeClass("stateOFF");
        item.addClass("stateON");
    }
}



// Toggle error, revert state of a toggle to previous value.
function toggleErrorIndex(){
    var item = $(".traineroption.selected");

    if (item.attr("data-state") == "ON") {
        item.attr("data-state", "OFF");
        item.removeClass("stateON");
        item.addClass("stateOFF");
    } else if (item.attr("data-state") == "OFF") {
        item.attr("data-state", "ON");
        item.removeClass("stateOFF");
        item.addClass("stateON");
    }
}


// Reset the trainer by showing the main menu.
function resetTrainer() {
    showMenu(menus["mainmenu"], true);

    // Reset trainer memory
    // memoryTree = {};
    // currentMemory = {};
}


// Does page Exist
function pageExists(page) {
    return content.pages[page] != null;
}



/***
 *      _______                  _                           _   _                   _                   _     _                 
 *     |__   __|                (_)                         | \ | |                 (_)                 | |   (_)                
 *        | |     _ __    __ _   _   _ __     ___   _ __    |  \| |   __ _  __   __  _    __ _    __ _  | |_   _    ___    _ __  
 *        | |    | '__|  / _` | | | | '_ \   / _ \ | '__|   | . ` |  / _` | \ \ / / | |  / _` |  / _` | | __| | |  / _ \  | '_ \ 
 *        | |    | |    | (_| | | | | | | | |  __/ | |      | |\  | | (_| |  \ V /  | | | (_| | | (_| | | |_  | | | (_) | | | | |
 *        |_|    |_|     \__,_| |_| |_| |_|  \___| |_|      |_| \_|  \__,_|   \_/   |_|  \__, |  \__,_|  \__| |_|  \___/  |_| |_|
 *                                                                                        __/ |                                  
 *                                                                                       |___/                                   
 */



// Move Up
function trainerUp() {
    $(".traineroption").eq(counter).removeClass("selected");
    
    if (counter > 0) {
        counter -= 1;
    } else {
        counter = maxamount;
    }

    $(".traineroption").eq(counter).addClass("selected");

    checkHoverAction($(".traineroption").eq(counter));

    playSound("NAV_UP_DOWN");
}


// Move Down
function trainerDown() {
    $(".traineroption").eq(counter).removeClass("selected");
    
    if (counter < maxamount) {
        counter += 1;
    } else {
        counter = 0;
    }
    
    $(".traineroption").eq(counter).addClass("selected");

    checkHoverAction($(".traineroption").eq(counter));   
    
    playSound("NAV_UP_DOWN");
}


// Previous Page
function trainerPrevPage() {
    var newpage;
    if (pageExists(currentpage - 1)) {
        newpage = currentpage - 1;
    } else {
        newpage = content.maxpages;
    }
    
    showPage(newpage);
    resetSelected();
    playSound("NAV_UP_DOWN");
}


// Next Page
function trainerNextPage() {
    var newpage;
    if (pageExists(currentpage + 1)) {
        newpage = currentpage + 1;
    } else {
        newpage = 0;
    }
    
    showPage(newpage);
    resetSelected();
    playSound("NAV_UP_DOWN");
}


// Back Menu
function trainerBack() {
    // If at the "mainmenu" div then we will hide the trainer.
    if (content.menu == menus["mainmenu"].menu) {
        container.hide();
        sendData("trainerclose", {});
    } else {
        showBackMenu(menus[content.menu.attr("data-parent")]);
    }
    
    playSound("BACK");
}


// Checks for hover functionality, used when changing elements.
function checkHoverAction(element){
    if (element.data('hover')){
        var data = element.data("hover").split(" ");

        // If the parent has sharedinfo we need to add this to our hover.
        if(element.parent().attr("data-sharedinfo")){
            data = (element.data("hover") + " "+ element.parent().attr("data-sharedinfo"));
            data = data.split(" ");
            //sendData("debug",data.join(" "));
        }
        sendData(data[0], {action: data[1], newstate: true, data: data});
        //sendData("debug","Hover Action: "+data.join(" "));
    }
}


// Select Option
function handleSelectedOption(requireSkip) {
    var item = $(".traineroption").eq(counter);
    var dataArray = Object.keys(item.data());   // Get all the data options on the element

    // Change to sub menu
    if(dataArray.indexOf("sub") > -1){
        var targetID = item.data("sub");

        //sendData("debug","changing to: "+targetID)

        // Does this sub menu require anything?
        if(dataArray.indexOf("require") > -1 && requireSkip != true){
            var requireString = "require"+item.data("require");
            sendData(requireString, {});
            playSound("SELECT");
            return;
        }

        // Does Sub Menu require a variable?
        if(dataArray.indexOf("dynamicsub") > -1){
            targetID = targetID + variablesToAdd[item.data("dynamicsub")];
        }


        // Menu to Show
        var submenu = menus[targetID];

        // If Submenu is a Dynamic Menu then request information.
        if(submenu.menu.attr("data-dynamicmenu")){
            // Get NUI Callback for this menu
            var text = submenu.menu.attr("data-dynamicmenu");

            // If the Menu needs to be loaded.
            if(menuLoaded.indexOf(text) == -1){
                sendData(text);
                playSound("SELECT");
                return;
            }
        }

        // Share information with submenu?
        if(dataArray.indexOf("share") > -1){
            var shareinfo = item.data("share") || "";
            var shareID = item.data("shareid") || item.parent().attr("id");

            //sendData("debug","shareinfo: "+shareinfo+" shareID:" + shareID);

            submenu.menu.attr("data-sharedinfo",shareinfo);
            submenu.menu.attr("data-parent",shareID);

            //sendData("debug",submenu.menu.attr("data-parent"));

            // Update the main reference of this menu with updated submenu.
            menus[targetID] = submenu ;           
        }


        // Show new menu
        showMenu(submenu, false);


    }

    // Action to take
    if(dataArray.indexOf("action") > -1){
        var newstate = true;     // Default the state to True

        // Does this sub menu require anything?
        if(dataArray.indexOf("require") > -1 && requireSkip != true){
            var requireString = "require"+item.data("require");
            sendData(requireString, {});
            playSound("SELECT");
            return;
        }

        if (dataArray.indexOf("state") > -1) {
            // .attr() because .data() gives original values

            if (item.attr("data-state") == "ON") {
                newstate = false;
                item.attr("data-state", "OFF");
                item.removeClass("stateON");
                item.addClass("stateOFF");
            } else if (item.attr("data-state") == "OFF") {
                item.attr("data-state", "ON");
                item.removeClass("stateOFF");
                item.addClass("stateON");
            }
        }


        
        var data = item.data("action").split(" ");

        // If the parent has sharedinfo we need to add this to our action.
        if(item.parent().attr("data-sharedinfo")){
            data = (item.data("action") + " "+ item.parent().attr("data-sharedinfo"));
            data = data.split(" ");
            //sendData("debug",data.join(" "));
        }

        sendData(data[0], {action: data[1], newstate: newstate, data: data});
        //sendData("debug",data.join(" "));
    }
    if(!requireSkip){
        playSound("SELECT");
    }

    requestStateToggles(item.parent().attr("id"))
}




// Updated all state toggles
function requestStateToggles(menuID){
    // Menu should be the parent element. Loop over all children element looking for data-toggle
    // data-state is required for data-toggle
    var menu = menus[menuID]
    var values = {};
    var children = menu.pages;

    for(var page=0;page<children.length;page++){
        for (var i = 0; i < children[page].length; i++) {
            var value = children[page][i].attr("data-toggle")
            if(value){
                values[value] = true
                //sendData("debug","Adding "+value+" to the list to check.")
            }
        }
    }
    //sendData("debug","Requsting state toggles for: "+menuID)

    sendData("statetoggles", {menuid: menuID, data: values})
}


/// Update the requested state toggles
function updateStateToggles(results,menuID){
    //sendData("debug","update state toggles")

    var menuObj = menus[menuID]
    var menu = menuObj.menu;
    var children = menuObj.pages;

    var objectKeys = Object.keys(results);

    for(var page=0;page<children.length;page++){
        for(var i=0;i<children[page].length;i++){
            var value = children[page][i].attr("data-toggle")
            if(value){
                if(objectKeys.indexOf(value) > -1){
                    children[page][i].attr("data-state",results[value])
                    //sendData("debug","found toggle: "+value+" with the value of: "+results[value])

                    children[page][i].removeClass("stateON");
                    children[page][i].removeClass("stateOFF");

                    // Update their state class
                    if (results[value] == "ON") {
                        children[page][i].addClass("stateON");
                    } else if (results[value] == "OFF") {
                        children[page][i].addClass("stateOFF");
                    }

                }
            }
        }
    }

    var data = {}
     data.menu = menu
     data.pages = children
     data.maxpages = menuObj.maxpages

    menus[menuID] = data
}


// Used to show a specific page of the current menu.
function showPage(page) {
    // Remove all previous page options from the page
    if (currentpage != null) {
        content.menu.children().detach();
    }
    
    // Update to new page information
    currentpage = page;
    
    // Add page options to the menu
    for (var i = 0; i < content.pages[currentpage].length; ++i) {
        content.menu.append(content.pages[currentpage][i]);
    }
    
    // Update the page indicator
    if (content.maxpages > 0) {
        $("#pageindicator").text("Page " + (currentpage + 1) + " / " + (content.maxpages + 1));
    } else {
        $("#pageindicator").text("");
    }
}


// select specific option of the page. doesn't submit data
function selectOption(opt) {
    $(".traineroption").removeClass("selected");
    
    counter = opt;
    maxamount = $(".traineroption").length - 1;
    $(".traineroption").eq(opt).addClass('selected');
}


// Reset the selector to top of page.
function resetSelected() {
    $(".traineroption").removeClass("selected");
    
    counter = 0;
    maxamount = $(".traineroption").length - 1;

    $(".traineroption").eq(0).addClass('selected');

    checkHoverAction($(".traineroption.selected"))   ; 
}


// Grabs Memory Tree for new Menu and updates old one.
function MemoryTreeHandler(menu){
    // Update old Menu
    if (content != null) {
        // Update memory Tree
        var ID = $(content.menu).attr("id");
        memoryTree[ID] = {"page":currentpage,"option":counter}
    }

    // Request New Memory
    var ID = $(menu.menu).attr("id")
    currentMemory = memoryTree[ID] || {}
    return [currentMemory.page || 0, currentMemory.option || 0]
}


// used to show a menu (adds back to container);
function showMenu(menu, memoryPrevention) {
    // Retrieve Page & Option to show for menu
    var [newPage,newOption] = MemoryTreeHandler(menu)

    // Remove old menu div
    if (content != null) {
        content.menu.detach();
    }
    
    // Add new menu div
    content = menu;
    container.append(content.menu);


    showPage(newPage);
    selectOption(newOption)
    requestStateToggles($(content.menu).attr("id")); 
}


// Used to show previous menu page, with memory
function showBackMenu(menu) {
    // Retrieve Page & Option to show for menu
    var [newPage,newOption] = MemoryTreeHandler(menu)
    
    // remove old menu
    if (content != null) {
        content.menu.detach();
    }
    
    // add new menu
    content = menu;
    container.append(content.menu);
    
    // Show page with memory
    showPage(newPage);
    selectOption(newOption);
}


/***
 *      __  __                             _____                         _     _                 
 *     |  \/  |                           / ____|                       | |   (_)                
 *     | \  / |   ___   _ __    _   _    | |       _ __    ___    __ _  | |_   _    ___    _ __  
 *     | |\/| |  / _ \ | '_ \  | | | |   | |      | '__|  / _ \  / _` | | __| | |  / _ \  | '_ \ 
 *     | |  | | |  __/ | | | | | |_| |   | |____  | |    |  __/ | (_| | | |_  | | | (_) | | | | |
 *     |_|  |_|  \___| |_| |_|  \__,_|    \_____| |_|     \___|  \__,_|  \__| |_|  \___/  |_| |_|
 *                                                                                               
 *                                                                                               
 */


// Find any divs and create a menu page out of them.
function refreshMenus(){
    updateMenuClasses();
    updateStateClasses();
    convertToMenus();
}


function requestAllStates(){
    var keys = Object.keys(menus);
    for (var i = 0; i < keys.length; i++) {
        var menuID = keys[i]
        requestStateToggles(menuID)
    }
}


// Convert any divs on the page to a detached menu
function convertToMenus(){
    $("div").each(function(i, obj) {
        // Skip Container elements.
        if ($(this).attr("data-container") == undefined){

            // Create the current menu page.
            var data = {};
            data.menu = $(this).detach();
            data.pages = [];

            // Move all child elements to the pages array.
            $(this).children().each(function(i, obj) {
                
                // TODO: Add better state syncing

                if ($(this).data("state") == "ON") {
                    var statedata = $(this).data("action").split(" ");
                    sendData(statedata[0], {action: statedata[1], newstate: true, data: {}});
                }
                
                var page = Math.floor(i / maxVisibleItems);
                if (data.pages[page] == null) {
                    data.pages[page] = [];
                }
                
                data.pages[page].push($(this).detach());
                data.maxpages = page;
            });
            
            // Add data to the menu.
            menus[$(this).attr("id")] = data;


            // If this menu is dynamic then save the original versions
            if($(this).attr("data-dynamicmenu")){
                if(!dynamicIDs[$(this).attr("data-dynamicmenu")]){
                    dynamicIDs[$(this).attr("data-dynamicmenu")] = $(this).attr("id");
                    dynamicMenus[$(this).attr("id")] = data
                }
            }
        }
    });
}



// Add Ammo Elements to the top of the menu
function appendAmmoEles(containerDiv){
    // Max Ammo
    var maxEle = $(trainerOption);
    maxEle.text("Max Ammo");
    maxEle.attr("data-action","weapon ammo max");
    maxEle.attr("data-hover","weapon holdweapon");
    containerDiv.prepend(maxEle);
     // Add Clip
    var clipEle = $(trainerOption);
    clipEle.text("Add Clip");
    clipEle.attr("data-action","weapon ammo add");
    clipEle.attr("data-hover","weapon holdweapon");
    containerDiv.prepend(clipEle);

    return containerDiv;
}


// Add Weapon Spawn Element to top of the menu
function appendWeaponSpawnEle(containerDiv,menuName){
    // Spawn Weapon
    var spawnEle = $(trainerOption);
    spawnEle.text(menuName);
    spawnEle.attr("data-action","weapon spawn");
    spawnEle.attr("data-hover","weapon holdweapon");
    spawnEle.attr("data-state","OFF")
    containerDiv.prepend(spawnEle);

    return containerDiv;
}


// Add the tintable menu element to the container
function addWeaponTintMenu(containerDiv,spawnName,idName){
    // Add to end of container.
    var newEle = $(trainerOption);
    newEle.text("Weapon Tints");
    newEle.attr("data-sub","weapontintsmenu");
    newEle.attr("data-share",spawnName);
    newEle.attr("data-shareid",idName);
    containerDiv.append(newEle);

    return containerDiv;
}



// Adds new attributes for the specified element. Recursive call to handle linking to sub-menu
function addNewTrainerOptions(newEle,currentObject,curIndex,idName,defaultAction){
    var subSeparator = "_"
    // defaultAction is used for static menus
    //sendData("debug",curIndex+" "+idName+" "+defaultAction+" : curIndex idName defaultAction")
    if(!defaultAction){
        defaultAction = "";
    }

    // Add all necessary attributes to the element.
    for(var objectKey in currentObject){
        var curValue = currentObject[objectKey];

        switch(objectKey){
            // Add all data attributes
            case "data":
                for(var dataKey in curValue){
                    var curDataValue = curValue[dataKey];

                    // Ensure unique IDs by using parent ID as starting point.
                    if(dataKey == "sub" || dataKey == "shareid"){
                        curDataValue = idName+subSeparator+curDataValue;
                        //sendData("debug","data-"+dataKey+" "+curDataValue)
                    }

                    if(dataKey == "action" || dataKey == "hover"){
                        if(defaultAction){
                            curDataValue = defaultAction+" "+curDataValue
                        } else {
                            curDataValue = curDataValue
                        }
                    }

                    newEle.attr("data-"+dataKey,curDataValue);
                }

                // Share weaponName with weapon sub menu option
                if(Object.keys(currentObject).indexOf("weapon") > -1){
                    newEle.attr("data-share",currentObject['weaponName'])
                }
                break;

            // Add submenu (accompanies by data-sub)
            case "submenu":
                var newID = idName+subSeparator+currentObject["data"]["sub"];

                //sendData("debug","creating submenu: "+newID)

                //Create Submenu Container Div
                var containerDiv = $("<div></div>");
                containerDiv.attr("id", newID);
                containerDiv.attr("data-parent",idName);


                // Loop over each subMenu and create the menu
                for(var subMenuI=0;subMenuI<curValue.length;subMenuI++){
                    var subObject = curValue[subMenuI];
                    var newSubEle = $(trainerOption);

                    newSubEle = addNewTrainerOptions(newSubEle,subObject,subMenuI,newID,defaultAction);
                    containerDiv.append(newSubEle);
                }


                // Add Weapon Spawn Option to trainer
                if(Object.keys(currentObject).indexOf("weapon") > -1){
                    var weaponName = currentObject["weaponName"];

                    // Add Ammo Options to trainer
                    if(Object.keys(currentObject).indexOf("ammo") > -1){
                        containerDiv = appendAmmoEles(containerDiv);
                    }

                    // Add trainer option to actually spawn weapon
                    containerDiv = appendWeaponSpawnEle(containerDiv,currentObject['menuName']);
                    

                    // Add Tintable Weapon Menu if weapon is tintable
                    if(tintable_weapons.indexOf(weaponName) > -1){
                        containerDiv = addWeaponTintMenu(containerDiv,weaponName,newID);
                    }
                }

                //sendData("debug","Appending containerDiv: "+containerDiv.attr("id"))
                container.append(containerDiv);
                break;

            // Option Name for the trainer
            case "menuName":
                newEle.text(curValue);
                break

            default:
                ;//console.log("Nothinhg")
        }
    }
    return newEle
}


// Create static menus
function createStaticMenus(){
    $("div").each(function(i,obj){
        if( $(this).attr("data-staticmenu")){

            // Grab data from JSON.
            var requestKey = $(this).attr("data-staticmenu");
            var requestedObj = requestObjects[requestKey];
            var requestedAction = requestAction[requestKey];
            var objectLength = requestedObj.length;

            //sendData("debug","Creating Static Menu... "+requestKey)

            // Loop over requestedObj and add each new option
            for(var index=0; index < objectLength; index++){
                var curObj = requestedObj[index];

                var newEle = $(trainerOption);
                
                // Add any necessary options for the static JSON
                newEle = addNewTrainerOptions(newEle,curObj,index,$(this).attr("id"),requestedAction);

                // Add new option to container div
                $(this).append(newEle);               
            }
        }
    });
}



// Create a Dynamic Menu
function createDynamicMenu(menuArray,name){
    // Remove old menu div to prevent losing pages
    if (content != null) {
        content.menu.detach();
    }

    // Get necesarry information and recreate original menu
    // sendData("debug", "creating dynamic menu")
    var idName = dynamicIDs[name];
    var data = jQuery.extend(true, {}, dynamicMenus[idName]);
    var choiceMenu = data.menu;
    var pages = jQuery.extend(true, [], data.pages)

    // Remove any children element to ensure blank page.
    choiceMenu.children().detach();

    // Readd menu to page.
    for (var i = 0; i < pages.length; i++) {
        for (var index = 0; index < pages[i].length; index++) {
            choiceMenu.append(pages[i][index])
        }
    }


    // If nothing to add and no placeholder elements add element
    if(menuArray.length == 0 && pages.length == 0){
        var noEle = $(trainerOption).text("Nothing to show.");
        choiceMenu.append(noEle);
    }


    // Add each option to the menu.
    for (var curIndex = 0; curIndex < menuArray.length; curIndex++){
        var currentObject = menuArray[curIndex];

        // Create the option to select the Feature.
        var newEle = $(trainerOption);
        newEle.text(currentObject['menuName'])

        // Adds options for menu option including submenus (recursive calls)
        newEle = addNewTrainerOptions(newEle,currentObject,curIndex,idName);

        // Add new option to menu
        choiceMenu.prepend(newEle);
    }
    container.append(choiceMenu);



    // Add all new menus to the menus object.
    refreshMenus();

    // Show the requested menu.
    showMenu(menus[idName], false);
    //sendData("debug","Created Menu");

}

/***
 *      _______                  _                           ______                  _                               
 *     |__   __|                (_)                         |  ____|                | |                              
 *        | |     _ __    __ _   _   _ __     ___   _ __    | |__      ___    __ _  | |_   _   _   _ __    ___   ___ 
 *        | |    | '__|  / _` | | | | '_ \   / _ \ | '__|   |  __|    / _ \  / _` | | __| | | | | | '__|  / _ \ / __|
 *        | |    | |    | (_| | | | | | | | |  __/ | |      | |      |  __/ | (_| | | |_  | |_| | | |    |  __/ \__ \
 *        |_|    |_|     \__,_| |_| |_| |_|  \___| |_|      |_|       \___|  \__,_|  \__|  \__,_| |_|     \___| |___/
 *                                                                                                                   
 *                                                                                                                   
 */


// Update voice div with active talking players
function updateVoices(custArray){
    // sendData("debug","updatedVoices")

    // Remove all players to be readded.
    voicePlayers.children().remove()

    // Readd all player voices
    for(var i=0;i<custArray.length;i++){
        var newEle = $("<p class='voicename'></p>");
        newEle.text(custArray[i]);
        voicePlayers.append(newEle);
    }

    // sendData("debug","done")
}


/***
 *       _____   _______              _______   _____    _____          _    _____    ____    _   _   
 *      / ____| |__   __|     /\     |__   __| |_   _|  / ____|        | |  / ____|  / __ \  | \ | |  
 *     | (___      | |       /  \       | |      | |   | |             | | | (___   | |  | | |  \| |  
 *      \___ \     | |      / /\ \      | |      | |   | |         _   | |  \___ \  | |  | | | . ` |  
 *      ____) |    | |     / ____ \     | |     _| |_  | |____    | |__| |  ____) | | |__| | | |\  |  
 *     |_____/     |_|    /_/    \_\    |_|    |_____|  \_____|    \____/  |_____/   \____/  |_| \_|  
 *                                                                                                    
 *                                                                                                    
 */


// Used to determine which weapon menus should get the tintable menu added.
var tintable_weapons = ["WEAPON_STINGER", "WEAPON_MARKSMANPISTOL", "WEAPON_COMBATPDW", "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_STUNGUN", "WEAPON_FLAREGUN", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_GUSENBERG", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_MARKSMANRIFLE", "WEAPON_GRENADELAUNCHER", "WEAPON_RPG", "WEAPON_MINIGUN", "WEAPON_FIREWORK", "WEAPON_RAILGUN", "WEAPON_HOMINGLAUNCHER", "WEAPON_MACHINEPISTOL", "WEAPON_DBSHOTGUN", "WEAPON_COMPACTRIFLE", "WEAPON_MINISMG", "WEAPON_AUTOSHOTGUN", "WEAPON_COMPACTLAUNCHER","WEAPON_MINISMG", "WEAPON_AUTOSHOTGUN", "WEAPON_COMPACTLAUNCHER", "WEAPON_PISTOL_MK2", "WEAPON_SMG_MK2", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE_MK2", "WEAPON_COMBATMG_MK2", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_REVOLVER_MK2"];

/***
 *           _    _____    ____    _   _    __      __                 _           _       _              
 *          | |  / ____|  / __ \  | \ | |   \ \    / /                (_)         | |     | |             
 *          | | | (___   | |  | | |  \| |    \ \  / /    __ _   _ __   _    __ _  | |__   | |   ___   ___ 
 *      _   | |  \___ \  | |  | | | . ` |     \ \/ /    / _` | | '__| | |  / _` | | '_ \  | |  / _ \ / __|
 *     | |__| |  ____) | | |__| | | |\  |      \  /    | (_| | | |    | | | (_| | | |_) | | | |  __/ \__ \
 *      \____/  |_____/   \____/  |_| \_|       \/      \__,_| |_|    |_|  \__,_| |_.__/  |_|  \___| |___/
 *                                                                                                        
 *                                                                                                        
 */
// Container for JSON File.
var MelloTrainerJSON;

// Container for the request names
var requestObjects;

// Request JSON from File
function GetMelloTrainerJSON(next){
    $.ajax({
        method: "GET",
        url: "mellotrainer.json", 
        dataType: "json",
        success: function(data){
            // Update the JSON Variable
            MelloTrainerJSON = data;
            // Create the HTML Reference Object
            updateRequestObject()

            next();
        }
    });
}

// Static Request Actions
var requestAction = {
    "player_skins_characters" : "playerskin",
    "player_skins_animals" :  "playerskin",
    "player_skins_npcs" :  "playerskin",
    "vehicle_cars_supercars" : "vehspawn",
    "vehicle_cars_sports" :  "vehspawn",
    "vehicle_cars_sportsclassics" :  "vehspawn",
    "vehicle_cars_muscle" :  "vehspawn",
    "vehicle_cars_lowriders" :  "vehspawn",
    "vehicle_cars_coupes" :  "vehspawn",
    "vehicle_cars_sedans" :  "vehspawn",
    "vehicle_cars_compacts" :  "vehspawn",
    "vehicle_cars_suvs" :  "vehspawn",
    "vehicle_cars_offroad" :  "vehspawn",
    "vehicle_cars_vip" :  "vehspawn",
    "vehicle_industrial_pickups" :  "vehspawn",
    "vehicle_industrial_vans" :  "vehspawn",
    "vehicle_industrial_trucks" :  "vehspawn",
    "vehicle_industrial_service" :  "vehspawn",
    "vehicle_industrial_trailers" :  "vehspawn",
    "vehicle_industrial_trains" :  "vehspawn",
    "vehicle_emergency" :  "vehspawn",
    "vehicle_motorcycles" :  "vehspawn",
    "vehicle_planes" :  "vehspawn",
    "vehicle_helicopters" :  "vehspawn",
    "vehicle_boats" :  "vehspawn",
    "vehicle_bicycles" :  "vehspawn",
    "weapon_melee" : "weapon mod",
    "weapon_handguns" : "weapon mod",
    "weapon_submachine" : "weapon mod",
    "weapon_assault" : "weapon mod",
    "weapon_shotgun" : "weapon mod",
    "weapon_snipers" : "weapon mod",
    "weapon_heavy" : "weapon mod",
    "weapon_thrown" : "weapon mod",


    "vehicle_mod_paint_primary_normal": "vehmod paint",
    "vehicle_mod_paint_secondary_normal": "vehmod paint2",
    "vehicle_mod_paint_both_normal": "vehmod paint3",
    "vehicle_mod_paint_primary_metal": "vehmod paint",
    "vehicle_mod_paint_secondary_metal": "vehmod paint2",
    "vehicle_mod_paint_both_metal": "vehmod paint3",
    "vehicle_mod_paint_primary_matte": "vehmod paint",
    "vehicle_mod_paint_secondary_matte": "vehmod paint2",
    "vehicle_mod_paint_both_matte": "vehmod paint3",
    "vehicle_mod_paint_primary_metallic": "vehmod paint",
    "vehicle_mod_paint_secondary_metallic": "vehmod paint2",
    "vehicle_mod_paint_both_metallic": "vehmod paint3",
    "vehicle_mod_paint_primary_chrome": "vehmod paint",
    "vehicle_mod_paint_secondary_chrome": "vehmod paint2",
    "vehicle_mod_paint_both_chrome": "vehmod paint3",
    "vehicle_mod_paint_pearl_topcoat": "vehmod paintpearl",
    "vehicle_mod_paint_wheels": "vehmod paintwheels",

    "vehicle_mod_neon_colors" : "vehmod lightcolor",
    "vehicle_mod_smoke_colors" : "vehmod smokecolor",


    "vehicle_mod_horn" : "vehmodify",
    "vehicle_wheel_0": "vehmodify",
    "vehicle_wheel_1": "vehmodify",
    "vehicle_wheel_2": "vehmodify",
    "vehicle_wheel_3": "vehmodify",
    "vehicle_wheel_4": "vehmodify",
    "vehicle_wheel_5":"vehmodify",
    "vehicle_wheel_7": "vehmodify",
    "vehicle_wheel_8": "vehmodify",
    "vehicle_wheel_front": "vehmodify",
    "vehicle_wheel_back": "vehmodify" 
};


function updateRequestObject(){
    if(MelloTrainerJSON === undefined){ return }

    // HTML Callback Quick References
    requestObjects = {
        // *
        // * Skin Categories
        // *
        "player_skins_characters" : MelloTrainerJSON["Skins"]["Player List"],
        "player_skins_animals" : MelloTrainerJSON["Skins"]["Animal List"],
        "player_skins_npcs" : MelloTrainerJSON["Skins"]["NPC List"],

        // *
        // * Vehicle Categories
        // *
        "vehicle_cars_supercars" : MelloTrainerJSON["Vehicles"]["Supercars"],
        "vehicle_cars_sports" : MelloTrainerJSON["Vehicles"]["Sports"],
        "vehicle_cars_sportsclassics" : MelloTrainerJSON["Vehicles"]["Sports Classics"],
        "vehicle_cars_muscle" : MelloTrainerJSON["Vehicles"]["Muscle"],
        "vehicle_cars_lowriders" : MelloTrainerJSON["Vehicles"]["Lowriders"],
        "vehicle_cars_coupes" : MelloTrainerJSON["Vehicles"]["Coupes"],
        "vehicle_cars_sedans" : MelloTrainerJSON["Vehicles"]["Sedans"],
        "vehicle_cars_compacts" : MelloTrainerJSON["Vehicles"]["Compacts"],
        "vehicle_cars_suvs" : MelloTrainerJSON["Vehicles"]["SUVs"],
        "vehicle_cars_offroad" : MelloTrainerJSON["Vehicles"]["Offroad"],
        "vehicle_cars_vip" : MelloTrainerJSON["Vehicles"]["VIP"],
        "vehicle_industrial_pickups" : MelloTrainerJSON["Vehicles"]["Pickups"],
        "vehicle_industrial_vans" : MelloTrainerJSON["Vehicles"]["Vans"],
        "vehicle_industrial_trucks" : MelloTrainerJSON["Vehicles"]["Trucks"],
        "vehicle_industrial_service" : MelloTrainerJSON["Vehicles"]["Service"],
        "vehicle_industrial_trailers" : MelloTrainerJSON["Vehicles"]["Trailers"],
        "vehicle_industrial_trains" : MelloTrainerJSON["Vehicles"]["Trains"],
        "vehicle_emergency" : MelloTrainerJSON["Vehicles"]["Emergency"],
        "vehicle_motorcycles" : MelloTrainerJSON["Vehicles"]["Motorcycles"],
        "vehicle_planes" : MelloTrainerJSON["Vehicles"]["Planes"],
        "vehicle_helicopters" : MelloTrainerJSON["Vehicles"]["Helicopters"],
        "vehicle_boats" : MelloTrainerJSON["Vehicles"]["Boats"],
        "vehicle_bicycles" : MelloTrainerJSON["Vehicles"]["Bicycles"],

        // *
        // * Weapon Categories
        // *
        "weapon_melee" : MelloTrainerJSON["Weapons"]["Melee"],
        "weapon_handguns" : MelloTrainerJSON["Weapons"]["Handguns"],
        "weapon_submachine" : MelloTrainerJSON["Weapons"]["Submachine"],
        "weapon_assault" : MelloTrainerJSON["Weapons"]["Assault"],
        "weapon_shotgun" : MelloTrainerJSON["Weapons"]["Shotguns"],
        "weapon_snipers" : MelloTrainerJSON["Weapons"]["Snipers"],
        "weapon_heavy" : MelloTrainerJSON["Weapons"]["Heavy"],
        "weapon_thrown" : MelloTrainerJSON["Weapons"]["Thrown"],

        // *
        // * Vehicle Paint Options
        // *
        "vehicle_mod_paint_primary_normal": MelloTrainerJSON["Vehicle Paints"]["Primary Classic"],
        "vehicle_mod_paint_secondary_normal": MelloTrainerJSON["Vehicle Paints"]["Secondary Classic"],
        "vehicle_mod_paint_primary_metal": MelloTrainerJSON["Vehicle Paints"]["Primary Metal"],
        "vehicle_mod_paint_secondary_metal": MelloTrainerJSON["Vehicle Paints"]["Secondary Metal"],
        "vehicle_mod_paint_primary_matte": MelloTrainerJSON["Vehicle Paints"]["Primary Matte"],
        "vehicle_mod_paint_secondary_matte": MelloTrainerJSON["Vehicle Paints"]["Secondary Matte"],
        "vehicle_mod_paint_primary_metallic": MelloTrainerJSON["Vehicle Paints"]["Primary Metallic"],
        "vehicle_mod_paint_secondary_metallic": MelloTrainerJSON["Vehicle Paints"]["Secondary Metallic"],
        "vehicle_mod_paint_primary_chrome": MelloTrainerJSON["Vehicle Paints"]["Primary Chrome"],
        "vehicle_mod_paint_secondary_chrome": MelloTrainerJSON["Vehicle Paints"]["Secondary Chrome"],
        "vehicle_mod_paint_wheels":  MelloTrainerJSON["Vehicle Paints"]["Wheels Colors"],
        // Own Category?
        "vehicle_mod_paint_pearl_topcoat": MelloTrainerJSON["Vehicle Paints"]["Primary Classic"],
        // Better Way to populate both? Maybe even better way to Primary/Secondary.
        "vehicle_mod_paint_both_normal" : MelloTrainerJSON["Vehicle Paints"]["Primary Classic"],
        "vehicle_mod_paint_both_metal": MelloTrainerJSON["Vehicle Paints"]["Primary Metal"],
        "vehicle_mod_paint_both_matte": MelloTrainerJSON["Vehicle Paints"]["Primary Matte"],
        "vehicle_mod_paint_both_metallic": MelloTrainerJSON["Vehicle Paints"]["Primary Metallic"],
        "vehicle_mod_paint_both_chrome": MelloTrainerJSON["Vehicle Paints"]["Primary Chrome"],

        // *
        // * Vehicle Neon/Smoke Color Options
        // *
        "vehicle_mod_neon_colors": MelloTrainerJSON["Vehicle RGBs"]["Neon Colors"],
        "vehicle_mod_smoke_colors": MelloTrainerJSON["Vehicle RGBs"]["Smoke Colors"],

        // *
        // * Vehicle Modification Options
        // *
        "vehicle_mod_horn" : MelloTrainerJSON["Vehicle Mods"]["Horns"],
        "vehicle_wheel_0": MelloTrainerJSON["Vehicle Mods"]["Wheels Sport"],
        "vehicle_wheel_1": MelloTrainerJSON["Vehicle Mods"]["Wheels Muscle"],
        "vehicle_wheel_2": MelloTrainerJSON["Vehicle Mods"]["Wheels Lowrider"],
        "vehicle_wheel_3": MelloTrainerJSON["Vehicle Mods"]["Wheels SUV"],
        "vehicle_wheel_4": MelloTrainerJSON["Vehicle Mods"]["Wheels Offroad"],
        "vehicle_wheel_5": MelloTrainerJSON["Vehicle Mods"]["Wheels Tuner"],
        "vehicle_wheel_7": MelloTrainerJSON["Vehicle Mods"]["Wheels Highend"],
        "vehicle_wheel_8": MelloTrainerJSON["Vehicle Mods"]["Wheels Benny"],
        "vehicle_wheel_front": MelloTrainerJSON["Vehicle Mods"]["Wheels Front"],
        "vehicle_wheel_back": MelloTrainerJSON["Vehicle Mods"]["Wheels Back"]
    }

}