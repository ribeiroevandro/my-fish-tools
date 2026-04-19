function __clone_known_editors --description "Known editor mappings: cli_cmd:app_name:desktop_name:display_name"
    printf "%s\n" \
        "code:Visual Studio Code:code:Visual Studio Code" \
        "cursor:Cursor:cursor:Cursor" \
        "subl:Sublime Text:sublime_text:Sublime Text" \
        "atom:Atom:atom:Atom" \
        "zed:Zed:dev.zed.Zed:Zed" \
        "fleet:Fleet:fleet:Fleet" \
        "nova:Nova:nova:Nova" \
        "idea:IntelliJ IDEA:jetbrains-idea:IntelliJ IDEA" \
        "vim:::Vim" \
        "nvim:::Neovim" \
        "emacs:::Emacs" \
        "nano:::Nano"
end
