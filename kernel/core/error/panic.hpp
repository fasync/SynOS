#pragma once

#include "type.hpp"
#include "../log/log.hpp"
#include <string.hpp>

namespace synos
{
namespace core
{
namespace error
{
using synos::core::error::ErrorType;
using synos::core::log::Logger;

static void panic(stdk::string msg, Logger log, ErrorType = ErrorType::Fatal)
{
}
} // namespace error
} // namespace core
} // namespace synos
