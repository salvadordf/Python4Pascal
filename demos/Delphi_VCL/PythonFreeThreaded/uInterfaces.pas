unit uInterfaces;

interface

type
  IMainForm = interface
    function GetValue(ModIdx, i: integer): integer;
    function Swap(ModIdx, i, j: integer): boolean;
  end;

implementation

end.
