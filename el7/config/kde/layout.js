var panel = new Panel
var panelScreen = panel.screen
var freeEdges = {"bottom": true, "top": true, "left": true, "right": true}

for (i = 0; i < panelIds.length; ++i) {
    var tmpPanel = panelById(panelIds[i])
    if (tmpPanel.screen == panelScreen) {
        // Ignore the new panel
        if (tmpPanel.id != panel.id) {
            freeEdges[tmpPanel.location] = false;
        }
    }
}

if (freeEdges["bottom"] == true) {
    panel.location = "bottom";
} else if (freeEdges["top"] == true) {
    panel.location = "top";
} else if (freeEdges["left"] == true) {
    panel.location = "left";
} else if (freeEdges["right"] == true) {
    panel.location = "right";
} else {
    // There is no free edge, so leave the default value
    panel.location = "top";
}

panel.height = screenGeometry(panel.screen).height > 1024 ? 68 : 48
panel.addWidget("launcher")
var widget = panel.addWidget("icon")
widget.writeConfig("Url", "file:///usr/share/applications/kde4/dolphin.desktop")
var widget = panel.addWidget("icon")
widget.writeConfig("Url", "file:///usr/share/applications/firefox.desktop")
var widget = panel.addWidget("icon")
widget.writeConfig("Url", "file:///usr/share/applications/thunderbird.desktop")
var widget = panel.addWidget("icon")
widget.writeConfig("Url", "file:///usr/share/applications/libreoffice-startcenter.desktop")
//panel.addWidget("org.kde.showActivityManager") //
pager = panel.addWidget("pager") 
pager.writeConfig("hideWhenSingleDesktop", "true")
panel.addWidget("tasks")
panel.addWidget("systemtray")
panel.addWidget("digital-clock")
panel.addWidget("lockout")
