public class BookDialog : Adw.Dialog {
    public signal void saved (Book book);
    private Book? book;

    private Adw.EntryRow title_row;
    private Adw.EntryRow authors_row;
    private Adw.SpinRow printed_pages_row;
    private Adw.SpinRow publication_year_row;
    private Adw.EntryRow publisher_row;
    private Adw.ComboRow status_row;
    private Adw.ActionRow date_started_row;
    private Adw.ActionRow date_finished_row;
    private Adw.SpinRow rating_row;

    private string date_started = "";
    private string date_finished = "";

    public BookDialog (Book? book) {
        Object ();
        this.book = book == null ? new Book () : book;
        build_ui ();
    }

    private void build_ui () {
        title = book == null ? "Add Book" : "Edit Book";
        content_width = 700;
        follows_content_size = true;

        var cancel_button = new Gtk.Button.with_label ("Cancel");
        cancel_button.clicked.connect (() => close ());
        var save_button = new Gtk.Button.with_label ("Save");
        save_button.clicked.connect (() => save() );
        save_button.add_css_class ("suggested-action");

        var header = new Adw.HeaderBar ();
        header.pack_start (cancel_button);
        header.pack_end (save_button);
        header.show_start_title_buttons = false;
        header.show_end_title_buttons = false;
        header.title_widget = new Adw.WindowTitle (title, "");

        var toolbar_view = new Adw.ToolbarView ();
        toolbar_view.add_top_bar (header);

        var scrolled_window = new Gtk.ScrolledWindow ();
        scrolled_window.propagate_natural_height = true;
        scrolled_window.propagate_natural_width = true;

        var clamp = new Adw.Clamp ();
        clamp.width_request = 700;
        clamp.margin_top = 10;
        clamp.margin_bottom = 20;
        clamp.margin_start = 10;
        clamp.margin_end = 10;

        var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);

        var book_group = new Adw.PreferencesGroup ();
        book_group.title = "Book";
        title_row = build_entry_row ("Title");
        authors_row = build_entry_row ("Author(s)");
        book_group.add (title_row);
        book_group.add (authors_row);

        var imprint_extent_group = new Adw.PreferencesGroup ();
        imprint_extent_group.title = "Imprint/Extent";
        printed_pages_row = build_pages_row ();
        publication_year_row = build_year_row ();
        publisher_row = build_entry_row ("Publisher");
        imprint_extent_group.add (printed_pages_row);
        imprint_extent_group.add (publication_year_row);
        imprint_extent_group.add (publisher_row);

        var progress_group = new Adw.PreferencesGroup ();
        progress_group.title = "Progress";
        status_row = build_status_row ();
        date_started_row = build_date_row ("Date Started");
        date_finished_row = build_date_row ("Date Finished");
        rating_row = build_rating_row ();
        progress_group.add (status_row);
        progress_group.add (date_started_row);
        progress_group.add (date_finished_row);
        progress_group.add (rating_row);

        toolbar_view.content = scrolled_window;
        scrolled_window.child = clamp;
        clamp.child = content_box;
        content_box.append (book_group);
        content_box.append (imprint_extent_group);
        content_box.append (progress_group);

        child = toolbar_view;
    }

    private Adw.EntryRow build_entry_row (string title) {
        var entry_row = new Adw.EntryRow ();
        entry_row.title = title;
        return entry_row;
    }

    private Adw.SpinRow build_year_row () {
        var adjustment = new Gtk.Adjustment (2000, 1900, 2100, 1, 10, 0);
        var spin_row = new Adw.SpinRow (adjustment, 1.0, 0);
        spin_row.title = "Publication Year";
        return spin_row;
    }

    private Adw.SpinRow build_pages_row () {
        var adjustment = new Gtk.Adjustment (200, 1, 5000, 1, 10, 0);
        var spin_row = new Adw.SpinRow (adjustment, 1.0, 0);
        spin_row.title = "Printed Pages";
        return spin_row;
    }

    private Adw.ComboRow build_status_row () {
        var combo_row = new Adw.ComboRow ();
        combo_row.title = "Status";
        combo_row.model = new Gtk.StringList (BookStatus.to_string_array());
        return combo_row;
    }

    private Adw.SpinRow build_rating_row () {
        var adjustment = new Gtk.Adjustment (0, 0, 5, 1, 10, 0);
        var spin_row = new Adw.SpinRow (adjustment, 1.0, 0);
        spin_row.title = "Rating";
        return spin_row;
    }

    public Adw.ActionRow build_date_row (string title) {
        var action_row = new Adw.ActionRow ();
        action_row.title = title;

        var label = new Gtk.Label("");

        var popover = new Gtk.Popover ();
        var calendar = new Gtk.Calendar ();
        calendar.day_selected.connect (() => {
            label.set_text (calendar.get_date ().to_string ());
            if (title == "Date Started") {
                date_started = calendar.get_date ().to_string ();
            } else {
                date_finished = calendar.get_date ().to_string ();
            }
            popover.set_visible (false);
        });
        popover.child = calendar;

        var calendar_button = new Gtk.MenuButton ();
        calendar_button.icon_name = "x-office-calendar-symbolic";
        calendar_button.valign = Gtk.Align.CENTER;
        calendar_button.tooltip_text = "Choose Date";
        calendar_button.add_css_class ("flat");
        calendar_button.popover = popover;

        var clear_button = new Gtk.Button.from_icon_name ("edit-clear-symbolic");
        clear_button.valign = Gtk.Align.CENTER;
        clear_button.tooltip_text = "Clear Date";
        clear_button.add_css_class ("flat");
        clear_button.clicked.connect (() => {
            label.set_text ("");
        });

        action_row.add_suffix (label);
        action_row.add_suffix (calendar_button);
        action_row.add_suffix (clear_button);
        return action_row;
    }

    private void save () {
        book.title = title_row.text;
        book.authors = authors_row.text;
        book.print_pages = (uint16) printed_pages_row.value;
        book.publication_year = (uint16) publication_year_row.value;
        book.publisher = publisher_row.text;
        book.rating = (uint16) rating_row.value;
        book.date_started = date_started;
        book.date_finished = date_finished;

        var status = status_row.selected_item as Gtk.StringObject;
        if (status != null) {
            book.status = BookStatus.from_string (status.get_string ());
        }

        saved (book);
        this.close ();
    }
}
