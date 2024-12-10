//
//  Calc.m
//  JNANail
//
//  Created by 今江 健一 on 2013/06/16.
//  Copyright (c) 2013年 今江 健一. All rights reserved.
//

#import "Calc.h"

@implementation Calc
- (NSString *)strNumberWithValue:(double)motoVal withKanma:(BOOL)KanmaAri forUnderPeriod:(NSInteger)underPeriod{
	NSString *ItijiStr =[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%%.%ldf",(long)underPeriod], motoVal];
	motoVal=[ItijiStr doubleValue];
	ItijiStr = nil;
	NSString *KaeriStr = @"";
	if (motoVal<0){
		KaeriStr=@"-";
		motoVal*=-1;
	}else{
		KaeriStr=@"";
	}
	double Seisuu = floor( motoVal);
	double MotoSeisuu = Seisuu;
	if (KanmaAri==TRUE) {
		int itijiSeisuu = 0;
		double hikiSuu  = 0;
		BOOL Hajimete=TRUE;
		for (int i=0; i<5; i++) {
			switch (i) {
				case 0:
					itijiSeisuu=floor(Seisuu/1000000000000000);
					hikiSuu=itijiSeisuu*1000000000000000;
					break;
				case 1:
					itijiSeisuu=floor(Seisuu/1000000000000);
					hikiSuu=itijiSeisuu*1000000000000;
					break;
				case 2:
					itijiSeisuu=floor(Seisuu/1000000000);
					hikiSuu=itijiSeisuu*1000000000;
					break;
				case 3:
					itijiSeisuu=floor(Seisuu/1000000);
					hikiSuu=itijiSeisuu*1000000;
					break;
				case 4:
					itijiSeisuu=floor(Seisuu/1000);
					hikiSuu=itijiSeisuu*1000;
					break;
				default:
					break;
			}
			if (itijiSeisuu>0) {
				//NSLog(@"%d",itijiSeisuu);
				if (Hajimete==TRUE) {
					Hajimete=FALSE;
					KaeriStr= [KaeriStr stringByAppendingString:[NSString stringWithFormat:@"%d,",itijiSeisuu]];
				}else {
					KaeriStr= [KaeriStr stringByAppendingString:[NSString stringWithFormat:@"%03d,",itijiSeisuu]];
				}
				//NSLog(KaeriStr);
				Seisuu=Seisuu-hikiSuu;
				//NSLog(@"seisuu=%f",Seisuu);
			}else if (Seisuu==0 && MotoSeisuu!=0) {
				KaeriStr= [KaeriStr stringByAppendingString:@"000,"];
			}else if (Hajimete==FALSE){
				KaeriStr= [KaeriStr stringByAppendingString:@"000,"];
			}
			
		}
		if (Seisuu==0 && MotoSeisuu!=0) {
			KaeriStr= [KaeriStr stringByAppendingString:@"000"];
		}else if(Seisuu>0){
			if (Hajimete==TRUE) {
				itijiSeisuu=Seisuu;
				KaeriStr= [KaeriStr stringByAppendingString:[NSString stringWithFormat:@"%d",itijiSeisuu]];
			}else {
				itijiSeisuu=Seisuu;
				KaeriStr= [KaeriStr stringByAppendingString:[NSString stringWithFormat:@"%03d",itijiSeisuu]];
			}
		}
	}else {
		KaeriStr= [KaeriStr stringByAppendingString:[NSString stringWithFormat:@"%.0f",Seisuu]];
	}
	
	motoVal-=MotoSeisuu;
	NSString *SyouSuu=[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%%.%ldf",(long)underPeriod], motoVal];
	KaeriStr= [KaeriStr stringByAppendingString: [SyouSuu substringFromIndex:1]];
	SyouSuu = nil;
	return KaeriStr;
}

- (NSString *)Hiduke:(NSDate *)motoVal withTime:(BOOL)JikanAri withYear:(BOOL)ToshiAri{
    NSCalendar *cal=[NSCalendar currentCalendar];
	
	NSUInteger flags = NSCalendarUnitYear
    | NSCalendarUnitMonth
    | NSCalendarUnitDay
    | NSCalendarUnitHour
    | NSCalendarUnitMinute
    | NSCalendarUnitSecond;
	
	NSDateComponents *cmp = [cal components:flags fromDate:motoVal];
	NSString * str=@"";
	if (ToshiAri==TRUE) {
		if (JikanAri==TRUE){
			str = [NSString stringWithFormat:@"%02ld/%02ld/%02ld %02ld:%02ld:%02ld",
                   (long)[cmp year],
                   (long)[cmp month],
                   (long)[cmp day],
                   (long)[cmp hour],
                   (long)[cmp minute],
                   (long)[cmp second]];
		}else {
			str = [NSString stringWithFormat:@"%02ld/%02ld/%02ld",
				   (long)[cmp year],
				   (long)[cmp month],
				   (long)[cmp day]];
		}
	}else {
		if (JikanAri==TRUE){
			str = [NSString stringWithFormat:@"%02ld/%ld %02ld:%02ld",
				   (long)[cmp month],
				   (long)[cmp day],
				   (long)[cmp hour],
				   (long)[cmp minute]];
		}else {
			str = [NSString stringWithFormat:@"%02ld/%02ld",
				   (long)[cmp month],
				   (long)[cmp day]];			
		}
	}
    
	return str;
}

@end
