project('book-tracker', 'vala', 'c', version: '0.1.0', meson_version: '>= 0.62.0')

sources = [
  'src/application.vala',
  'src/window.vala',
  'src/book.vala',
  'src/storage.vala',
  'src/library-view.vala',
  'src/dashboard-view.vala',
  'src/book-dialog.vala'
]

dependencies = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.5'),
  dependency('gee-0.8'),
  dependency('json-glib-1.0')
]

executable('book-tracker', sources, dependencies: dependencies, install: true)
