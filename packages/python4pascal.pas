{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit python4pascal;

{$warn 5023 off : no warning about unused units}
interface

uses
  uP4P.Constants, uP4P.CustomPyModule, uP4P.Engine, uP4P.Interfaces, 
  uP4P.IOPyModule, uP4P.LibFunctions, uP4P.Loader, uP4P.MiscFunctions, 
  uP4P.Py, uP4P.PyAIter, uP4P.PyAnySet, uP4P.PyArg, uP4P.PyAsyncGen, 
  uP4P.PyBool, uP4P.PyBuffer, uP4P.PyByteArray, uP4P.PyBytes, uP4P.PyCallable, 
  uP4P.PyCallIter, uP4P.PyCapsule, uP4P.PyCell, uP4P.PyCFunction, 
  uP4P.PyClassMethod, uP4P.PyCMethod, uP4P.PyCode, uP4P.PyCodec, 
  uP4P.PyCompile, uP4P.PyComplex, uP4P.PyConfig, uP4P.PyContext, 
  uP4P.PyContextToken, uP4P.PyContextVar, uP4P.PyCoro, uP4P.PyCriticalSection, 
  uP4P.PyDescr, uP4P.PyDict, uP4P.PyDictItems, uP4P.PyDictKeys, 
  uP4P.PyDictProxy, uP4P.PyDictValues, uP4P.PyDictViewSet, uP4P.PyEllipsis, 
  uP4P.PyErr, uP4P.PyEval, uP4P.PyException, uP4P.PyExceptionClass, 
  uP4P.PyExceptionInstance, uP4P.PyExceptionName, uP4P.PyFile, uP4P.PyFloat, 
  uP4P.PyFrame, uP4P.PyFrameLocalsProxy, uP4P.PyFrozenSet, uP4P.PyFunction, 
  uP4P.PyGC, uP4P.PyGen, uP4P.PyGILState, uP4P.PyHash, uP4P.PyImport, 
  uP4P.PyIndex, uP4P.PyInitConfig, uP4P.PyInstanceMethod, 
  uP4P.PyInterpreterConfig, uP4P.PyInterpreterState, uP4P.PyIter, uP4P.PyList, 
  uP4P.PyLong, uP4P.PyLongExport, uP4P.PyLongWriter, uP4P.PyMapping, 
  uP4P.PyMath, uP4P.PyMem, uP4P.PyMember, uP4P.PyMemoryView, uP4P.PyMethod, 
  uP4P.PyModule, uP4P.PyModuleDef, uP4P.PyModuleSpecHelper, uP4P.PyMonitoring, 
  uP4P.PyMutex, uP4P.PyNone, uP4P.PyNotImplemented, uP4P.PyNumber, 
  uP4P.PyObject, uP4P.PyODict, uP4P.PyOS, uP4P.PyPickleBuffer, 
  uP4P.PyPreConfig, uP4P.PyRange, uP4P.PyRefTracer, uP4P.PyRun, 
  uP4P.PySeqIter, uP4P.PySequence, uP4P.PySet, uP4P.PySignal, uP4P.PySlice, 
  uP4P.PyState, uP4P.PyStaticMethod, uP4P.PyStatus, uP4P.PyStructSequence, 
  uP4P.PySys, uP4P.PyThread, uP4P.PyThreadLock, uP4P.PyThreadState, 
  uP4P.PyThreadTSS, uP4P.PyTime, uP4P.PyTraceBack, uP4P.PyTraceMalloc, 
  uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyUnicodeDecodeError, 
  uP4P.PyUnicodeEncodeError, uP4P.PyUnicodeTranslateError, 
  uP4P.PyUnicodeWriter, uP4P.PyVectorcall, uP4P.PyWeakref, 
  uP4P.PyWideStringList, uP4P.PyWrapper, uP4P.Types, uP4P.PyDateTimeModule, 
  uP4P.PyObjectVariantType, uP4P.PyTimeModule, uP4P.Thread, 
  uP4P.ImportedPyModule, uP4P.PyGenericAlias, uP4P.PyAnyDict, 
  uP4P.PyBytesWriter, uP4P.PyFrozenDict, uP4P.PyInterpreterGuard, 
  uP4P.PyInterpreterView, uP4P.PyTimeStruct, uP4P.Py_bf, uP4P.Py_mod, 
  uP4P.Py_mp, uP4P.PyABIInfo, uP4P.PySentinel, uP4P.PyType, uP4P.PySlot, 
  uP4P.PyMethodDef, uP4P.PyModuleDef_Slot, uP4P.CustomHeapType, 
  uP4P.PyType_Spec, uP4P.PyType_Slot, uP4P.PyModuleSlotManager, 
  uP4P.PyHeapTypeSlotManager, uP4P.PyGetSetDef, uP4P.PyMemberDef, 
  uP4P.Metadata, uP4P.PyMarshal, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('python4pascal', @Register);
end.
