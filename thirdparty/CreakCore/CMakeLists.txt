cmake_minimum_required(VERSION 3.20)

project(CreakCore)

if(XCODE)
    set(CMAKE_XCODE_GENERATE_TOP_LEVEL_PROJECT_ONLY TRUE)
endif()

MESSAGE( STATUS "======= Start Build " ${PROJECT_NAME} " =======")

enable_testing()

enable_language(CXX)
enable_language(OBJC)
# enable_language(SWIFT)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
# SET(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "Build architectures for Mac OS X" FORCE)
set(CMAKE_XCODE_ATTRIBUTE_ARCHS "$(ARCHS_STANDARD)")
set(CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD)")

MESSAGE( STATUS "CMAKE_CXX_FLAGS: " ${CMAKE_CXX_FLAGS} )
MESSAGE( STATUS "CMAKE_OBJC_FLAGS: " ${CMAKE_OBJC_FLAGS} )

# if(CMAKE_GENERATOR MATCHES "Xcode")
# elseif(CMAKE_GENERATOR MATCHES "Visual Studio")
# endif()

###### Check Dependency Librarys ######

### C++ Flags ###
set(CMAKE_CXX_FLAGS "-stdlib=libc++")
include(CheckCXXSymbolExists)
check_cxx_symbol_exists(kqueue sys/event.h HAVE_KQUEUE)
if(NOT HAVE_KQUEUE)
  message(STATUS "kqueue NOT found!")
else()
  message(STATUS "kqueue found!")
endif()

### NSFoundation ###
find_library(FOUNDATION_LIBRARY Foundation)
if (NOT FOUNDATION_LIBRARY)
  message(STATUS "Foundation.framework NOT found!")
else()
  message(STATUS "Foundation.framework found! ${FOUNDATION_LIBRARY}")
endif()

### Core Graphics ###
find_library(CG_LIBRARY CoreGraphics)
if (NOT CG_LIBRARY)
  message(STATUS "CoreGraphics.framework NOT found!")
else()
  message(STATUS "CoreGraphics.framework found! ${CG_LIBRARY}")
endif()

### Core Video ###
find_library(CV_LIBRARY CoreVideo)
if (NOT CV_LIBRARY)
  message(STATUS "CoreVideo.framework NOT found!")
else()
  message(STATUS "CoreVideo.framework found! ${CV_LIBRARY}")
endif()

### APPKIT (For macOS) ### 
find_library(APPKIT_LIBRARY AppKit)
if (NOT APPKIT_LIBRARY)
  message(STATUS "AppKit.framework NOT found!")
else()
  message(STATUS "AppKit.framework found! ${APPKIT_LIBRARY}")
endif()

### UIKit (For iOS) ###
# find_library(UIKIT_LIBRARY UIKit)
# if (NOT UIKIT_LIBRARY)
#   message(STATUS "UIKit.framework NOT found!")
# else()
#   message(STATUS "UIKit.framework found! ${UIKIT_LIBRARY}")
# endif()

# Hook up XCTest for the supported plaforms (all but WatchOS)
if(NOT PLATFORM MATCHES ".*WATCHOS.*")
  # Use the standard find_package, broken between 3.14.0 and 3.14.4 at least for XCtest...
  find_package(XCTest)
  # Fallback: Try to find XCtest as host package via toochain macro (should always work)
  # find_host_package(XCTest REQUIRED)
endif()

### Setup Dependency List ###
set(DEPENDENCY_LIBRARY
${FOUNDATION_LIBRARY}
${CG_LIBRARY}
${CV_LIBRARY}
)

### Add DEPENDENCY_LIBRARY to grpahics Library(Metal or OGL) ###
if(USE_METAL)
# set(DEPENDENCY_LIBRARY ${DEPENDENCY_LIBRARY})
else() # !USE_METAL -> USE_OPENGL
  find_library(OGL_LIBRARY OpenGL)
  if (NOT OGL_LIBRARY)
    message(STATUS "OpenGL.framework NOT found!")
  else()
    message(STATUS "OpenGL.framework found! ${OGL_LIBRARY}")
  endif()
  list(APPEND DEPENDENCY_LIBRARY ${OGL_LIBRARY})
endif()

###### Setup File List ######
set(FRAMWORK_NAME CreakCoreAppKit)

set(SOURCES
  sources/CreakNSOGLView.mm
  sources/CreckOGLRenderer.cpp
)
set(HEADERS
  private_headers/CreakFlags.h
  private_headers/CreckOGLHelper.hpp
  private_headers/CreckOGLRenderer.hpp
)
set(PUBLIC_HEADERS
  public_headers/CreakAppleFlags.h
  public_headers/CreakCoreAppKit.h
  public_headers/CreakNSOGLView.h
  public_headers/CreakOpenGLFlags.h
)
set(BUNDLE_RESOURCES
  resources/basic.frag
  resources/basic.vert
)

###### Setup Library Files ######
if(BUILD_STATIC_FRAMEWORK)
  add_library (CreakCoreAppKit STATIC ${SOURCES} ${HEADERS} ${PUBLIC_HEADERS})
  target_link_libraries(CreakCoreAppKit ${DEPENDENCY_LIBRARY} ${APPKIT_LIBRARY})
  message(STATUS CreakCoreAppKit " - Building static version...")
else() # !BUILD_STATIC_FRAMEWORK
  add_library (CreakCoreAppKit SHARED ${SOURCES} ${HEADERS} ${PUBLIC_HEADERS})
  target_link_libraries(CreakCoreAppKit ${DEPENDENCY_LIBRARY} ${APPKIT_LIBRARY})
  target_compile_definitions(CreakCoreAppKit PUBLIC IS_BUILDING_SHARED)
  message(STATUS CreakCoreAppKit " - Building shared version...")
endif()

###### Setup Framwork Target ######
message( STATUS "Try Create Target - " CreakCoreAppKit "...")
### Setup Target ###
set_target_properties(CreakCoreAppKit PROPERTIES
  FRAMEWORK TRUE
  MACOSX_BUNDLE TRUE
  FRAMEWORK_VERSION C
  MACOSX_FRAMEWORK_IDENTIFIER com.SWKim.CreakCore
  # MACOSX_FRAMEWORK_INFO_PLIST Info.plist
  # "current version" in semantic format in Mach-O binary file
  VERSION 16.4.0
  # "compatibility version" in semantic format in Mach-O binary file
  SOVERSION 1.0.0
  PUBLIC_HEADER ${PUBLIC_HEADERS}
  RESOURCE ${BUNDLE_RESOURCES}
  # XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
)

### Setup Auto Refence Count For Objective-C/C++ ###
if(NOT ARC_OFF)
# set_property (TARGET CreakCoreAppKit APPEND_STRING PROPERTY 
#               COMPILE_FLAGS "-fobjc-arc")
  target_compile_options(CreakCoreAppKit PUBLIC "-fobjc-arc")
  message(STATUS "Use Auto Reference Count for Objective-C/C++...")
else()
  message(STATUS "Don't Use Auto Reference Count for Objective-C/C++...")
endif()

MESSAGE( STATUS "======= End Build " ${PROJECT_NAME} " =======")