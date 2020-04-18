;*****************************************************
;
;    ﾃｷｽﾄ　ジェネレータ NTSCﾓﾉｸﾛ出力
;
;    4x5フォント
;
;
;PIC16F628A @25MHz　　1命令＝0.16uS
;*****************************************************



	LIST P=PIC16F628A
	INCLUDE "P16F628A.INC"
  __CONFIG BODEN_ON & _HS_OSC & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _LVP_OFF


;********** VRAMの定義 210bytes ********************

CBLOCK   020h    ;bank0
D1.1          ;1列
D1.2
D1.3
D1.4
D1.5
D1.6

D2.1
D2.2
D2.3
D2.4
D2.5
D2.6

D3.1
D3.2
D3.3
D3.4
D3.5
D3.6

D4.1
D4.2
D4.3
D4.4
D4.5
D4.6

D5.1
D5.2
D5.3
D5.4
D5.5
D5.6

D6.1          ;２列
D6.2
D6.3
D6.4
D6.5
D6.6

D7.1
D7.2
D7.3
D7.4
D7.5
D7.6

D8.1
D8.2
D8.3
D8.4
D8.5
D8.6

D9.1
D9.2
D9.3
D9.4
D9.5
D9.6

D10.1
D10.2
D10.3
D10.4
D10.5
D10.6

D11.1        ;３列
D11.2
D11.3
D11.4
D11.5
D11.6

D12.1
D12.2
D12.3
D12.4
D12.5
D12.6

D13.1
D13.2
D13.3
D13.4
D13.5
D13.6

D14.1
D14.2      ;6x13+2=82
D14.3
D14.4
ENDC

CBLOCK   0A0h    ;bank1
D14.5
D14.6

D15.1
D15.2
D15.3
D15.4
D15.5
D15.6

D16.1        ;４列
D16.2
D16.3
D16.4
D16.5
D16.6

D17.1
D17.2
D17.3
D17.4
D17.5
D17.6

D18.1
D18.2
D18.3
D18.4
D18.5
D18.6

D19.1
D19.2
D19.3
D19.4
D19.5
D19.6

D20.1
D20.2
D20.3
D20.4
D20.5
D20.6

D21.1          ;5列
D21.2
D21.3
D21.4
D21.5
D21.6

D22.1
D22.2
D22.3
D22.4
D22.5
D22.6

D23.1
D23.2
D23.3
D23.4
D23.5
D23.6

D24.1
D24.2
D24.3
D24.4
D24.5
D24.6

D25.1
D25.2
D25.3
D25.4
D25.5
D25.6

D26.1       ;６列
D26.2
D26.3
D26.4
D26.5
D26.6

D27.1
D27.2
D27.3
D27.4
D27.5
D27.6
ENDC


CBLOCK  011Fh    ;bank2
D28.1
D28.2
D28.3
D28.4
D28.5
D28.6

D29.1
D29.2
D29.3
D29.4
D29.5
D29.6

D30.1
D30.2
D30.3
D30.4
D30.5
D30.6

D31.1      ;７列
D31.2
D31.3
D31.4
D31.5
D31.6

D32.1
D32.2
D32.3
D32.4
D32.5
D32.6

D33.1
D33.2
D33.3
D33.4
D33.5
D33.6

D34.1
D34.2
D34.3
D34.4
D34.5
D34.6

D35.1
D35.2
D35.3
D35.4
D35.5
D35.6
ENDC

CBLOCK 072h   ;14bytes
V1
V2
V3
V4
V5
V6
dot
access_pointer   ;0~83
CNT_H            ;4line count





ENDC


