local M = {}

M.state = {}

M.scp_prefix = 'scp -o ConnectTimeout=5 '

M.edit = function(url)
  if M.state[url] ~= nil then
    vim.cmd.bdelete()
    vim.cmd.edit(M.state[url])
    return true
  end

  local user, rest = url:match("^scp://(.*)[@](.*)$")
  local path, file, extension = rest:match("(.-)([^//]-([^//%.]+))$")

  local tempdir  = vim.fn.tempname() .. '/scamp-' .. user .. '@' .. path

  vim.fn.mkdir(tempdir, "p")

  local tempfile = tempdir .. file
  local log      = vim.fn.system(M.scp_prefix .. url .. ' ' .. tempfile)

  if vim.v.shell_error ~= 0 then
    print('Error: failed to edit ' .. url)
    print(log)
    vim.cmd.bdelete()
    return false
  end

  vim.cmd.edit(tempfile)

  vim.bo.filetype = extension

  M.state[url]      = tempfile
  M.state[tempfile] = url

  return true
end

M.write = function(url)
  vim.cmd('silent write')

  local log = vim.fn.system(M.scp_prefix .. vim.fn.expand('%') .. ' ' .. url)

  if vim.v.shell_error ~= 0 then
    print('Error: failed to write ' .. url)
    print(log)
    return false
  end

  return true
end

M.cmd = function(args)
  local subcommand = args[1]
  local url        = args[2]

  local ok, _ = pcall(M[subcommand], url)

  if ok then return true end

  print('Error: bad subcommand.')
  return false
end

M.setup = function(opts)
  if opts ~= nil and opts.scp_options ~= nil then
    local options = ''
    for _, each in ipairs(opts.scp_options) do
      options = options .. ' -o ' .. each
    end
    M.scp_prefix = 'scp' .. options .. ' '
  end

  vim.api.nvim_create_autocmd(
    { "BufReadCmd", "FileReadCmd" },
    { pattern = { "scp://*" },
      callback = function(args) M.edit(args.match) end })

  vim.api.nvim_create_autocmd(
    { "BufWriteCmd", "FileWriteCmd" },
    { pattern = { "/tmp/*/scamp-*" },
      callback = function(args) M.write(M.state[args.match]) end })

  vim.api.nvim_create_autocmd(
    { "BufWriteCmd", "FileWriteCmd" },
    { pattern = { "scp://*" },
      callback = function(args) M.write(args.match) end })

  return true
end

return M
