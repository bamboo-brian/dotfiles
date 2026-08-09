-- Telekinesis Neovim colorscheme
-- Place at: ~/.config/nvim/colors/telekinesis.lua
-- Then: :colorscheme telekinesis

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "telekinesis"

local c = {
  bg        = "#0A1412",
  bg_alt    = "#12302C",
  bg_float  = "#0E241F",
  fg        = "#E7FBF2",
  fg_dim    = "#6E9A90",
  selection = "#1B3E38",
  border    = "#234A42",

  black   = "#10201C",
  red     = "#E2554F",
  green   = "#B8FF29",
  yellow  = "#F0B429",
  blue    = "#4A8FA6",
  magenta = "#B0538A",
  cyan    = "#2FE0C4",
  white   = "#9FC9C0",

  bright_black   = "#2A4A42",
  bright_red     = "#FF7B7B",
  bright_green   = "#D4FF6E",
  bright_yellow  = "#FFD166",
  bright_blue    = "#6FB8D1",
  bright_magenta = "#D17FB0",
  bright_cyan    = "#6FF5DE",
  bright_white   = "#F4FFFB",

  error   = "#FF5C5C",
  warning = "#F0B429",
  info    = "#2FE0C4",
  success = "#4ADE80",
}

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl("Normal",       { fg = c.fg, bg = c.bg })
hl("NormalFloat",  { fg = c.fg, bg = c.bg_float })
hl("FloatBorder",  { fg = c.border, bg = c.bg_float })
hl("Cursor",       { fg = c.bg, bg = c.green })
hl("CursorLine",   { bg = c.bg_alt })
hl("CursorLineNr", { fg = c.green, bold = true })
hl("LineNr",       { fg = c.bright_black })
hl("SignColumn",   { bg = c.bg })
hl("ColorColumn",  { bg = c.bg_alt })
hl("Visual",       { bg = c.selection })
hl("VisualNOS",    { bg = c.selection })
hl("Search",       { fg = c.bg, bg = c.yellow })
hl("IncSearch",    { fg = c.bg, bg = c.green })
hl("Pmenu",        { fg = c.fg, bg = c.bg_alt })
hl("PmenuSel",     { fg = c.bg, bg = c.green })
hl("PmenuSbar",    { bg = c.bg_alt })
hl("PmenuThumb",   { bg = c.bright_black })
hl("StatusLine",   { fg = c.fg, bg = c.bg_alt })
hl("StatusLineNC", { fg = c.fg_dim, bg = c.bg_alt })
hl("TabLine",      { fg = c.fg_dim, bg = c.bg_alt })
hl("TabLineSel",   { fg = c.bg, bg = c.green })
hl("TabLineFill",  { bg = c.bg })
hl("VertSplit",    { fg = c.border })
hl("WinSeparator", { fg = c.border })
hl("Directory",    { fg = c.cyan })
hl("Title",        { fg = c.green, bold = true })
hl("MatchParen",   { fg = c.bg, bg = c.magenta })
hl("NonText",      { fg = c.bright_black })
hl("Whitespace",   { fg = c.bright_black })
hl("Folded",       { fg = c.fg_dim, bg = c.bg_alt })
hl("FoldColumn",   { fg = c.bright_black })

-- Diagnostics
hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn",  { fg = c.warning })
hl("DiagnosticInfo",  { fg = c.info })
hl("DiagnosticHint",  { fg = c.success })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.warning })
hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint",  { undercurl = true, sp = c.success })

-- Diff
hl("DiffAdd",    { fg = c.success, bg = c.bg_alt })
hl("DiffChange", { fg = c.warning, bg = c.bg_alt })
hl("DiffDelete", { fg = c.error, bg = c.bg_alt })
hl("DiffText",   { fg = c.cyan, bg = c.bg_alt })

-- Syntax
hl("Comment",    { fg = c.fg_dim, italic = true })
hl("Constant",   { fg = c.magenta })
hl("String",     { fg = c.green })
hl("Character",  { fg = c.green })
hl("Number",     { fg = c.bright_yellow })
hl("Boolean",    { fg = c.bright_yellow })
hl("Float",      { fg = c.bright_yellow })
hl("Identifier", { fg = c.fg })
hl("Function",   { fg = c.cyan, bold = true })
hl("Statement",  { fg = c.bright_red })
hl("Conditional",{ fg = c.bright_red })
hl("Repeat",     { fg = c.bright_red })
hl("Label",      { fg = c.bright_red })
hl("Operator",   { fg = c.white })
hl("Keyword",    { fg = c.bright_red })
hl("Exception",  { fg = c.error })
hl("PreProc",    { fg = c.yellow })
hl("Include",    { fg = c.yellow })
hl("Define",     { fg = c.yellow })
hl("Macro",      { fg = c.yellow })
hl("Type",       { fg = c.blue })
hl("StorageClass", { fg = c.blue })
hl("Structure",  { fg = c.blue })
hl("Typedef",    { fg = c.blue })
hl("Special",    { fg = c.bright_magenta })
hl("SpecialChar",{ fg = c.bright_magenta })
hl("Tag",        { fg = c.green })
hl("Delimiter",  { fg = c.white })
hl("Underlined", { underline = true, fg = c.cyan })
hl("Ignore",     { fg = c.bright_black })
hl("Error",      { fg = c.error })
hl("Todo",       { fg = c.bg, bg = c.yellow, bold = true })

