unit uP4P.PyErr;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>Helper class for all the PyErr_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#exception-handling">See the article about Exception Handling.</see></para>
  /// </remarks>
  TPyErr = class
    public
      /// <summary>
      /// <para>This is a shorthand for TPyErr.SetObject(type_, Py_None).</para>
      /// </summary>
      class procedure SetNone(const type_: IPyObject); overload;
      /// <summary>
      /// <para>This is a shorthand for TPyErr.SetObject(type_, Py_None).</para>
      /// </summary>
      class procedure SetNone(type_: PPyObject); overload;
      /// <summary>
      /// <para>This is a shorthand for TPyErr.SetObject(type_, Py_None).</para>
      /// </summary>
      class procedure SetNone(type_: TPyExceptionType); overload;
      /// <summary>
      /// <para>This function is similar to TPyErr.SetString() but lets you
      /// specify an arbitrary Python object for the "value" of the
      /// exception.</para>
      /// </summary>
      class procedure SetObject(const type_, value: IPyObject); overload;
      /// <summary>
      /// <para>This function is similar to TPyErr.SetString() but lets you
      /// specify an arbitrary Python object for the "value" of the
      /// exception.</para>
      /// </summary>
      class procedure SetObject(type_: PPyObject; const value: IPyObject); overload;
      /// <summary>
      /// <para>This function is similar to TPyErr.SetString() but lets you
      /// specify an arbitrary Python object for the "value" of the
      /// exception.</para>
      /// </summary>
      class procedure SetObject(type_: TPyExceptionType; const value: IPyObject); overload;
      /// <summary>
      /// <para>This is the most common way to set the error indicator. The
      /// first argument specifies the exception type; it is normally one of the
      /// standard exceptions, e.g. PyExc_RuntimeError. You need not create a
      /// new strong reference to it (e.g. with TPy.INCREF()). The second
      /// argument is an error message.</para>
      /// </summary>
      class procedure SetString(const type_: IPyObject; const message_: string); overload;
      /// <summary>
      /// <para>This is the most common way to set the error indicator. The
      /// first argument specifies the exception type; it is normally one of the
      /// standard exceptions, e.g. PyExc_RuntimeError. You need not create a
      /// new strong reference to it (e.g. with TPy.INCREF()). The second
      /// argument is an error message.</para>
      /// </summary>
      class procedure SetString(type_: PPyObject; const message_: string); overload;
      /// <summary>
      /// <para>This is the most common way to set the error indicator. The
      /// first argument specifies the exception type; it is normally one of the
      /// standard exceptions, e.g. PyExc_RuntimeError. You need not create a
      /// new strong reference to it (e.g. with TPy.INCREF()). The second
      /// argument is an error message.</para>
      /// </summary>
      class procedure SetString(type_: TPyExceptionType; const message_: string); overload;
      /// <summary>
      /// <para>Test whether the error indicator is set. If set, return the
      /// exception type (the first argument to the last call to one of the
      /// TPyErr.Set* functions or to TPyErr.Restore()). If not set, return nil.
      /// You do not own a reference to the return value, so you do not need to
      /// TPy.DECREF() it.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>Note: Do not compare the return value to a specific exception;
      /// use TPyErr.ExceptionMatches() instead, shown below. (The comparison
      /// could easily fail since the exception may be an instance instead of a
      /// class, in the case of a class exception, or it may be a subclass of
      /// the expected exception.)</para>
      /// </summary>
      class function Occurred(): IPyObject;
      /// <summary>
      /// <para>Clear the error indicator. If the error indicator is not set,
      /// there is no effect.</para>
      /// </summary>
      class procedure Clear();
      /// <summary>
      /// <para>Deprecated since version 3.12: Use TPyErr.GetRaisedException()
      /// instead.</para>
      /// <para>Retrieve the error indicator into three variables whose
      /// addresses are passed. If the error indicator is not set, set all three
      /// variables to nil. If it is set, it will be cleared and you own a
      /// reference to each object retrieved. The value and traceback object may
      /// be nil even when the type object is not.</para>
      /// <para>Note: This function is normally only used by legacy code that
      /// needs to catch exceptions or save and restore the error indicator
      /// temporarily.</para>
      /// <para>For example:</para>
      /// <code>
      /// {
      ///    PyObject *type, *value, *traceback;
      ///    PyErr_Fetch(&type, &value, &traceback);
      ///
      ///    /* ... code that might produce other errors ... */
      ///
      ///    PyErr_Restore(type, value, traceback);
      /// }
      /// </code>
      ///</para>
      /// </summary>
      class procedure Fetch(out ptype, pvalue, ptraceback: IPyObject); overload;
      /// <summary>
      /// <para>Deprecated since version 3.12: Use TPyErr.GetRaisedException()
      /// instead.</para>
      /// <para>Retrieve the error indicator into three variables whose
      /// addresses are passed. If the error indicator is not set, set all three
      /// variables to nil. If it is set, it will be cleared and you own a
      /// reference to each object retrieved. The value and traceback object may
      /// be nil even when the type object is not.</para>
      /// <para>Note: This function is normally only used by legacy code that
      /// needs to catch exceptions or save and restore the error indicator
      /// temporarily.</para>
      /// <para>For example:</para>
      /// <code>
      /// {
      ///    PyObject *type, *value, *traceback;
      ///    PyErr_Fetch(&type, &value, &traceback);
      ///
      ///    /* ... code that might produce other errors ... */
      ///
      ///    PyErr_Restore(type, value, traceback);
      /// }
      /// </code>
      ///</para>
      /// </summary>
      class procedure Fetch(out ptype: PPyObject; out pvalue, ptraceback: IPyObject); overload;
      /// <summary>
      /// <para>Deprecated since version 3.12: Use TPyErr.SetRaisedException()
      /// instead.</para>
      /// <para>Set the error indicator from the three objects, type, value, and
      /// traceback, clearing the existing exception if one is set. If the
      /// objects are nil, the error indicator is cleared. Do not pass a nil
      /// type and non-nil value or traceback. The exception type should be a
      /// class. Do not pass an invalid exception type or value. (Violating
      /// these rules will cause subtle problems later.) This call takes away a
      /// reference to each object: you must own a reference to each object
      /// before the call and after the call you no longer own these references.
      /// (If you don't understand this, don't use this function.
      /// I warned you.)</para>
      /// <para>Note: This function is normally only used by legacy code that
      /// needs to save and restore the error indicator temporarily.
      /// Use TPyErr.Fetch() to save the current error indicator.</para>
      /// </summary>
      class procedure Restore(const type_, value, traceback: IPyObject); overload;
      /// <summary>
      /// <para>Deprecated since version 3.12: Use TPyErr.SetRaisedException()
      /// instead.</para>
      /// <para>Set the error indicator from the three objects, type, value, and
      /// traceback, clearing the existing exception if one is set. If the
      /// objects are nil, the error indicator is cleared. Do not pass a nil
      /// type and non-nil value or traceback. The exception type should be a
      /// class. Do not pass an invalid exception type or value. (Violating
      /// these rules will cause subtle problems later.) This call takes away a
      /// reference to each object: you must own a reference to each object
      /// before the call and after the call you no longer own these references.
      /// (If you don't understand this, don't use this function.
      /// I warned you.)</para>
      /// <para>Note: This function is normally only used by legacy code that
      /// needs to save and restore the error indicator temporarily.
      /// Use TPyErr.Fetch() to save the current error indicator.</para>
      /// </summary>
      class procedure Restore(type_: PPyObject; const value, traceback: IPyObject); overload;
      /// <summary>
      /// <para>Return the exception currently being raised, clearing the error
      /// indicator at the same time. Return nil if the error indicator is
      /// not set.</para>
      /// <para>This function is used by code that needs to catch exceptions,
      /// or code that needs to save and restore the error indicator
      /// temporarily.</para>
      /// <para>See also TPyErr.GetHandledException(), to save the exception
      /// currently being handled.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function GetRaisedException(): IPyObject;
      /// <summary>
      /// <para>Set exc as the exception currently being raised, clearing the
      /// existing exception if one is set. If exc is nil, just clear the
      /// existing exception.</para>
      /// <para>exc must be a valid exception or nil.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class procedure SetRaisedException(const exc: IPyObject);
      /// <summary>
      /// <para>Retrieve the active exception instance, as would be returned by
      /// sys.exception(). This refers to an exception that was already caught,
      /// not to an exception that was freshly raised. Returns a new reference
      /// to the exception or nil. Does not modify the interpreter's exception
      /// state.</para>
      /// <para>Note This function is not normally used by code that wants to
      /// handle exceptions. Rather, it can be used when code needs to save and
      /// restore the exception state temporarily. Use
      /// TPyErr.SetHandledException() to restore or clear the exception
      /// state.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetHandledException(): IPyObject;
      /// <summary>
      /// <para>Set the active exception, as known from sys.exception(). This
      /// refers to an exception that was already caught, not to an exception
      /// that was freshly raised. To clear the exception state,
      /// pass nil.</para>
      /// <para>Note This function is not normally used by code that wants to
      /// handle exceptions. Rather, it can be used when code needs to save and
      /// restore the exception state temporarily. Use
      /// TPyErr.GetHandledException() to get the exception state.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class procedure SetHandledException(const exc: IPyObject);
      /// <summary>
      /// <para>Retrieve the old-style representation of the exception info, as
      /// known from sys.exc_info(). This refers to an exception that was
      /// already caught, not to an exception that was freshly raised.
      /// Returns new references for the three objects, any of which may be nil.
      /// Does not modify the exception info state. This function is kept for
      /// backwards compatibility. Prefer using
      /// TPyErr.GetHandledException().</para>
      /// <para>Note This function is not normally used by code that wants to
      /// handle exceptions. Rather, it can be used when code needs to save and
      /// restore the exception state temporarily. Use TPyErr.SetExcInfo() to
      /// restore or clear the exception state.</para>
      /// </summary>
      class procedure GetExcInfo(out ptype, pvalue, ptraceback: IPyObject); overload;
      /// <summary>
      /// <para>Retrieve the old-style representation of the exception info, as
      /// known from sys.exc_info(). This refers to an exception that was
      /// already caught, not to an exception that was freshly raised.
      /// Returns new references for the three objects, any of which may be nil.
      /// Does not modify the exception info state. This function is kept for
      /// backwards compatibility. Prefer using
      /// TPyErr.GetHandledException().</para>
      /// <para>Note This function is not normally used by code that wants to
      /// handle exceptions. Rather, it can be used when code needs to save and
      /// restore the exception state temporarily. Use TPyErr.SetExcInfo() to
      /// restore or clear the exception state.</para>
      /// </summary>
      class procedure GetExcInfo(out ptype: PPyObject; out pvalue, ptraceback: IPyObject); overload;
      /// <summary>
      /// <para>Set the exception info, as known from sys.exc_info(). This
      /// refers to an exception that was already caught, not to an exception
      /// that was freshly raised. This function "steals" the references of the
      /// arguments. To clear the exception state, pass nil for all three
      /// arguments. This function is kept for backwards compatibility. Prefer
      /// using TPyErr.SetHandledException().</para>
      /// <para>Note: This function is not normally used by code that wants to
      /// handle exceptions. Rather, it can be used when code needs to save and
      /// restore the exception state temporarily. Use TPyErr.GetExcInfo() to
      /// read the exception state.</para>
      /// <para>Added in version 3.3.</para>
      /// <para>Changed in version 3.11: The type and traceback arguments are
      /// no longer used and can be nil. The interpreter now derives them from
      /// the exception instance (the value argument). The function still
      /// "steals" references of all three arguments.</para>
      /// </summary>
      class procedure SetExcInfo(const type_, value, traceback: IPyObject); overload;
      /// <summary>
      /// <para>Set the exception info, as known from sys.exc_info(). This
      /// refers to an exception that was already caught, not to an exception
      /// that was freshly raised. This function "steals" the references of the
      /// arguments. To clear the exception state, pass nil for all three
      /// arguments. This function is kept for backwards compatibility. Prefer
      /// using TPyErr.SetHandledException().</para>
      /// <para>Note: This function is not normally used by code that wants to
      /// handle exceptions. Rather, it can be used when code needs to save and
      /// restore the exception state temporarily. Use TPyErr.GetExcInfo() to
      /// read the exception state.</para>
      /// <para>Added in version 3.3.</para>
      /// <para>Changed in version 3.11: The type and traceback arguments are
      /// no longer used and can be nil. The interpreter now derives them from
      /// the exception instance (the value argument). The function still
      /// "steals" references of all three arguments.</para>
      /// </summary>
      class procedure SetExcInfo(type_: PPyObject; const value, traceback: IPyObject); overload;
      /// <summary>
      /// <para>Return true if the given exception matches the exception type
      /// in exc. If exc is a class object, this also returns true when given
      /// is an instance of a subclass. If exc is a tuple, all exception types
      /// in the tuple (and recursively in subtuples) are searched for a
      /// match.</para>
      /// </summary>
      class function GivenExceptionMatches(const given, exc: IPyObject): boolean;
      /// <summary>
      /// <para>Equivalent to TPyErr.GivenExceptionMatches(TPyErr.Occurred(),
      /// exc). This should only be called when an exception is actually set;
      /// a memory access violation will occur if no exception has been
      /// raised.</para>
      /// </summary>
      class function ExceptionMatches(const exc: IPyObject): boolean;
      /// <summary>
      /// <para>Deprecated since version 3.12: Use TPyErr.GetRaisedException()
      /// instead, to avoid any possible de-normalization.</para>
      /// <para>Under certain circumstances, the values returned by
      /// TPyErr.Fetch() below can be "unnormalized", meaning that exc is a
      /// class object but val is not an instance of the same class. This
      /// function can be used to instantiate the class in that case. If the
      /// values are already normalized, nothing happens. The delayed
      /// normalization is implemented to improve performance.</para>
      /// <para>Note: This function does not implicitly set the __traceback__
      /// attribute on the exception value. If setting the traceback
      /// appropriately is desired, the following additional snippet is
      /// needed:</para>
      /// <code>
      /// if (tb != NULL) {
      ///   PyException_SetTraceback(val, tb);
      /// }
      /// </code>
      /// </summary>
      class procedure NormalizeException(out exc, val, tb: IPyObject);
      /// <summary>
      /// <para>This is a shorthand for
      /// TPyErr.SetString(PyExc_TypeError, message), where message indicates
      /// that a built-in operation was invoked with an illegal argument. It is
      /// mostly for internal use.</para>
      /// </summary>
      class function BadArgument(): boolean;
      /// <summary>
      /// <para>This is a shorthand for TPyErr.SetNone(PyExc_MemoryError); it
      /// returns nil so an object allocation function can write return
      /// TPyErr.NoMemory(); when it runs out of memory.</para>
      /// </summary>
      class function NoMemory(): IPyObject;
      /// <summary>
      /// <para>This is a convenience function to raise an exception when a C
      /// library function has returned an error and set the C variable errno.
      /// It constructs a tuple object whose first item is the integer errno
      /// value and whose second item is the corresponding error message
      /// (gotten from strerror()), and then calls
      /// TPyErr.SetObject(type, object). On Unix, when the errno value is
      /// EINTR, indicating an interrupted system call, this calls
      /// TPyErr.CheckSignals(), and if that set the error indicator, leaves it
      /// set to that. The function always returns nil, so a wrapper function
      /// around a system call can write return TPyErr.SetFromErrno(type); when
      /// the system call returns an error.</para>
      /// </summary>
      class function SetFromErrno(const type_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetFromErrno(), with the additional behavior
      /// that if filenameObject is not nil, it is passed to the constructor of
      /// type as a third parameter. In the case of OSError exception, this is
      /// used to define the filename attribute of the exception
      /// instance.</para>
      /// </summary>
      class function SetFromErrnoWithFilenameObject(const type_, filenameObject: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetFromErrnoWithFilenameObject(), but takes a
      /// second filename object, for raising errors when a function that takes
      /// two filenames fails.</para>
      /// </summary>
      class function SetFromErrnoWithFilenameObjects(const type_, filenameObject, filenameObject2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetFromErrnoWithFilenameObject(), but the
      /// filename is given as a string. filename is decoded from the filesystem
      /// encoding and error handler.</para>
      /// </summary>
      class function SetFromErrnoWithFilename(const type_: IPyObject; const filename: string): IPyObject;
      {$IFDEF MSWINDOWS}
      /// <summary>
      /// <para>Similar to TPyErr.SetFromWindowsErr(), with the additional
      /// behavior that if filename is not nil, it is decoded from the
      /// filesystem encoding (os.fsdecode()) and passed to the constructor of
      /// OSError as a third parameter to be used to define the filename
      /// attribute of the exception instance.</para>
      /// </summary>
      class function SetFromWindowsErrWithFilename(ierr: integer; const filename: string): IPyObject;
      /// <summary>
      /// <para>This is a convenience function to raise OSError. If called with
      /// ierr of 0, the error code returned by a call to GetLastError() is used
      /// instead. It calls the Win32 function FormatMessage() to retrieve the
      /// Windows description of error code given by ierr or GetLastError(),
      /// then it constructs a OSError object with the winerror attribute set to
      /// the error code, the strerror attribute set to the corresponding error
      /// message (gotten from FormatMessage()), and then calls
      /// TPyErr.SetObject(PyExc_OSError, object). This function always returns
      /// nil.</para>
      /// </summary>
      class function SetFromWindowsErr(ierr: integer): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetExcFromWindowsErr(), with the additional
      /// behavior that if filename is not nil, it is passed to the constructor
      /// of OSError as a third parameter to be used to define the filename
      /// attribute of the exception instance.</para>
      /// </summary>
      class function SetExcFromWindowsErrWithFilenameObject(const type_: IPyObject; ierr: integer; const filename: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetExcFromWindowsErrWithFilenameObject(), but
      /// accepts a second filename object.</para>
      /// </summary>
      class function SetExcFromWindowsErrWithFilenameObjects(const type_: IPyObject; ierr: integer; const filename, filename2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetFromWindowsErrWithFilename(), with an
      /// additional parameter specifying the exception type to be
      /// raised.</para>
      /// </summary>
      class function SetExcFromWindowsErrWithFilename(const type_: IPyObject; ierr: integer; const filename: string): IPyObject;
      /// <summary>
      /// <para>Similar to TPyErr.SetFromWindowsErr(), with an additional
      /// parameter specifying the exception type to be raised.</para>
      /// </summary>
      class function SetExcFromWindowsErr(const type_: IPyObject; ierr: integer): IPyObject;
      {$ENDIF}
      /// <summary>
      /// <para>Much like TPyErr.SetImportError() but this function allows for
      /// specifying a subclass of ImportError to raise.</para>
      /// </summary>
      class function SetImportErrorSubclass(const exception, msg, name_, path: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is a convenience function to raise ImportError. msg will be
      /// set as the exception's message string. name and path, both of which
      /// can be nil, will be set as the ImportError's respective name and path
      /// attributes.</para>
      /// </summary>
      class function SetImportError(const msg, name_, path: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is a shorthand for
      /// TPyErr.SetString(PyExc_SystemError, message), where message indicates
      /// that an internal operation (e.g. a Python/C API function) was invoked
      /// with an illegal argument. It is mostly for internal use.</para>
      /// </summary>
      class procedure BadInternalCall;
      /// <summary>
      /// <para>This utility function creates and returns a new exception class.
      /// The name argument must be the name of the new exception, a C string of
      /// the form module.classname. The base and dict arguments are normally
      /// nil. This creates a class object derived from Exception (accessible in
      /// C as PyExc_Exception).</para>
      /// <para>The __module__ attribute of the new class is set to the first
      /// part (up to the last dot) of the name argument, and the class name is
      /// set to the last part (after the last dot). The base argument can be
      /// used to specify alternate base classes; it can either be only one
      /// class or a tuple of classes. The dict argument can be used to specify
      /// a dictionary of class variables and methods.</para>
      /// </summary>
      class function NewException(const name_: string; const base, dict: IPyObject): IPyObject;
      /// <summary>
      /// <para>Same as TPyErr.NewException(), except that the new exception
      /// class can easily be given a docstring: If doc is non-nil, it will be
      /// used as the docstring for the exception class.</para>
      /// </summary>
      class function NewExceptionWithDoc(const name_, doc: string; base, dict: IPyObject): IPyObject;
      /// <summary>
      /// <para>Call sys.unraisablehook() using the current exception and obj
      /// argument.</para>
      /// <para>This utility function prints a warning message to sys.stderr
      /// when an exception has been set but it is impossible for the
      /// interpreter to actually raise the exception. It is used, for example,
      /// when an exception occurs in an __del__() method.</para>
      /// <para>The function is called with a single argument obj that
      /// identifies the context in which the unraisable exception occurred. If
      /// possible, the repr of obj will be printed in the warning message. If
      /// obj is nil, only the traceback is printed.</para>
      /// <para>An exception must be set when calling this function.</para>
      /// </summary>
      class procedure WriteUnraisable(const obj: IPyObject);
      /// <summary>
      /// <para>Handle external interruptions, such as signals or activating a
      /// debugger, whose processing has been delayed until it is safe to run
      /// Python code and/or raise exceptions.</para>
      /// <para>For example, pressing Ctrl-C causes a terminal to send the
      /// signal.SIGINT signal. This function executes the corresponding Python
      /// signal handler, which, by default, raises the KeyboardInterrupt
      /// exception.</para>
      /// <para>TPyErr.CheckSignals() should be called by long-running C code
      /// frequently enough so that the response appears immediate to
      /// humans.</para>
      /// <para>Handlers invoked by this function currently include:</para>
      /// <code>
      /// - Signal handlers, including Python functions registered using the
      ///   signal module.
      ///   Signal handlers are only run in the main thread of the main
      ///   interpreter.
      ///   (This is where the function got the name: originally, signals were
      ///    the only way to interrupt the interpreter.)
      /// - Running the garbage collector, if necessary.
      /// - Executing a pending remote debugger script.
      /// - Raise the exception set by TPyThreadState.SetAsyncExc().
      /// </code>
      /// <para>If any handler raises an exception, immediately return False
      /// with that exception set. Any remaining interruptions are left to be
      /// processed on the next TPyErr.CheckSignals() invocation, if
      /// appropriate.</para>
      /// <para>If all handlers finish successfully, or there are no handlers to
      /// run, return True.</para>
      /// <para>Changed in version 3.12: This function may now invoke the
      /// garbage collector.</para>
      /// <para>Changed in version 3.14: This function may now execute a remote
      /// debugger script, if remote debugging is enabled.</para>
      /// <para>Changed in version 3.15: The exception set by
      /// TPyThreadState.SetAsyncExc() is now raised.</para>
      /// </summary>
      class function CheckSignals(): boolean;
      /// <summary>
      /// <para>Simulate the effect of a SIGINT signal arriving. This is
      /// equivalent to TPyErr.SetInterruptEx(SIGINT).</para>
      /// <para>Note: This function is async-signal-safe. It can be called
      /// without an attached thread state and from a C signal handler.</para>
      /// </summary>
      class procedure SetInterrupt();
      /// <summary>
      /// <para>Simulate the effect of a signal arriving. The next time
      /// TPyErr.CheckSignals() is called, the Python signal handler for the
      /// given signal number will be called.</para>
      /// <para>This function can be called by C code that sets up its own
      /// signal handling and wants Python signal handlers to be invoked as
      /// expected when an interruption is requested (for example when the user
      /// presses Ctrl-C to interrupt an operation).</para>
      /// <para>If the given signal isn't handled by Python (it was set to
      /// signal.SIG_DFL or signal.SIG_IGN), it will be ignored.</para>
      /// <para>If signum is outside of the allowed range of signal numbers,
      /// False is returned. Otherwise, True is returned. The error indicator is
      /// never changed by this function.</para>
      /// <para>Note This function is async-signal-safe. It can be called
      /// without an attached thread state and from a C signal handler.</para>
      /// </summary>
      class function SetInterruptEx(signum: integer): boolean;
      /// <summary>
      /// <para>Like TPyErr.SyntaxLocationEx(), but the col_offset parameter is
      /// omitted.</para>
      /// </summary>
      class procedure SyntaxLocation(const filename: string; lineno: integer);
      /// <summary>
      /// <para>Like TPyErr.SyntaxLocationObject(), but filename is a string
      /// decoded from the filesystem encoding and error handler.</para>
      /// </summary>
      class procedure SyntaxLocationEx(const filename: string; lineno, col_offset: integer);
      /// <summary>
      /// <para>Similar to TPyErr.ProgramTextObject(), but filename is a string,
      /// which is decoded with the filesystem encoding and error handler,
      /// instead of a Python object reference.</para>
      /// </summary>
      class function ProgramText(const filename: string; lineno: integer): IPyObject;
      /// <summary>
      /// <para>Set file, line, and offset information for the current
      /// exception. If the current exception is not a SyntaxError, then it sets
      /// additional attributes, which make the exception printing subsystem
      /// think the exception is a SyntaxError.</para>
      /// </summary>
      class procedure SyntaxLocationObject(const filename: IPyObject; lineno, col_offset: integer);
      /// <summary>
      /// <para>Similar to TPyErr.SyntaxLocationObject(), but also sets the
      /// end_lineno and end_col_offset information for the current
      /// exception.</para>
      /// </summary>
      class procedure RangedSyntaxLocationObject(const filename: IPyObject; lineno, col_offset, end_lineno, end_col_offset: integer);
      /// <summary>
      /// <para>Get the source line in filename at line lineno. filename should
      /// be a Python str object.</para>
      /// <para>On success, this function returns a Python string object with
      /// the found line. On failure, this function returns nil without an
      /// exception set.</para>
      /// </summary>
      class function ProgramTextObject(const filename: IPyObject; lineno: integer): IPyObject;
      /// <summary>
      /// <para>Issue a warning message. The category argument is a warning
      /// category (see below) or nil; the message argument is a string.
      /// stack_level is a positive number giving a number of stack frames;
      /// the warning will be issued from the currently executing line of code
      /// in that stack frame. A stack_level of 1 is the function calling
      /// TPyErr.WarnEx(), 2 is the function above that, and so forth.</para>
      /// <para>Warning categories must be subclasses of PyExc_Warning;
      /// TPyExc.Warning is a subclass of TPyExc.Exception; the default warning
      /// category is PyExc_RuntimeWarning. The standard Python warning
      /// categories are available as global variables whose names are
      /// enumerated at Warning types.</para>
      /// <para>For information about warning control, see the documentation for
      /// the warnings module and the -W option in the command line
      /// documentation. There is no C API for warning control.</para>
      /// </summary>
      class function WarnEx(const category: IPyObject; const message_: string; stack_level: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Similar to TPyErr.WarnExplicitObject() except that message and
      /// module are strings, and filename is decoded from the filesystem
      /// encoding and error handler.</para>
      /// </summary>
      class function WarnExplicit(const category: IPyObject; const message_, filename: string; lineno: integer; const module_: string; const registry_: IPyObject): boolean;
      /// <summary>
      /// <para>Issue a warning message with explicit control over all warning
      /// attributes. This is a straightforward wrapper around the Python
      /// function warnings.warn_explicit(); see there for more information.
      /// The module and registry arguments may be set to nil to get the
      /// default effect described there.</para>
      /// </summary>
      class function WarnExplicitObject(const category, message_, filename: IPyObject; lineno: integer; const module_, registry_: IPyObject): boolean;
      /// <summary>
      /// <para>Alias for TPyErr.PrintEx(1).</para>
      /// </summary>
      class procedure Print;
      /// <summary>
      /// <para>Print a standard traceback to sys.stderr and clear the error
      /// indicator. Unless the error is a SystemExit, in that case no
      /// traceback is printed and the Python process will exit with the error
      /// code specified by the SystemExit instance.</para>
      /// <para>Call this function only when the error indicator is set.
      /// Otherwise it will cause a fatal error!</para>
      /// <para>If set_sys_last_vars is nonzero, the variable sys.last_exc is
      /// set to the printed exception. For backwards compatibility, the
      /// deprecated variables sys.last_type, sys.last_value and
      /// sys.last_traceback are also set to the type, value and traceback of
      /// this exception, respectively.</para>
      /// <para>Changed in version 3.12: The setting of sys.last_exc was
      /// added.</para>
      /// </summary>
      class procedure PrintEx(set_sys_last_vars: integer);
      /// <summary>
      /// <para>Legacy variant of TPyErr.DisplayException().</para>
      /// <para>Print the exception value with its traceback to sys.stderr.
      /// If value has no traceback set, tb is used as its traceback. The first
      /// argument is ignored.</para>
      /// <para>If sys.stderr is None, nothing is printed. If sys.stderr is not
      /// set, the exception is dumped to the C stderr stream instead.</para>
      /// <para>Deprecated since version 3.12: Use TPyErr.DisplayException()
      /// instead.</para>
      /// </summary>
      class procedure Display(const unused, value, tb: IPyObject);
      /// <summary>
      /// <para>Print the standard traceback display of exc to sys.stderr,
      /// including chained exceptions and notes.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class procedure DisplayException(const exc: IPyObject);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyException;

class procedure TPyErr.SetNone(const type_: IPyObject);
begin
  if assigned(PyErr_SetNone) and
     TPyObject.IsInitialized(type_) then
    PyErr_SetNone(type_.PyObject);
end;

class procedure TPyErr.SetNone(type_: PPyObject);
begin
  if assigned(PyErr_SetNone) and
     assigned(type_) then
    PyErr_SetNone(type_);
end;

class procedure TPyErr.SetNone(type_: TPyExceptionType);
begin
  TPyErr.SetNone(TPyException.GetExceptionType(type_));
end;

class procedure TPyErr.SetObject(const type_, value: IPyObject);
begin
  if assigned(PyErr_SetObject) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(value) then
    PyErr_SetObject(type_.PyObject, value.PyObject);
end;

class procedure TPyErr.SetObject(type_: PPyObject; const value: IPyObject);
begin
  if assigned(PyErr_SetObject) and
     assigned(type_) and
     TPyObject.IsInitialized(value) then
    PyErr_SetObject(type_, value.PyObject);
end;

class procedure TPyErr.SetObject(type_: TPyExceptionType; const value: IPyObject);
begin
  TPyErr.SetObject(TPyException.GetExceptionType(type_), value);
end;

class procedure TPyErr.SetString(const type_: IPyObject; const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(PyErr_SetString) and
     TPyObject.IsInitialized(type_) then
    begin
      TempMessage := StringToPyUTF8(message_);
      PyErr_SetString(type_.PyObject, PAnsiChar(TempMessage));
    end;
end;

class procedure TPyErr.SetString(type_: PPyObject; const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(PyErr_SetString) and
     assigned(type_) then
    begin
      TempMessage := StringToPyUTF8(message_);
      PyErr_SetString(type_, PAnsiChar(TempMessage));
    end;
end;

class procedure TPyErr.SetString(type_: TPyExceptionType; const message_: string);
begin
  TPyErr.SetString(TPyException.GetExceptionType(type_), message_);
end;

class function TPyErr.Occurred(): IPyObject;
begin
  if assigned(PyErr_Occurred) then
    Result := TPyObject.Wrap(PyErr_Occurred(), False)
   else
    Result := nil;
end;

class procedure TPyErr.Clear();
begin
  if assigned(PyErr_Clear) then
    PyErr_Clear();
end;

class procedure TPyErr.Fetch(out ptype, pvalue, ptraceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  ptype      := nil;
  pvalue     := nil;
  ptraceback := nil;

  if assigned(PyErr_Fetch) then
    begin
      TempType      := nil;
      TempValue     := nil;
      TempTraceback := nil;

      PyErr_Fetch(TempType, TempValue, TempTraceback);

      ptype      := TPyObject.Wrap(TempType);
      pvalue     := TPyObject.Wrap(TempValue);
      ptraceback := TPyObject.Wrap(TempTraceback);
    end;
end;

class procedure TPyErr.Fetch(out ptype: PPyObject; out pvalue, ptraceback: IPyObject);
var
  TempValue, TempTraceback: PPyObject;
begin
  ptype      := nil;
  pvalue     := nil;
  ptraceback := nil;

  if assigned(PyErr_Fetch) then
    begin
      TempValue     := nil;
      TempTraceback := nil;

      PyErr_Fetch(ptype, TempValue, TempTraceback);

      pvalue     := TPyObject.Wrap(TempValue);
      ptraceback := TPyObject.Wrap(TempTraceback);
    end;
end;

class procedure TPyErr.Restore(const type_, value, traceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_Restore) then
    begin
      if TPyObject.IsInitialized(type_) then
        TempType := type_.UnWrap
       else
        TempType := nil;

      if TPyObject.IsInitialized(value) then
        TempValue := value.UnWrap
       else
        TempValue := nil;

      if TPyObject.IsInitialized(traceback) then
        TempTraceback := traceback.UnWrap
       else
        TempTraceback := nil;

      PyErr_Restore(TempType, TempValue, TempTraceback);
    end;
end;

class procedure TPyErr.Restore(type_: PPyObject; const value, traceback: IPyObject);
var
  TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_Restore) then
    begin
      if TPyObject.IsInitialized(value) then
        TempValue := value.UnWrap
       else
        TempValue := nil;

      if TPyObject.IsInitialized(traceback) then
        TempTraceback := traceback.UnWrap
       else
        TempTraceback := nil;

      PyErr_Restore(type_, TempValue, TempTraceback);
    end;
end;

class function TPyErr.GetRaisedException(): IPyObject;
begin
  if assigned(PyErr_GetRaisedException) then
    Result := TPyObject.Wrap(PyErr_GetRaisedException())
   else
    Result := nil;
end;

class procedure TPyErr.SetRaisedException(const exc: IPyObject);
begin
  if assigned(PyErr_SetRaisedException) and
     TPyObject.IsInitialized(exc) then
    PyErr_SetRaisedException(exc.UnWrap);
end;

class function TPyErr.GetHandledException(): IPyObject;
begin
  if assigned(PyErr_GetHandledException) then
    Result := TPyObject.Wrap(PyErr_GetHandledException())
   else
    Result := nil;
end;

class procedure TPyErr.SetHandledException(const exc: IPyObject);
begin
  if assigned(PyErr_SetHandledException) then
    begin
      if TPyObject.IsInitialized(exc) then
        PyErr_SetHandledException(exc.PyObject)
       else
        PyErr_SetHandledException(nil);
    end;
end;

class procedure TPyErr.GetExcInfo(out ptype, pvalue, ptraceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  ptype      := nil;
  pvalue     := nil;
  ptraceback := nil;

  if assigned(PyErr_GetExcInfo) then
    begin
      TempType      := nil;
      TempValue     := nil;
      TempTraceback := nil;

      PyErr_GetExcInfo(TempType, TempValue, TempTraceback);

      ptype      := TPyObject.Wrap(TempType);
      pvalue     := TPyObject.Wrap(TempValue);
      ptraceback := TPyObject.Wrap(TempTraceback);
    end;
end;

class procedure TPyErr.GetExcInfo(out ptype: PPyObject; out pvalue, ptraceback: IPyObject);
var
  TempValue, TempTraceback: PPyObject;
begin
  ptype      := nil;
  pvalue     := nil;
  ptraceback := nil;

  if assigned(PyErr_GetExcInfo) then
    begin
      TempValue     := nil;
      TempTraceback := nil;

      PyErr_GetExcInfo(ptype, TempValue, TempTraceback);

      pvalue     := TPyObject.Wrap(TempValue);
      ptraceback := TPyObject.Wrap(TempTraceback);
    end;
end;

class procedure TPyErr.SetExcInfo(const type_, value, traceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_SetExcInfo) then
    begin
      if TPyObject.IsInitialized(type_) then
        TempType := type_.Unwrap
       else
        TempType := nil;

      if TPyObject.IsInitialized(value) then
        TempValue := value.Unwrap
       else
        TempValue := nil;

      if TPyObject.IsInitialized(traceback) then
        TempTraceback := traceback.Unwrap
       else
        TempTraceback := nil;

      PyErr_SetExcInfo(TempType, TempValue, TempTraceback);
    end;
end;

class procedure TPyErr.SetExcInfo(type_: PPyObject; const value, traceback: IPyObject);
var
  TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_SetExcInfo) then
    begin
      if TPyObject.IsInitialized(value) then
        TempValue := value.Unwrap
       else
        TempValue := nil;

      if TPyObject.IsInitialized(traceback) then
        TempTraceback := traceback.Unwrap
       else
        TempTraceback := nil;

      PyErr_SetExcInfo(type_, TempValue, TempTraceback);
    end;
end;

class function TPyErr.GivenExceptionMatches(const given, exc: IPyObject): boolean;
begin
  Result := assigned(PyErr_GivenExceptionMatches) and
            TPyObject.IsInitialized(given) and
            TPyObject.IsInitialized(exc) and
            (PyErr_GivenExceptionMatches(given.PyObject, exc.PyObject) <> 0);
end;

class function TPyErr.ExceptionMatches(const exc: IPyObject): boolean;
begin
  Result := assigned(PyErr_ExceptionMatches) and
            TPyObject.IsInitialized(exc) and
            (PyErr_ExceptionMatches(exc.PyObject) <> 0);
end;

class procedure TPyErr.NormalizeException(out exc, val, tb: IPyObject);
var
  TempExc, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_NormalizeException) then
    begin
      PyErr_NormalizeException(TempExc, TempValue, TempTraceback);

      exc := TPyObject.Wrap(TempExc);
      val := TPyObject.Wrap(TempValue);
      tb  := TPyObject.Wrap(TempTraceback);
    end
   else
    begin
      exc := nil;
      val := nil;
      tb  := nil;
    end;
end;

class function TPyErr.BadArgument(): boolean;
begin
  Result := assigned(PyErr_BadArgument) and
            (PyErr_BadArgument() <> 0);
end;

class function TPyErr.NoMemory(): IPyObject;
begin
  if assigned(PyErr_NoMemory) then
    Result := TPyObject.Wrap(PyErr_NoMemory())
   else
    Result := nil;
end;

class function TPyErr.SetFromErrno(const type_: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetFromErrno) and
     TPyObject.IsInitialized(type_) then
    Result := TPyObject.Wrap(PyErr_SetFromErrno(type_.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetFromErrnoWithFilenameObject(const type_, filenameObject: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetFromErrnoWithFilenameObject) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filenameObject) then
    Result := TPyObject.Wrap(PyErr_SetFromErrnoWithFilenameObject(type_.PyObject, filenameObject.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetFromErrnoWithFilenameObjects(const type_, filenameObject, filenameObject2: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetFromErrnoWithFilenameObjects) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filenameObject) and
     TPyObject.IsInitialized(filenameObject2) then
    Result := TPyObject.Wrap(PyErr_SetFromErrnoWithFilenameObjects(type_.PyObject, filenameObject.PyObject, filenameObject2.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetFromErrnoWithFilename(const type_: IPyObject; const filename: string): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SetFromErrnoWithFilename) and
     TPyObject.IsInitialized(type_) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyErr_SetFromErrnoWithFilename(type_.PyObject, PAnsiChar(TempFilename)))
    end
   else
    Result := nil;
end;

{$IFDEF MSWINDOWS}
class function TPyErr.SetFromWindowsErrWithFilename(ierr: integer; const filename: string): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SetFromWindowsErrWithFilename) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyErr_SetFromWindowsErrWithFilename(ierr, PAnsiChar(TempFilename)))
    end
   else
    Result := nil;
end;

class function TPyErr.SetFromWindowsErr(ierr: integer): IPyObject;
begin
  if assigned(PyErr_SetFromWindowsErr) then
    Result := TPyObject.Wrap(PyErr_SetFromWindowsErr(ierr))
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErrWithFilenameObject(const type_: IPyObject; ierr: integer; const filename: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetExcFromWindowsErrWithFilenameObject) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filename) then
    Result := TPyObject.Wrap(PyErr_SetExcFromWindowsErrWithFilenameObject(type_.PyObject, ierr, filename.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErrWithFilenameObjects(const type_: IPyObject; ierr: integer; const filename, filename2: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetExcFromWindowsErrWithFilenameObjects) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filename) and
     TPyObject.IsInitialized(filename2) then
    Result := TPyObject.Wrap(PyErr_SetExcFromWindowsErrWithFilenameObjects(type_.PyObject, ierr, filename.PyObject, filename2.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErrWithFilename(const type_: IPyObject; ierr: integer; const filename: string): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SetExcFromWindowsErrWithFilename) and
     TPyObject.IsInitialized(type_) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyErr_SetExcFromWindowsErrWithFilename(type_.PyObject, ierr, PAnsiChar(TempFilename)));
    end
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErr(const type_: IPyObject; ierr: integer): IPyObject;
begin
  if assigned(PyErr_SetExcFromWindowsErr) and
     TPyObject.IsInitialized(type_) then
    Result := TPyObject.Wrap(PyErr_SetExcFromWindowsErr(type_.PyObject, ierr))
   else
    Result := nil;
end;
{$ENDIF}

class function TPyErr.SetImportErrorSubclass(const exception, msg, name_, path: IPyObject): IPyObject;
var
  TempName, TempPath : PPyObject;
begin
  if assigned(PyErr_SetImportErrorSubclass) and
     TPyObject.IsInitialized(exception) and
     TPyObject.IsInitialized(msg) then
    begin
      if TPyObject.IsInitialized(name_) then
        TempName := name_.PyObject
       else
        TempName := nil;

      if TPyObject.IsInitialized(path) then
        TempPath := path.PyObject
       else
        TempPath := nil;

      Result := TPyObject.Wrap(PyErr_SetImportErrorSubclass(exception.PyObject, msg.PyObject, TempName, TempPath));
    end
   else
    Result := nil;
end;

class function TPyErr.SetImportError(const msg, name_, path: IPyObject): IPyObject;
var
  TempName, TempPath : PPyObject;
begin
  if assigned(PyErr_SetImportError) and
     TPyObject.IsInitialized(msg) then
    begin
      if TPyObject.IsInitialized(name_) then
        TempName := name_.PyObject
       else
        TempName := nil;

      if TPyObject.IsInitialized(path) then
        TempPath := path.PyObject
       else
        TempPath := nil;

      Result := TPyObject.Wrap(PyErr_SetImportError(msg.PyObject, TempName, TempPath));
    end
   else
    Result := nil;
end;

class procedure TPyErr.BadInternalCall;
begin
  if assigned(PyErr_BadInternalCall) then
    PyErr_BadInternalCall();
end;

class function TPyErr.NewException(const name_: string; const base, dict: IPyObject): IPyObject;
var
  TempName : AnsiString;
  TempBase, TempDict : PPyObject;
begin
  if assigned(PyErr_NewException) then
    begin
      TempName := StringToPyUTF8(name_);

      if TPyObject.IsInitialized(base) then
        TempBase := base.PyObject
       else
        TempBase := nil;

      if TPyObject.IsInitialized(dict) then
        TempDict := dict.PyObject
       else
        TempDict := nil;

      Result := TPyObject.Wrap(PyErr_NewException(PAnsiChar(TempName), TempBase, TempDict));
    end
   else
    Result := nil;
end;

class function TPyErr.NewExceptionWithDoc(const name_, doc: string; base, dict: IPyObject): IPyObject;
var
  TempName, TempDoc : AnsiString;
  TempBase, TempDict : PPyObject;
begin
  if assigned(PyErr_NewExceptionWithDoc) then
    begin
      TempName := StringToPyUTF8(name_);
      TempDoc  := StringToPyUTF8(doc);

      if TPyObject.IsInitialized(base) then
        TempBase := base.PyObject
       else
        TempBase := nil;

      if TPyObject.IsInitialized(dict) then
        TempDict := dict.PyObject
       else
        TempDict := nil;

      Result := TPyObject.Wrap(PyErr_NewExceptionWithDoc(PAnsiChar(TempName), PAnsiChar(TempDoc), TempBase, TempDict));
    end
   else
    Result := nil;
end;

class procedure TPyErr.WriteUnraisable(const obj: IPyObject);
begin
  if assigned(PyErr_WriteUnraisable) then
    begin
      if TPyObject.IsInitialized(obj) then
        PyErr_WriteUnraisable(obj.PyObject)
       else
        PyErr_WriteUnraisable(nil);
    end
end;

class function TPyErr.CheckSignals(): boolean;
begin
  Result := assigned(PyErr_CheckSignals) and
            (PyErr_CheckSignals() = 0);
end;

class procedure TPyErr.SetInterrupt();
begin
  if assigned(PyErr_SetInterrupt) then
    PyErr_SetInterrupt();
end;

class function TPyErr.SetInterruptEx(signum: integer): boolean;
begin
  Result := assigned(PyErr_SetInterruptEx) and
            (PyErr_SetInterruptEx(signum) = 0);
end;

class procedure TPyErr.SyntaxLocation(const filename: string; lineno: integer);
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SyntaxLocation) then
    begin
      TempFilename := StringToPyUTF8(filename);
      PyErr_SyntaxLocation(PAnsiChar(TempFilename), lineno);
    end;
end;

class procedure TPyErr.SyntaxLocationEx(const filename: string; lineno, col_offset: integer);
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SyntaxLocationEx) then
    begin
      TempFilename := StringToPyUTF8(filename);
      PyErr_SyntaxLocationEx(PAnsiChar(TempFilename), lineno, col_offset);
    end;
end;

class function TPyErr.ProgramText(const filename: string; lineno: integer): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_ProgramText) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result := TPyObject.Wrap(PyErr_ProgramText(PAnsiChar(TempFilename), lineno));
    end
   else
    Result := nil;
end;

class procedure TPyErr.SyntaxLocationObject(const filename: IPyObject; lineno, col_offset: integer);
begin
  if assigned(PyErr_SyntaxLocationObject) and
     TPyObject.IsInitialized(filename) then
    PyErr_SyntaxLocationObject(filename.PyObject, lineno, col_offset);
end;

class procedure TPyErr.RangedSyntaxLocationObject(const filename: IPyObject; lineno, col_offset, end_lineno, end_col_offset: integer);
begin
  if assigned(PyErr_RangedSyntaxLocationObject) and
     TPyObject.IsInitialized(filename) then
    PyErr_RangedSyntaxLocationObject(filename.PyObject, lineno, col_offset, end_lineno, end_col_offset);
end;

class function TPyErr.ProgramTextObject(const filename: IPyObject; lineno: integer): IPyObject;
begin
  if assigned(PyErr_ProgramTextObject) and
     TPyObject.IsInitialized(filename) then
    Result := TPyObject.Wrap(PyErr_ProgramTextObject(filename.PyObject, lineno))
   else
    Result := nil;
end;

class function TPyErr.WarnEx(const category: IPyObject; const message_: string; stack_level: Py_ssize_t): boolean;
var
  TempMessage : AnsiString;
begin
  Result := False;

  if assigned(PyErr_WarnEx) then
    begin
      TempMessage := StringToPyUTF8(message_);

      if TPyObject.IsInitialized(category) then
        Result := (PyErr_WarnEx(category.PyObject, PAnsiChar(TempMessage), stack_level) = 0)
       else
        Result := (PyErr_WarnEx(nil, PAnsiChar(TempMessage), stack_level) = 0);
    end;
end;

class function TPyErr.WarnExplicit(const category: IPyObject; const message_, filename: string; lineno: integer; const module_: string; const registry_: IPyObject): boolean;
var
  TempMessage, TempFilename, TempModule : AnsiString;
  TempCategory, TempRegistry : PPyObject;
begin
  Result := False;

  if assigned(PyErr_WarnExplicit) then
    begin
      TempMessage  := StringToPyUTF8(message_);
      TempFilename := StringToPyUTF8(filename);
      TempModule   := StringToPyUTF8(module_);

      if TPyObject.IsInitialized(category) then
        TempCategory := category.PyObject
       else
        TempCategory := nil;

      if TPyObject.IsInitialized(registry_) then
        TempRegistry := registry_.PyObject
       else
        TempRegistry := nil;

      Result := (PyErr_WarnExplicit(TempCategory, PAnsiChar(TempMessage), PAnsiChar(TempFilename), lineno, PAnsiChar(TempModule), TempRegistry) = 0);
    end;
end;

class function TPyErr.WarnExplicitObject(const category, message_, filename: IPyObject; lineno: integer; const module_, registry_: IPyObject): boolean;
var
  TempCategory, TempMessage, TempFilename, TempModule, TempRegistry : PPyObject;
begin
  Result := False;

  if assigned(PyErr_WarnExplicitObject) then
    begin
      if TPyObject.IsInitialized(category) then
        TempCategory := category.PyObject
       else
        TempCategory := nil;

      if TPyObject.IsInitialized(message_) then
        TempMessage := message_.PyObject
       else
        TempMessage := nil;

      if TPyObject.IsInitialized(filename) then
        TempFilename := filename.PyObject
       else
        TempFilename := nil;

      if TPyObject.IsInitialized(module_) then
        TempModule := module_.PyObject
       else
        TempModule := nil;

      if TPyObject.IsInitialized(registry_) then
        TempRegistry := registry_.PyObject
       else
        TempRegistry := nil;

      Result := (PyErr_WarnExplicitObject(TempCategory, TempMessage, TempFilename, lineno, TempModule, TempRegistry) = 0);
    end;
end;

class procedure TPyErr.Print;
begin
  if assigned(PyErr_Print) then
    PyErr_Print();
end;

class procedure TPyErr.PrintEx(set_sys_last_vars: integer);
begin
  if assigned(PyErr_PrintEx) then
    PyErr_PrintEx(set_sys_last_vars);
end;

class procedure TPyErr.Display(const unused, value, tb: IPyObject);
begin
  if assigned(PyErr_Display) and
     TPyObject.IsInitialized(unused) and
     TPyObject.IsInitialized(value) and
     TPyObject.IsInitialized(tb) then
    PyErr_Display(unused.PyObject, value.PyObject, tb.PyObject);
end;

class procedure TPyErr.DisplayException(const exc: IPyObject);
begin
  if assigned(PyErr_DisplayException) and
     TPyObject.IsInitialized(exc) then
    PyErr_DisplayException(exc.PyObject);
end;

end.
