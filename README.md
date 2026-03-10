# SwiftNest

SwiftNest is a curated Swift Package Collection that provides a unified way to discover and integrate a suite of Swift utility libraries and tools. This project automates the generation of the `collection.json` file required by Xcode and the Swift Package Manager.

## Purpose

The primary goal of SwiftNest is to maintain an up-to-date Swift Package Collection for a specific set of libraries, ensuring they are easily accessible for development across Apple platforms (iOS, macOS, tvos, watchos).

## Components

The repository is organized into the following key components:

- **`packages.json`**: The source configuration file. It contains the metadata and URLs for all Swift packages included in the collection.
- **`collection.json`**: The generated Swift Package Collection file. This is the output used by Xcode and `swift package` commands to import the collection.
- **`run.sh`**: A utility script used to refresh the collection. It clones the generator tool and executes the build process.
- **`swift-package-collection-generator/`**: A local instance of the Apple/community tool used to transform the package list into the standardized collection format.

## Included Packages

The collection currently includes several utility libraries, such as:
- **BlueJay**: A core utility library.
- **Goose**: Miscellaneous Swift utilities.
- **Nuthatch, Pigeon, Parakeet, Twigs, Weaver, Woodpecker**: Various specialized Swift components.
- **XCAssetFill**: A tool for managing Xcode asset catalogs.

## Installation & Usage

### Adding to Xcode
To use this collection in your development workflow:
1. Open Xcode.
2. Go to **File > Add Packages...**.
3. Click the **+** button at the bottom left and select **Add Swift Package Collection**.
4. Enter the URL where your `collection.json` is hosted (or use the local path if applicable).

### Generating the Collection
If you need to update the collection or add new packages:
1. Ensure you have the Swift toolchain installed.
2. Edit `packages.json` to include or remove package URLs.
3. Run the generation script:
   ```bash
   ./run.sh
   ```

## Dependencies

- **Swift 5.9+**: Required for running the generator and for the packages within the collection.
- **Git**: Required by `run.sh` to fetch the latest generator tool.
- **swift-package-collection-generator**: The underlying tool provided by Apple for collection metadata generation.
