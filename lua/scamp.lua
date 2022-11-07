local M = {}

M.state = {}

M.edit = function(url)
  if M.state[url] ~= nil then
    vim.cmd.bdelete()
    vim.cmd.edit(M.state[url])
    return true
  end

  print('Reading ' .. url .. '...')
  local user, rest = url:match("^scp://(.*)[@](.*)$")
  local path, file, extension = rest:match("(.-)([^//]-([^//%.]+))$")

  local tempdir  = vim.fn.tempname() .. '/scamp-' .. user .. '@' .. path

  vim.fn.mkdir(tempdir, "p")

  local tempfile = tempdir .. file

  local ok, _ = pcall(vim.cmd, 'silent !scp ' .. url .. ' ' .. tempfile)

  if ok then
    vim.cmd.bdelete()
    vim.cmd.edit(tempfile)

    vim.bo.filetype = extension

    M.state[url]      = tempfile
    M.state[tempfile] = url

    return true
  end

  print('Error: failed to edit ' .. tempdir)
  return false
end

M.write = function(file)
  vim.cmd('silent write')

  local url = M.state[file]

  print('Writing ' .. url .. '...')
  local ok, _ = pcall(vim.cmd, 'silent !scp % ' .. url)

  if ok then
    print('Wrote buffer to ' .. url)
    return true
  end

  print('Error: failed to write ' .. url)
  return false
end

M.overwrite = function(url)
  vim.cmd('silent write')

  print('Writing ' .. url .. '...')
  local ok, _ = pcall(vim.cmd, 'silent !scp % ' .. url)

  if ok then
    print('Wrote buffer to ' .. url)
    return true
  end

  print('Error: failed to write ' .. url)
  return false
end

M.cmd = function(args)
  local subcommand = args[1]
  local url        = args[2]

  local ok, _ = pcall(M[subcommand], url)

  if ok then return true end

  print('Error: bad subcommand.')
  return false
end

M.setup = function()
  vim.api.nvim_create_autocmd(
    { "BufReadCmd", "FileReadCmd" },
    { pattern = { "scp://*" }, callback = function(args) M.edit(args.match) end }
  )

  vim.api.nvim_create_autocmd(
    { "BufWriteCmd", "FileWriteCmd" },
    { pattern = { "/tmp/*/scamp-*" }, callback = function(args) M.write(args.match) end }
  )

  vim.api.nvim_create_autocmd(
    { "BufWriteCmd", "FileWriteCmd" },
    { pattern = { "scp://*" }, callback = function(args) M.overwrite(args.match) end }
  )
end

return M
