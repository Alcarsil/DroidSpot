function love.conf( t )
	t.identity = nil
	t.author = "Alessandro Carvalho Silva 'AlephC' <alcarsil@gmail.com> "
	t.version = "11.3"
	t.console = false
	t.accelerometerjoystick = false
	t.externalstorage = true
	t.gammacorrect = false
	
	t.audio.mixwithsystem = true
	
	t.window.title = "Droid Spot"
	t.window.icon = "icon.png"
	t.window.width = 1280
	t.window.height = 720
	t.window.borderless = true
	t.window.resizable = true
	t.window.minWidth = 1
	t.window.minHeight = 1
	t.window.fullscreen = true
	t.window.fullscreentype = "desktop"
	t.window.usedpiscale = true
	t.window.vsync = 1
	t.window.msaa = 0
	t.window.display = 1
	t.window.highdpi = true
	t.window.x = nil
	t.window.y = nil
	
	t.modules.audio = true
	t.modules.event = true
	t.modules.graphics = true
	t.modules.image = true
	t.modules.joystick = true
	t.modules.keyboard = true
	t.modules.math = true
	t.modules.mouse = true
	t.modules.physics = true
	t.modules.sound = true
	t.modules.system = true
	t.modules.timer = true
	t.modules.touch = false
	t.modules.video = true
	t.modules.window = true
	t.modules.thread = true
end