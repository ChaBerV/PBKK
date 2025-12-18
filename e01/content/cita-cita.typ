#let meta = toml("../info.toml")

#import "@preview/grotesk-cv:1.0.5": experience-entry
#import meta.import.fontawesome: *

#let icon = meta.section.icon.other_experience
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons

= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Ambition] 

#if language == "en" [
  I just wish to become a good game developer, to someday join a good game studio and one day join Riot Games and become a developer there. I also want to cherish what message my mother left behind and make her proud of me.
]

