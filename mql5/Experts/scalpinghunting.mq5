//+------------------------------------------------------------------+
//|                                              scalpinghunting.mq5 |
//|                                                          Steffen |
//|                                           https://www.vittech.dk |
//+------------------------------------------------------------------+
#property copyright "Steffen"
#property link      "https://www.vittech.dk"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <forexinclude.mqh>

double BBhigh;
double BBlow;
double BBMid;
double BB2high;
double BB2low;
double socvalue;
double SMA;
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



input int BBtimePeriod = 80;
input double BBduv = 0.9;
input double BB2duv = 9.4;
input int Kperiod = 54;
input int Dperiod = 64;
input int slowing = 5;
input int ma_period = 6;
input int socUpper = 65;
input int socLower = 35;
input double buylot =0.01;
input double selllot =0.01;









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
   
   
if(IsNewCandle())
{
   UpdateValues();
   if(UpdateBuyOptions())
   {  
      
      trade.Buy(buylot,NULL,Ask,BB2low,BBMid,NULL);
      
      //Alert("Buy at "+ _Symbol);
   
   }
   if(UpdateSellOptions())
   {  
     
      trade.Sell(selllot,NULL,Bid,BB2high,BBMid,NULL);
      //Alert("Sell at "+ _Symbol);
      
   }
   
   
   UpdateLastValues();
}
   
   
   CommenString += " Balance : "+DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE))+"\n";
   CommenString += " Eqyity : "+DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY))+"\n";
   CommenString += " Lot : "+DoubleToString(0.01)+"\n";
   
   
  }
//+------------------------------------------------------------------+


void UpdateValues()
{  
   Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);
   Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
   double BBdata[3];
   BollingerBrand(BBtimePeriod,0, BBduv,BBdata);
   BBMid = BBdata[0];
   BBhigh = BBdata[1];
   BBlow = BBdata[2];
   BollingerBrand(BBtimePeriod,0, BB2duv,BBdata);
   BB2high = BBdata[1];
   BB2low = BBdata[2];
   double STOCHASTICdata[4];
   STOCHASTIC2(Kperiod, Dperiod,slowing, STOCHASTICdata); 
   Kvalue = STOCHASTICdata[0];
   Dvalue = STOCHASTICdata[1];
   lastKvalue = STOCHASTICdata[2];
   lastDvalue = STOCHASTICdata[3];
   SMA = MovingAvaget(ma_period,0);
   profit = DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT));
   doublerisk();
   


}
void UpdateLastValues()
{
   OldSMA = SMA;
   oldProfit=profit;

}

bool UpdateBuyOptions()
{  
   bool ready = false;
   if(lastKvalue>socLower && socLower>Kvalue)
   {
      if(Kvalue>Dvalue)
      {
      if(OldSMA>BBlow)
      {
      if(BBlow>SMA)
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
   if(lastKvalue<socUpper &&  socUpper< Kvalue )
   {
      if( Kvalue<Dvalue)
      {
      if(OldSMA<BBhigh)
      {  
         if(BBhigh<SMA)
         {
         ready= true;
         }
      }
      }
   }
   return ready;
}

bool closeBuyPosition()
{  
   bool ready = false;
   if(OldSMA > BBMid)
   {
   if(BBMid > SMA)
   {
      ready =true;
   }
   }
   return ready;
   

}
bool closeSellPosition()
{  
   bool ready = false;
   if(OldSMA < BBMid)
   {
   if( BBMid < SMA)
   {
      ready =true;
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
void doublerisk()
{
   if(oldProfit<profit)
   {
      numberoftrade+=1;
   }else
   numberoftrade=1;

}