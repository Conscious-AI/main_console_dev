## 1. Changes made in `runner/main.cpp`

#### In method `wWinMain()`

```cpp
// Get & Set window WorkArea size
RECT workArea;
SystemParametersInfoA(SPI_GETWORKAREA, 0, &workArea, 0);

// Aligning window at far right
Win32Window::Point origin(workArea.right - (workArea.right / 6), 0);
// Adjusting to right size
Win32Window::Size size(workArea.right / 6, workArea.bottom);
```

## 2. Changes made in `runner/win32_window.cpp`

#### In typedef `HWND window` in method `Win32Window::CreateAndShow()`

Replaced `WS_OVERLAPPEDWINDOW` with `WS_POPUP`.

#### Added just after the above replacement

```cpp
// Removing all window styles
SetWindowLong(window, GWL_EXSTYLE, WS_EX_TOOLWINDOW | WS_EX_LAYERED | WS_VISIBLE);

// Setting tranparency of layered windows
SetLayeredWindowAttributes(window, NULL, 200, LWA_ALPHA);
```