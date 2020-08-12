//+------------------------------------------------------------------+
//|                                                 forexinclude.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>

double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);
double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);

COrderInfo order;
CTrade trade;
CPositionInfo pos;




void validatePositions(double TP, double SL)
  {
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if(pos.SelectByIndex(i))
        {
        if(pos.Symbol()==_Symbol)
        {
         if(pos.PositionType()==POSITION_TYPE_BUY)
           {

            if(pos.Profit()>TP || pos.Profit()<SL)
              {
               trade.PositionClose(pos.Ticket());
               Comment("closing Buy Position");
              }
           }
         else
          {
            if(pos.PositionType()==POSITION_TYPE_SELL)
               if(pos.Profit()>TP ||pos.Profit()< SL)
                 {
                  trade.PositionClose(pos.Ticket());
                  Comment("closing Sell Position");
                 }
           }
         }
        }
     }

  }
  
  
  
   void BollingerBrand(int timePeriod,int shift, double duv, double& BBdata[]){
   double MiddelBrandArray[];
   double UpperBandArray[];
   double LowerBandArray[];
   
   ArraySetAsSeries(MiddelBrandArray,true);
   ArraySetAsSeries(UpperBandArray,true);
   ArraySetAsSeries(LowerBandArray,true);
   
   int BollingerBrandDefinition = iBands(_Symbol,PERIOD_CURRENT,timePeriod,shift,duv,PRICE_CLOSE);
  
   
   CopyBuffer(BollingerBrandDefinition,0,0,3,MiddelBrandArray);
   CopyBuffer(BollingerBrandDefinition,1,0,3,UpperBandArray);
   CopyBuffer(BollingerBrandDefinition,2,0,3,LowerBandArray);
   
   double MiddelBrandValue=MiddelBrandArray[0];
   double UpperBrandValue = UpperBandArray[0];
   double LowerBandValue = LowerBandArray[0];
   
   BBdata[0]=MiddelBrandArray[0];
   BBdata[1]=UpperBandArray[0];
   BBdata[2]= LowerBandArray[0];
   
 }
 
 double MACD(int fast_ema_period, int slow_ema_period, int signal_period, int applied_price ){
   double MACDArray[];
   ArraySetAsSeries(MACDArray,true);
 
   int MACDDefinition = iMACD(_Symbol,PERIOD_CURRENT,fast_ema_period,slow_ema_period, signal_period, applied_price);
   
   CopyBuffer(MACDDefinition,0,0,3,MACDArray);
   return MACDArray[0];
   
 }
 
 double STOCHASTIC(int Kperiod, int Dperiod, int slowing){
   double DataArray[];
   ArraySetAsSeries(DataArray,true);
 
   int Definition = iStochastic(NULL,PERIOD_CURRENT,Kperiod,Dperiod, slowing, MODE_SMA,STO_LOWHIGH);
   
   CopyBuffer(Definition,0,0,3,DataArray);
   return DataArray[0];
   
 }
  void STOCHASTIC2(int Kperiod, int Dperiod, int slowing, double& BBdata[]){
   double KArray[];
   double DArray[];
   
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
 
   int Definition = iStochastic(NULL,PERIOD_CURRENT,Kperiod,Dperiod, slowing, MODE_SMA,STO_LOWHIGH);
   
   CopyBuffer(Definition,0,0,3,KArray);
   CopyBuffer(Definition,1,0,3,DArray);
   BBdata[0] = KArray[0];
   BBdata[1] = DArray[0];
   BBdata[2] = KArray[1];
   BBdata[3] = DArray[1];
   
   
 }
 

  
double MovingAvaget(int ma, int ma_shift){
   double DataArray[];
   ArraySetAsSeries(DataArray,true);
 
   int Definition = iMA(NULL,PERIOD_CURRENT,ma,ma_shift, MODE_SMA,PRICE_CLOSE);
   
   CopyBuffer(Definition,0,0,3,DataArray);
   return DataArray[0];
   
 }

  double EMA(int ma_period, int ma_shift){
   double DataArray[];
   ArraySetAsSeries(DataArray,true);
 
   int Definition = iMA(NULL,PERIOD_CURRENT,ma_period,ma_shift, MODE_EMA,PRICE_CLOSE);
   
   CopyBuffer(Definition,0,0,3,DataArray);
   return DataArray[0];
   
 }
 
void Buy(double lot)
  {
   Print("Entert Buy");
   if(!trade.Buy(lot,NULL,Ask,0,0,NULL))
     {
      Print("Buy() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
            
     }
   else
     {
      Print("Buy() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
  }
//+------------------------------------------------------------------+
void Sell(double lot)
  {
   Print("Entert Buy");
   if(!trade.Sell(lot,NULL,Bid,0,0,NULL))
     {
      Print("Buy() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("Buy() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
  }
 

 void updateAskBid()
 {
 Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK),_Digits);
 Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
 
 }
 
 void CloseBuy(double TP, double SL)
  {
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if(pos.SelectByIndex(i))
        {
        if(pos.Symbol()==_Symbol)
         {
         if(pos.PositionType()==POSITION_TYPE_BUY)
           {

            if(pos.Profit()>TP || pos.Profit()<SL)
              {
               trade.PositionClose(pos.Ticket());
               Comment("closing Buy Position");
              }
           }
          }
        }
     }

  }
  
  void CloseSell(double TP, double SL)
  {
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if(pos.SelectByIndex(i))
        {

         if(pos.PositionType()==POSITION_TYPE_SELL)
               if(pos.Profit()>TP ||pos.Profit()< SL)
                 {
                  trade.PositionClose(pos.Ticket());
                  Comment("closing Sell Position");
                 }
          }

        
     }

  }


 double RSI(int period){
   double MACDArray[];
   ArraySetAsSeries(MACDArray,true);
 
   int MACDDefinition = iRSI(_Symbol,PERIOD_CURRENT,period, PRICE_CLOSE);
   
   CopyBuffer(MACDDefinition,0,0,3,MACDArray);
   return MACDArray[0];
   
 }
  double RSI1H(int period){
   double MACDArray[];
   ArraySetAsSeries(MACDArray,true);
 
   int MACDDefinition = iRSI(_Symbol,PERIOD_H1,period, PRICE_CLOSE);
   
   CopyBuffer(MACDDefinition,0,0,3,MACDArray);
   return MACDArray[0];
   
 }
 
double Volume(){
   double MACDArray[];
   ArraySetAsSeries(MACDArray,true);
 
   int MACDDefinition = iVolumes(_Symbol,PERIOD_CURRENT, VOLUME_TICK);
   
   CopyBuffer(MACDDefinition,0,0,3,MACDArray);
   return MACDArray[0];
   
 }
double Volume1H(){
   double MACDArray[];
   ArraySetAsSeries(MACDArray,true);
 
   int MACDDefinition = iVolumes(_Symbol,PERIOD_H1,VOLUME_TICK);
   
   CopyBuffer(MACDDefinition,0,0,3,MACDArray);
   return MACDArray[0];
   
 }