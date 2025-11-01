from qutebrowser.api import interceptor
import rosepine

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

# set the palette you'd like to use
# valid options are 'rose-pine', 'rose-pine-moon' and 'rose-pine-dawn'
# last argument (optional, default is False): enable the plain look for the menu rows
rosepine.setup(c, 'rose-pine', True)

c.auto_save.session = False  # Whether or not to restore the previous session
c.url.default_page = 'https://louie.co.nz/25th_hour/'
c.url.start_pages = ['https://louie.co.nz/25th_hour/']

c.content.blocking.method = "both"
c.content.blocking.enabled = True

c.fonts.default_size = '10pt'
c.tabs.show = 'multiple'  # Show tabs only if more than one
c.statusbar.show = 'always'

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = 'smart'

config.set('colors.webpage.darkmode.enabled', False, 'https://louie.co.nz/25th_hour/*')

c.url.searchengines = {
    'DEFAULT': 'https://www.startpage.com/?q={}',
    'g': 'https://www.google.com/search?q={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'gh': 'https://github.com/search?q={}',
    'wk': 'https://en.wikipedia.org/w/index.php?search={}',
    'aw': 'https://wiki.archlinux.org/title/{}',
}

c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
]

#======================== Keybinds =============================#

# Video download
config.bind('Yv', 'spawn --userscript video-music-downloader.sh')
config.bind('Ya', 'spawn --userscript video-music-downloader.sh --audio')

# Clear history
config.bind('Ch', 'history-clear')

# Go back to startpage
config.bind('Sp','open www.startpage.com')

# Yoinking location & maps off of whatever IP
config.bind('Xe', 'spawn --userscript iggy')

# Curtesy of Gavin Freeborn
#================== Youtube Add Blocking =======================#
def filter_yt(info: interceptor.Request):
    """Block the given request if necessary."""
    url = info.request_url
    if (
        url.host() == "www.youtube.com"
        and url.path() == "/get_video_info"
        and "&adformat=" in url.query()
    ):
        info.block()


interceptor.register(filter_yt)
