/**
 * Copyright (c) 2021, Florian Buestgens
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     1. Redistributions of source code must retain the above copyright
 *        notice, this list of conditions and the following disclaimer.
 *
 *     2. Redistributions in binary form must reproduce the above copyright notice,
 *        this list of conditions and the following disclaimer in the
 *        documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY Florian Buestgens ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Florian Buestgens BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#pragma once

#include <string.hpp>
#include <system/types.hpp>
#include "ip.hpp"

namespace synos
{
namespace net
{
namespace core
{
/**
 * @brief Specify a endpoint (for example a client in the local network) 
 *        who is allowed to read the published resource at url
 */
template <typename IP> class Endpoint {
	/// The remote IP which is allowed to connect. This param must be defined at bootup. It can't be changed later.
	const IP ip_;

	/// The resource which is allowed to read. Probably a log from a specific subsystem.
	const stdk::string url_;

    public:
	/**
	 * @brief Constructs a endpoint object
	 * @param ip The remote IP which is allowed to connect. This param must be defined at bootup. It can't be changed later.
	 * @param url The resource which is allowed to read. Probably a log from a specific subsystem.
	 */
	Endpoint(IP ip, stdk::string url) : ip_(ip), url_(url)
	{
	}
};
} // namespace core
} // namespace net
} // namespace synos
