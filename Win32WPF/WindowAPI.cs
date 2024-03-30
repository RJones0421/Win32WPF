using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace Win32WPF
{
  public class WindowAPI
  {
    private const string windowDLL = @"D:\WPFTest\Win32WPF\bin\Debug-windows-x86_64\Win32WPF\CppDll.dll";

    [DllImport(windowDLL)]
    public static extern IntPtr InitializeWin32(IntPtr host, int width, int height);
  }
}
