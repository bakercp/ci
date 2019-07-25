#!/usr/bin/env bash

# Build and install a recent version of doxygen.
git clone --depth=1 --branch Release_1_8_15 https://github.com/doxygen/doxygen.git; 
mkdir -p doxygen/build
pushd doxygen/build > /dev/null
cmake -G "Unix Makefiles" ..; 
make -s && sudo make install; 
popd > /dev/null

# Prepare documentation in root directory.
# Remove docs/ prefix from all .md files for linking.
sed -i'.bak' -e 's|docs/||g' *.md 
# Convert any ./src/ style links to the fully qualified URL.
sed -i'.bak' -e 's|[(]\.\(\.*/\)|(https://github.com/'"$TRAVIS_REPO_SLUG"/tree/master'\1|g' *.md

# Move into the docs directory.
cd docs/
# Get the docs from the root directory.
cp ../*.md .
# Fix any links to the Github pages.
sed -i'.bak' -e 's|[(]\.\./\.\.|(https://github.com/'"$TRAVIS_REPO_SLUG"'|g' *.md;
# Generate the documentation.
doxygen Doxyfile 
# Github pages will discard files beginning w/ underscores without this.
touch html/.nojekyll 
