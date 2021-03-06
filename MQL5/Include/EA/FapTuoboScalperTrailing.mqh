//+------------------------------------------------------------------+
//|                                     FapTuoboScalperTrainling.mqh |
//|                                                         Zephyrrr |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Zephyrrr"
#property link      "http://www.mql5.com"

#include <ExpertModel\ExpertModel.mqh>
#include <ExpertModel\ExpertModelTrailing.mqh>

#include <Trade\Trade.mqh>
 
class CFapTuoboScalperTrailing : public CExpertModelTrailing
{
private:
    int gi_StopLoss, gi_TakeProfit;
    void SetOrderLevels(CTableOrder *order, double& sl,double& tp);
public:
                      CFapTuoboScalperTrailing();
    virtual bool      ValidationSettings();
    virtual bool      InitIndicators(CIndicators* indicators);
    
    virtual bool      CheckTrailingStopLong(CTableOrder* order,double& sl,double& tp);
    virtual bool      CheckTrailingStopShort(CTableOrder* order,double& sl,double& tp);
    
    void InitParameters();
};

void CFapTuoboScalperTrailing::CFapTuoboScalperTrailing()
{
}

bool CFapTuoboScalperTrailing::ValidationSettings()
{
    if (!CExpertModelTrailing::ValidationSettings())
        return false;
        
   return true;
}

void CFapTuoboScalperTrailing::InitParameters()
{
    int Scalper_EURGBP_TakeProfit = 5;
int Scalper_EURGBP_StopLoss = 35;
int Scalper_EURCHF_TakeProfit = 3;
int Scalper_EURCHF_StopLoss = 93;
int Scalper_GBPCHF_TakeProfit = 10;
int Scalper_GBPCHF_StopLoss = 81;
int Scalper_USDCAD_TakeProfit = 11;
int Scalper_USDCAD_StopLoss = 73;
int Scalper_USDCHF_TakeProfit = 9;
int Scalper_USDCHF_StopLoss = 82;
int Scalper_GBPUSD_TakeProfit = 10;
int Scalper_GBPUSD_StopLoss = 76;
int Scalper_EURUSD_TakeProfit = 16;
int Scalper_EURUSD_StopLoss = 69;

    if (m_symbol.Name() == "EURGBP")
    {
            gi_TakeProfit = Scalper_EURGBP_TakeProfit;
            gi_StopLoss = Scalper_EURGBP_StopLoss;
    }
    else if (m_symbol.Name() == "EURCHF")
    {
        gi_TakeProfit = Scalper_EURCHF_TakeProfit;
            gi_StopLoss = Scalper_EURCHF_StopLoss;
    }
    else if (m_symbol.Name() == "GBPCHF")
    {
        gi_TakeProfit = Scalper_GBPCHF_TakeProfit;
               gi_StopLoss = Scalper_GBPCHF_StopLoss;
    }
    else if (m_symbol.Name() == "USDCAD")
    {
        gi_TakeProfit = Scalper_USDCAD_TakeProfit;
                  gi_StopLoss = Scalper_USDCAD_StopLoss;
    }
    else if (m_symbol.Name() == "USDCHF")
    {
                     gi_TakeProfit = Scalper_USDCHF_TakeProfit;
                     gi_StopLoss = Scalper_USDCHF_StopLoss;
    }
    else if (m_symbol.Name() == "GBPUSD")
    {
                        gi_TakeProfit = Scalper_GBPUSD_TakeProfit;
                        gi_StopLoss = Scalper_GBPUSD_StopLoss;
    }
    else if (m_symbol.Name() == "EURUSD")
    {
         gi_TakeProfit = Scalper_EURUSD_TakeProfit;
                        gi_StopLoss = Scalper_EURUSD_StopLoss;
    }
    else
    {
        printf(__FUNCTION__+": unsupported symbol!");
        return;
    }
    
    gi_TakeProfit *= 10;
    gi_StopLoss *= 10;
}

bool CFapTuoboScalperTrailing::InitIndicators(CIndicators* indicators)
{
    if(indicators==NULL) 
        return(false);
    bool ret = true;
    
    return ret;
}

