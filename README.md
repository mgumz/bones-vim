# The VIM settings & plugins I use

## Content

    vimrc          - vim settings
    init.lua       - neovim entrypoint, injects vimrc

## Installation

Use https://github.com/mgumz/vopher to fetch and extract the base.

    $> vopher -dir ~/.config fetch nvim https://github.com/mgumz/bones-vim

Then fetch all plugins:

    $> cd ~/.config/nvim && bash do.sh up

and … thats it.

## Organisation

I use the following organisation for the external plugin / packages:

* `pack`                 - the regular package folder
* `pack/{section}`       - common (for both vim + nvim), nvim, vim
* `pack/{section}/opt`   - packages which I either do not want to have active
                         all the time OR which are useful only in neovim
                         or in vanilla vim.
* `pack/{section}/start` - packages to start automatically upon start of
                         neovim/vim

`vopher` puts the packages/plugins into the appropriate folder by prefixing
each plugin line with the destination folder:

That is why `vopher` has to be launched via `vopher -dir pack` - its default
would be `pack/vopher/start` and thus would not allow the organisation of
plugins the in way I sketched above.

## Other

Further information is available under

* http://www.vim.org and
* https://neovim.io
