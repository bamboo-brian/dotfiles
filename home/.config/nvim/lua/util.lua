local ts = vim.treesitter

local getMethodAtNode = function(tsNode)
	local methodNode, classNode, methodName, className
	while tsNode do
		local type = tsNode:type()
		if type == 'method_declaration' then
			methodNode = tsNode
		end
		if type == 'class_declaration' then
			classNode = tsNode
		end
		tsNode = tsNode:parent()
	end
	if methodNode then
		methodName = ts.get_node_text(methodNode:field('name')[1], 0)
	end
	if classNode then
		className = ts.get_node_text(classNode:field('name')[1], 0)
	end
	return {methodName = methodName, methodNode = methodNode, className = className, classNode = classNode}
end

return {
	debug_hover = function()
		local widgets = require("dap.ui.widgets")

		local node = ts.get_node()

		if not node then
			return
		end

		if node:type() == "name" then
			node = node:parent()
		end

		local expr = ts.get_node_text(node, 0)

		widgets.hover(expr)
	end,

	fold_php_uses = function(args)
		local bufnr = type(args) == "table" and args.buf or 0
		local ok, parser = pcall(ts.get_parser, bufnr, "php")
		if not ok or not parser then
			return
		end

		local trees = parser:parse()
		local tree = trees and trees[1]
		if not tree then
			return
		end

		local root = tree:root()
		local query = ts.query.parse('php', '(namespace_use_declaration) @use')
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

	copyMethod = function()
		local methodInfo = getMethodAtNode(ts.get_node())
		if not (methodInfo.methodName and methodInfo.className) then
			vim.print("Could not get method name")
			return
		end
		vim.fn.setreg("*", methodInfo.className .. "::" .. methodInfo.methodName)
	end,

	copyClass = function()
		local methodInfo = getMethodAtNode(ts.get_node())
		if not methodInfo.className then
			vim.print("Could not get class name")
			return
		end
		vim.fn.setreg("*", methodInfo.className)
	end,

	runTest = function()
		if vim.bo.filetype == 'php' then
			local herdr = require('herdr')
			local result, err = herdr.pane.split(vim.env.HERDR_PANE_ID, { direction = 'down', no_focus = true })
			if err or not result then
				vim.notify('herdr split failed: ' .. (err or 'unknown'), vim.log.levels.ERROR)
				return
			end
			herdr.pane.run(result.result.pane.pane_id, 'phpunit-watch ' .. vim.fn.expand('%'))
		end
	end
}
