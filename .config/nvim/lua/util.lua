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
		local ts_utils = require("nvim-treesitter.ts_utils")
		local widgets = require("dap.ui.widgets")

		local node = ts_utils.get_node_at_cursor()

		if not node then
			return
		end

		if node:type() == "name" then
			node = node:parent()
		end

		local expr = ts.get_node_text(node, 0)

		widgets.hover(expr)
	end,

	fold_php_uses = function()
		local tree = ts.get_parser():parse()
		local root = tree[1]:root()
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
			os.execute('zellij run -d down -- phpunit-watch ' .. vim.fn.expand('%'))
		end
	end
}
