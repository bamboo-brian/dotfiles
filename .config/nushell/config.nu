$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
$env.config.history.isolation = true

$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

$env.config.buffer_editor = "nvim"

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.sort = "smart"

$env.config.table.index_mode = "auto"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""

source git.nu
alias l = ls -a
alias e = nvim
