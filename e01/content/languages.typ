#let meta = toml("../info.toml")

#import "@preview/grotesk-cv:1.0.5": language-entry
#import meta.import.fontawesome: *

#let icon = meta.section.icon.languages
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons

= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Languages] else if language == "es" [Idiomas]

#v(5pt)

#if language == "en" {
  language-entry(language: "Bahasa Indonesia", proficiency: "Native")
  language-entry(language: "English", proficiency: "Fluent")
  language-entry(language: "Japanese", proficiency: "Newbie")
}