-- Treesitter (subset, links to base groups where sensible)
hl("@variable",         { fg = c.fg })
hl("@variable.builtin", { fg = c.bright_magenta })
hl("@constant",         { fg = c.magenta })
hl("@constant.builtin", { fg = c.bright_yellow })
hl("@string",           { link = "String" })
hl("@number",           { link = "Number" })
hl("@boolean",          { link = "Boolean" })
hl("@function",         { link = "Function" })
hl("@function.builtin", { fg = c.cyan })
hl("@keyword",          { link = "Keyword" })
hl("@keyword.function", { fg = c.bright_red })
hl("@keyword.return",   { fg = c.bright_red })
hl("@type",              { link = "Type" })
hl("@type.builtin",      { fg = c.blue })
hl("@property",          { fg = c.fg })
hl("@field",              { fg = c.fg })
hl("@parameter",          { fg = c.white, italic = true })
hl("@comment",            { link = "Comment" })
hl("@punctuation.delimiter", { fg = c.white })
hl("@punctuation.bracket",   { fg = c.white })
hl("@tag",                { link = "Tag" })
hl("@tag.attribute",      { fg = c.green })
hl("@tag.delimiter",      { fg = c.fg_dim })

-- Treesitter (extended)
hl("@constructor",        { fg = c.cyan })
hl("@constant.macro",     { fg = c.yellow })
hl("@module",             { fg = c.cyan })
hl("@namespace",          { fg = c.cyan })
hl("@attribute",          { fg = c.yellow })
hl("@keyword.operator",   { fg = c.white })
hl("@keyword.import",     { fg = c.yellow })
hl("@keyword.conditional",{ fg = c.bright_red })
hl("@keyword.repeat",     { fg = c.bright_red })
hl("@keyword.exception",  { fg = c.error })
hl("@keyword.directive",  { fg = c.yellow })
hl("@keyword.coroutine",  { fg = c.bright_red })
hl("@operator",           { fg = c.white })
hl("@punctuation.special",{ fg = c.bright_magenta })
hl("@string.escape",      { fg = c.bright_magenta })
hl("@string.special",     { fg = c.bright_magenta })
hl("@string.regex",       { fg = c.bright_cyan })
hl("@string.documentation", { fg = c.fg_dim, italic = true })
hl("@number.float",       { fg = c.bright_yellow })
hl("@character.special",  { fg = c.bright_magenta })
hl("@comment.documentation", { fg = c.fg_dim, italic = true })
hl("@comment.error",      { fg = c.error, bold = true })
hl("@comment.warning",    { fg = c.warning, bold = true })
hl("@comment.todo",       { link = "Todo" })
hl("@comment.note",       { fg = c.info, bold = true })
hl("@label",               { fg = c.bright_red })
hl("@variable.member",     { fg = c.fg })
hl("@variable.parameter",  { fg = c.white, italic = true })
hl("@markup.heading",      { fg = c.green, bold = true })
hl("@markup.strong",       { bold = true })
hl("@markup.italic",       { italic = true })
hl("@markup.strikethrough",{ strikethrough = true })
hl("@markup.underline",    { underline = true })
hl("@markup.link",         { fg = c.cyan })
hl("@markup.link.url",     { fg = c.cyan, underline = true })
hl("@markup.list",         { fg = c.bright_red })
hl("@markup.list.checked", { fg = c.success })
hl("@markup.list.unchecked", { fg = c.fg_dim })
hl("@markup.raw",          { fg = c.magenta })
hl("@diff.plus",           { fg = c.success })
hl("@diff.minus",          { fg = c.error })
hl("@diff.delta",          { fg = c.warning })

-- Git signs
hl("GitSignsAdd",    { fg = c.success })
hl("GitSignsChange", { fg = c.warning })
hl("GitSignsDelete", { fg = c.error })

-- Telescope / misc plugin bridges
hl("TelescopeSelection", { bg = c.bg_alt })
hl("TelescopeBorder",    { fg = c.border })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.green, bold = true })
