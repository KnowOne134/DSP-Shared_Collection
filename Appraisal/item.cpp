/************************************************************************
*                                                                       *
*  Appraisal Origin IDs                                                 *
*                                                                       *
************************************************************************/

void CItem::setAppraisalID(uint8* appID)
{
    memcpy(m_extra + 0x16, &appID, sizeof(m_extra) - 0x16);
}