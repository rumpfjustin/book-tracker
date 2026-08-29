public class DashboardView : Gtk.Box {
    public DashboardView () {
        Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);
    }

    construct {
        append (new Gtk.Label ("Dashboard View"));
    }
}