#define  AD0   PORTA,0
#define  AD1   PORTA,1
#define  HD    PORTB,7
#define  VD    PORTB,6
#define  E     PORTA,2
#define  CLK   PORTA,3


        ORG     0
        bcf     INTCON,GIE     ;割り込み禁止
        movlw   b'00000111'
        movwf   CMCON          ;ｺﾝﾊﾟﾚｰﾀOFF

        bsf     STATUS,RP0     ;bank1
        movlw   b'00111000'
        movwf   TRISA
        movlw   b'00111111'
        movwf   TRISB

        bcf     STATUS,RP0     ;bank0
        bcf     AD0
        bsf     AD1
        clrf    access_pointer
        
        
;********************* main ************************************
        
        
START   
        
AN1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D1.1,w
        movwf   V1
        movf    D1.2,w
        movwf   V2
        movf    D1.3,w
        movwf   V3
        movf    D1.4,w
        movwf   V4
        movf    D1.5,w
        movwf   V5
        movf    D1.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
AN2     movlw   D'5'
        movwf   CNT_H
AN3     call    H_5line
        btfss   STATUS,Z
        goto    AN3
        call    wait3

BN1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D2.1,w
        movwf   V1
        movf    D2.2,w
        movwf   V2
        movf    D2.3,w
        movwf   V3
        movf    D2.4,w
        movwf   V4
        movf    D2.5,w
        movwf   V5
        movf    D2.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
BN2     movlw   D'5'
        movwf   CNT_H
BN3     call    H_5line
        btfss   STATUS,Z
        goto    BN3
        call    wait3

CN1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D3.1,w
        movwf   V1
        movf    D3.2,w
        movwf   V2
        movf    D3.3,w
        movwf   V3
        movf    D3.4,w
        movwf   V4
        movf    D3.5,w
        movwf   V5
        movf    D3.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
CN2     movlw   D'5'
        movwf   CNT_H
CN3     call    H_5line
        btfss   STATUS,Z
        goto    CN3
        call    wait3

DN1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D4.1,w
        movwf   V1
        movf    D4.2,w
        movwf   V2
        movf    D4.3,w
        movwf   V3
        movf    D4.4,w
        movwf   V4
        movf    D4.5,w
        movwf   V5
        movf    D4.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
DN2     movlw   D'5'
        movwf   CNT_H
DN3     call    H_5line
        btfss   STATUS,Z
        goto    DN3
        call    wait3

EN1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D5.1,w
        movwf   V1
        movf    D5.2,w
        movwf   V2
        movf    D5.3,w
        movwf   V3
        movf    D5.4,w
        movwf   V4
        movf    D5.5,w
        movwf   V5
        movf    D5.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
EN2     movlw   D'5'
        movwf   CNT_H
EN3     call    H_5line
        btfss   STATUS,Z
        goto    EN3

        call    line_blanking     ;4ﾗｲﾝ分の黒帯
;
;   １列目終了
;

AQ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D6.1,w
        movwf   V1
        movf    D6.2,w
        movwf   V2
        movf    D6.3,w
        movwf   V3
        movf    D6.4,w
        movwf   V4
        movf    D6.5,w
        movwf   V5
        movf    D6.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
AQ2     movlw   D'5'
        movwf   CNT_H
AQ3     call    H_5line
        btfss   STATUS,Z
        goto    AQ3
        call    wait3

BQ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D7.1,w
        movwf   V1
        movf    D7.2,w
        movwf   V2
        movf    D7.3,w
        movwf   V3
        movf    D7.4,w
        movwf   V4
        movf    D7.5,w
        movwf   V5
        movf    D7.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
BQ2     movlw   D'5'
        movwf   CNT_H
BQ3     call    H_5line
        btfss   STATUS,Z
        goto    BQ3
        call    wait3

CQ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D8.1,w
        movwf   V1
        movf    D8.2,w
        movwf   V2
        movf    D8.3,w
        movwf   V3
        movf    D8.4,w
        movwf   V4
        movf    D8.5,w
        movwf   V5
        movf    D8.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
CQ2     movlw   D'5'
        movwf   CNT_H
CQ3     call    H_5line
        btfss   STATUS,Z
        goto    CQ3
        call    wait3

