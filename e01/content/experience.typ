#let meta = toml("../info.toml")

#import "@preview/grotesk-cv:1.0.5": experience-entry
#import meta.import.fontawesome: *

#let icon = meta.section.icon.experience
#let language = meta.personal.language
#let include-icon = meta.personal.include_icons

= #if include-icon [#fa-icon(icon) #h(5pt)] #if language == "en" [Experience] else if language == "es" [Experiencia]

#v(2pt)

#if language == "en" [

  #experience-entry(
    title: [Expert Staff of Media and Information],
    date: [Mar 2025 - Present],
    company: [TPKH ITS],
    location: [Surabaya, IDN],
  )

  - Working together behind the scenes with other staff for the media outlet of TPKH ITS from Instagram, TikTok and YouTube. 
  - Work includes Media Design, Video Editing, Photography, and Front of House.

  #experience-entry(
    title: [Vice Head of Medical Subdivision],
    date: [October 2025 - February 2025],
    company: [Ini Lho ITS],
    location: [Surabaya, IDN],
  )
  - Monitoring and serving of injured people in the event.
  - Making sure the event runs smoothly and every scenario handle-able.


]