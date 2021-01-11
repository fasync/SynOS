#pragma once

#include "error/type.hpp"
#include "log/log.hpp"
#include "string.hpp"

namespace stdk {
static void
panic(stdk::string, stdk::Log::Logger log,
    stdk::Error::ErrorType type = stdk::Error::ErrorType::Fatal)
{
}
}