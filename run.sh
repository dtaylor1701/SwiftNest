rm -rf swift-package-collection-generator
git clone git@github.com:apple/swift-package-collection-generator.git
swift run --package-path swift-package-collection-generator package-collection-generate packages.json collection.json
