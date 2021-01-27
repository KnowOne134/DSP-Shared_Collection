inline int32 CLuaBaseEntity::addItem(lua_State *L)
{
    // exsisting code
    if (lua_istable(L,1))
    {
        //exsisting code
        if (PChar->getStorage(LOC_INVENTORY)->GetFreeSlotsCount() != 0)
        {
            //exsisting code
                lua_getfield(L, 1, "appraisal");
                if (!lua_isnil(L, -1) && lua_isnumber(L, -1))
                {
                    uint8* appid = (uint8*)lua_tointeger(L, -1);
                    PItem->setAppraisalID(appid);
                }
                //exsisting code