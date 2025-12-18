#let meta = toml("../info.toml")
#import meta.import.fontawesome: *

#let icon = meta.section.icon.profile
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons

// = Summary
= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Summary] else if language == "es" [Resumen]

#v(5pt)

#if language == "en" [
  Student of Informatics department on Sepuluh Nopember Institute of Technology. Love gaming and game in general. Love Unity, Figma, Adobe, C/CS/C++.

] 