DQ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D9.1,w
        movwf   V1
        movf    D9.2,w
        movwf   V2
        movf    D9.3,w
        movwf   V3
        movf    D9.4,w
        movwf   V4
        movf    D9.5,w
        movwf   V5
        movf    D9.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
DQ2     movlw   D'5'
        movwf   CNT_H
DQ3     call    H_5line
        btfss   STATUS,Z
        goto    DQ3
        call    wait3

EQ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D10.1,w
        movwf   V1
        movf    D10.2,w
        movwf   V2
        movf    D10.3,w
        movwf   V3
        movf    D10.4,w
        movwf   V4
        movf    D10.5,w
        movwf   V5
        movf    D10.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
EQ2     movlw   D'5'
        movwf   CNT_H
EQ3     call    H_5line
        btfss   STATUS,Z
        goto    EQ3

        call    line_blanking     ;4ﾗｲﾝ分の黒帯
;
;      二列目終了
;







AZ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D11.1,w
        movwf   V1
        movf    D11.2,w
        movwf   V2
        movf    D11.3,w
        movwf   V3
        movf    D11.4,w
        movwf   V4
        movf    D11.5,w
        movwf   V5
        movf    D11.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
AZ2     movlw   D'5'
        movwf   CNT_H
AZ3     call    H_5line
        btfss   STATUS,Z
        goto    AZ3
        call    wait3

BZ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D12.1,w
        movwf   V1
        movf    D12.2,w
        movwf   V2
        movf    D12.3,w
        movwf   V3
        movf    D12.4,w
        movwf   V4
        movf    D12.5,w
        movwf   V5
        movf    D12.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
BZ2     movlw   D'5'
        movwf   CNT_H
BZ3     call    H_5line
        btfss   STATUS,Z
        goto    BZ3
        call    wait3
        
CZ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D13.1,w
        movwf   V1
        movf    D13.2,w
        movwf   V2
        movf    D13.3,w
        movwf   V3
        movf    D13.4,w
        movwf   V4
        movf    D13.5,w
        movwf   V5
        movf    D13.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        call    wait1
CZ2     movlw   D'5'
        movwf   CNT_H
CZ3     call    H_5line
        btfss   STATUS,Z
        goto    CZ3
        call    wait3

DZ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        movf    D14.1,w
        movwf   V1
        movf    D14.2,w
        movwf   V2
        movf    D14.3,w
        movwf   V3
        movf    D14.4,w
        movwf   V4
        bsf     STATUS,RP0     ;bank1
        movf    D14.5,w
        movwf   V5
        movf    D14.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0     ;bank0
        call    order10    ;14+10+2+2+1=29
        nop
        bsf     AD1
        bsf     HD
        nop
        call    order12
        call    order12    ;callまでに2+13+10+4=29
DZ2     movlw   D'5'
        movwf   CNT_H
DZ3     call    H_5line
        btfss   STATUS,Z
        goto    DZ3
        call    wait3

EZ1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0    ;bank1
        movf    D15.1,w
        movwf   V1
        movf    D15.2,w
        movwf   V2
        movf    D15.3,w
        movwf   V3
        movf    D15.4,w
        movwf   V4
        movf    D15.5,w
        movwf   V5
        movf    D15.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0   ;bank0
        call    wait2
EZ2     movlw   D'5'
        movwf   CNT_H
EZ3     call    H_5line
        btfss   STATUS,Z
        goto    EZ3

        call    line_blanking     ;4ﾗｲﾝ分の黒帯
;
;       ３列目終了
;









AF1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D16.1,w
        movwf   V1
        movf    D16.2,w
        movwf   V2
        movf    D16.3,w
        movwf   V3
        movf    D16.4,w
        movwf   V4
        movf    D16.5,w
        movwf   V5
        movf    D16.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
AF2     movlw   D'5'
        movwf   CNT_H
AF3     call    H_5line
        btfss   STATUS,Z
        goto    AF3
        call    wait3

