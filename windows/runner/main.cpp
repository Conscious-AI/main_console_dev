#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "run_loop.h"
#include "utils.h"
#include "window_configuration.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command)
{
  // Get window WorkArea Size
  RECT workArea;
  SystemParametersInfoA(SPI_GETWORKAREA, 0, &workArea, 0);

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent())
  {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  RunLoop run_loop;

  flutter::DartProject project(L"data");
  FlutterWindow window(&run_loop, project);

  Win32Window::Point origin(workArea.right - (workArea.right / 6), 0);
  Win32Window::Size size(workArea.right / 6, workArea.bottom);

  if (!window.CreateAndShow(kFlutterWindowTitle, origin, size))
  {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  run_loop.Run();

  ::CoUninitialize();
  return EXIT_SUCCESS;
}