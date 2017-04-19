#include "clang-c/Platform.h"

#ifdef I // For some reason this is defined
#undef I
#endif

#include "clang-c/Index.h"
#include "clang-c/BuildSystem.h"
#include "clang-c/CXErrorCode.h"
#include "clang-c/Documentation.h"
#include "clang-c/CXCompilationDatabase.h"
#include "clang-c/CXString.h"
