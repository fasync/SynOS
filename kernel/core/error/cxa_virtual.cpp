#include "panic.hpp"
/**
 * This function gets called if our kernel detects that not all pure virtual
 * functions can be called.
 * This should NEVER be called. If it is, it's probably because of undefined
 * behavior.
 */
extern "C" void __cxa_pure_virtual()
{
	// synos::core::error::panic(
	// 	"ERROR: Not all virtual functions could be called. This is dangerous.");
}
