#pragma once

#include "type.hpp"
#include "../log/log.hpp"
#include "../string.hpp"

namespace stdk
{
namespace Error
{
static void panic(stdk::string, stdk::Log::Logger log,
		  stdk::Error::ErrorType type = stdk::Error::ErrorType::Fatal)
{
}
} // namespace Error
} // namespace stdk
