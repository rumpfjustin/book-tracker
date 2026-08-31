public class BookTrackerApplication : Adw.Application {
    public BookTrackerApplication () {
        Object (application_id: "com.github.rumpfjustin.book-tracker", flags: ApplicationFlags.DEFAULT_FLAGS);
    }

    protected override void activate () {
        var window = active_window;
        if (window == null) {
            window = new BookTrackerWindow (this);
        }
        window.present ();
    }
}

int main (string[] args) {
    var app = new BookTrackerApplication ();
    return app.run (args);
}
