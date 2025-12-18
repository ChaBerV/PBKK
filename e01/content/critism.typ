#let meta = toml("../info.toml")

#import "@preview/grotesk-cv:1.0.5": experience-entry
#import meta.import.fontawesome: *

#let icon = meta.section.icon.other_experience
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons

= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Critism] 
 Tan Malaka once said. "If young people who have studied in school consider themselves too superior and intelligent to blend in with a society that works with hoes and only has simple ideals, then it would be better if education were not provided at all." This idealism serves as a reminder to students currently studying. Being a student should be about being someone who carries the hopes of society and someday carry the torches of said society to a better future.