-- mail_everyone/init.lua
-- Send email to everyone by moderators
--[[
    Copyright (C) 2024  1F616EMO

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
    USA
]]

local S = core.get_translator("mail_everyone")

if not mail.register_recipient_handler then
    error("[admin_mail] Please use the most recent version of mail (commit ea7773730ec8fa73dfef304fa0f1ff03013e0fba).")
end

local auth

mail.register_recipient_handler(function(sender, name)
    if name ~= "$everyone" then return nil end

    if not core.check_player_privs(sender, { ban = true }) then
        return false, S("Insufficant privileges to send to everyone!")
    end

    auth = auth or core.get_auth_handler()
    local list_dest = {}
    for i_name in auth.iterate() do
        if i_name ~= sender then
            list_dest[#list_dest + 1] = i_name
        end
    end

    return true, list_dest
end)
