unit uP4P.PyModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>Helper class for all the PyModule_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-objects">See the article about Module Objects.</see></para>
  /// <para><see href="https://docs.python.org/3/reference/datamodel.html#modules">See the article about Modules.</see></para>
  /// </remarks>
  TPyModule = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a module object, or a subtype of a
      /// module object. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a module object, but not a subtype
      /// of PyModule_Type. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new module object with module.__name__ set to name.
      /// The module's __name__, __doc__, __package__ and __loader__ attributes
      /// are filled in (all but __name__ are set to None). The caller is
      /// responsible for setting a __file__ attribute.</para>
      /// <para>Return nil with an exception set on error.</para>
      /// </summary>
      class function NewObject(const name_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyModule.NewObject(), but the name is a string
      /// instead of a Unicode object.</para>
      /// </summary>
      class function New(const name_: string): IPyObject;
      /// <summary>
      /// <para>Return the dictionary object that implements module's namespace;
      /// this object is the same as the __dict__ attribute of the module
      /// object. If module is not a module object (or a subtype of a module
      /// object), SystemError is raised and nil is returned.</para>
      /// <para>It is recommended extensions use other PyModule_* and PyObject_*
      /// functions rather than directly manipulate a module's __dict__.</para>
      /// <para>The returned reference is borrowed from the module; it is valid
      /// until the module is destroyed.</para>
      /// </summary>
      class function GetDict(const module_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return module's __name__ value. If the module does not provide
      /// one, or if it is not a string, SystemError is raised and nil is
      /// returned.</para>
      /// </summary>
      class function GetNameObject(const module_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyModule.GetNameObject() but return the name as a
      /// string.</para>
      /// <para>The returned buffer is only valid until the module is renamed or
      /// destroyed. Note that Python code may rename a module by setting its
      /// __name__ attribute.</para>
      /// </summary>
      class function GetName(const module_: IPyObject): string; overload;
      /// <summary>
      /// <para>Similar to TPyModule.GetNameObject() but return the name encoded
      /// to 'utf-8'.</para>
      /// <para>The returned buffer is only valid until the module is renamed or
      /// destroyed. Note that Python code may rename a module by setting its
      /// __name__ attribute.</para>
      /// </summary>
      class function GetName(const module_: PPyObject): AnsiString; overload;
      /// <summary>
      /// <para>Return the name of the file from which module was loaded using
      /// module's __file__ attribute. If this is not defined, or if it is not
      /// a string, raise SystemError and return nil; otherwise return a
      /// reference to a Unicode object.</para>
      /// </summary>
      class function GetFilenameObject(const module_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a pointer to the PyModuleDef struct from which the module
      /// was created, or nil if the module wasn't created from a
      /// definition.</para>
      /// <para>On error, return nil with an exception set.
      /// Use TPyErr.Occurred() to tell this case apart from a missing
      /// PyModuleDef.</para>
      /// </summary>
      class function GetDef(const module_: IPyObject): PPyModuleDef;
      /// <summary>
      /// <para>Return the "state" of the module, that is, a pointer to the
      /// block of memory allocated at module creation time, or nil.
      /// See PyModuleDef.m_size.</para>
      /// </summary>
      class function GetState(const module_: IPyObject): Pointer;
      /// <summary>
      /// <para>Add an object to module as name. This is a convenience function
      /// which can be used from the module's initialization function.
      /// <para>On success, return True. On error, raise an exception and return
      /// False.</para>
      /// <para>Example usage:</para>
      /// <code>
      /// static int
      /// add_spam(PyObject *module, int value)
      /// {
      ///     PyObject *obj = PyLong_FromLong(value);
      ///     if (obj == NULL) {
      ///         return -1;
      ///     }
      ///     int res = PyModule_AddObjectRef(module, "spam", obj);
      ///     Py_DECREF(obj);
      ///     return res;
      ///  }
      /// </code>
      /// <para>To be convenient, the function accepts nil value with an
      /// exception set. In this case, return False and just leave the raised
      /// exception unchanged.</para>
      /// <para>The example can also be written without checking explicitly if
      /// obj is nil:</para>
      /// <code>
      /// static int
      /// add_spam(PyObject *module, int value)
      /// {
      ///     PyObject *obj = PyLong_FromLong(value);
      ///     int res = PyModule_AddObjectRef(module, "spam", obj);
      ///     Py_XDECREF(obj);
      ///     return res;
      ///  }
      /// </code>
      /// <para>Note that TPy.XDECREF() should be used instead of TPy.DECREF()
      /// in this case, since obj can be nil.</para>
      /// <para>The number of different name strings passed to this function
      /// should be kept small, usually by only using statically allocated
      /// strings as name. For names that aren't known at compile time, prefer
      /// calling TPyUnicode.FromString() and TPyObject.SetAttr() directly.
      /// For more details, see TPyUnicode.InternFromString(), which may be
      /// used internally to create a key object.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function AddObjectRef(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;
      /// <summary>
      /// <para>Similar to TPyModule.AddObjectRef(), but "steals" a reference
      /// to value (even on error). It can be called with a result of function
      /// that returns a new reference without bothering to check its result or
      /// even saving it to a variable.</para>
      /// <para>Example usage:</para>
      /// <code>
      /// if (PyModule_Add(module, "spam", PyBytes_FromString(value)) < 0) {
      ///     goto error;
      /// }
      /// </code>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function Add(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;
      /// <summary>
      /// <para>Similar to TPyModule.AddObjectRef(), but steals a reference to
      /// value on success (if it returns True).
      /// <para>The new TPyModule.Add() or TPyModule.AddObjectRef() functions
      /// are recommended, since it is easy to introduce reference leaks by
      /// misusing the TPyModule.AddObject() function.</para>
      /// <para>Note: Unlike other functions that steal references,
      /// TPyModule.AddObject() only releases the reference to value on
      /// success.</para>
      /// <para>This means that its return value must be checked, and calling
      /// code must TPy.XDECREF() value manually on error.</para>
      /// <para>Example usage:</para>
      /// <code>
      /// PyObject *obj = PyBytes_FromString(value);
      /// if (PyModule_AddObject(module, "spam", obj) < 0) {
      ///     // If 'obj' is not NULL and PyModule_AddObject() failed,
      ///     // 'obj' strong reference must be deleted with Py_XDECREF().
      ///     // If 'obj' is NULL, Py_XDECREF() does nothing.
      ///     Py_XDECREF(obj);
      ///     goto error;
      /// }
      /// // PyModule_AddObject() stole a reference to obj:
      /// // Py_XDECREF(obj) is not needed here.
      /// </code>
      /// <para>Soft deprecated since version 3.13.</para>
      /// </summary>
      class function AddObject(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;
      /// <summary>
      /// <para>Add an integer constant to module as name. This convenience
      /// function can be used from the module's initialization function.
      /// Return False with an exception set on error, True on success.</para>
      /// <para>This is a convenience function that calls TPyLong.FromLong() and
      /// TPyModule.AddObjectRef(); see their documentation for details.</para>
      /// </summary>
      class function AddIntConstant(const module_: IPyObject; const name_: string; value: C_Long): boolean;
      /// <summary>
      /// <para>Add a string constant to module as name. This convenience
      /// function can be used from the module's initialization function.
      /// The string value must be nil-terminated. Return False with an
      /// exception set on error, True on success.</para>
      /// <para>This is a convenience function that calls
      /// TPyUnicode.InternFromString() and TPyModule.AddObjectRef(); see their
      /// documentation for details.</para>
      /// </summary>
      class function AddStringConstant(const module_: IPyObject; const name_, value: string): boolean;
      /// <summary>
      /// <para>Add a type object to module. The type object is finalized by
      /// calling internally TPyType.Ready(). The name of the type object
      /// is taken from the last component of tp_name after dot.
      /// Return False with an exception set on error, True on success.</para>
      /// </summary>
      class function AddType(const module_: IPyObject; type_: PPyTypeObject): boolean;
      /// <summary>
      /// <para>Set the docstring for module to docstring. This function is
      /// called automatically when creating a module from PyModuleDef
      /// (such as when using Multi-phase initialization, TPyModule.Create, or
      /// TPyModule.FromDefAndSpec).</para>
      /// <para>Return True on success. Return False with an exception set on
      /// error.</para>
      /// </summary>
      class function SetDocString(const module_: IPyObject; const docstring: string): boolean;
      /// <summary>
      /// <para>Add the functions from the nil terminated functions array to
      /// module. Refer to the PyMethodDef documentation for details on
      /// individual entries (due to the lack of a shared module namespace,
      /// module level "functions" implemented in C typically receive the
      /// module as their first parameter, making them similar to instance
      /// methods on Python classes).</para>
      /// <para>This function is called automatically when creating a module
      /// from PyModuleDef (such as when using Multi-phase initialization,
      /// TPyModule.Create, or TPyModule.FromDefAndSpec). Some module authors
      /// may prefer defining functions in multiple PyMethodDef arrays; in that
      /// case they should call this function directly.</para>
      /// <para>The functions array must be statically allocated (or otherwise
      /// guaranteed to outlive the module object).</para>
      /// </summary>
      class function AddFunctions(const module_: IPyObject; functions: PPyMethodDef): boolean;
      /// <summary>
      /// <para>Process any execution slots (Py_mod_exec) given in def.</para>
      /// <para>Soft deprecated since version 3.15: To run a module's own
      /// execution slots, prefer TPyModule.Exec(), which works on modules that
      /// were not created from a PyModuleDef structure.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModule_ExecDef">See the article about PyModule_ExecDef.</see></para>
      /// </remarks>
      class function ExecDef(const module_: IPyObject; def: PPyModuleDef): boolean;
      /// <summary>
      /// <para>Create a new module object, given the definition in def.
      /// This function calls TPyModule.Create2() with module_api_version set
      /// to PYTHON_API_VERSION.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModule_Create">See the article about PyModule_Create.</see></para>
      /// </remarks>
      class function Create(def: PPyModuleDef): IPyObject;
      /// <summary>
      /// <para>Create a new module object, given the definition in def,
      /// assuming the API version module_api_version. If that version does not
      /// match the version of the running interpreter, a RuntimeWarning is
      /// emitted.</para>
      /// <para>Return nil with an exception set on error.</para>
      /// <para>This function does not support slots. The m_slots member of def
      /// must be nil.</para>
      /// <para>Note: Most uses of this function should be using
      /// TPyModule.Create() instead; only use this if you are sure you need
      /// it.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModule_Create2">See the article about PyModule_Create2.</see></para>
      /// </remarks>
      class function Create2(def: PPyModuleDef; module_api_version: integer): IPyObject;
      /// <summary>
      /// <para>This function calls TPyModule.FromDefAndSpec2() with
      /// module_api_version set to PYTHON_API_VERSION.</para>
      /// <para>Soft deprecated since version 3.15: Prefer
      /// TPyModule.FromSlotsAndSpec() in new code.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModule_FromDefAndSpec">See the article about PyModule_FromDefAndSpec.</see></para>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModule_FromDefAndSpec2">See the article about PyModule_FromDefAndSpec2.</see></para>
      /// </remarks>
      class function FromDefAndSpec(def: PPyModuleDef; const spec: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a new module object, given the definition in def and the
      /// ModuleSpec spec, assuming the API version module_api_version. If that
      /// version does not match the version of the running interpreter, a
      /// RuntimeWarning is emitted.</para>
      /// <para>Return nil with an exception set on error.</para>
      /// <para>Note that this does not process execution slots (Py_mod_exec).
      /// Both TPyModule.FromDefAndSpec and TPyModule.ExecDef must be called to
      /// fully initialize a module.</para>
      /// <para>Note: Most uses of this function should be using
      /// TPyModule.FromDefAndSpec() instead; only use this if you are sure you
      /// need it.</para>
      /// <para>Soft deprecated since version 3.15: Prefer
      /// TPyModule.FromSlotsAndSpec() in new code.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModule_FromDefAndSpec2">See the article about PyModule_FromDefAndSpec2.</see></para>
      /// </remarks>
      class function FromDefAndSpec2(def: PPyModuleDef; const spec: IPyObject; module_api_version: integer): IPyObject;
      /// <summary>
      /// <para>Create a new module object, given an array of slots and the
      /// ModuleSpec spec.</para>
      /// <para>The slots argument must point to an array of PySlot structures,
      /// terminated by an entry with slot ID of 0 (typically written as
      /// PySlot_END). The array must include a Py_mod_abi entry.</para>
      /// <para>The spec argument may be any ModuleSpec-like object, as
      /// described in Py_mod_create documentation. Currently, the spec must
      /// have a name attribute.</para>
      /// <para>On success, return the new module. On error, return nil with
      /// an exception set.</para>
      /// <para>Note that this does not process the module's execution slot
      /// (Py_mod_exec). Both TPyModule.FromSlotsAndSpec() and TPyModule.Exec()
      /// must be called to fully initialize a module. (See also Multi-phase
      /// initialization.)</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.PyModule_FromSlotsAndSpec">See the article about PyModule_FromSlotsAndSpec.</see></para>
      /// <para><see href="https://docs.python.org/3.15/c-api/slots.html#definition-slots">See the article about Definition slots.</see></para>
      /// <para><see href="https://peps.python.org/pep-0820/">See the article for PEP 820.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      class function FromSlotsAndSpec(const slots: PPySlot; const spec: IPyObject): IPyObject;
      /// <summary>
      /// <para>Execute the Py_mod_exec slot(s) of module.</para>
      /// <para>On success, return True. On error, return False with an
      /// exception set.</para>
      /// <para>For clarity: If module has no slots, for example if it uses
      /// legacy single-phase initialization, this function does nothing and
      /// returns True.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.PyModule_Exec">See the article about PyModule_Exec.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      class function Exec(const module_: IPyObject): boolean;
      /// <summary>
      /// <para>Set result_ to the size of module's state, as specified using
      /// Py_mod_state_size (or PyModuleDef.m_size), and return True.</para>
      /// <para>On error, set result_ to -1, and return False with an exception
      /// set.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.PyModule_GetStateSize">See the article about PyModule_GetStateSize.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      class function GetStateSize(const module_: IPyObject; out result_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Set result_ to the module token for module and return True.
      /// <para>On error, set result_ to nil, and return False with an
      /// exception set.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.PyModule_GetToken">See the article about PyModule_GetToken.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      class function GetToken(const module_: IPyObject; out result_: Pointer): boolean; overload;
      /// <summary>
      /// <para>Set result_ to the module token for module and return True.
      /// <para>On error, set result_ to nil, and return False with an
      /// exception set.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.PyModule_GetToken">See the article about PyModule_GetToken.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      class function GetToken(const module_: PPyObject; out result_: Pointer): boolean; overload;
      /// <summary>
      /// <para>The following function should only be used in a tp_traverse
      /// handler; calling them in other contexts may have unintended
      /// consequences.</para>
      /// <para>This function act like their counterpart without the _DuringGC
      /// suffix, but it's guaranteed to not have side effects, it doesn't set
      /// an exception on failure, and it returns/sets borrowed references as
      /// detailed in the individual documentation.</para>
      /// <para>Note that this function may fail, but as it doesn't set an
      /// exception, no error information is available. In some cases, failure
      /// is not distinguishable from a successful nil result.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetState_DuringGC(const module_: IPyObject): Pointer;
      /// <summary>
      /// <para>The following function should only be used in a tp_traverse
      /// handler; calling them in other contexts may have unintended
      /// consequences.</para>
      /// <para>This function act like their counterpart without the _DuringGC
      /// suffix, but it's guaranteed to not have side effects, it doesn't set
      /// an exception on failure, and it returns/sets borrowed references as
      /// detailed in the individual documentation.</para>
      /// <para>Note that this function may fail, but as it doesn't set an
      /// exception, no error information is available. In some cases, failure
      /// is not distinguishable from a successful nil result.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetToken_DuringGC(const module_: IPyObject; out result_: Pointer): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyModule.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyModule_Type);
end;

class function TPyModule.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyModule_Type);
end;

class function TPyModule.NewObject(const name_: IPyObject): IPyObject;
begin
  if assigned(PyModule_NewObject) and
     TPyObject.IsInitialized(name_) then
    Result := TPyObject.Wrap(PyModule_NewObject(name_.PyObject))
   else
    Result := nil;
end;

class function TPyModule.New(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyModule_New) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyModule_New(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPyModule.GetDict(const module_: IPyObject): IPyObject;
begin
  if assigned(PyModule_GetDict) and
     TPyObject.IsInitialized(module_) then
    Result := TPyObject.Wrap(PyModule_GetDict(module_.PyObject), False)
   else
    Result := nil;
end;

class function TPyModule.GetNameObject(const module_: IPyObject): IPyObject;
begin
  if assigned(PyModule_GetNameObject) and
     TPyObject.IsInitialized(module_) then
    Result := TPyObject.Wrap(PyModule_GetNameObject(module_.PyObject))
   else
    Result := nil;
end;

class function TPyModule.GetName(const module_: IPyObject): string;
begin
  if TPyObject.IsInitialized(module_) then
    Result := PyUTF8ToString(PAnsiChar(GetName(module_.PyObject)))
   else
    Result := '';
end;

class function TPyModule.GetName(const module_: PPyObject): AnsiString;
begin
  if assigned(PyModule_GetName) and assigned(module_) then
    Result := PyModule_GetName(module_)
   else
    Result := '';
end;

class function TPyModule.GetFilenameObject(const module_: IPyObject): IPyObject;
begin
  if assigned(PyModule_GetFilenameObject) and
     TPyObject.IsInitialized(module_) then
    Result := TPyObject.Wrap(PyModule_GetFilenameObject(module_.PyObject))
   else
    Result := nil;
end;

class function TPyModule.GetDef(const module_: IPyObject): PPyModuleDef;
begin
  if assigned(PyModule_GetDef) and
     TPyObject.IsInitialized(module_) then
    Result := PyModule_GetDef(module_.PyObject)
   else
    Result := nil;
end;

class function TPyModule.GetState(const module_: IPyObject): Pointer;
begin
  if assigned(PyModule_GetState) and
     TPyObject.IsInitialized(module_) then
    Result := PyModule_GetState(module_.PyObject)
   else
    Result := nil;
end;

class function TPyModule.AddObjectRef(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddObjectRef) and
     TPyObject.IsInitialized(module_) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_AddObjectRef(module_.PyObject, PAnsiChar(TempName), value.PyObject) = 0);
    end;
end;

class function TPyModule.Add(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;   
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_Add) and
     TPyObject.IsInitialized(module_) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_Add(module_.PyObject, PAnsiChar(TempName), value.UnWrap) = 0);
    end;
end;

class function TPyModule.AddObject(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;     
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddObject) and
     TPyObject.IsInitialized(module_) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      if (PyModule_AddObject(module_.PyObject, PAnsiChar(TempName), value.PyObject) = 0) then
        begin
          value.InitPyObject;
          Result := True;
        end;
    end;
end;

class function TPyModule.AddIntConstant(const module_: IPyObject; const name_: string; value: C_Long): boolean; 
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddIntConstant) and
     TPyObject.IsInitialized(module_) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_AddIntConstant(module_.PyObject, PAnsiChar(TempName), value) = 0);
    end;
end;

class function TPyModule.AddStringConstant(const module_: IPyObject; const name_, value: string): boolean;    
var
  TempName, TempValue : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddStringConstant) and
     TPyObject.IsInitialized(module_) then
    begin
      TempName  := StringToPyUTF8(name_);
      TempValue := StringToPyUTF8(value);
      Result    := (PyModule_AddStringConstant(module_.PyObject, PAnsiChar(TempName), PAnsiChar(TempValue)) = 0);
    end;
end;

class function TPyModule.AddType(const module_: IPyObject; type_: PPyTypeObject): boolean;    
begin
  Result := assigned(PyModule_AddType) and
            TPyObject.IsInitialized(module_) and
            (PyModule_AddType(module_.PyObject, type_) = 0);
end;

class function TPyModule.SetDocString(const module_: IPyObject; const docstring: string): boolean;  
var
  TempDoc : AnsiString;
begin
  Result := False;

  if assigned(PyModule_SetDocString) and
     TPyObject.IsInitialized(module_) then
    begin
      TempDoc := StringToPyUTF8(docstring);
      Result  := (PyModule_SetDocString(module_.PyObject, PAnsiChar(TempDoc)) = 0);
    end;
end;

class function TPyModule.AddFunctions(const module_: IPyObject; functions: PPyMethodDef): boolean;     
begin
  Result := assigned(PyModule_AddFunctions) and
            TPyObject.IsInitialized(module_) and
            (PyModule_AddFunctions(module_.PyObject, functions) = 0);
end;

class function TPyModule.ExecDef(const module_: IPyObject; def: PPyModuleDef): boolean;  
begin
  Result := assigned(PyModule_ExecDef) and
            TPyObject.IsInitialized(module_) and
            (PyModule_ExecDef(module_.PyObject, def) = 0);
end;

class function TPyModule.Create(def: PPyModuleDef): IPyObject; 
begin
  Result := TPyModule.Create2(def, PYTHON_API_VERSION);
end;

class function TPyModule.Create2(def: PPyModuleDef; module_api_version: integer): IPyObject; 
begin
  if assigned(PyModule_Create2) then
    Result := TPyObject.Wrap(PyModule_Create2(def, module_api_version))
   else 
    Result := nil;
end;

class function TPyModule.FromDefAndSpec(def: PPyModuleDef; const spec: IPyObject): IPyObject;       
begin
  Result := TPyModule.FromDefAndSpec2(def, spec, PYTHON_API_VERSION); 
end;

class function TPyModule.FromDefAndSpec2(def: PPyModuleDef; const spec: IPyObject; module_api_version: integer): IPyObject;
begin
  if assigned(PyModule_FromDefAndSpec2) and
     TPyObject.IsInitialized(spec) then
    Result := TPyObject.Wrap(PyModule_FromDefAndSpec2(def, spec.PyObject, module_api_version))
   else
    Result := nil;
end;

class function TPyModule.FromSlotsAndSpec(const slots: PPySlot; const spec: IPyObject): IPyObject;
begin
  if assigned(PyModule_FromSlotsAndSpec) and
     TPyObject.IsInitialized(spec) then
    Result := TPyObject.Wrap(PyModule_FromSlotsAndSpec(slots, spec.PyObject))
   else
    Result := nil;
end;

class function TPyModule.Exec(const module_: IPyObject): boolean;
begin
  Result := assigned(PyModule_Exec) and
            TPyObject.IsInitialized(module_) and
            (PyModule_Exec(module_.PyObject) = 0);
end;

class function TPyModule.GetStateSize(const module_: IPyObject; out result_: Py_ssize_t): boolean;
begin
  Result := assigned(PyModule_GetStateSize) and
            TPyObject.IsInitialized(module_) and
            (PyModule_GetStateSize(module_.PyObject, result_) = 0);
end;

class function TPyModule.GetToken(const module_: IPyObject; out result_: Pointer): boolean;
begin
  Result := assigned(module_) and
            GetToken(module_.PyObject, result_);
end;

class function TPyModule.GetToken(const module_: PPyObject; out result_: Pointer): boolean;
begin
  Result := assigned(PyModule_GetToken) and
            assigned(module_) and
            (PyModule_GetToken(module_, result_) = 0);
end;

class function TPyModule.GetState_DuringGC(const module_: IPyObject): Pointer;
begin
  if assigned(PyModule_GetState_DuringGC) and
     TPyObject.IsInitialized(module_) then
    Result := PyModule_GetState_DuringGC(module_.PyObject)
   else
    Result := nil;
end;

class function TPyModule.GetToken_DuringGC(const module_: IPyObject; out result_: Pointer): boolean;
begin
  Result := assigned(PyModule_GetToken_DuringGC) and
            TPyObject.IsInitialized(module_) and
            (PyModule_GetToken_DuringGC(module_.PyObject, result_) = 0);
end;

end.