BF1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D17.1,w
        movwf   V1
        movf    D17.2,w
        movwf   V2
        movf    D17.3,w
        movwf   V3
        movf    D17.4,w
        movwf   V4
        movf    D17.5,w
        movwf   V5
        movf    D17.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
BF2     movlw   D'5'
        movwf   CNT_H
BF3     call    H_5line
        btfss   STATUS,Z
        goto    BF3
        call    wait3

CF1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D18.1,w
        movwf   V1
        movf    D18.2,w
        movwf   V2
        movf    D18.3,w
        movwf   V3
        movf    D18.4,w
        movwf   V4
        movf    D18.5,w
        movwf   V5
        movf    D18.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
CF2     movlw   D'5'
        movwf   CNT_H
CF3     call    H_5line
        btfss   STATUS,Z
        goto    CF3
        call    wait3

DF1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D19.1,w
        movwf   V1
        movf    D19.2,w
        movwf   V2
        movf    D19.3,w
        movwf   V3
        movf    D19.4,w
        movwf   V4
        movf    D19.5,w
        movwf   V5
        movf    D19.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
DF2     movlw   D'5'
        movwf   CNT_H
DF3     call    H_5line
        btfss   STATUS,Z
        goto    DF3
        call    wait3

EF1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D20.1,w
        movwf   V1
        movf    D20.2,w
        movwf   V2
        movf    D20.3,w
        movwf   V3
        movf    D20.4,w
        movwf   V4
        movf    D20.5,w
        movwf   V5
        movf    D20.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
EF2     movlw   D'5'
        movwf   CNT_H
EF3     call    H_5line
        btfss   STATUS,Z
        goto    EF3

        call    line_blanking     ;4ﾗｲﾝ分の黒帯
;
;     ４列目終了
;
        








AX1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D21.1,w
        movwf   V1
        movf    D21.2,w
        movwf   V2
        movf    D21.3,w
        movwf   V3
        movf    D21.4,w
        movwf   V4
        movf    D21.5,w
        movwf   V5
        movf    D21.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
AX2     movlw   D'5'
        movwf   CNT_H
AX3     call    H_5line
        btfss   STATUS,Z
        goto    AX3
        call    wait3

BX1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D22.1,w
        movwf   V1
        movf    D22.2,w
        movwf   V2
        movf    D22.3,w
        movwf   V3
        movf    D22.4,w
        movwf   V4
        movf    D22.5,w
        movwf   V5
        movf    D22.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
BX2     movlw   D'5'
        movwf   CNT_H
BX3     call    H_5line
        btfss   STATUS,Z
        goto    BX3
        call    wait3

CX1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D23.1,w
        movwf   V1
        movf    D23.2,w
        movwf   V2
        movf    D23.3,w
        movwf   V3
        movf    D23.4,w
        movwf   V4
        movf    D23.5,w
        movwf   V5
        movf    D23.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
CX2     movlw   D'5'
        movwf   CNT_H
CX3     call    H_5line
        btfss   STATUS,Z
        goto    CX3
        call    wait3

DX1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D24.1,w
        movwf   V1
        movf    D24.2,w
        movwf   V2
        movf    D24.3,w
        movwf   V3
        movf    D24.4,w
        movwf   V4
        movf    D24.5,w
        movwf   V5
        movf    D24.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
DX2     movlw   D'5'
        movwf   CNT_H
DX3     call    H_5line
        btfss   STATUS,Z
        goto    DX3
        call    wait3

EX1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D25.1,w
        movwf   V1
        movf    D25.2,w
        movwf   V2
        movf    D25.3,w
        movwf   V3
        movf    D25.4,w
        movwf   V4
        movf    D25.5,w
        movwf   V5
        movf    D25.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
EX2     movlw   D'5'
        movwf   CNT_H
EX3     call    H_5line
        btfss   STATUS,Z
        goto    EX3

        call    line_blanking     ;4ﾗｲﾝ分の黒帯
