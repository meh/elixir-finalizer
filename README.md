Finalizers for Elixir
=====================
This wrapper uses the awesome [resource][1] NIF hack.

Example
-------

```elixir
spawn fn ->
  Finalizer.define fn ->
    IO.puts "I'm dead :("
  end
end
```

[1]: https://github.com/tonyrog/resource
