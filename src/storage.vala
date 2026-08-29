public class Storage : GLib.Object {
    private string data_dir;
    private string file_path;
    public Gee.ArrayList<Book> books { get; default = new Gee.ArrayList<Book>(); }

    public Storage () {
        data_dir = Path.build_filename (Environment.get_user_data_dir (), "book-tracker");
        DirUtils.create_with_parents (data_dir, 0700);
        file_path = Path.build_filename (data_dir, "books.json");

        var parser = new Json.Parser ();
        try {
            parser.load_from_file (file_path);
            var root = parser.get_root ().get_array ();
            foreach (var node in root.get_elements ()) {
                var obj = node.get_object ();
                var book = new Book () {
                    id = (uint16) obj.get_int_member ("id"),
                    title = obj.get_string_member ("title"),
                    authors = obj.get_string_member ("authors"),
                    print_pages = (uint16) obj.get_int_member ("print_pages"),
                    publication_year = (uint16) obj.get_int_member ("publication_year"),
                    publisher = obj.get_string_member ("publisher"),
                    status = BookStatus.from_string (obj.get_string_member ("status")),
                    date_started = obj.get_string_member ("date_started"),
                    date_finished = obj.get_string_member ("date_finished"),
                    rating = (uint16) obj.get_int_member ("rating")
                };
                books.add (book);
            }
        } catch (Error e) {
            stderr.printf ("WARNING: %s\n", e.message);
        }
    }

    public void add_book (Book book) {
        book.id = (uint16) books.size + 1;
        books.add (book);
        save ();
    }

    public void save () {
        var array = new Json.Array ();
        foreach (var book in books) {
            var obj = to_json_object (book);
            array.add_object_element (obj);
        }

        var root = new Json.Node (Json.NodeType.ARRAY);
        root.set_array (array);

        var generator = new Json.Generator ();
        generator.root = root;
        generator.pretty = true;

        try {
            generator.to_file (file_path);
        } catch (Error e) {
            stderr.printf ("WARNING: %s", e.message);
        }
    }

    private Json.Object to_json_object (Book book) {
        var obj = new Json.Object ();
        obj.set_int_member ("id", book.id);
        obj.set_string_member ("title", book.title);
        obj.set_string_member ("authors", book.authors);
        obj.set_int_member ("print_pages", book.print_pages);
        obj.set_int_member ("publication_year", book.publication_year);
        obj.set_string_member ("publisher", book.publisher);
        obj.set_string_member ("status", book.status.to_string ());
        obj.set_string_member ("date_started", book.date_started);
        obj.set_string_member ("date_finished", book.date_finished);
        obj.set_int_member ("rating", book.rating);
        return obj;
    }
}
