public class Book : GLib.Object {
    public uint16 id { get; set; default = 0; }
    public string title { get; set; default = ""; }
    public string authors { get; set; default = ""; }
    public uint16 print_pages { get; set; default = 0; }
    public uint16 publication_year { get; set; default = 0; }
    public string publisher { get; set; default = ""; }
    public BookStatus status { get; set; default = BookStatus.TO_READ; }
    public string date_started { get; set; default = ""; }
    public string date_finished { get; set; default = ""; }
    public uint16 rating { get; set; default = 0; }
}

public enum BookStatus {
    READING,
    TO_READ,
    READ;

    public static string[] to_string_array () {
        return { "To Read", "Reading", "Read" };
    }

    public string to_string () {
        switch (this) {
            case READING: return "Reading";
            case TO_READ: return "To Read";
            case READ: return "Read";
            default: assert_not_reached ();
        }
    }

    public static BookStatus from_string (string str) {
        switch (str) {
            case "Reading": return READING;
            case "To Read": return TO_READ;
            case "Read": return READ;
            default: assert_not_reached ();
        }
    }
}
