let
  # Define your users and systems here
  atreyas = "age1335u3awp0l7228tgle30f2z7mpmqgulrey2q2mfm3pv4ra45lvjs4el2d2";

  users = [ atreyas ];
  systems = [
    # Add your system's SSH host keys here if needed
  ];
  allKeys = users ++ systems;
in
{
  "github-token.age".publicKeys = allKeys;
}
