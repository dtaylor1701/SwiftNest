# SwiftNest Design Document

## 1. Overview
SwiftNest is a curated Swift Package Collection designed to provide a unified discovery and integration mechanism for a specialized suite of Swift utility libraries and tools. It automates the generation and maintenance of the `collection.json` manifest, adhering to the [Swift Package Collection](https://github.com/apple/swift-package-manager/blob/main/Documentation/PackageCollections.md) format.

## 2. High-Level Architecture
The project follows a simple "Source -> Transform -> Output" architectural pattern:

- **Source Manifest (`packages.json`)**: A high-level, human-readable JSON file containing the canonical list of package URLs to be included in the collection.
- **Generator Engine (`swift-package-collection-generator`)**: A specialized Swift CLI tool (cloned and executed during the build process) that processes the source manifest. It performs metadata enrichment by querying package repositories for tags, versions, and manifest details.
- **Output Artifact (`collection.json`)**: The final, machine-readable package collection manifest consumed by Xcode and the Swift Package Manager.
- **Automation Layer (`run.sh`)**: A shell-based orchestration layer that manages dependencies (cloning the generator) and executes the build pipeline.

## 3. Technical Stack
- **Language**: Swift (5.9+) for the generator and package manifests.
- **Build System**: Swift Package Manager (SPM).
- **Orchestration**: POSIX-compliant Shell (sh/bash).
- **Environment**: macOS/Linux (compatible with Docker for CI/CD environments).
- **Dependency Management**: SPM for internal library dependencies; Git for external tool fetching.

## 4. Core Design Philosophies
- **Infrastructure as Code**: The package collection is defined declaratively in `packages.json`, allowing version-controlled management of the entire collection state.
- **Automation-First**: No manual editing of the complex `collection.json` schema is permitted. All updates are performed via the automated generation pipeline.
- **Minimalism**: The root repository remains lightweight, containing only the source configuration and automation scripts, while fetching the heavy generation logic on-demand.
- **Reliability through Enrichment**: The generator ensures that only valid, tag-compliant package versions are included in the final collection by verifying them against their remote git origins.

## 5. Data Models & Schema
### 5.1. Input Schema (`packages.json`)
A simple array-based structure designed for ease of maintenance:
```json
{
  "name": "Collection Name",
  "author": { "name": "Author Name" },
  "packages": [
    { "url": "https://github.com/user/repo.git" }
  ]
}
```

### 5.2. Output Schema (`collection.json`)
The output follows the standard Swift Package Collection v1.0 schema, including:
- **Collection Metadata**: Name, author, generation timestamp.
- **Package Details**: Summary, README URLs, and keywords.
- **Version Manifest**: A deep hierarchy of versions, each containing platform requirements, products, targets, and tool versions.

## 6. Components & Interaction
1. **Developer**: Updates `packages.json` with new package URLs.
2. **`run.sh`**:
   - Cleans previous generator instances.
   - Clones the `swift-package-collection-generator` repository.
   - Executes `swift run package-collection-generate`.
3. **Generator CLI**:
   - Parses `packages.json`.
   - Fetches repository metadata for each URL.
   - Validates `Package.swift` manifests for each tagged version.
   - Compiles and writes the final `collection.json`.

## 7. Technical Specifications
- **Concurrency**: The generator tool utilizes Swift Concurrency (where applicable) to fetch metadata from multiple repositories in parallel, optimizing performance for large collections.
- **Error Handling**: The generation process is transactional. If a package URL is unreachable or contains invalid manifests, the generator reports errors and exits with a non-zero status code to prevent the deployment of a corrupted collection.
- **Persistence**: The state is entirely file-based. No external database is required.

## 8. Testing Strategy
Testing is primarily focused on the generation logic within the `swift-package-collection-generator` submodule:
- **Unit Tests**: Validate JSON parsing, URL validation, and version sorting logic.
- **Integration Tests**: Verify the end-to-end generation flow using mock package repositories.
- **Validation**: The final `collection.json` can be validated against the official Swift Package Collection JSON schema.

## 9. Security & Scalability
- **Integrity**: The generation process verifies git tags and commit hashes, ensuring the collection points to immutable versions of the included libraries.
- **Scalability**: The architecture scales linearly with the number of packages. Since the output is a static JSON file, it can be hosted on any CDN or static hosting service (e.g., GitHub Pages) for high availability.
- **Network Security**: All repository interactions are performed over HTTPS/SSH, leveraging standard git security protocols.
