# GitHub Style Generator

This tool generates the GitHub style with the official GitHub style package.
Node/npm are required, with npm 5 or above to make use of `package-lock.json`.

The Xcode `Transpile Styles` phase calls this generator while building MacDown.
Install the Node dependencies before release-quality builds so the generated
`GitHub-2020.css` stylesheet is not left empty:

```bash
npm install
make
```

To update the upstream style package, bump the package name in `Makefile`, and
run:

```bash
npm install
npm update primer-markdown
make
```
