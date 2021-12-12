lib:
let myLib = import ./.;
in lib.extend (self: super: { fahmi = myLib { lib = super; }; })
