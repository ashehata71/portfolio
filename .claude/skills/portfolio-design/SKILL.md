---
name: portfolio-design
description: Visual design system and design process for this Flutter web portfolio (Ahmed Yasser) — the palette, type scale, section anatomy, breakpoints, motion vocabulary, and the web quality floor. Load before building, restyling, or reviewing any section, tile, or theme in lib/presentation, before proposing a visual redesign, and before adding animation or a new section to the page.
---

# Portfolio design

This is a single-page Flutter **web** portfolio, deployed to Firebase Hosting. It has one
job: convince a hiring manager or client, in under a minute of scrolling, that Ahmed Yasser
builds high-quality mobile applications. Everything on the page is evidence for that claim —
if an element isn't evidence, it's decoration and it should be cut.

Audience: recruiters and engineering managers skimming on desktop, plus people who open the
link from LinkedIn or WhatsApp **on a phone**. Mobile is not the fallback case here; it's
roughly half the traffic. Design both, always.

Subject material to design *from*: mobile app craft — app store artifacts, device frames,
release badges, build pipelines, the Play/App Store listings the projects actually shipped to.
That vernacular is where distinctive choices come from. Reach for it before reaching for
generic "developer portfolio" furniture.

## Current visual direction — and its honest weakness

The page today runs the well-known navy-and-teal developer-portfolio palette (the
Brittany-Chiang lineage). It is competent and it is also the single most recognizable default
in this genre. Treat that as a real constraint:

- **Small change, styling fix, one component** → stay inside the existing tokens below. A
  half-migrated page looks worse than a consistent default.
- **Redesign or new visual direction requested** → do not spend the freedom re-landing on
  navy/teal, nor on the AI-default looks (cream + serif + terracotta; near-black + acid green;
  hairline broadsheet). Bring a direction drawn from the mobile-craft material above, and say
  what you changed and why before writing code.

## Tokens

These values are the canonical palette. They currently live **hardcoded across nine files**
under `lib/presentation/` and `lib/core/apps/portfolio_app.dart`, which contradicts the global
"no hardcoded colors" standard. Two rules follow:

- Never introduce a *new* hex literal. If a color you need isn't in this table, you're either
  reaching for decoration or you're starting a redesign — decide which, out loud.
- The first task that touches three or more of these files should extract them into a
  `ThemeExtension` (or a `core/theme/` token class) and migrate as it goes. Don't do that
  migration as a drive-by on a one-file change.

| Token | Hex | Role |
|---|---|---|
| `navy` | `#0A192F` | Page background, app bar (at 0.92 alpha), drawer |
| `navyLight` | `#112240` | Raised surfaces — project cards, certificate tiles |
| `navyBorder` | `#233554` | Hairline borders and dividers on raised surfaces |
| `accent` | `#64FFDA` | The single accent: eyebrows, links, hover wash, active state |
| `textPrimary` | `#CCD6F6` | Headings and high-emphasis text |
| `textBody` | `#8892B0` | Body copy, nav labels, resting icon color |

Accent discipline: `accent` is the loudest thing on the page and it stays that way by being
rare. It marks *one* thing per section — the eyebrow, or the link, or the hover state, not all
three. If a screen has more than roughly three teal elements in view, cut back.

Stray tokens: `#50C878` (primary), `#FF69B4` (secondary) and `#2C2C3A` (surface) sit in the
`ColorScheme` in `portfolio_app.dart`. Nothing on the page names them — they only leak in
through Material defaults like ink and focus colors, which is why the odd green flash appears
on interaction. Don't build on them; reconcile them with the table above when you next touch
that theme.

## Type

`GoogleFonts.montagaTextTheme()` (a display serif) is currently applied to **every** role —
headings and body alike. Montaga is a display face; at 16px body sizes on a dark background it
reads soft and hurts scanning. When type work is in scope, split the roles:

- **Display** — the characteristic face, used with restraint: name, section headings, the
  typed hero line.
- **Body** — a clean face tuned for dark-background reading at 15–17px, `height: 1.5`.
- **Utility** — mono or a tight sans for dates, tech-stack chips, badges, and numbers. The
  hero already implies a terminal register with its typed line and `▌` caret; a mono utility
  face makes that read as intentional rather than accidental.

