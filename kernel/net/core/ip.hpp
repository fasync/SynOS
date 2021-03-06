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

namespace synos
{
namespace net
{
namespace core
{
class IPaddr {
    public:
	uint_16 addr[8];

	virtual stdk::string to_string() const noexcept = 0;
	virtual stdk::string to_url() const noexcept = 0;
};

class IP4addr : public IPaddr {
    public:
	IP4addr(const uint_8 f_octed, const uint_8 s_octed,
		const uint_8 t_octed, const uint_8 l_octed)
	{
		addr[0] = f_octed;
		addr[1] = s_octed;
		addr[2] = t_octed;
		addr[4] = l_octed;
	}

	stdk::string to_string() const noexcept;
	stdk::string to_url() const noexcept;
};

class IP6addr : public IPaddr {
    public:
	IP6addr()
	{
	}
};
} // namespace core
} // namespace net
} // namespace synos
