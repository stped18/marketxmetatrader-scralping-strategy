//+------------------------------------------------------------------+
//|                                                          SOC.mq5 |
//|                                                          Steffen |
//|                                           https://www.vittech.dk |
//+------------------------------------------------------------------+
#property copyright "Steffen"
#property link      "https://www.vittech.dk"
#property version   "1.00"
#include <forexinclude.mqh>


double socvalue;
double SMA;
double Ema;
double OldSMA=0;
double OldSoc =0;
string CommenString;
int BarsOnChart=0;
double Kvalue=0;
double Dvalue =0;
double lastKvalue =0;
double lastDvalue =0;
double profit = 0;
double oldProfit=0;
double numberoftrade =1;
double rsivalue;
double MACDvalue;



input int Kperiod = 14;
input int Dperiod = 3;
input int slowing = 5;
input int ma_period = 5;
input int Ema_period = 144;
input int socUpper = 70;
input int socLower = 30;
input double buylot =0.01;
input double selllot =0.01;
input int rsi_period=18;
input int rsi_high=70;
input int rsi_low=30;
input int rsi_CloseSellValue=50;
input int rsi_ClosebuyValue=50;
input int fast_ema_period=12;
input int slow_ema_period=26;
input int signal_period=9;










int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   CommenString="";
   
   UpdateValues();
   
if(true)
{  

   
   if(SMA<Ema)
   {
   if(UpdateBuyOptions())
   {  
      
      trade.Buy(buylot,NULL,Ask,0,0,NULL);
      
      //Alert("Buy at "+ _Symbol);
   
   }else
   {
      validateCloseBuyPositions();
   
   }
   }
   else{
   if(UpdateSellOptions())
   {          
      
      trade.Sell(selllot,NULL,Bid,0,0,NULL);
   }
   else
   {
      validateCloseSellPositions();
   }
   }
   
   
   
   
   UpdateLastValues();
}
   
   
   CommenString += " Balance : "+DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE))+"\n";
   CommenString += " Eqyity : "+DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY))+"\n";
   CommenString += " Lot : "+DoubleToString(0.01)+"\n";
   Comment(CommenString);
   
   
  }
//+------------------------------------------------------------------+


void UpdateValues()
{  
   Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);
   Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
   double STOCHASTICdata[4];
   STOCHASTIC2(Kperiod, Dperiod,slowing, STOCHASTICdata); 
   Kvalue = STOCHASTICdata[0];
   Dvalue = STOCHASTICdata[1];
   lastKvalue = STOCHASTICdata[2];
   lastDvalue = STOCHASTICdata[3];
   SMA = MovingAvaget(ma_period,0);
   Ema = EMA(Ema_period, 0);
   profit = AccountInfoDouble(ACCOUNT_PROFIT);
   rsivalue = RSI(rsi_period);
   MACDvalue = MACD(fast_ema_period,slow_ema_period, signal_period, PRICE_CLOSE );

   


}
void UpdateLastValues()
{
   OldSMA = SMA;
   oldProfit=profit;

}

bool UpdateBuyOptions()
{  
   bool ready = false;
   if(socLower>Kvalue)
   {
      if(lastDvalue>=lastKvalue && Dvalue<Kvalue)
      {  
         if(rsivalue<rsi_low)
         {
            if(MACDvalue<0)
            {
               ready= true;
            }
         }
      }
   }
   return ready;
   
}
bool UpdateSellOptions()
{  
   bool ready = false;
   if(socUpper< Kvalue )
   {
      if(lastDvalue<=lastKvalue && Dvalue>Kvalue)
      {
         if(rsivalue>rsi_high)
         {
            if(MACDvalue>0)
            {
               ready= true; 
            }
         }       
      }
   }
   return ready;
}





bool IsNewCandle()                 
{
             
   if(Bars(_Symbol,PERIOD_CURRENT)==BarsOnChart)
   {
   return(false);
   }
   else
   {
   BarsOnChart=Bars(_Symbol,PERIOD_CURRENT);
   return(true);
   }
}


void validateCloseBuyPositions()
{
   
 
   if((rsivalue>rsi_ClosebuyValue))
   {
      CloseBuy(0.1,5);
   }


}


void validateCloseSellPositions()
{
  
   if((rsivalue<rsi_CloseSellValue))
   {
    CloseSell(0.1,5);
   }

}
