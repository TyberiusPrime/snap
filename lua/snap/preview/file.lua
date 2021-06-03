local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local read_file = snap.get("preview.read-file")
local loading = snap.get("loading")
local function _1_(request)
  local load_counter = 0
  local last_time = 0
  local function render_loader()
    if ((vim.loop.now() - last_time) > 500) then
      local function _2_()
        if not request.canceled() then
          last_time = vim.loop.now()
          load_counter = (load_counter + 1)
          return vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, loading(request.width, request.height, load_counter))
        end
      end
      return snap.sync(_2_)
    end
  end
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(tostring(request.selection), ":p", ...)
  end
  path = snap.sync(_2_)
  local preview = read_file(path, render_loader)
  local function _3_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", false)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", false)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      local fake_path = (vim.fn.tempname() .. "/" .. vim.fn.fnamemodify(tostring(request.selection), ":t"))
      vim.api.nvim_buf_set_name(request.bufnr, fake_path)
      local function _4_()
        return vim.api.nvim_command("filetype detect")
      end
      vim.api.nvim_buf_call(request.bufnr, _4_)
      preview = nil
      return nil
    end
  end
  snap.sync(_3_)
  preview = nil
  return nil
end
return _1_