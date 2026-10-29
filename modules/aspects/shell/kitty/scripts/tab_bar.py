# Custom kitty tab bar:
#   - a non-interactive "pill" before the first tab showing the current session name
#   - each tab titled with the foreground process of its top-left window
#     (falls back to the active window), rendered with the stock powerline style
import os

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_tab_with_powerline,
)

# Theme palette index used for the session pill
SESSION_COLOR_INDEX = 5
SESSION_ICON = "\uf07c"  # nf-fa-folder_open

# Raw exe names (after wrapper cleanup) mapped to a friendlier label.
# Shells are collapsed to "terminal" so short-lived commands don't flicker the title.
ALIASES = {
    "vim": "nvim",
    "zsh": "terminal",
    "bash": "terminal",
    "sh": "terminal",
}

# Nerd Font icon per label; anything not listed gets DEFAULT_ICON
ICONS = {
    "nvim": "\uf36f",  # nf-linux-neovim
    "terminal": "\ue795",  # nf-dev-terminal
    "lazygit": "\ue702",  # nf-dev-git
    "yazi": "\uf07c",  # nf-fa-folder_open
    "git": "\ue702",
    "claude": "\U000f06a9",  # nf-md-robot
    "htop": "\uf0e4",  # nf-fa-tachometer
    "btop": "\uf0e4",
    "ssh": "\uf233",  # nf-fa-server
    "python3": "\ue73c",  # nf-dev-python
    "python": "\ue73c",
    "docker": "\uf308",  # nf-linux-docker
    "man": "\uf02d",  # nf-fa-book
}
DEFAULT_ICON = "\uf013"  # nf-fa-cog


def _clean_exe(exe: str) -> str:
    name = os.path.basename(exe).lstrip(".")
    if name.endswith("-wrapped"):
        name = name[: -len("-wrapped")]
    return ALIASES.get(name, name)


def _launched_exe(cmdline: list[str]) -> str | None:
    """Strip session wrappers: `kitten run-shell direnv exec . vim` -> `vim`."""
    args = list(cmdline)
    while args:
        name = os.path.basename(args[0])
        if name == "kitten" and args[1:2] == ["run-shell"]:
            args = [a for a in args[2:] if not a.startswith("-")]
        elif name == "direnv" and args[1:2] == ["exec"]:
            args = args[3:]
        else:
            return args[0]
    return None


def _process_name(tab_id: int) -> str | None:
    tab = get_boss().tab_for_id(tab_id)
    if tab is None:
        return None
    windows = [
        g.windows[-1]
        for g in tab.windows.iter_all_layoutable_groups(only_visible=True)
        if g.windows
    ]
    if windows:
        window = min(windows, key=lambda w: (w.geometry.top, w.geometry.left))
    else:
        window = tab.active_window
    if window is None:
        return None
    # Oldest PID: the highest one is a child (e.g. claude's MCP servers), not the program.
    # Launch argv as fallback: the first draw happens before the program has started.
    procs = window.child.foreground_processes
    cmdline = min(procs, key=lambda p: p["pid"])["cmdline"] if procs else window.child.argv
    exe = _launched_exe(cmdline) or window.get_exe_of_child(oldest=True)
    return _clean_exe(exe)


def _draw_session_pill(draw_data: DrawData, screen: Screen, name: str) -> None:
    saved_fg, saved_bg = screen.cursor.fg, screen.cursor.bg
    pill_bg = as_rgb(get_options().color_table[SESSION_COLOR_INDEX])
    default_bg = as_rgb(int(draw_data.default_bg))

    screen.cursor.bg = pill_bg
    screen.cursor.fg = default_bg
    screen.cursor.bold = True
    screen.draw(f" {SESSION_ICON} {name} ")
    screen.cursor.bold = False
    screen.cursor.fg = pill_bg
    screen.cursor.bg = saved_bg
    screen.draw("\ue0b4")

    screen.cursor.fg, screen.cursor.bg = saved_fg, saved_bg
    screen.draw(" ")


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if index == 1 and screen.cursor.x == 0:
        session = tab.session_name or tab.active_session_name
        if session:
            _draw_session_pill(draw_data, screen, session)

    if tab.tab_id >= 0:
        name = _process_name(tab.tab_id)
        if name:
            tab = tab._replace(title=f"{ICONS.get(name, DEFAULT_ICON)} {name}")

    return draw_tab_with_powerline(
        draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
    )
