/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import '../TypeHelpers.dart';
import '../../Bindings.dart';
import '../../Bindings_KDDWBindingsCore.dart' as KDDWBindingsCore;
import '../../Bindings_KDDWBindingsFlutter.dart' as KDDWBindingsFlutter;
import '../../LibraryLoader.dart';

var _dylib = Library.instance().dylib;

class View extends KDDWBindingsCore.View {
  View.fromCppPointer(var cppPointer, [var needsAutoDelete = false])
      : super.fromCppPointer(cppPointer, needsAutoDelete) {}
  View.init() : super.init() {}
  factory View.fromCache(var cppPointer, [needsAutoDelete = false]) {
    if (KDDWBindingsCore.View.isCached(cppPointer)) {
      var instance =
          KDDWBindingsCore.View.s_dartInstanceByCppPtr[cppPointer.address];
      if (instance != null) return instance as View;
    }
    return View.fromCppPointer(cppPointer, needsAutoDelete);
  } //View(KDDockWidgets::Core::Controller * controller, KDDockWidgets::Core::ViewType type, KDDockWidgets::Core::View * arg__3, Qt::WindowFlags windowFlags)
  View(KDDWBindingsCore.Controller? controller, int type,
      KDDWBindingsCore.View? arg__3,
      {int windowFlags = 0})
      : super.init() {
    final voidstar_Func_voidstar_int_voidstar_int func = _dylib
        .lookup<
                ffi.NativeFunction<
                    voidstar_Func_voidstar_ffi_Int32_voidstar_ffi_Int32_FFI>>(
            'c_KDDockWidgets__flutter__View__constructor_Controller_ViewType_View_WindowFlags')
        .asFunction();
    thisCpp = func(controller == null ? ffi.nullptr : controller.thisCpp, type,
        arg__3 == null ? ffi.nullptr : arg__3.thisCpp, windowFlags);
    KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] = this;
    registerCallbacks();
  }
  static void activateWindow_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::activateWindow()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.activateWindow();
  }

  static int close_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print("Dart instance not found for View::close()! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.close();
    return result ? 1 : 0;
  }

  static void createPlatformWindow_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::createPlatformWindow()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.createPlatformWindow();
  }

  static int flags_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::flags() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.flags();
    return result;
  }

  static ffi.Pointer<void> geometry_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::geometry() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.geometry();
    return result.thisCpp;
  }

  static void grabMouse_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::grabMouse()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.grabMouse();
  }

  static int hasFocus_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::hasFocus() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.hasFocus();
    return result ? 1 : 0;
  }

  static void hide_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print("Dart instance not found for View::hide()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.hide();
  }

  static void init_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print("Dart instance not found for View::init()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.init();
  }

  static int isActiveWindow_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isActiveWindow() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isActiveWindow();
    return result ? 1 : 0;
  }

  static int isExplicitlyHidden_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isExplicitlyHidden() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isExplicitlyHidden();
    return result ? 1 : 0;
  }

  static int isMaximized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isMaximized() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isMaximized();
    return result ? 1 : 0;
  }

  static int isMinimized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isMinimized() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isMinimized();
    return result ? 1 : 0;
  } // isMounted() const

  bool isMounted() {
    final bool_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<bool_Func_voidstar_FFI>>(
            cFunctionSymbolName(791))
        .asFunction();
    return func(thisCpp) != 0;
  }

  static int isMounted_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isMounted() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isMounted();
    return result ? 1 : 0;
  }

  static int isNull_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isNull() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isNull();
    return result ? 1 : 0;
  }

  static int isRootView_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isRootView() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isRootView();
    return result ? 1 : 0;
  }

  static int isVisible_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::isVisible() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isVisible();
    return result ? 1 : 0;
  }

  static ffi.Pointer<void> mapFromGlobal_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> globalPt) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::mapFromGlobal(KDDockWidgets::Point globalPt) const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.mapFromGlobal(Point.fromCppPointer(globalPt));
    return result.thisCpp;
  }

  static ffi.Pointer<void> mapTo_calledFromC(ffi.Pointer<void> thisCpp,
      ffi.Pointer<void>? parent, ffi.Pointer<void> pos) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::mapTo(KDDockWidgets::Core::View * parent, KDDockWidgets::Point pos) const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.mapTo(
        (parent == null || parent.address == 0)
            ? null
            : KDDWBindingsCore.View.fromCppPointer(parent),
        Point.fromCppPointer(pos));
    return result.thisCpp;
  }

  static ffi.Pointer<void> mapToGlobal_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> localPt) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::mapToGlobal(KDDockWidgets::Point localPt) const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.mapToGlobal(Point.fromCppPointer(localPt));
    return result.thisCpp;
  }

  static ffi.Pointer<void> maxSizeHint_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::maxSizeHint() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.maxSizeHint();
    return result.thisCpp;
  }

  static ffi.Pointer<void> minSize_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::minSize() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.minSize();
    return result.thisCpp;
  }

  static void move_2_calledFromC(ffi.Pointer<void> thisCpp, int x, int y) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::move(int x, int y)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.move_2(x, y);
  }

  static ffi.Pointer<void> normalGeometry_calledFromC(
      ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::normalGeometry() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.normalGeometry();
    return result.thisCpp;
  } // onChildAdded(KDDockWidgets::Core::View * childView)

  onChildAdded(KDDWBindingsCore.View? childView) {
    final void_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_voidstar_FFI>>(
            cFunctionSymbolName(794))
        .asFunction();
    func(thisCpp, childView == null ? ffi.nullptr : childView.thisCpp);
  }

  static void onChildAdded_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? childView) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::onChildAdded(KDDockWidgets::Core::View * childView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onChildAdded((childView == null || childView.address == 0)
        ? null
        : KDDWBindingsCore.View.fromCppPointer(childView));
  } // onChildRemoved(KDDockWidgets::Core::View * childView)

  onChildRemoved(KDDWBindingsCore.View? childView) {
    final void_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_voidstar_FFI>>(
            cFunctionSymbolName(795))
        .asFunction();
    func(thisCpp, childView == null ? ffi.nullptr : childView.thisCpp);
  }

  static void onChildRemoved_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? childView) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::onChildRemoved(KDDockWidgets::Core::View * childView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onChildRemoved((childView == null || childView.address == 0)
        ? null
        : KDDWBindingsCore.View.fromCppPointer(childView));
  } // onChildVisibilityChanged(KDDockWidgets::Core::View * childView)

  onChildVisibilityChanged(KDDWBindingsCore.View? childView) {
    final void_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_voidstar_FFI>>(
            cFunctionSymbolName(796))
        .asFunction();
    func(thisCpp, childView == null ? ffi.nullptr : childView.thisCpp);
  }

  static void onChildVisibilityChanged_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? childView) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::onChildVisibilityChanged(KDDockWidgets::Core::View * childView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onChildVisibilityChanged(
        (childView == null || childView.address == 0)
            ? null
            : KDDWBindingsCore.View.fromCppPointer(childView));
  } // onFlutterWidgetResized(int w, int h)

  bool onFlutterWidgetResized(int w, int h) {
    final bool_Func_voidstar_int_int func = _dylib
        .lookup<ffi.NativeFunction<bool_Func_voidstar_ffi_Int32_ffi_Int32_FFI>>(
            'c_KDDockWidgets__flutter__View__onFlutterWidgetResized_int_int')
        .asFunction();
    return func(thisCpp, w, h) != 0;
  } // onGeometryChanged()

  onGeometryChanged() {
    final void_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_FFI>>(
            cFunctionSymbolName(798))
        .asFunction();
    func(thisCpp);
  }

  static void onGeometryChanged_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::onGeometryChanged()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onGeometryChanged();
  } // onMouseEvent(KDDockWidgets::Event::Type eventType, KDDockWidgets::Point localPos, KDDockWidgets::Point globalPos, bool leftIsPressed)

  onMouseEvent(
      int eventType, Point localPos, Point globalPos, bool leftIsPressed) {
    final void_Func_voidstar_int_voidstar_voidstar_bool func = _dylib
        .lookup<
                ffi.NativeFunction<
                    void_Func_voidstar_ffi_Int32_voidstar_voidstar_ffi_Int8_FFI>>(
            'c_KDDockWidgets__flutter__View__onMouseEvent_Type_Point_Point_bool')
        .asFunction();
    func(
        thisCpp,
        eventType,
        localPos == null ? ffi.nullptr : localPos.thisCpp,
        globalPos == null ? ffi.nullptr : globalPos.thisCpp,
        leftIsPressed ? 1 : 0);
  } // onRebuildRequested()

  onRebuildRequested() {
    final void_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_FFI>>(
            cFunctionSymbolName(800))
        .asFunction();
    func(thisCpp);
  }

  static void onRebuildRequested_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::onRebuildRequested()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onRebuildRequested();
  }

  static int onResize_2_calledFromC(ffi.Pointer<void> thisCpp, int h, int w) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::onResize(int h, int w)! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.onResize_2(h, w);
    return result ? 1 : 0;
  }

  static void raise_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print("Dart instance not found for View::raise()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.raise();
  }

  static void raiseAndActivate_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::raiseAndActivate()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.raiseAndActivate();
  } // raiseChild(KDDockWidgets::Core::View * childView)

  raiseChild(KDDWBindingsCore.View? childView) {
    final void_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_voidstar_FFI>>(
            cFunctionSymbolName(803))
        .asFunction();
    func(thisCpp, childView == null ? ffi.nullptr : childView.thisCpp);
  }

  static void raiseChild_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? childView) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::raiseChild(KDDockWidgets::Core::View * childView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.raiseChild((childView == null || childView.address == 0)
        ? null
        : KDDWBindingsCore.View.fromCppPointer(childView));
  } // raiseWindow(KDDockWidgets::Core::View * rootView)

  raiseWindow(KDDWBindingsCore.View? rootView) {
    final void_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_voidstar_FFI>>(
            cFunctionSymbolName(804))
        .asFunction();
    func(thisCpp, rootView == null ? ffi.nullptr : rootView.thisCpp);
  }

  static void raiseWindow_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? rootView) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::raiseWindow(KDDockWidgets::Core::View * rootView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.raiseWindow((rootView == null || rootView.address == 0)
        ? null
        : KDDWBindingsCore.View.fromCppPointer(rootView));
  }

  static void releaseKeyboard_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::releaseKeyboard()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.releaseKeyboard();
  }

  static void releaseMouse_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::releaseMouse()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.releaseMouse();
  }

  static void setCursor_calledFromC(ffi.Pointer<void> thisCpp, int shape) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setCursor(Qt::CursorShape shape)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setCursor(shape);
  }

  static void setFixedHeight_calledFromC(ffi.Pointer<void> thisCpp, int h) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setFixedHeight(int h)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setFixedHeight(h);
  }

  static void setFixedWidth_calledFromC(ffi.Pointer<void> thisCpp, int w) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setFixedWidth(int w)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setFixedWidth(w);
  }

  static void setGeometry_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> geometry) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setGeometry(KDDockWidgets::Rect geometry)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setGeometry(Rect.fromCppPointer(geometry));
  }

  static void setHeight_calledFromC(ffi.Pointer<void> thisCpp, int h) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setHeight(int h)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setHeight(h);
  }

  static void setMaximumSize_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> sz) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setMaximumSize(KDDockWidgets::Size sz)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setMaximumSize(Size.fromCppPointer(sz));
  }

  static void setMinimumSize_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> sz) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setMinimumSize(KDDockWidgets::Size sz)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setMinimumSize(Size.fromCppPointer(sz));
  }

  static void setMouseTracking_calledFromC(
      ffi.Pointer<void> thisCpp, int enable) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setMouseTracking(bool enable)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setMouseTracking(enable != 0);
  } // setNormalGeometry(KDDockWidgets::Rect geo)

  setNormalGeometry(Rect geo) {
    final void_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_voidstar_FFI>>(
            'c_KDDockWidgets__flutter__View__setNormalGeometry_Rect')
        .asFunction();
    func(thisCpp, geo == null ? ffi.nullptr : geo.thisCpp);
  }

  static void setParent_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? parent) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setParent(KDDockWidgets::Core::View * parent)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setParent((parent == null || parent.address == 0)
        ? null
        : KDDWBindingsCore.View.fromCppPointer(parent));
  }

  static void setSize_2_calledFromC(ffi.Pointer<void> thisCpp, int w, int h) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setSize(int w, int h)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setSize_2(w, h);
  }

  static void setViewName_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? name) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setViewName(const QString & name)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setViewName(QString.fromCppPointer(name).toDartString());
  }

  static void setVisible_calledFromC(ffi.Pointer<void> thisCpp, int visible) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setVisible(bool visible)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setVisible(visible != 0);
  }

  static void setWidth_calledFromC(ffi.Pointer<void> thisCpp, int w) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setWidth(int w)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setWidth(w);
  }

  static void setWindowOpacity_calledFromC(
      ffi.Pointer<void> thisCpp, double v) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setWindowOpacity(double v)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setWindowOpacity(v);
  }

  static void setWindowTitle_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? title) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setWindowTitle(const QString & title)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setWindowTitle(QString.fromCppPointer(title).toDartString());
  }

  static void setZOrder_calledFromC(ffi.Pointer<void> thisCpp, int z) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::setZOrder(int z)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setZOrder(z);
  }

  static void show_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print("Dart instance not found for View::show()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.show();
  }

  static void showMaximized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::showMaximized()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.showMaximized();
  }

  static void showMinimized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::showMinimized()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.showMinimized();
  }

  static void showNormal_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::showNormal()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.showNormal();
  }

  static void update_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print("Dart instance not found for View::update()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.update();
  } // updateGeometry()

  updateGeometry() {
    final void_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_FFI>>(
            'c_KDDockWidgets__flutter__View__updateGeometry')
        .asFunction();
    func(thisCpp);
  }

  static ffi.Pointer<void> viewName_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        KDDWBindingsCore.View.s_dartInstanceByCppPtr[thisCpp.address] as View;
    if (dartInstance == null) {
      print(
          "Dart instance not found for View::viewName() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.viewName();
    return result.thisCpp;
  }

  void release() {
    final void_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_FFI>>(
            'c_KDDockWidgets__flutter__View__destructor')
        .asFunction();
    func(thisCpp);
  }

  String cFunctionSymbolName(int methodId) {
    switch (methodId) {
      case 689:
        return "c_KDDockWidgets__flutter__View__activateWindow";
      case 699:
        return "c_KDDockWidgets__flutter__View__close";
      case 701:
        return "c_KDDockWidgets__flutter__View__createPlatformWindow";
      case 707:
        return "c_KDDockWidgets__flutter__View__flags";
      case 708:
        return "c_KDDockWidgets__flutter__View__geometry";
      case 709:
        return "c_KDDockWidgets__flutter__View__grabMouse";
      case 712:
        return "c_KDDockWidgets__flutter__View__hasFocus";
      case 714:
        return "c_KDDockWidgets__flutter__View__hide";
      case 716:
        return "c_KDDockWidgets__flutter__View__init";
      case 718:
        return "c_KDDockWidgets__flutter__View__isActiveWindow";
      case 719:
        return "c_KDDockWidgets__flutter__View__isExplicitlyHidden";
      case 720:
        return "c_KDDockWidgets__flutter__View__isMaximized";
      case 721:
        return "c_KDDockWidgets__flutter__View__isMinimized";
      case 791:
        return "c_KDDockWidgets__flutter__View__isMounted";
      case 722:
        return "c_KDDockWidgets__flutter__View__isNull";
      case 723:
        return "c_KDDockWidgets__flutter__View__isRootView";
      case 724:
        return "c_KDDockWidgets__flutter__View__isVisible";
      case 725:
        return "c_KDDockWidgets__flutter__View__mapFromGlobal_Point";
      case 726:
        return "c_KDDockWidgets__flutter__View__mapTo_View_Point";
      case 727:
        return "c_KDDockWidgets__flutter__View__mapToGlobal_Point";
      case 728:
        return "c_KDDockWidgets__flutter__View__maxSizeHint";
      case 729:
        return "c_KDDockWidgets__flutter__View__minSize";
      case 733:
        return "c_KDDockWidgets__flutter__View__move_int_int";
      case 734:
        return "c_KDDockWidgets__flutter__View__normalGeometry";
      case 794:
        return "c_KDDockWidgets__flutter__View__onChildAdded_View";
      case 795:
        return "c_KDDockWidgets__flutter__View__onChildRemoved_View";
      case 796:
        return "c_KDDockWidgets__flutter__View__onChildVisibilityChanged_View";
      case 798:
        return "c_KDDockWidgets__flutter__View__onGeometryChanged";
      case 800:
        return "c_KDDockWidgets__flutter__View__onRebuildRequested";
      case 736:
        return "c_KDDockWidgets__flutter__View__onResize_int_int";
      case 738:
        return "c_KDDockWidgets__flutter__View__raise";
      case 739:
        return "c_KDDockWidgets__flutter__View__raiseAndActivate";
      case 803:
        return "c_KDDockWidgets__flutter__View__raiseChild_View";
      case 804:
        return "c_KDDockWidgets__flutter__View__raiseWindow_View";
      case 741:
        return "c_KDDockWidgets__flutter__View__releaseKeyboard";
      case 742:
        return "c_KDDockWidgets__flutter__View__releaseMouse";
      case 745:
        return "c_KDDockWidgets__flutter__View__setCursor_CursorShape";
      case 746:
        return "c_KDDockWidgets__flutter__View__setFixedHeight_int";
      case 747:
        return "c_KDDockWidgets__flutter__View__setFixedWidth_int";
      case 748:
        return "c_KDDockWidgets__flutter__View__setGeometry_Rect";
      case 749:
        return "c_KDDockWidgets__flutter__View__setHeight_int";
      case 750:
        return "c_KDDockWidgets__flutter__View__setMaximumSize_Size";
      case 751:
        return "c_KDDockWidgets__flutter__View__setMinimumSize_Size";
      case 752:
        return "c_KDDockWidgets__flutter__View__setMouseTracking_bool";
      case 753:
        return "c_KDDockWidgets__flutter__View__setParent_View";
      case 755:
        return "c_KDDockWidgets__flutter__View__setSize_int_int";
      case 756:
        return "c_KDDockWidgets__flutter__View__setViewName_QString";
      case 757:
        return "c_KDDockWidgets__flutter__View__setVisible_bool";
      case 758:
        return "c_KDDockWidgets__flutter__View__setWidth_int";
      case 759:
        return "c_KDDockWidgets__flutter__View__setWindowOpacity_double";
      case 760:
        return "c_KDDockWidgets__flutter__View__setWindowTitle_QString";
      case 761:
        return "c_KDDockWidgets__flutter__View__setZOrder_int";
      case 762:
        return "c_KDDockWidgets__flutter__View__show";
      case 763:
        return "c_KDDockWidgets__flutter__View__showMaximized";
      case 764:
        return "c_KDDockWidgets__flutter__View__showMinimized";
      case 765:
        return "c_KDDockWidgets__flutter__View__showNormal";
      case 767:
        return "c_KDDockWidgets__flutter__View__update";
      case 768:
        return "c_KDDockWidgets__flutter__View__viewName";
    }
    return super.cFunctionSymbolName(methodId);
  }

  static String methodNameFromId(int methodId) {
    switch (methodId) {
      case 689:
        return "activateWindow";
      case 699:
        return "close";
      case 701:
        return "createPlatformWindow";
      case 707:
        return "flags";
      case 708:
        return "geometry";
      case 709:
        return "grabMouse";
      case 712:
        return "hasFocus";
      case 714:
        return "hide";
      case 716:
        return "init";
      case 718:
        return "isActiveWindow";
      case 719:
        return "isExplicitlyHidden";
      case 720:
        return "isMaximized";
      case 721:
        return "isMinimized";
      case 791:
        return "isMounted";
      case 722:
        return "isNull";
      case 723:
        return "isRootView";
      case 724:
        return "isVisible";
      case 725:
        return "mapFromGlobal";
      case 726:
        return "mapTo";
      case 727:
        return "mapToGlobal";
      case 728:
        return "maxSizeHint";
      case 729:
        return "minSize";
      case 733:
        return "move_2";
      case 734:
        return "normalGeometry";
      case 794:
        return "onChildAdded";
      case 795:
        return "onChildRemoved";
      case 796:
        return "onChildVisibilityChanged";
      case 798:
        return "onGeometryChanged";
      case 800:
        return "onRebuildRequested";
      case 736:
        return "onResize_2";
      case 738:
        return "raise";
      case 739:
        return "raiseAndActivate";
      case 803:
        return "raiseChild";
      case 804:
        return "raiseWindow";
      case 741:
        return "releaseKeyboard";
      case 742:
        return "releaseMouse";
      case 745:
        return "setCursor";
      case 746:
        return "setFixedHeight";
      case 747:
        return "setFixedWidth";
      case 748:
        return "setGeometry";
      case 749:
        return "setHeight";
      case 750:
        return "setMaximumSize";
      case 751:
        return "setMinimumSize";
      case 752:
        return "setMouseTracking";
      case 753:
        return "setParent";
      case 755:
        return "setSize_2";
      case 756:
        return "setViewName";
      case 757:
        return "setVisible";
      case 758:
        return "setWidth";
      case 759:
        return "setWindowOpacity";
      case 760:
        return "setWindowTitle";
      case 761:
        return "setZOrder";
      case 762:
        return "show";
      case 763:
        return "showMaximized";
      case 764:
        return "showMinimized";
      case 765:
        return "showNormal";
      case 767:
        return "update";
      case 768:
        return "viewName";
    }
    throw Error();
  }

  void registerCallbacks() {
    assert(thisCpp != null);
    final RegisterMethodIsReimplementedCallback registerCallback = _dylib
        .lookup<ffi.NativeFunction<RegisterMethodIsReimplementedCallback_FFI>>(
            'c_KDDockWidgets__flutter__View__registerVirtualMethodCallback')
        .asFunction();
    final callback689 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.activateWindow_calledFromC);
    registerCallback(thisCpp, callback689, 689);
    const callbackExcept699 = 0;
    final callback699 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.close_calledFromC, callbackExcept699);
    registerCallback(thisCpp, callback699, 699);
    final callback701 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsCore.View.createPlatformWindow_calledFromC);
    registerCallback(thisCpp, callback701, 701);
    const callbackExcept707 = 0;
    final callback707 = ffi.Pointer.fromFunction<int_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.flags_calledFromC, callbackExcept707);
    registerCallback(thisCpp, callback707, 707);
    final callback708 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.geometry_calledFromC);
    registerCallback(thisCpp, callback708, 708);
    final callback709 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.grabMouse_calledFromC);
    registerCallback(thisCpp, callback709, 709);
    const callbackExcept712 = 0;
    final callback712 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.hasFocus_calledFromC, callbackExcept712);
    registerCallback(thisCpp, callback712, 712);
    final callback714 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.hide_calledFromC);
    registerCallback(thisCpp, callback714, 714);
    final callback716 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsCore.View.init_calledFromC);
    registerCallback(thisCpp, callback716, 716);
    const callbackExcept718 = 0;
    final callback718 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isActiveWindow_calledFromC, callbackExcept718);
    registerCallback(thisCpp, callback718, 718);
    const callbackExcept719 = 0;
    final callback719 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isExplicitlyHidden_calledFromC,
        callbackExcept719);
    registerCallback(thisCpp, callback719, 719);
    const callbackExcept720 = 0;
    final callback720 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isMaximized_calledFromC, callbackExcept720);
    registerCallback(thisCpp, callback720, 720);
    const callbackExcept721 = 0;
    final callback721 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isMinimized_calledFromC, callbackExcept721);
    registerCallback(thisCpp, callback721, 721);
    const callbackExcept791 = 0;
    final callback791 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isMounted_calledFromC, callbackExcept791);
    registerCallback(thisCpp, callback791, 791);
    const callbackExcept722 = 0;
    final callback722 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsCore.View.isNull_calledFromC, callbackExcept722);
    registerCallback(thisCpp, callback722, 722);
    const callbackExcept723 = 0;
    final callback723 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isRootView_calledFromC, callbackExcept723);
    registerCallback(thisCpp, callback723, 723);
    const callbackExcept724 = 0;
    final callback724 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.isVisible_calledFromC, callbackExcept724);
    registerCallback(thisCpp, callback724, 724);
    final callback725 =
        ffi.Pointer.fromFunction<voidstar_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.mapFromGlobal_calledFromC);
    registerCallback(thisCpp, callback725, 725);
    final callback726 =
        ffi.Pointer.fromFunction<voidstar_Func_voidstar_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.mapTo_calledFromC);
    registerCallback(thisCpp, callback726, 726);
    final callback727 =
        ffi.Pointer.fromFunction<voidstar_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.mapToGlobal_calledFromC);
    registerCallback(thisCpp, callback727, 727);
    final callback728 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.maxSizeHint_calledFromC);
    registerCallback(thisCpp, callback728, 728);
    final callback729 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.minSize_calledFromC);
    registerCallback(thisCpp, callback729, 729);
    final callback733 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.move_2_calledFromC);
    registerCallback(thisCpp, callback733, 733);
    final callback734 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.normalGeometry_calledFromC);
    registerCallback(thisCpp, callback734, 734);
    final callback794 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.onChildAdded_calledFromC);
    registerCallback(thisCpp, callback794, 794);
    final callback795 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.onChildRemoved_calledFromC);
    registerCallback(thisCpp, callback795, 795);
    final callback796 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.onChildVisibilityChanged_calledFromC);
    registerCallback(thisCpp, callback796, 796);
    final callback798 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.onGeometryChanged_calledFromC);
    registerCallback(thisCpp, callback798, 798);
    final callback800 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.onRebuildRequested_calledFromC);
    registerCallback(thisCpp, callback800, 800);
    const callbackExcept736 = 0;
    final callback736 =
        ffi.Pointer.fromFunction<bool_Func_voidstar_ffi_Int32_ffi_Int32_FFI>(
            KDDWBindingsCore.View.onResize_2_calledFromC, callbackExcept736);
    registerCallback(thisCpp, callback736, 736);
    final callback738 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.raise_calledFromC);
    registerCallback(thisCpp, callback738, 738);
    final callback739 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.raiseAndActivate_calledFromC);
    registerCallback(thisCpp, callback739, 739);
    final callback803 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.raiseChild_calledFromC);
    registerCallback(thisCpp, callback803, 803);
    final callback804 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.raiseWindow_calledFromC);
    registerCallback(thisCpp, callback804, 804);
    final callback741 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.releaseKeyboard_calledFromC);
    registerCallback(thisCpp, callback741, 741);
    final callback742 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.releaseMouse_calledFromC);
    registerCallback(thisCpp, callback742, 742);
    final callback745 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setCursor_calledFromC);
    registerCallback(thisCpp, callback745, 745);
    final callback746 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setFixedHeight_calledFromC);
    registerCallback(thisCpp, callback746, 746);
    final callback747 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setFixedWidth_calledFromC);
    registerCallback(thisCpp, callback747, 747);
    final callback748 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.setGeometry_calledFromC);
    registerCallback(thisCpp, callback748, 748);
    final callback749 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setHeight_calledFromC);
    registerCallback(thisCpp, callback749, 749);
    final callback750 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.setMaximumSize_calledFromC);
    registerCallback(thisCpp, callback750, 750);
    final callback751 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.setMinimumSize_calledFromC);
    registerCallback(thisCpp, callback751, 751);
    final callback752 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int8_FFI>(
            KDDWBindingsFlutter.View.setMouseTracking_calledFromC);
    registerCallback(thisCpp, callback752, 752);
    final callback753 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.setParent_calledFromC);
    registerCallback(thisCpp, callback753, 753);
    final callback755 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setSize_2_calledFromC);
    registerCallback(thisCpp, callback755, 755);
    final callback756 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.setViewName_calledFromC);
    registerCallback(thisCpp, callback756, 756);
    final callback757 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int8_FFI>(
            KDDWBindingsFlutter.View.setVisible_calledFromC);
    registerCallback(thisCpp, callback757, 757);
    final callback758 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setWidth_calledFromC);
    registerCallback(thisCpp, callback758, 758);
    final callback759 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Double_FFI>(
            KDDWBindingsFlutter.View.setWindowOpacity_calledFromC);
    registerCallback(thisCpp, callback759, 759);
    final callback760 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            KDDWBindingsFlutter.View.setWindowTitle_calledFromC);
    registerCallback(thisCpp, callback760, 760);
    final callback761 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            KDDWBindingsFlutter.View.setZOrder_calledFromC);
    registerCallback(thisCpp, callback761, 761);
    final callback762 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.show_calledFromC);
    registerCallback(thisCpp, callback762, 762);
    final callback763 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.showMaximized_calledFromC);
    registerCallback(thisCpp, callback763, 763);
    final callback764 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.showMinimized_calledFromC);
    registerCallback(thisCpp, callback764, 764);
    final callback765 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.showNormal_calledFromC);
    registerCallback(thisCpp, callback765, 765);
    final callback767 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.update_calledFromC);
    registerCallback(thisCpp, callback767, 767);
    final callback768 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        KDDWBindingsFlutter.View.viewName_calledFromC);
    registerCallback(thisCpp, callback768, 768);
  }
}
