require("bacon").setup({
  quickfix = {
    enabled = true, -- populate quickfix list with bacon errors and warnings
    event_trigger = true, -- triggers the QuickFixCmdPost event after populating the quickfix list
  },
})