Size scale in use — keep to it, and set sizes responsively rather than inventing new steps:

| Role | Wide (>768) | Narrow |
|---|---|---|
| Name / hero display | 60 | 40 |
| Hero subline | 50 | 30 |
| Section heading | headlineMedium | headlineMedium |
| Body | 16 / `height: 1.5` | 16 / `height: 1.5` |
| Eyebrow, caption | 16 accent-colored | 16 accent-colored |

## Layout and section anatomy

- Page is one `SingleChildScrollView` with `horizontal: 24` padding, sections stacked in a
  `Column`. Section order carries the argument: hero → about → skills → experience → projects
  → certificates → contact.
- Every section goes through `SectionWrapper` (`lib/presentation/widgets/section_wrapper.dart`)
  so heading treatment and vertical rhythm stay identical. Add a section by adding a
  `SectionWrapper` child and registering its key in `sectionNames` + `_navItems` in
  `portfolio_app.dart` — both, or the nav silently breaks.
- **Breakpoint is 768px**, read via `MediaQuery.of(context).size.width > 768`. There is exactly
  one breakpoint; don't add a second without saying why. Above it: side-by-side rows, desktop
  nav links in the AppBar. Below it: stacked columns, hamburger `Drawer`.
- Content needs a max width on large monitors. Full-bleed 24px-padded text at 1920px is a line
  length no one reads — cap the column and center it.
- Cards (`ProjectTile`, `CertificateTile`) sit on `navyLight` with a `navyBorder` hairline.
  Keep radius and shadow consistent between the two; they read as one family.

Structural devices must encode something true. The projects and experience lists are **not** a
numbered sequence — don't number them. Experience *is* a timeline, so chronology is real
information there and may be expressed structurally.

## Motion

The page has a deliberate, small motion vocabulary. Extend it; don't add a fourth idiom.

1. **Hero type-on** — `Timer.periodic`, 100ms per character, with a `▌` caret. Fires once on
   load.
2. **Section reveal** — `AnimatedOpacity` + `AnimatedPadding`, 600ms, triggered by the scroll
   listener in `_onScroll` as each section enters the viewport.
3. **Skill bars** — width animates in when the skills section becomes visible.

Rules:

- Reveal-on-scroll is one-way. Sections don't re-hide when scrolled past.
- Hover is a web-first affordance and it is currently thin: only icon buttons respond. Links,
  nav items, and project cards should all have a visible hover state — `accent` at low alpha,
  or a border-color shift. Use `MouseRegion`/`InkWell`, keep it under 200ms.
- Cancel every `Timer`, dispose every controller, and check `context.mounted` after any
  `await` or `Future.delayed` — `_onScroll` and the hero timer both already do this; match them.

## Quality floor

Non-negotiable on every UI change, and not something to announce in the UI:

- **Reduced motion**: respect `MediaQuery.of(context).disableAnimations`. The type-on and the
  scroll reveals must degrade to their final state instantly, not just run faster.
- **Keyboard**: nav links, social icons, project links, and the drawer are all reachable and
  show a visible focus indicator. This page is a link people tab through.
- **Semantics**: social `IconButton`s need labels — a screen reader currently hears nothing
  useful for four of them in the hero. Images and certificate thumbnails need `semanticLabel`.
- **Contrast**: `textBody` `#8892B0` on `navy` clears AA for body text; it does **not** clear
  AA for small or thin text. Don't drop body copy below 16px in that color.
- **Narrow**: test at 360px width. Rows that don't wrap and 60px display type are the two
  things that break first.

## Process

1. **Read the target section and its neighbours first.** The section widgets are small and
   consistent; match the one next door rather than inventing a local pattern.
2. **Plan before code.** For anything larger than a styling tweak, write the compact plan
   first — palette, type roles, layout concept, and the one signature element the change will
   be remembered by. Review that plan against the "honest weakness" section above and revise
   whatever reads as the default answer.
3. **Spend boldness in one place.** One signature element per view; everything around it quiet.
4. **Verify visually.** `flutter run -d chrome`, check wide and 360px narrow, screenshot if the
   change is visual. A screenshot settles arguments that prose can't.
5. **Then the standard gate**: `dart format` → `flutter analyze` clean on touched files →
   `flutter test`. Report honestly what was run and what failed.
