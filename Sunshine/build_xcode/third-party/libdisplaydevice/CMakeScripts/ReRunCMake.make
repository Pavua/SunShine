# Generated by CMake, DO NOT EDIT

TARGETS:= 
empty:= 
space:= $(empty) $(empty)
spaceplus:= $(empty)\ $(empty)

TARGETS += $(subst $(space),$(spaceplus),$(wildcard /Users/pablito/SunShine/Sunshine/third-party/libdisplaydevice/CMakeLists.txt))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /Users/pablito/SunShine/Sunshine/third-party/libdisplaydevice/cmake/Json_DD.cmake))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /Users/pablito/SunShine/Sunshine/third-party/libdisplaydevice/src/CMakeLists.txt))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /Users/pablito/SunShine/Sunshine/third-party/libdisplaydevice/src/common/CMakeLists.txt))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /opt/homebrew/share/cmake/Modules/FindPackageHandleStandardArgs.cmake))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /opt/homebrew/share/cmake/Modules/FindPackageMessage.cmake))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /opt/homebrew/share/cmake/nlohmann_json/nlohmann_jsonConfig.cmake))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /opt/homebrew/share/cmake/nlohmann_json/nlohmann_jsonConfigVersion.cmake))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /opt/homebrew/share/cmake/nlohmann_json/nlohmann_jsonTargets.cmake))
TARGETS += $(subst $(space),$(spaceplus),$(wildcard /Users/pablito/SunShine/Sunshine/build_xcode/CMakeFiles/cmake.verify_globs))

.NOTPARALLEL:

.PHONY: all VERIFY_GLOBS

all: VERIFY_GLOBS /Users/pablito/SunShine/Sunshine/build_xcode/CMakeFiles/cmake.check_cache

VERIFY_GLOBS:
	/opt/homebrew/bin/cmake -P /Users/pablito/SunShine/Sunshine/build_xcode/CMakeFiles/VerifyGlobs.cmake

/Users/pablito/SunShine/Sunshine/build_xcode/CMakeFiles/cmake.check_cache: $(TARGETS)
	/opt/homebrew/bin/cmake -S/Users/pablito/SunShine/Sunshine -B/Users/pablito/SunShine/Sunshine/build_xcode
