# Introduction

This GitHub Action starts TigerGraph Server with the default ports (9000 and 14240).

The TG Server  version must be specified using the tgserver-version input. The used version must exist in the published tigergraph Docker hub tags. Default value is latest, other popular choices are 3.6.0, 3.7.0, 3.8.0.

This is useful when running tests against a TigerGraph Server database.

## Example usage

```yaml
name: Run tests

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        tgserver-version: ['3.7.0', '3.8.0']

    steps:
    - name: Git checkout
      uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Start Tigergraph Server
      uses: marcosconceicao/tigergraph-github-action@v2
      with:
        tgserver-version: ${{ matrix.tgserver-version }}

    - run: npm install

    - run: npm test
      env:
        CI: true
```