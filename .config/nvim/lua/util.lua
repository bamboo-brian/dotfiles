return {
	debug_hover = function()
		local ts_utils = require("nvim-treesitter.ts_utils")
		local widgets = require("dap.ui.widgets")

		local node = ts_utils.get_node_at_cursor()

		if not node then
			return
		end

		if node:type() == "name" then
			node = node:parent()
		end

		local expr = vim.treesitter.get_node_text(node, 0)

		widgets.hover(expr)
	end,

	fold_php_uses = function()
		local parser = vim.treesitter.get_parser()
		local tree = parser:parse()
		local root = tree[1]:root()
		local query = vim.treesitter.query.parse('php', '(namespace_use_declaration) @use')
		local captures = query:iter_captures(root, 0)
		_, firstNode, _ = captures()
		if not firstNode then
			return
		end
		local firstRow = firstNode:range()
		local lastNode = nil
		for _, node, _ in captures do
			lastNode = node
		end
		if not lastNode then
			return
		end
		local lastRow = lastNode:range()
		vim.cmd(firstRow + 1 .. ',' .. lastRow + 1 .. 'fold')

	end,
}
