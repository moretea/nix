let
  x = {
    a = /*! test */ 1;
  };
in builtins.attrDocs (x)