;
;       ５列目終了
;








AW1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D26.1,w
        movwf   V1
        movf    D26.2,w
        movwf   V2
        movf    D26.3,w
        movwf   V3
        movf    D26.4,w
        movwf   V4
        movf    D26.5,w
        movwf   V5
        movf    D26.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
AW2     movlw   D'5'
        movwf   CNT_H
AW3     call    H_5line
        btfss   STATUS,Z
        goto    AW3
        call    wait3

BW1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP0      ;bank1
        movf    D27.1,w
        movwf   V1
        movf    D27.2,w
        movwf   V2
        movf    D27.3,w
        movwf   V3
        movf    D27.4,w
        movwf   V4
        movf    D27.5,w
        movwf   V5
        movf    D27.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP0      ;bank0
        call    wait2
BW2     movlw   D'5'
        movwf   CNT_H
BW3     call    H_5line
        btfss   STATUS,Z
        goto    BW3
        call    wait3
;ここからﾊﾞﾝｸ２になる
CW1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D28.1,w
        movwf   V1
        movf    D28.2,w
        movwf   V2
        movf    D28.3,w
        movwf   V3
        movf    D28.4,w
        movwf   V4
        movf    D28.5,w
        movwf   V5
        movf    D28.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
CW2     movlw   D'5'
        movwf   CNT_H
CW3     call    H_5line
        btfss   STATUS,Z
        goto    CW3
        call    wait3

DW1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D29.1,w
        movwf   V1
        movf    D29.2,w
        movwf   V2
        movf    D29.3,w
        movwf   V3
        movf    D29.4,w
        movwf   V4
        movf    D29.5,w
        movwf   V5
        movf    D29.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
DW2     movlw   D'5'
        movwf   CNT_H
DW3     call    H_5line
        btfss   STATUS,Z
        goto    DW3
        call    wait3

EW1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D30.1,w
        movwf   V1
        movf    D30.2,w
        movwf   V2
        movf    D30.3,w
        movwf   V3
        movf    D30.4,w
        movwf   V4
        movf    D30.5,w
        movwf   V5
        movf    D30.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
EW2     movlw   D'5'
        movwf   CNT_H
EW3     call    H_5line
        btfss   STATUS,Z
        goto    EW3

        call    line_blanking     ;4ﾗｲﾝ分の黒帯
;
;        ６列目終了
;








AT1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D31.1,w
        movwf   V1
        movf    D31.2,w
        movwf   V2
        movf    D31.3,w
        movwf   V3
        movf    D31.4,w
        movwf   V4
        movf    D31.5,w
        movwf   V5
        movf    D31.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
AT2     movlw   D'5'
        movwf   CNT_H
AT3     call    H_5line
        btfss   STATUS,Z
        goto    AT3
        call    wait3

BT1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D32.1,w
        movwf   V1
        movf    D32.2,w
        movwf   V2
        movf    D32.3,w
        movwf   V3
        movf    D32.4,w
        movwf   V4
        movf    D32.5,w
        movwf   V5
        movf    D32.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
BT2     movlw   D'5'
        movwf   CNT_H
BT3     call    H_5line
        btfss   STATUS,Z
        goto    BT3
        call    wait3

CT1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D33.1,w
        movwf   V1
        movf    D33.2,w
        movwf   V2
        movf    D33.3,w
        movwf   V3
        movf    D33.4,w
        movwf   V4
        movf    D33.5,w
        movwf   V5
        movf    D33.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
CT2     movlw   D'5'
        movwf   CNT_H
CT3     call    H_5line
        btfss   STATUS,Z
        goto    CT3
        call    wait3

DT1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D34.1,w
        movwf   V1
        movf    D34.2,w
        movwf   V2
        movf    D34.3,w
        movwf   V3
        movf    D34.4,w
        movwf   V4
        movf    D34.5,w
        movwf   V5
        movf    D34.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
DT2     movlw   D'5'
        movwf   CNT_H
