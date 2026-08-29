public class BookTrackerWindow : Adw.ApplicationWindow {
    private Storage storage = new Storage ();
    private Gtk.Stack content_stack = new Gtk.Stack ();
    private LibraryView library_view = new LibraryView ();
    private DashboardView dashboard_view = new DashboardView ();
    private Adw.WindowTitle content_window_title = new Adw.WindowTitle ("", "");

    public BookTrackerWindow (Gtk.Application app) {
        Object (application: app, default_width: 1000, default_height: 800, title: "Book Tracker");
        build_ui ();
    }

    private void build_ui () {
        var split_view = new Adw.NavigationSplitView ();
        split_view.sidebar = build_sidebar_view ();
        split_view.content = build_content_view ();
        content = split_view;
    }

    private Adw.NavigationPage build_sidebar_view () {
        var header = new Adw.HeaderBar ();
        header.title_widget = new Adw.WindowTitle ("Book Tracker", "");

        var nav_list = new Gtk.ListBox ();
        nav_list.add_css_class ("navigation-sidebar");
        nav_list.selection_mode = Gtk.SelectionMode.SINGLE;
        nav_list.append (build_nav_row ("Library", "open-book-symbolic"));
        nav_list.append (build_nav_row ("Dashboard", "grid-filled-symbolic"));

        nav_list.row_selected.connect ((row) => {
            if (row == null) {
                return;
            }
            var index = row.get_index ();
            if (index == 0) {
                content_stack.set_visible_child (library_view);
                content_window_title.title = "Library";
            } else if (index == 1) {
                content_stack.set_visible_child (dashboard_view);
                content_window_title.title = "Dashboard";
            }
        });

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.content = nav_list;
        toolbar_view.add_top_bar (header);
        return new Adw.NavigationPage (toolbar_view, "Sections");
    }

    private Gtk.ListBoxRow build_nav_row (string label_text, string icon_name) {
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        box.append (new Gtk.Image.from_icon_name (icon_name));
        box.append (new Gtk.Label (label_text));
        var row = new Gtk.ListBoxRow ();
        row.child = box;
        return row;
    }

    public Adw.NavigationPage build_content_view () {
        var add_button = new Gtk.Button.from_icon_name ("list-add-symbolic");
        add_button.tooltip_text ="Add Book";
        add_button.clicked.connect (() => open_dialog (null));

        var header = new Adw.HeaderBar ();
        header.title_widget = content_window_title;
        header.pack_end (add_button);

        library_view.books = storage.books;

        content_stack.add_child (library_view);
        content_stack.add_child (dashboard_view);

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.content = content_stack;
        toolbar_view.add_top_bar (header);
        return new Adw.NavigationPage (toolbar_view, "Content");
    }

    private void open_dialog (Book? book) {
        var dialog = new BookDialog (book);
        dialog.saved.connect ((book) => {
            storage.add_book (book);
            storage.save ();
        });
        dialog.present (this);
    }
}
