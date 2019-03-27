loadTemplate("org.kde.plasma-desktop.defaultPanel")

for (var i = 0; i < screenCount; ++i) {
    var desktop = new Activity
    desktop.name = i18n("MLED")
    folderview = desktop.addWidget("folderview");
    folderview.writeConfig("url", "desktop:/");
    desktop.screen = i
    desktop.wallpaperPlugin = 'image'
    desktop.wallpaperMode = 'SingleImage'
    var wallpaper = "Castilla_Sky"
    desktop.currentConfigGroup = new Array("Wallpaper", "image")
    desktop.writeConfig("wallpaper", wallpaper)
    desktop.writeConfig("userswallpaper", wallpaper)

    //Create more panels for other screens
    if (i > 0){
        var panel = new Panel
        panel.screen = i
        panel.location = 'bottom'
        panel.height = screenGeometry(i).height > 1024 ? 35 : 27
        var tasks = panel.addWidget("tasks")
        tasks.writeConfig("showOnlyCurrentScreen", true);
    }
}

locked = true;