DT3     call    H_5line
        btfss   STATUS,Z
        goto    DT3
        call    wait3
        
        
ET1     bcf     AD1      ;ここから4.7uSの落ち込み
        bcf     HD
        bsf     STATUS,RP1      ;bank2
        movf    D35.1,w
        movwf   V1
        movf    D35.2,w
        movwf   V2
        movf    D35.3,w
        movwf   V3
        movf    D35.4,w
        movwf   V4
        movf    D35.5,w
        movwf   V5
        movf    D35.6,w
        movwf   V6       ;V1~6にドットﾃﾞｰﾀを入れた
        bcf     STATUS,RP1      ;bank0
        call    wait2
ET2     movlw   D'5'
        movwf   CNT_H
ET3     call    H_5line
        btfss   STATUS,Z
        goto    ET3
;
;      ７列目終了
;
  ;*******************************************:
;      これから18ライン分の黒帯
;           ＋垂直ブランキング期間
;           ＋17ライン分の黒帯に入る
;       63.55uSx(18+20+17)=3.495mS
;       この期間に文字データを受け取りVRAMに反映
        nop
        nop
        bcf     AD1
        bcf     HD
        movlw   D'9'
        movwf   CNT_H
        call   order4
        nop
        call   order4
        call   b_LP        ;9x2=18　黒帯
        bcf     AD1
        bcf     HD
B1      nop
        nop
        call    half_a
        call    half_a
        call    half_a
        bcf     VD           ;垂直同期
B2      bcf     AD1
        bcf     HD
        nop
        nop
        call    half_b
        call    half_b
        call    half_b
        BSF     VD
B3      nop
        call    half_a
        call    half_a
        call    half_a
B4      nop
        call   order4
        call   order4
        movlw  D'14'
        movwf  CNT_H    
b_LP    call   b_LP
        goto   AN1     ;一画面描写終了
        

        





;****************************************************************
;
;       subroutine
;
;****************************************************************

wait1   call    order12    ;12+2+12+1+2=29
        nop
        bsf     AD1
        bsf     HD
        call    order10
        call    order10    ;callまでに12+10+1+2+4=29
        nop
        return

wait2   call    order10    ;14+2+10+2+1=29
        nop
        bsf     AD1
        bsf     HD
        call    order10
        call    order10    ;callまでに12+10+1+2+4=29
        nop
        return
        
wait3   call    order4     ;ﾌﾛﾝﾄﾎﾟｰﾁ用
        nop
        return

H_5line call    H_working    ;5回分
        decf    CNT_H,f     ;decfsz命令ではZがｾｯﾄしないのに注意
        btfss   STATUS,Z
        call    H_blanking
        return

line_blanking    ;8+2
        bcf     AD1
        bcf     HD
        incf   CNT_H
        incf   CNT_H
        nop
        call   order10    ;12+10+4+2+1=29
b_LP    call   order10      ;水平同期
        call   order4
        bsf    AD1
        bsf    HD
    call   DATAfech_decorde_write1;ｺｺからcallを含まず
        nop                       ;↓↓
        bcf    AD1                ;↓↓
        bcf    HD                 ;ｺｺまで、58,855uS期間367,8(実質363命令)
        call   order12    ;12+10+4+2+1=29
        call   order10      ;水平同期
        call   order4
        nop
        bsf    AD1
        bsf    HD
    call   DATAwrite2          ;(実質360命令)
        decf   CNT_H,f
        btfsc  STATUS,Z
        return
        nop
        bcf    AD1
        bcf    HD
        call   order10
        nop
        goto   b_LP
        

order4   return

order10  nop
         nop
         call  order4
         return
         
order12  call  order4
         call  order4
         return
        
H_blanking call   order4     ;ﾌﾛﾝﾄﾎﾟｰﾁ
           nop
           bcf    AD1
           bcf    HD
           call   order12    ;12+10+4+2+1=29
           call   order10      ;水平同期
           call   order4
           nop
           bsf    AD1
           bsf    HD
           call   order12
           call   order4       ;ﾊﾞｯｸﾎﾟｰﾁ
           call   order4
           return

