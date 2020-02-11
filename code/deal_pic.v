module deal_pic(
    input clk,
    input [11:0] in_rgb,//�����rgb����
    input [7:0] oper,//���������������ṩ
    output reg[11:0] out_rgb//����Ĵ������rgb����
);
    reg [7:0]mid1,mid2;
    reg [7:0]red_mid,green_mid,blue_mid,red_mid2,green_mid2,blue_mid2;
    always @ (*)
    begin
        red_mid={in_rgb[11:8],4'b0000};
        green_mid={in_rgb[7:4],4'b0000};
        blue_mid={in_rgb[3:0],4'b0000};
        red_mid2={in_rgb[11:8],4'b0000};
        green_mid2={in_rgb[7:4],4'b0000};
        blue_mid2={in_rgb[3:0],4'b0000};
        if(oper==8'b00110001)//�Ҷ��˾�
        begin
            mid1=(red_mid+green_mid+blue_mid)/3;
            red_mid=mid1;
            green_mid=mid1;
            blue_mid=mid1;
        end
        else if(oper==8'b00110010)//�ڰ��˾�����ֵ����
        begin
            mid1=(red_mid+green_mid+blue_mid)/3;
            if(mid1>=100)
            begin
                red_mid=255;
                green_mid=255;
                blue_mid=255;
            end
            else
            begin
                red_mid=0;
                green_mid=0;
                blue_mid=0;
            end
        end
        else if(oper==8'b00110011)//�����˾�����Ƭ��
        begin
            red_mid=255-red_mid;
            green_mid=255-green_mid;
            blue_mid=255-blue_mid;
        end
        else if(oper==8'b00110100)//ȥɫ�˾�
        begin
            mid1=red_mid>green_mid?red_mid:green_mid;
            mid1=mid1>blue_mid?mid1:blue_mid;
            mid2=red_mid<green_mid?red_mid:green_mid;
            mid2=mid1<blue_mid?mid1:blue_mid;
            mid1=(mid1+mid2)/2;
            red_mid=mid1;
            green_mid=mid1;
            blue_mid=mid1;
        end
        else if(oper==8'b00110101)//�����˾�
        begin
            red_mid=red_mid2*128/(green_mid2+blue_mid2+1);
            green_mid=green_mid2*128/(red_mid2+blue_mid2);
            blue_mid=blue_mid2*128/(red_mid2+green_mid2);
        end
        else if(oper==8'b00110110)//�����˾�
        begin
            red_mid=(red_mid2-green_mid2-blue_mid2)*3/2;
            green_mid=(green_mid2-red_mid2-blue_mid2)*3/2;
            blue_mid=(blue_mid2-red_mid2-green_mid2)*3/2;
        end
        else if(oper==8'b00110111)//�������˾�
        begin
            red_mid=(green_mid2-blue_mid2+green_mid2+red_mid2)*red_mid2/256;
            green_mid=(blue_mid2-green_mid2+blue_mid2+red_mid2)*red_mid2/256;
            blue_mid=(blue_mid2-green_mid2+blue_mid2+red_mid2)*green_mid2/256;
        end
        else if(oper==8'b00111000)//�����˾�
        begin
            red_mid=red_mid2*393/1000+green_mid2*769/1000+blue_mid2*189/1000;
            green_mid=red_mid2*349/1000+green_mid2*686/1000+blue_mid2*168/1000;
            blue_mid=red_mid2*272/1000+green_mid2*534/1000+blue_mid2*131/1000;
        end
        
        out_rgb[11:8]=red_mid[7:4];
        out_rgb[7:4]=green_mid[7:4];
        out_rgb[3:0]=blue_mid[7:4];
    end
endmodule