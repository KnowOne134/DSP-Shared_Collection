int32 CLuaItem::getAppraisalID(lua_State* L)
{
    DSP_DEBUG_BREAK_IF(m_PLuaItem == nullptr);

    auto PItem = dynamic_cast<CItem*>(m_PLuaItem);
    if (PItem)
    {
        lua_pushinteger(L, PItem->m_extra[0x16]);
    }
    else
        lua_pushinteger(L, 0);

    return 1;
}