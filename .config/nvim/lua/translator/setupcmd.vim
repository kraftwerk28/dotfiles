" Taken from https://github.com/cjrsgu/google-translate-api-browser/blob/master/src/languages.ts#L5-L113
let s:langs = {
\   'auto': 'Automatic', 'af': 'Afrikaans', 'sq': 'Albanian',
\   'am': 'Amharic', 'ar': 'Arabic', 'hy': 'Armenian', 'az': 'Azerbaijani',
\   'eu': 'Basque', 'be': 'Belarusian', 'bn': 'Bengali', 'bs': 'Bosnian',
\   'bg': 'Bulgarian', 'ca': 'Catalan', 'ceb': 'Cebuano', 'ny': 'Chichewa',
\   'zh': 'Chinese Simplified', 'zh-cn': 'Chinese Simplified',
\   'zh-tw': 'Chinese Traditional', 'co': 'Corsican', 'hr': 'Croatian',
\   'cs': 'Czech', 'da': 'Danish', 'nl': 'Dutch', 'en': 'English',
\   'eo': 'Esperanto', 'et': 'Estonian', 'tl': 'Filipino', 'fi': 'Finnish',
\   'fr': 'French', 'fy': 'Frisian', 'gl': 'Galician', 'ka': 'Georgian',
\   'de': 'German', 'el': 'Greek', 'gu': 'Gujarati', 'ht': 'Haitian Creole',
\   'ha': 'Hausa', 'haw': 'Hawaiian', 'he': 'Hebrew', 'iw': 'Hebrew',
\   'hi': 'Hindi', 'hmn': 'Hmong', 'hu': 'Hungarian', 'is': 'Icelandic',
\   'ig': 'Igbo', 'id': 'Indonesian', 'ga': 'Irish', 'it': 'Italian',
\   'ja': 'Japanese', 'jw': 'Javanese', 'kn': 'Kannada', 'kk': 'Kazakh',
\   'km': 'Khmer', 'ko': 'Korean', 'ku': 'Kurdish (Kurmanji)', 'ky': 'Kyrgyz',
\   'lo': 'Lao', 'la': 'Latin', 'lv': 'Latvian', 'lt': 'Lithuanian',
\   'lb': 'Luxembourgish', 'mk': 'Macedonian', 'mg': 'Malagasy',
\   'ms': 'Malay', 'ml': 'Malayalam', 'mt': 'Maltese', 'mi': 'Maori',
\   'mr': 'Marathi', 'mn': 'Mongolian', 'my': 'Myanmar (Burmese)',
\   'ne': 'Nepali', 'no': 'Norwegian', 'ps': 'Pashto', 'fa': 'Persian',
\   'pl': 'Polish', 'pt': 'Portuguese', 'pa': 'Punjabi', 'ro': 'Romanian',
\   'ru': 'Russian', 'sm': 'Samoan', 'gd': 'Scots Gaelic', 'sr': 'Serbian',
\   'st': 'Sesotho', 'sn': 'Shona', 'sd': 'Sindhi', 'si': 'Sinhala',
\   'sk': 'Slovak', 'sl': 'Slovenian', 'so': 'Somali', 'es': 'Spanish',
\   'su': 'Sundanese', 'sw': 'Swahili', 'sv': 'Swedish', 'tg': 'Tajik',
\   'ta': 'Tamil', 'te': 'Telugu', 'th': 'Thai', 'tr': 'Turkish',
\   'uk': 'Ukrainian', 'ur': 'Urdu', 'uz': 'Uzbek', 'vi': 'Vietnamese',
\   'cy': 'Welsh', 'xh': 'Xhosa', 'yi': 'Yiddish', 'yo': 'Yoruba', 'zu': 'Zulu',
\ }

let s:langsrev = {}
let s:langscompl = []
for kv in items(s:langs)
  let s:long = substitute(kv[1], ' ', '_', 'g')
  let s:short = kv[0]
  let s:langsrev[s:long] = s:short
  let s:langs[s:short] = s:long
  call add(s:langscompl, s:long)
endfor

function! s:LngCode(lng)
  if index(keys(s:langs), a:lng) != -1
    return a:lng
  endif
  return get(s:langsrev, a:lng, '')
endfunction

function! s:LangCompl(A, L, P)
  return filter(copy(s:langscompl), 'v:val =~? a:A')
endfunction

function! s:Tr(...)
  if index([1, 2], len(a:000)) == -1
    echoerr "Wrong argument number"
    return
  endif

  if len(a:000) == 1
    let l:l1 = s:LngCode(a:1)
    if l:l1 == '' | echoerr "Unknown language" | return | endif
    let l:luaexpr = 'require''translator''.translate(vim.fn.submatch(0), '''
      \ . l:l1 . ''')'
  elseif len(a:000) == 2
    let l:l1 = s:LngCode(a:1)
    let l:l2 = s:LngCode(a:2)
    if l:l1 == '' || l:l2 == '' | echoerr "Unknown language" | return | endif
    let l:luaexpr = 'require''translator''.translate(vim.fn.submatch(0), '''
      \ . l:l1 . ''', ''' . l:l2 . ''')'
  endif
  let l:fullexpr = 's#\%V\_.*\%V\_.#\=luaeval("' . l:luaexpr . '")#'
  normal! ma
  execute l:fullexpr
  normal! `a
endfunction

command -nargs=+ -range -complete=customlist,s:LangCompl
      \ Translate call <SID>Tr(<f-args>)
