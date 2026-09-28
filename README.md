# Flame

Flame is the barebones folder structure that Tribe is built on. If you want to build a Tribe-compatible frontend from scratch, Flame is your starting point.

→ **[tribe-framework.org](https://tribe-framework.org)**

---

## HTML-only Websites

Flame also covers single-file websites: one `index.html` built on Bootstrap 5.3, with no build step, no Ember and no backend. These files are written and maintained in the Tribe **HTML Editor**, which splits the document into panes and reassembles them on download.

This section is the contract an AI assistant must follow so that generated HTML opens cleanly in the HTML Editor and round-trips without losing anything.

### Table of Contents

- [Document Anatomy](#document-anatomy)
- [Default Stack](#default-stack)
- [Theme Tokens](#theme-tokens)
- [Code Rules](#code-rules)
- [How the Editor Reads a File](#how-the-editor-reads-a-file)
- [Starter Document](#starter-document)
- [Snippet Reference](#snippet-reference)
- [Prompting](#prompting)

---

### Document Anatomy

The editor holds the document in three groups. The panes are assembled top to bottom into one file.

| Group  | Pane       | Output location                                        | Language |
| ------ | ---------- | ------------------------------------------------------ | -------- |
| `HEAD` | Doctype    | first line of the file, plus `<html lang="…">`         | html     |
| `HEAD` | Metadata   | inside `<head>`: charset, viewport, title, meta tags   | html     |
| `HEAD` | Styles     | inside `<head>`, wrapped in a single `<style>` element | css      |
| `HEAD` | Scripts    | inside `<head>`: `<link>` and `<script>` tags, verbatim | html     |
| `BODY` | Navbar     | top of `<body>`                                        | html     |
| `BODY` | Sections   | after the navbar, in order; any number of sections     | html     |
| `TAIL` | Footer     | end of `<body>`                                        | html     |
| `TAIL` | Scripts    | after the footer: bundle tags and inline JS            | html     |

The assembled file has this exact order:

```html
<!doctype html>
<html lang="en">
  <head>
    <!-- Metadata pane -->
    <!-- head Scripts pane -->
    <!-- font links generated from the theme (data-theme-font) -->
    <style id="theme-tokens">/* generated from the theme */</style>
    <style>/* Styles pane */</style>
  </head>
  <body id="top">
    <!-- Navbar pane -->
    <!-- Section 1 … Section N -->
    <!-- Footer pane -->
    <!-- tail Scripts pane -->
  </body>
</html>
```

`<body>` always carries `id="top"`. The starter navbar brand and the footer "Back to top" link point at `#top`.

---

### Default Stack

All dependencies load from jsDelivr. Nothing is installed locally.

| Package                  | Version | Placement       |
| ------------------------ | ------- | --------------- |
| Bootstrap CSS            | 5.3.3   | head Scripts    |
| FontAwesome Free         | 6.5.2   | head Scripts    |
| animate.css              | 4.1.1   | head Scripts    |
| Bootstrap JS (bundle)    | 5.3.3   | tail Scripts    |
| Google Font (from theme) | n/a     | generated       |

The head Scripts pane defaults to:

```html
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
  rel="stylesheet"
  integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
  crossorigin="anonymous"
/>
<link
  href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css"
  rel="stylesheet"
/>
<link
  href="https://cdn.jsdelivr.net/npm/animate.css@4.1.1/animate.min.css"
  rel="stylesheet"
/>
```

The tail Scripts pane defaults to:

```html
<script
  src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
  integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
  crossorigin="anonymous"
></script>
<script>
  document.addEventListener('DOMContentLoaded', () => {});
</script>
```

---

### Theme Tokens

Bootstrap from a CDN cannot be recompiled with Sass variables. The editor therefore generates a `<style id="theme-tokens">` block that reproduces the default Tribe `app.scss` settings in plain CSS. The theme is chosen with the editor's Font, Palette and Flags controls, and the block is regenerated on every change.

#### Fonts

| id               | Label          | Stack                                                    |
| ---------------- | -------------- | -------------------------------------------------------- |
| `ibm-plex-mono`  | IBM Plex Mono  | `'IBM Plex Mono', monospace` (default)                   |
| `inter`          | Inter          | `'Inter', system-ui, sans-serif`                         |
| `jetbrains-mono` | JetBrains Mono | `'JetBrains Mono', monospace`                            |
| `space-grotesk`  | Space Grotesk  | `'Space Grotesk', sans-serif`                            |
| `fraunces`       | Fraunces       | `'Fraunces', Georgia, serif`                             |
| `system`         | System UI      | `system-ui, -apple-system, Segoe UI, Roboto, sans-serif` |

The chosen stack is applied to `--bs-body-font-family`, `--bs-font-sans-serif`, `body` and `.display-1` to `.display-6`. Font `<link>` tags are emitted with a `data-theme-font` attribute.

#### Palette

| Name        | Default   |
| ----------- | --------- |
| `primary`   | `#000000` |
| `secondary` | `#cccccc` |
| `success`   | `#00ff00` |
| `info`      | `#0000ff` |
| `warning`   | `#ffff00` |
| `danger`    | `#ff0000` |
| `light`     | `#eeeeee` |
| `dark`      | `#333333` |

For each colour the block sets `--bs-{name}` and `--bs-{name}-rgb`, and overrides `.text-{name}`, `.bg-{name}`, `.border-{name}`, `.link-{name}`, `.text-bg-{name}`, `.btn-{name}`, `.btn-outline-{name}` and `.alert-{name}`. Button text colour is computed from contrast. Hover and active states, alert tints and alert text are mixed from the base colour.

#### Flags

| Flag               | Default | Effect when on                                                                  |
| ------------------ | ------- | ------------------------------------------------------------------------------- |
| Rounded edges      | off     | Bootstrap radii apply. When off, every `--bs-border-radius*` token is `0`.      |
| CSS grid utilities | on      | Adds `.grid`, `.g-col-{bp}-{1..12}` and `.g-start-{bp}-{1..12}`.                 |
| Negative margins   | on      | Adds `.m-n{1..10}`, `.mt-n*`, `.mb-n*`, `.ms-n*`, `.me-n*`, `.mx-n*`, `.my-n*`. |

#### Spacers

The spacer scale extends Bootstrap's `0` to `5` with five extra steps. Margin and padding utilities (`m`, `mt`, `mb`, `ms`, `me`, `mx`, `my` and the `p` equivalents) are generated for `6` to `10`.

| Step | Value     |
| ---- | --------- |
| 6    | `4.5rem`  |
| 7    | `6rem`    |
| 8    | `7.5rem`  |
| 9    | `9rem`    |
| 10   | `12rem`   |

The grid breakpoints for `.g-col-*` are `sm` 576px, `md` 768px, `lg` 992px and `xl` 1200px.

---

### Code Rules

These rules are **mandatory** for HTML generated for the HTML Editor.

1. **One self-contained file**
   Output a single complete `index.html`. Do not split CSS or JS into separate local files. External resources load from a CDN only.

2. **Bootstrap 5.3 is the only design system**
   Use Bootstrap classes for layout, spacing, colour and components. Do not add Tailwind or any other CSS framework.

3. **Use the theme, do not redefine it**
   Use the palette through Bootstrap classes (`btn-primary`, `text-bg-dark`, `bg-light`). Do not write a `<style id="theme-tokens">` block and do not add `data-theme-font` links. The editor generates both and discards any copy found in an opened file.

4. **Custom CSS goes in one `<style>` element in `<head>`**
   Keep custom CSS small. The starter sets `body { padding-top: 4.5rem; }` to clear the fixed navbar; keep that rule while the navbar is `fixed-top`.

5. **Icons: FontAwesome 6.x only**
   Use `fa-solid`, `fa-regular` or `fa-brands` classes.

6. **Animations: animate.css, subtle**
   Use `animate__animated` with fades and minimal slides only.

7. **Exactly one top-level `<nav>` and one top-level `<footer>`**
   Both are direct children of `<body>`. The navbar comes first and the footer comes last, before the tail scripts.

8. **Every other top-level body element is a section**
   Wrap each page block in `<section id="section-N" class="py-5">` with a `.container` inside. Number the ids from `1` in document order. Navbar links point at these ids.

9. **Scripts go at the end of `<body>`**
   Put the Bootstrap bundle and all inline JS as top-level `<script>` elements after the footer. Put page JS inside a `DOMContentLoaded` listener. Do not place a top-level `<script>` between sections.

10. **Unique ids per component**
    Modals, accordions, collapses and carousels need unique ids (`modal-1`, `acc-1`, `acc-1-a`). Duplicated sections must not share ids.

11. **Accessibility attributes are required**
    Keep `aria-*`, `role`, `alt`, `scope` and `aria-label` attributes on Bootstrap components as in the Bootstrap documentation.

12. **The page must work without a backend**
    Forms, data and interactions are static or client-side. Do not call Tribe API endpoints or `/custom/*.php` scripts from an HTML-only website.

---

### How the Editor Reads a File

When a `.html` file is opened, the editor parses it with `DOMParser` and assigns every element to a pane. A generated file must follow the rules above so that this mapping is lossless.

| Source in the file                                        | Destination pane          |
| --------------------------------------------------------- | ------------------------- |
| Leading `<!doctype …>`                                    | Doctype                   |
| `lang` on `<html>` (falls back to `en`)                   | lang field                |
| `<head>` children that are not `STYLE`, `SCRIPT`, `LINK`  | Metadata                  |
| `<head>` `<style>` elements except `#theme-tokens`        | Styles (text joined)      |
| `<head>` `<link>` and `<script>` without `data-theme-font` | head Scripts             |
| Top-level `<body>` `<nav>` elements                       | Navbar                    |
| Top-level `<body>` `<footer>` elements                    | Footer                    |
| Top-level `<body>` `<script>` elements                    | tail Scripts              |
| Every other top-level `<body>` element                    | one Section each          |

Section labels are taken from the element's `id`, or its tag name when there is no `id`. The theme is not read from the file; the editor's current theme is applied to the opened document.

Consequences of this mapping:

- A top-level `<div>` or `<main>` becomes one large section. Use `<section>` blocks instead.
- A `<nav>` placed later in the body is moved into the Navbar pane, above all sections.
- A top-level `<script>` placed between sections is moved to the tail Scripts pane.
- Text nodes and comments directly inside `<body>` are dropped.

---

### Starter Document

This is the document the editor starts with, and the recommended skeleton for generated pages.

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="" />
    <title>Untitled document</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/animate.css@4.1.1/animate.min.css"
      rel="stylesheet"
    />
    <style>
      body {
        padding-top: 4.5rem;
      }
    </style>
  </head>
  <body id="top">
    <nav class="navbar navbar-expand-lg fixed-top bg-body-tertiary border-bottom">
      <div class="container">
        <a class="navbar-brand fw-bold" href="#top">Brand</a>
        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#nav"
          aria-controls="nav"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="nav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item"><a class="nav-link active" href="#section-1">Intro</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <section id="section-1" class="py-5">
      <div class="container">
        <div class="row align-items-center g-4">
          <div class="col-lg-7">
            <h1 class="display-5 fw-bold">Headline</h1>
            <p class="lead text-body-secondary">Supporting copy.</p>
            <a class="btn btn-primary" href="#section-1" role="button">Primary action</a>
          </div>
        </div>
      </div>
    </section>

    <footer class="border-top py-4 mt-5">
      <div class="container d-flex flex-wrap justify-content-between">
        <span class="text-body-secondary small">&copy; 2026</span>
        <a class="small link-body-emphasis text-decoration-none" href="#top">Back to top</a>
      </div>
    </footer>

    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"
    ></script>
    <script>
      document.addEventListener('DOMContentLoaded', () => {});
    </script>
  </body>
</html>
```

A new section added in the editor uses this template:

```html
<section id="section-N" class="py-5">
  <div class="container">
    <h2 class="h3 fw-bold mb-3">Heading</h2>
    <p class="text-body-secondary">Copy.</p>
  </div>
</section>
```

---

### Snippet Reference

The editor toolbar inserts these blocks. Generated markup should use the same patterns.

**Layout**

| Snippet              | Markup                                                                  |
| -------------------- | ----------------------------------------------------------------------- |
| Container            | `<div class="container">`                                               |
| Row + columns        | `<div class="row g-4">` with `.col-md-6` children                       |
| Section wrapper      | `<section class="py-5">` with a `.container`                            |
| Responsive card grid | `.row.row-cols-1.row-cols-md-3.g-4` with `.col > .card.h-100 > .card-body` |
| CSS grid             | `<div class="grid">` with `.g-col-12.g-col-md-6` children               |

**Components**

`card`, `alert`, `button`, `accordion`, `modal`, `table` (inside `.table-responsive`, `table-striped align-middle`), `list-group` (`list-group-flush`) and an animated block (`animate__animated animate__fadeInUp`).

**Inline**

`<strong>`, `<em>`, `<code>`, `<a href="#">` and `<!-- -->` comments.

---

### Prompting

Attach this README before asking an AI assistant to generate or edit an HTML-only website.

**New page:**

```
[Paste Flame README]

Build an HTML-only website for [project description].
Sections: [list of sections in order].
Return one complete index.html that follows the HTML-only Websites rules.
```

**Edit an existing page:**

```
[Paste Flame README]

Here is my index.html: [paste, or use the editor's Copy button]

[Describe the change]. Return the complete updated index.html.
```

**Edit one section:**

```
[Paste Flame README]

Here is section-3 from my HTML Editor: [paste the section pane]

[Describe the change]. Return only the <section> element.
```

The returned file is loaded with **Open .html** in the HTML Editor. A single returned section is pasted into its section pane.


---

## License

[GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html)