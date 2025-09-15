

#let _get_fulltitle(
    title: none,
    subtitle: none,
) = {
    assert(title != none)

    if subtitle != none {
        [#title. #subtitle]
    } else {
        title
    }
}

#let _heading_builder(
    is_bold: true,
    is_smallcapsed: false,
    is_underlined: false,
    font_size: 16pt,
    line_len: 2cm,
    vspace: 0.5cm,
    body,
) = {
    if is_smallcapsed {
        body = smallcaps(body)
    }

    if is_underlined {
        body = underline(body)
    }

    let body = text(
        size: font_size,
        weight: if is_bold { "bold" } else { "regular" },
        body,
    )

    let line = line(length: line_len, stroke: if is_bold { 1pt } else { 0.5pt })

    v(vspace, weak: true)
    grid(
        columns: (1fr, auto, 1fr),
        align: (horizon + right, horizon + center, horizon + left),
        column-gutter: 5pt,
        line, body, line,
    )
    v(vspace, weak: true)
}

#let _with_set_heading_style(body) = {
    show heading.where(level: 1): h => _heading_builder(
        is_bold: true,
        font_size: 16pt,
        line_len: 3cm,
        h.body,
    )

    show heading.where(level: 2): h => _heading_builder(
        is_bold: false,
        is_smallcapsed: true,
        font_size: 14pt,
        line_len: 2cm,
        h.body,
    )

    show heading.where(level: 3): h => _heading_builder(
        is_bold: false,
        is_smallcapsed: true,
        is_underlined: false,
        font_size: 12pt,
        line_len: 1cm,
        h.body,
    )

    show heading.where(level: 4): h => _heading_builder(
        is_bold: false,
        is_smallcapsed: true,
        is_underlined: false,
        font_size: 12pt,
        line_len: 0cm,
        h.body,
    )

    body
}

#let _title(
    title: none,
    subtitle: none,
    author: none,
    title_fmt: "page",
) = {
    assert(title != none)
    assert(("page", "block", none).contains(title_fmt))

    if title_fmt == "page" {
        align(center + horizon)[
            #text(27pt, weight: "bold", title)

            #if subtitle != none {
                text(23pt, weight: "bold", subtitle)
            }

            #if author != none {
                text(20pt, author)
            }
        ]

        pagebreak(weak: true)
    } else if title_fmt == "block" {
        align(center)[
            #text(20pt, weight: "bold", title)

            #if subtitle != none {
                text(16pt, weight: "bold", subtitle)
            }

            #if author != none {
                text(16pt, author)
            }
        ]
    }
}

#let _with_set_page_style(
    fulltitle: none,
    body,
) = {
    set page(
      header: align(center)[
          #fulltitle
          #line(length: 100%, stroke: 0.5pt)
      ],
      footer: align(center, {
          line(length: 100%, stroke: 0.5pt)
          context counter(page).display("1")
      }),
    )

    body
}

#let _with_set_text_style(body) = {
    set text(size: 11pt)
    set par(justify: true, spacing: 1.5em)

    set table(align: left)

    body
}

#let conf(
    // A title of the document
    title: none,
    // A subtitle of the document
    subtitle: none,
    // An author of the document
    author: none,
    // A format of the title.
    // On of: "page", "block", none
    title_fmt: "page",
    // Arguments to be forwarded to outline.
    // Set to `none` to disable outline.
    // Set to `arguments()` not to provide any arguments.
    outline_args: arguments(indent: 0.7cm, depth: 3),
    // Bibliography sources
    bib_sources: none,
    // A body of the document
    body,
) = {
    let fulltitle = _get_fulltitle(title: title, subtitle: subtitle)

    set document(title: fulltitle, author: author)

    set text(lang: "ru")

    _title(
        title: title,
        subtitle: subtitle,
        author: author,
        title_fmt: title_fmt,
    )

    if outline_args != none {
        outline(..outline_args)
        pagebreak(weak: true)
    }

    show: _with_set_text_style
    show: _with_set_page_style.with(fulltitle: fulltitle)
    show: _with_set_heading_style

    body

    if bib_sources != none {
        bibliography(bib_sources, full: true)
    }
}
