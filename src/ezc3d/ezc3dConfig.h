#ifndef EZC3D_CONFIG_H
#define EZC3D_CONFIG_H

// dllexport/import declaration
#ifdef EZC3D_SHARED
#ifdef _WIN32
#ifdef EZC3D_API_EXPORTS
#define EZC3D_API __declspec(dllexport)
#else
#define EZC3D_API __declspec(dllimport)
#endif
#else
#define EZC3D_API
#endif
#else
#define EZC3D_API
#endif

#ifdef _WIN32
#define EZC3D_VISIBILITY
#else
#define EZC3D_VISIBILITY __attribute__((visibility("default")))
#endif

// Write down the version of the ezc3d
#define EZC3D_VERSION                                                          \
  "@EZC3D_VERSION_MAJOR@.@EZC3D_VERSION_MINOR@.@EZC3D_VERSION_PATCH@"
#define EZC3D_CONTACT "pariterre@hotmail.com"

#endif // EZC3D_CONFIG_H
