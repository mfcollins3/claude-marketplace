# Claude Marketplace

This repository is a [Claude Code plugin marketplace](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
maintained by [Michael F. Collins, III](https://michaelfcollins3.dev). It
hosts a growing collection of plugins that extend
[Claude Code](https://claude.com/claude-code) with skills, commands, and
agents for real-world software development workflows.

## Plugins

| Plugin | Description |
| --- | --- |
| [Software Architecture](plugins/software-architecture/README.md) | Software architecture tools intended to help you build better software products. |
| [Product Management](plugins/product-management/README.md) | Tools for writing PRDs, creating GitHub Projects, and scoping releases. |

## Installing the Marketplace

Add this repository as a plugin marketplace in Claude Code:

```bash
/plugin marketplace add mfcollins3/claude-marketplace
```

You can also add it using the full repository URL:

```bash
/plugin marketplace add https://github.com/mfcollins3/claude-marketplace
```

## Installing a Plugin

Once the marketplace has been added, install a plugin by name using the
`/plugin install` command, qualified with the marketplace name
(`michaelfcollins3`):

```bash
/plugin install software-architecture@michaelfcollins3
```

Alternatively, run `/plugin` without arguments to browse the available
plugins in this marketplace and install them interactively.

## License

This repository is licensed under the [MIT License](LICENSE.md).
