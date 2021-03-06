
if !exists('s:doneMappings')
	let s:doneMappings = 1
" Define environments for IMAP evaluation " {{{
"let s:figure =     "\\begin{figure}[htpb]\<cr>\\centering\<cr>\\psfig{figure=eps file}\<cr>\\caption{caption text}\<cr>\\label{fig:label}\<cr>\\end{figure}"
let s:figure_graphicx =    "\\begin{figure}[htpb]\<cr>\\centering\<cr>\\includegraphics[width=0.1\\textwidth]{file}\<cr>\\caption{captiontext}\<cr>\\label{fig:label}\<cr>\\end{figure}"
let s:figure =    "\\begin{figure}[htpb]\<cr>\\centering\<cr>\\includegraphics[]{file}\<cr>\\caption{captiontext}\<cr>\\label{fig:label}\<cr>\\end{figure}"
let s:minipage =   "\\begin{minipage}[<+tb+>]{<+width+>}\<cr><++>\<cr>\\end{minipage}"
let s:picture =    "\\begin{picture}(<+width+>, <+height+>)(<+xoff+>,<+yoff+>)\<cr>\\put(<+xoff+>,<+yoff+>){\\framebox(<++>,<++>){<++>}}\<cr>\\end{picture}"
let s:list =       "\\begin{list}{label}{spacing}\<cr>\\item<++> \<cr>\\end{list}"
let s:table =      "\\begin{table}[htbp]\<cr>\\centering\<cr>\\begin{tabular}{ll}\<cr> <++> \<cr>\\end{tabular}\<cr>\\caption{Captiontext}\<cr>\\label{tab:label}\<cr>\\end{table}"
let s:array =      "$\\left\\{\<cr>\\begin{array}{ll}\<cr><++>\<cr>\\end{array}\<cr>\\right.$"
let s:description ="\\begin{description}\<cr>\\item[<+label+>]<++>\<cr>\\end{description}"
let s:document =   "\\documentclass[<+options+>]{<+class+>}\<cr>\<cr>\\begin{document}\<cr><++>\<cr>\\end{document}"
let s:tabular = "\\begin{tabular}[<+hbtp+>]{<+format+>}\<cr><++>\<cr>\\end{tabular}"
let s:tabular_star = "\\begin{tabular*}[<+hbtp+>]{<+format+>}\<cr><++>\<cr>\\end{tabular*}"

" }}}


" Tex_EnvMacros: sets up maps and menus for environments {{{
" Description: 
function! <SID>Tex_EnvMacros(lhs, submenu, name)
    call IMAP(a:lhs, "\<C-r>=Tex_PutEnvironment('".a:name."')\<CR>", 'tex')
endfunction 
" }}}

function! <SID>Tex_SectionMacros(lhs, name)
		call IMAP (a:lhs, "\\".a:name.'{<++>}', 'tex')
endfunction " }}}

function! <SID>Tex_SpecialMacros(lhs, submenu, name, irhs, ...)
    call IMAP(a:lhs, a:irhs, 'tex')
endfunction " }}}


function! Tex_itemize(env)
	return IMAP_PutTextWithMovement('\begin{'.a:env."}\<cr>\\item\<cr><++>\<cr>\\item\<cr><++> \<cr>\\item\<cr><++> \<cr>\\end{".a:env."}")
endfunction

" " Tex_eqnarray: {{{
" function! Tex_eqnarray(env)
" 	return IMAP_PutTextWithMovement('\begin{'.a:env."}\<cr><++>\<cr>".arrlabel."\\end{".a:env."}<++>")
" endfunction
" " }}} 
" Tex_eqnarray: {{{
function! Tex_eqnarray(env)
	return IMAP_PutTextWithMovement('\begin{'.a:env."}\<cr><++>\<cr>""\\end{".a:env."}<++>")
endfunction
" }}} 

" Tex_tabular: {{{
function! Tex_tabular(env)
		return IMAP_PutTextWithMovement('\begin{'.a:env.'}[<+position+>]{<+format+>}'."\<cr><++>\<cr>\\end{".a:env.'}<++>')
endfunction
" }}} 
" Tex_table: {{{
function! Tex_table(env)
		return IMAP_PutTextWithMovement(s:table)
endfunction
" }}} 
" Tex_figure: {{{
function! Tex_figure(env)
			return IMAP_PutTextWithMovement(s:figure)
endfunction
" }}} 
" Tex_PutEnvironment: calls various specialized functions {{{
" Description: 
"   Based on input argument, it calls various specialized functions.
function! Tex_PutEnvironment(env)
	if exists("s:isvisual") && s:isvisual == "yes"
		let s:isvisual = 'no'
		if a:env == '\['
			return VEnclose('', '', '\[', '\]')
		elseif a:env == '$$'
			return VEnclose('', '', '$$', '$$')
		endif
		return VEnclose('\begin{'.a:env.'}', '\end{'.a:env.'}', '\begin{'.a:env.'}', '\end{'.a:env.'}')
	else
		" The user can define something like 
		" let g:Tex_Env_theorem = "\\begin{theorem}\<CR><++>\<CR>\\end{theorem}"
		" This will effectively over-write the default definition of the
		" theorem environment which uses a \label.
		if exists("b:Tex_Env_{'".a:env."'}")
			return IMAP_PutTextWithMovement(b:Tex_Env_{a:env})
		elseif exists("g:Tex_Env_{'".a:env."'}")
			return IMAP_PutTextWithMovement(g:Tex_Env_{a:env})
		elseif a:env =~ 'equation*\|eqnarray*\|theorem\|lemma\|equation\|eqnarray\|align\*\|align\>\|multline'
			let g:aa = a:env
			return Tex_eqnarray(a:env)
		elseif a:env =~ "enumerate\\|itemize\\|theindex\\|trivlist"
			return Tex_itemize(a:env)
		elseif a:env =~ "table\\|table*"
			return Tex_table(a:env)
		elseif a:env =~ "tabular\\|tabular*\\|array\\|array*"
			return Tex_tabular(a:env)
		elseif exists('*Tex_'.a:env)
			exe 'return Tex_'.a:env.'(a:env)'
		elseif a:env == '$$'
			return IMAP_PutTextWithMovement('$$<++>$$')
		elseif a:env == '\['
			return IMAP_PutTextWithMovement("\\[\<CR><++>\<CR>\\]<++>")
		else
			" Look in supported packages if exists template for environment
			" given in the line
		endif
		" If nothing before us managed to create an environment, then just
		" create a bare-bones environment from the name.
		return IMAP_PutTextWithMovement('\begin{'.a:env."}\<cr><++>\<cr>\\end{".a:env."}<++>")
	endif
endfunction " }}}

call s:Tex_EnvMacros('EEN', '&Lists.', 'enumerate')
call s:Tex_EnvMacros('EIT', '&Lists.', 'itemize')

" Sections {{{
call s:Tex_SectionMacros('SPA', 'part')
call s:Tex_SectionMacros('SCH', 'chapter')
call s:Tex_SectionMacros('SSE', 'section')
call s:Tex_SectionMacros('SSS', 'subsection')
call s:Tex_SectionMacros('SS2', 'subsubsection')
call s:Tex_SectionMacros('SPG', 'paragraph')
call s:Tex_SectionMacros('SSP', 'subparagraph')
" }}}
" Tables {{{
call s:Tex_SpecialMacros('ETE', '&Tables.', 'table', s:table)
call s:Tex_EnvMacros('ETG', '&Tables.', 'tabbing')
" call s:Tex_EnvMacros('',    '&Tables.', 'table*')
" call s:Tex_EnvMacros('',    '&Tables.', 'table2')
call s:Tex_SpecialMacros('ETR', '&Tables.', 'tabular', s:tabular)
" call s:Tex_SpecialMacros('', '&Tables.', 'tabular*', s:tabular_star)
call s:Tex_SpecialMacros('EFI', '', 'figure', "\<C-r>=Tex_PutEnvironment('figure')\<CR>")
" }}}
" Math {{{
" call s:Tex_EnvMacros('EAL', '&Math.', 'align')
call s:Tex_EnvMacros('EAR', '&Math.', 'array')
" call s:Tex_EnvMacros('EDM', '&Math.', 'displaymath')
" call s:Tex_EnvMacros('EEA', '&Math.', 'eqnarray')
" call s:Tex_EnvMacros('',    '&Math.', 'eqnarray*')
" call s:Tex_EnvMacros('EEQ', '&Math.', 'equation')
" call s:Tex_EnvMacros('EMA', '&Math.', 'math')
" }}if !exists('g:Tex_Leader')
"
"
" if g:Tex_Leader is not set, default to backtick
if !exists('g:Tex_Leader')
    let g:Tex_Leader = '`'
endif
	call IMAP ('__', '_{<++>}<++>', "tex")
	call IMAP ('()', '(<++>)<++>', "tex")
	call IMAP ('[]', '[<++>]<++>', "tex")
	call IMAP ('{}', '{<++>}<++>', "tex")
	call IMAP ('^^', '^{<++>}<++>', "tex")
	call IMAP ('$$', '$<++>$<++>', "tex")
	call IMAP ('==', '&=& ', "tex")
	call IMAP ('~~', '&\approx& ', "tex")
	call IMAP ('=~', '\approx', "tex")
	call IMAP ('::', '\dots', "tex")
	call IMAP ('((', '\left( <++> \right)<++>', "tex")
	call IMAP ('[[', '\left[ <++> \right]<++>', "tex")
	call IMAP ('{{', '\left\{ <++> \right\}<++>', "tex")
	call IMAP (g:Tex_Leader.'^', '\hat{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.'_', '\bar{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.'6', '\partial', "tex")
	call IMAP (g:Tex_Leader.'8', '\infty', "tex")
	call IMAP (g:Tex_Leader.'/', '\frac{<++>}{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.'%', '\frac{<++>}{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.'@', '\circ', "tex")
	call IMAP (g:Tex_Leader.'0', '^\circ', "tex")
	call IMAP (g:Tex_Leader.'=', '\equiv', "tex")
	call IMAP (g:Tex_Leader."\\",'\setminus', "tex")
	call IMAP (g:Tex_Leader.'.', '\cdot', "tex")
	call IMAP (g:Tex_Leader.'*', '\times', "tex")
	call IMAP (g:Tex_Leader.'&', '\wedge', "tex")
	call IMAP (g:Tex_Leader.'-', '\bigcap', "tex")
	call IMAP (g:Tex_Leader.'+', '\bigcup', "tex")
	call IMAP (g:Tex_Leader.'M', '\sum_{<++>}^{<++>}<++>', 'tex')
	call IMAP (g:Tex_Leader.'S', '\sum_{<++>}^{<++>}<++>', 'tex')
	call IMAP (g:Tex_Leader.'(', '\subset', "tex")
	call IMAP (g:Tex_Leader.')', '\supset', "tex")
	call IMAP (g:Tex_Leader.'<', '\le', "tex")
	call IMAP (g:Tex_Leader.'>', '\ge', "tex")
	call IMAP (g:Tex_Leader.',', '\nonumber', "tex")
	call IMAP (g:Tex_Leader.'~', '\tilde{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.';', '\dot{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.':', '\ddot{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.'2', '\sqrt{<++>}<++>', "tex")
	call IMAP (g:Tex_Leader.'|', '\Big|', "tex")
	call IMAP (g:Tex_Leader.'I', "\\int_{<++>}^{<++>}<++>", 'tex')
	" }}}
	" Greek Letters {{{
	call IMAP(g:Tex_Leader.'a', '\alpha', 'tex')
	call IMAP(g:Tex_Leader.'b', '\beta', 'tex')
	call IMAP(g:Tex_Leader.'c', '\chi', 'tex')
	call IMAP(g:Tex_Leader.'d', '\delta', 'tex')
	call IMAP(g:Tex_Leader.'e', '\varepsilon', 'tex')
	call IMAP(g:Tex_Leader.'f', '\varphi', 'tex')
	call IMAP(g:Tex_Leader.'g', '\gamma', 'tex')
	call IMAP(g:Tex_Leader.'h', '\eta', 'tex')
	call IMAP(g:Tex_Leader.'i', '\iota', 'tex')
	call IMAP(g:Tex_Leader.'k', '\kappa', 'tex')
	call IMAP(g:Tex_Leader.'l', '\lambda', 'tex')
	call IMAP(g:Tex_Leader.'m', '\mu', 'tex')
	call IMAP(g:Tex_Leader.'n', '\nu', 'tex')
	call IMAP(g:Tex_Leader.'p', '\pi', 'tex')
	call IMAP(g:Tex_Leader.'q', '\theta', 'tex')
	call IMAP(g:Tex_Leader.'r', '\rho', 'tex')
	call IMAP(g:Tex_Leader.'s', '\sigma', 'tex')
	call IMAP(g:Tex_Leader.'t', '\tau', 'tex')
	call IMAP(g:Tex_Leader.'u', '\upsilon', 'tex')
	call IMAP(g:Tex_Leader.'v', '\varsigma', 'tex')
	call IMAP(g:Tex_Leader.'w', '\omega', 'tex')
	call IMAP(g:Tex_Leader.'w', '\wedge', 'tex')  " AUCTEX style
	call IMAP(g:Tex_Leader.'x', '\xi', 'tex')
	call IMAP(g:Tex_Leader.'y', '\psi', 'tex')
	call IMAP(g:Tex_Leader.'z', '\zeta', 'tex')
	" not all capital greek letters exist in LaTeX!
	" reference: http://www.giss.nasa.gov/latex/ltx-405.html
	call IMAP(g:Tex_Leader.'D', '\Delta', 'tex')
	call IMAP(g:Tex_Leader.'F', '\Phi', 'tex')
	call IMAP(g:Tex_Leader.'G', '\Gamma', 'tex')
	call IMAP(g:Tex_Leader.'Q', '\Theta', 'tex')
	call IMAP(g:Tex_Leader.'L', '\Lambda', 'tex')
	call IMAP(g:Tex_Leader.'X', '\Xi', 'tex')
	call IMAP(g:Tex_Leader.'Y', '\Psi', 'tex')
	call IMAP(g:Tex_Leader.'S', '\Sigma', 'tex')
	call IMAP(g:Tex_Leader.'U', '\Upsilon', 'tex')
	call IMAP(g:Tex_Leader.'W', '\Omega', 'tex')
	" }}}
	" ProtectLetters: sets up indentity maps for things like ``a {{{
	" " Description: If we simply do
	" 		call IMAP('`a', '\alpha', 'tex')
	" then we will never be able to type 'a' after a tex-quotation. Since
	" IMAP() always uses the longest map ending in the letter, this problem
	" can be avoided by creating a fake map for ``a -> ``a.
	" This function sets up fake maps of the following forms:
	" 	``[aA]  -> ``[aA]    (for writing in quotations)
	" 	\`[aA]  -> \`[aA]    (for writing diacritics)
	" 	"`[aA]  -> "`[aA]    (for writing german quotations)
	" It does this for all printable lower ascii characters just to make sure
	" we dont let anything slip by.
	function! s:ProtectLetters(first, last)
		let i = a:first
		while i <= a:last
			if nr2char(i) =~ '[[:print:]]'
				call IMAP('``'.nr2char(i), '``'.nr2char(i), 'tex')
				call IMAP('\`'.nr2char(i), '\`'.nr2char(i), 'tex')
				call IMAP('"`'.nr2char(i), '"`'.nr2char(i), 'tex')
			endif
			let i = i + 1
		endwhile
	endfunction 
	call s:ProtectLetters(32, 127)
	" }}}
	" vmaps: enclose selected region in brackets, environments {{{ 
	" The action changes depending on whether the selection is character-wise
	" or line wise. for example, selecting linewise and pressing \v will
	" result in the region being enclosed in \begin{verbatim}, \end{verbatim},
	" whereas in characterise visual mode, the thingie is enclosed in \verb|
	" and |.
	exec 'vnoremap <silent> '.g:Tex_Leader."( \<C-\\>\<C-N>:call VEnclose('\\left( ', ' \\right)', '\\left(', '\\right)')\<CR>"
	exec 'vnoremap <silent> '.g:Tex_Leader."[ \<C-\\>\<C-N>:call VEnclose('\\left[ ', ' \\right]', '\\left[', '\\right]')\<CR>"
	exec 'vnoremap <silent> '.g:Tex_Leader."{ \<C-\\>\<C-N>:call VEnclose('\\left\\{ ', ' \\right\\}', '\\left\\{', '\\right\\}')\<CR>"
	exec 'vnoremap <silent> '.g:Tex_Leader."$ \<C-\\>\<C-N>:call VEnclose('$', '$', '\\[', '\\]')\<CR>"
	" }}}
endif

