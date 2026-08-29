public class LibraryView : Gtk.Box {
    private Gee.ArrayList<Book> _books = new Gee.ArrayList<Book> ();
    public Gee.ArrayList<Book> books {
        get { return _books; }
        set {
            _books = value;
            build_list ();
        }
    }
    private Gtk.ListBox list_box = new Gtk.ListBox ();

    public LibraryView () {
        Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);
    }

    construct {
        list_box.add_css_class ("boxed-list");
        list_box.selection_mode = Gtk.SelectionMode.NONE;
        list_box.margin_top = 10;
        list_box.margin_bottom = 10;
        list_box.margin_start = 10;
        list_box.margin_end = 10;
        list_box.valign = Gtk.Align.START;
        list_box.row_activated.connect ((row) => {
            var index = row.get_index ();
            stdout.printf("Index selected... %d", index);
        });

        var scrolled_window = new Gtk.ScrolledWindow ();
        scrolled_window.vexpand = true;
        scrolled_window.child = list_box;

        append (scrolled_window);

        build_list ();
    }

    private void build_list () {
        foreach (var book in books) {
            var row = new Adw.ActionRow ();
            row.title = book.title;
            row.subtitle = book.authors;
            row.add_suffix (new Gtk.Label (book.rating.to_string ()));
            list_box.append (row);
        }
    }
}
