# OpenWorm

`OpenWorm` is a simple viewer app that allow to search for books using the OpenLibrary API.

## How To Run

There are no third party dependencies. Simply build and run the project.

## Project Highlights

### Features

The following features are improvements on the requirements that I believe enhance the user experience:

- Home screen with welcome text when the search is not active; 
- Loading indicator when fetching data;
- Empty state when the search returns no results;
- Support for both Dark Mode and Dynamic Type;
- A book with multiple authors will appear in a section for each one of them (that's a feature, not a bug!);
- Display user readable error messages.

### Technical

- No 3rd party library — reduces the app size;
- Support for iOS 13 and up — like an app I could release in the App Store today;
- Rudimentary image loading and in-memory cache system;
- Networking layer with a single generic `fetch` method and specialized `Endpoint` enums;
- Update the cover constraints to match the aspect ratio of the remote image (detail screen);
- Created a number of custom labels to reuse throughout the project, all supporting live changes in Text Size;

## App Limitations

The app is following as closely as possible the requirements as layed down in the Take Home Exercise document. Except for the detail screen that doesn't show a lot of information due to lack of time (and sleep as can be guessed by the commits time).

## Future Improvements

This project is only laying down some of the foundations for a more complex app. Given more time (weeks or months), here are future improvements should be added:

- Retry option when a fetch request fails;
- Paging the search results, but given the requirements of having categories this may be hard without changing how we display the data;
- Move the image cache system out of the image view class & add configuration (ie. on-disk cache, cache size, ...);
- Load the same cover for a book on both the search and details screens;
- Fetch more information to display on the detail screen;
- Localize & internationalize the app;
- Fix bug where the category header can be partially (or entirely) out of the right edge of the screen when there are less than three books in a category;
- Improve author names parsing for a more robust app;
- Add a completion handler when remote images are downloaded to, for example, update the aspect ratio constraint on the receiving image view — instead of potentially creating a new `NSLayoutConstraint` object multiple times in `layoutSubviews`, like I did, wasting CPU cycles.