half_b  movlw   D'12'
        movwf   V1
half_b_LP1 call  order10
        decfsz  V1,f
        goto   half_b_LP1
        call    order4
        nop
        nop
        bsf     AD1
        call    order12
        call    order12
        call    order4
        bcf     AD1
        nop
        call    order4
        movlw   D'12'
        movwf   V1
half_b_LP2 call  order10
        decfsz  V1,f
        goto   half_b_LP2
        call    order4
        nop
        bsf     AD1
        bsf     HD
        call    order12
        call    order12
        call    order4
        bcf     AD1
        bcf     HD
        return
        
half_a  call  order10
        bsf   AD1
        bsf   HD
        movlw  D'15'
        movwf  V1
half_a_LP1  call   order10
        decfsz   V1,f
        goto    half_a_LP1
        bcf   AD1
        call  order12
        nop
        nop
        bsf   AD1
        movlw  D'15'
        movwf  V1
half_a_LP2  call   order10
        decfsz   V1,f
        goto    half_a_LP2
        bcf   AD1
        bcf   HD
        return

H_working  clrf   dot
           bsf    dot,1
           bcf    AD0
           nop
           nop
           
           bsf    dot,0
           btfss  V1,7
           bcf    dot,0
           movf   dot,w
           movwf  PORTA    ;1行目
           
           bsf    dot,0
           btfss  V1,6
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V1,5
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V1,4
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V1,3
           bcf    dot,0
           movf   dot,w
           movwf  PORTA    ;2行目
           
           bsf    dot,0
           btfss  V1,2
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V1,1
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V1,0
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V2,7
           bcf    dot,0
           movf   dot,w
           movwf  PORTA    ;3行目
           
           bsf    dot,0
           btfss  V2,6
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V2,5
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V2,4
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V2,3
           bcf    dot,0
           movf   dot,w
           movwf  PORTA     ;4行目
           
           bsf    dot,0
           btfss  V2,2
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V2,1
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V2,0
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V3,7
           bcf    dot,0
           movf   dot,w
           movwf  PORTA      ;5行目
           
           bsf    dot,0
           btfss  V3,6
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V3,5
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V3,4
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V3,3
           bcf    dot,0
           movf   dot,w
           movwf  PORTA      ;6行目
           
           bsf    dot,0
           btfss  V3,2
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V3,1
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V3,0
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V4,7
           bcf    dot,0
           movf   dot,w
           movwf  PORTA     ;7行目
           
           bsf    dot,0
           btfss  V4,6
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V4,5
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V4,4
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V4,3
           bcf    dot,0
           movf   dot,w
           movwf  PORTA     ;8行目
           
           bsf    dot,0
           btfss  V4,2
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V4,1
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V4,0
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V5,7
           bcf    dot,0
           movf   dot,w
           movwf  PORTA      ;9行目
           
           bsf    dot,0
           btfss  V5,6
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V5,5
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V5,4
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V5,3
           bcf    dot,0
           movf   dot,w
           movwf  PORTA      ;10行目
           
           bsf    dot,0
           btfss  V5,2
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V5,1
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V5,0
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V6,7
           bcf    dot,0
           movf   dot,w
           movwf  PORTA        ;11行目
           
           bsf    dot,0
           btfss  V6,6
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V6,5
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V6,4
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           bsf    dot,0
           btfss  V6,3
           bcf    dot,0
           movf   dot,w
           movwf  PORTA       ;12行目
                      
           bsf    dot,0
           btfss  V6,2
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V6,1
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           bsf    dot,0
           btfss  V6,0
           bcf    dot,0
           movf   dot,w
           movwf  PORTA
           
           call   order4
           bcf    AD0
           
           call   order4
           call   order4
           call   order4
           nop
           return
           
           END