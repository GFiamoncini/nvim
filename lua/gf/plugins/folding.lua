return {
  "nicolas-martin/region-folding.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    region_text = { start = "#region", ending = "#endregion" },
    fold_indicator = "▼"
  }
}
