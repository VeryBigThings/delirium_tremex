# DeliriumTremex

DeliriumTremex is a library for standardized
[GraphQL](http://graphql.org/)
error handling through
[Absinthe](https://hex.pm/packages/absinthe).

## Idea

All errors should be returned it the `errors` field.

Errors have the following format:

```JSON
{
  "key": "username",
  "message": "Username is already taken",
  "messages": ["is already taken", "is too short"],
  "fullMessages": ["Username is already taken", "Username is to short"],
  "index": null,
  "subErrors": null
}
```

Field explantion:

* `key` - The key the error is attached to
* `message` - A single error message associated to the key
* `messages` - List of all the non-formatted error messages associated with the key
* `fullMessages` - List of all the formatted error messages associated with the key
* `index` - If the error is a nested error, specifies the index in the array at which the error occured
* `subErrors` - Contains all sub-errors of the key

Sub-errors are errors that occur in nested data. E.g. let's say that you are
creating an article together with an array of comments. If any of those
comments fail validation their errors would be returned in the `subErrors`
array.

E.g.: If the second comment's content is too short.

```JSON
{
  "key": "comments",
  "message": "Error validating all comments",
  "messages": null,
  "fullMessages": null,
  "index": null,
  "subErrors": [
    {
      "key": "content",
      "message": "Content is too short",
      "messages": ["is too short"],
      "fullMessages": ["Content is to short"],
      "index": 1,
      "subErrors" null
    }
  ]
}
```

Note that sub-errors can also have sub-errors which allows for basically
infinite nesting. This should satisfy most use cases.

## Integrations

Currently `DeliriumTremex` integrates with:

* [Ecto](https://github.com/elixir-ecto/ecto) - Automatically formats validation errors if passed a changeset.

## Installation

Add the following to your `mix.exs` file:

```Elixir
defp deps do
  [
    {:absinthe, "~> 1.4"},
    {:delirium_tremex, "~> 0.1.0"}
  ]
end
```

If you have other dependencies just append the contents of the list above to
your dependencies.

## Usage

In your GraphQL/Absinthe schema add the following middleware to the
queries/mutations for which you want the errors to be formatted.

e.g.

```Elixir
alias DeliriumTremex.Middleware.HandleErrors

query do
  field :current_account, type: :account do
    resolve &AccountResolver.current_account/2
    middleware HandleErrors # <-- This line adds the error handeling
  end
end

mutation do
  field :register, type: :account do
    arg :username, :string
    arg :password, :string

    resolve &AccountResolver.register/2
    middleware HandleErrors # <-- This line adds the error handeling
  end
end
```

## Contribution

For suggestions, fixes or questions, please feel free to open an issue.
Pull requests are always welcome.

## License

This project is licensed under the GPLv3. It comes with absolutely no
warranty. [The license is available in this repository.](/LICENSE.txt)
