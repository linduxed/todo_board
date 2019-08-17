# TodoBoard

Terminal user interface for viewing `todo.txt` files. Serves as a replacement for [`todo.txt-cli`](https://github.com/ginatrapani/todo.txt-cli/) along with various add-ons for it.

## Setup

1. Clone the repo
1. `mix deps.get`
1. `cp config/config.exs.sample config/config.exs`. Change paths to file in `config/config.exs` if necessary.

## Running application

The application is started with the following command:

```bash
mix run --no-halt
```

## Generating documentation

```bash
mix docs
```

View the documentation by opening `doc/index.html` in your preferred browser.