bool CFapTuoboScalperTrailing::CheckTrailingStopLong(CTableOrder* order,double& sl,double& tp)
{
    sl = EMPTY_VALUE;
    tp = EMPTY_VALUE;
    
    if(order==NULL)  
        return(false);
    
    SetOrderLevels(order, sl ,tp);
    
    if ((sl != EMPTY_VALUE && sl != order.StopLoss())
        || (tp != EMPTY_VALUE && tp != order.TakeProfit()))
    {
        Debug("FapTuoboScalperTrailing: tp=" + DoubleToString(tp, 4) + ",sl=" + DoubleToString(sl, 4));
        return true;
    }
    
    return false;
}

bool CFapTuoboScalperTrailing::CheckTrailingStopShort(CTableOrder* order,double& sl,double& tp)
{
    sl = EMPTY_VALUE;
    tp = EMPTY_VALUE;
    
    if(order==NULL)  
        return(false);
        
    SetOrderLevels(order, sl ,tp);
    
    if ((sl != EMPTY_VALUE && sl != order.StopLoss())
        || (tp != EMPTY_VALUE && tp != order.TakeProfit()))
    {
        Debug("FapTuoboScalperTrailing: tp=" + DoubleToString(tp, 4) + ",sl=" + DoubleToString(sl, 4));
        return true;
    }
    return false;
}

void CFapTuoboScalperTrailing::SetOrderLevels(CTableOrder *order, double& sl,double& tp) 
{
    //  假tp，sl。真的在WatchLevel
    bool Scalper_StealthMode = true;
    int gi_1208 = 150 * GetPointOffset(m_symbol.Digits());
    int gi_1212 = 21 * GetPointOffset(m_symbol.Digits());
    int gi_1216 = 40 * GetPointOffset(m_symbol.Digits());
    int gi_1220 = 21 * GetPointOffset(m_symbol.Digits());
   
   double ld_16;
   double l_price_24;
   double ld_32;
   double ld_40;
   bool li_48;
   int li_52;
   int li_56;
   double l_price_60 = EMPTY_VALUE;
   double l_price_68 = EMPTY_VALUE;
   double ld_0 = SymbolInfoInteger(m_symbol.Name(), SYMBOL_TRADE_STOPS_LEVEL) * m_symbol.Point();
   
    CExpertModel* em = (CExpertModel *)m_expert;
    
        ld_16 = m_symbol.Ask();
        l_price_24 = order.Price();
        ld_32 = order.StopLoss();
        ld_40 = order.TakeProfit();
        li_48 = true;
        li_52 = 0;
        li_56 = 0;
        if (ld_32 == 0.0) 
        {
            if (Scalper_StealthMode) 
                li_52 = gi_1208 + MathRand() % gi_1212;
            else 
                li_52 = gi_StopLoss;
            if (li_52 != 0) 
            {
                if (order.OrderType() == ORDER_TYPE_BUY) 
                {
                    l_price_60 = l_price_24 - li_52 * m_symbol.Point();
                    if (ld_16 - l_price_60 <= ld_0) 
                        li_48 = false;
                } 
                else 
                {
                    l_price_60 = l_price_24 + li_52 * m_symbol.Point();
                    if (l_price_60 - ld_16 <= ld_0) 
                        li_48 = false;
                }
            }
        } 
        else    
            l_price_60 = ld_32;
            
        if (ld_40 == 0.0) 
        {
            if (Scalper_StealthMode) 
                li_56 = gi_1216 + MathRand() % gi_1220;
            else 
                li_56 = gi_TakeProfit;
            if (li_56 != 0) 
            {
                if (order.OrderType() == ORDER_TYPE_BUY) 
                {
                    l_price_68 = l_price_24 + li_56 * m_symbol.Point();
                    if (l_price_68 - ld_16 <= ld_0) 
                        li_48 = false;
                } 
                else 
                {
                    l_price_68 = l_price_24 - li_56 * m_symbol.Point();
                    if (ld_16 - l_price_68 <= ld_0) 
                        li_48 = false;
                }
            }
        } 
        else 
            l_price_68 = ld_40;
            
        if (li_52 != 0 && li_56 != 0 && li_48) 
        {
            sl = l_price_60;
            tp = l_price_68;

            Debug("SetOrderLevels: OrderModify()");
        }
}

