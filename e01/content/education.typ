#let meta = toml("../info.toml")

#import "@preview/grotesk-cv:1.0.5": education-entry
#import meta.import.fontawesome: *

#let icon = meta.section.icon.education
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons


= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Education] else if language == "es" [Educación]

#v(1pt)

- #education-entry(
  degree: [Elementary School],
  date: [2010-2016],
  institution: [SD Negeri 3 BanjarJawa],
  location: [Singaraja, Buleleng, Bali]
)


- #education-entry(
  degree: [Junior Highschool],
  date: [2016-2019],
  institution: [SMP Negeri 1 Singaraja],
  location: [Buleleng, Bali]
)

- #education-entry(
  degree: [Senior Highschool],
  date: [2019-2022],
  institution: [SMA Negeri 1 Singaraja],
  location: [Bali]
)
- #education-entry(
  degree: [Bachelor of Computer Science],
  date: [2023-Present],
  institution: [Sepuluh Nopember Institute of Technology],
  location: [Surabaya, Indonesia]
)



