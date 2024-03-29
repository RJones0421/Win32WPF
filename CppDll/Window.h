#pragma once

#include "pch.h"

// Window procedure
LRESULT CALLBACK window_proc( HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam )
{
  switch (msg)
  {
  case WM_CLOSE:
    DestroyWindow( hwnd );
    return 0;
  case WM_DESTROY:
    PostQuitMessage( 0 );
    return 0;
  case WM_SIZE:
    break;
  default:
    break;
  }

  return DefWindowProc( hwnd, msg, wparam, lparam );
}

#define DLL_EXPORT extern "C" __declspec(dllexport)

using window_handle = HWND;
window_handle window{ nullptr };

DLL_EXPORT window_handle InitializeWin32( window_handle parent, int width, int height )
{
  // Create window class
  WNDCLASSEX wc;
  ZeroMemory( &wc, sizeof( wc ) );
  wc.cbSize = sizeof( wc );
  wc.style = CS_HREDRAW | CS_VREDRAW;
  wc.lpfnWndProc = window_proc;
  wc.cbClsExtra = 0;
  wc.cbWndExtra = 0;
  wc.hInstance = 0;
  wc.hIcon = LoadIcon( NULL, IDI_APPLICATION );
  wc.hCursor = LoadCursor( NULL, IDC_ARROW );
  wc.hbrBackground = CreateSolidBrush( RGB( 255, 0, 100 ) );
  wc.lpszMenuName = NULL;
  wc.lpszClassName = L"Win32Window";
  wc.hIconSm = LoadIcon( NULL, IDI_APPLICATION );

  // Register window class
  RegisterClassEx( &wc );
  RECT rect{};
  GetWindowRect( parent, &rect );
  AdjustWindowRect( &rect, WS_CHILD, false );

  const int top{ rect.top };
  const int left{ rect.left };
  const int init_width{ rect.right - left };
  const int init_height{ rect.bottom - top };

  const wchar_t* caption{ L"Win32 Window Caption" };

  // Create a window instance
  window = CreateWindowEx(
    0,
    wc.lpszClassName,
    caption,
    WS_CHILD,
    left,
    top,
    init_width,
    init_height,
    parent,
    NULL,
    NULL,
    NULL
  );

  ShowWindow( window, SW_SHOWNORMAL );
  UpdateWindow( window );
  return window;
}
