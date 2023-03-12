c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.autoformatter = 'black'

c.InteractiveShellApp.extensions = [
	'autoreload'
]

c.InteractiveShellApp.exec_lines = [
	"%autoreload 3",
	"print('Warning: autoreload 3 is enabled in ipython_config.py; disable to improve performance.')"
]

