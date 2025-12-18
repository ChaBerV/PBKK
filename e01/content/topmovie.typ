#let meta = toml("../info.toml")

#import "@preview/grotesk-cv:1.0.5": reference-entry
#import meta.import.fontawesome: *

#let icon = meta.section.icon.references
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons


= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Top Movie/ TV Show] else if language == "es" [Referencias]

#v(5pt)

#if language == "en" [

  #reference-entry(
    name: [Hacksaw Ridge],
    company: [ Movie ],
    email: [https://www.imdb.com/title/tt2119532/]
  )
  - Based on the real life of Private Desmond Doss in WWII period as a combat medic who refuses to wound any person but saving them instead.
  
  #reference-entry(
    name: [Bones],
    company: [ TV Show ],
    email: [https://www.imdb.com/title/tt0460627/]
  )
  - A Crime TV Show based on the experience of a real life forensic anthropologist Dr. Temperance Brennan handling human bones found in weird environment and solving the crime associated with them. 
] 


