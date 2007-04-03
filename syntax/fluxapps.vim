" File Name: fluxapps.vim
" Maintainer: M.Gumz aka ak|ra (#fluxbox on freenode) <gumz at cs.uni-magdeburg.de>
" Original Date: 040206 01:07:09 
" Last Update: 040206 01:07:12 
" Description: fluxbox apps-file syntax

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syntax keyword fluxboxTag app end startup

syntax keyword fluxboxRemember Workspace 
syntax keyword fluxboxRemember Deco 
syntax keyword fluxboxRemember Hidden 
syntax keyword fluxboxRemember Layer 
syntax keyword fluxboxRemember Position 
syntax keyword fluxboxRemember Sticky

syntax keyword fluxboxValue UPPERRIGHT
syntax keyword fluxboxValue UPPERLEFT 
syntax keyword fluxboxValue LOWERRIGHT 
syntax keyword fluxboxValue LOWERLEFT 
syntax keyword fluxboxValue WINCENTER 
syntax keyword fluxboxValue CENTER

syntax match fluxboxValue /{.*}/hs=s+1,he=e-1
syntax match fluxboxComment /[#!].*$/

highlight link fluxboxTag Type 
highlight link fluxboxRemember Macro
highlight link fluxboxComment Comment
highlight link fluxboxValue String
syntax sync fromstart

let b:current_syntax = 'fluxapps'

