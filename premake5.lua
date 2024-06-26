workspace "Win32WPF"
	startproject "Win32WPF"
	
	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["Glad"] = "CppDll/Vendor/Glad/include"
IncludeDir["GLFW"] = "CppDll/Vendor/GLFW/include"

include "CppDll/Vendor/Glad"
include "CppDll/Vendor/GLFW"

project "CppDll"
	location "CppDll"
	kind "SharedLib"
	language "C++"
	cppdialect "C++17"
	architecture "x86_64"
	staticruntime "off"
	
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	
	pchheader "pch.h"
	pchsource "CppDll/src/pch.cpp"
	
	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}
	
	defines
	{
		"_CRT_SECURE_NO_WARNINGS"
	}
	
	includedirs
	{
		"%{prj.name}/src",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.GLFW}",
	}
	
	links
	{
		"Glad",
		"GLFW",
		"opengl32.lib"
	}
	
	filter "system:windows"
		systemversion "latest"
		
		defines
		{
			"ME_PLATFORM_WINDOWS",
			"ME_DYNAMIC_LINK",
			"ME_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
		}
		
		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Win32WPF/\"")
		}
		
	filter "configurations:Debug"
		defines "ME_DEBUG"
		runtime "Debug"
		symbols "on"
		
	filter "configurations:Release"
		defines "ME_RELEASE"
		runtime "Release"
		optimize "on"
		
	filter "configurations:Dist"
		defines "ME_DIST"
		runtime "Release"
		optimize "on"

project "Win32WPF"
	location "Win32WPF"
	kind "WindowedApp"
	language "C#"

	dotnetframework "net8.0-windows"

	targetdir ("bin/" .. outputdir .. "x86_64/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "x86_64/%{prj.name}")

	flags
	{
		"WPF"
	}

	files
	{
		"%{prj.name}/*.cs",
	}
