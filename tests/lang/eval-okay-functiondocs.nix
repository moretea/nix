{
  single = builtins.functionDocs (a: /*!single*/ a);
  single_nope = builtins.functionDocs (a: a);
  nested = builtins.functionDocs (a: /*!nested*/ b: a);
  formals1 = builtins.functionDocs ({a}: /*!formals1*/ a);
  formals2 = builtins.functionDocs ({a} @ q: /*!formals2*/ a);
  formals3 = builtins.functionDocs (q @ {a}: /*!formals3*/ a);
  formals_nope = builtins.functionDocs (q @ {a}:  a);
}
