module camera_get_pic (
    input rst,
    input pclk,
    input href,
    input vsync,
    input [7:0]data_in,//����ͷD[9]��D[2]
    output reg[11:0]data_out,//һ�����ص������
    output reg wr_en,//������ϣ�д��Чʹ��
    output reg[18:0]out_addr=0//����λ��
    );


    reg [15:0] rgb565 = 0;
    reg  [18:0] next_addr = 0;
    reg [1:0] status = 0;//ÿ����������ϳ�һ��rgb��Ϣ������һ����λ��status���ϵ���λ����
    
    
    always@ (posedge pclk)
        begin
        if(vsync == 0)//�ߵ�ƽ��Ч
            begin
                out_addr <=0;
                next_addr <= 0;
                status=0;
            end
        else
            begin
                data_out <= {rgb565[15:12],rgb565[10:7],rgb565[4:1]};
                out_addr <= next_addr;
                wr_en <= status[1];
                status <= {status[0], (href && !status[0])};//���Ǹߵ�ƽ��Ч
                rgb565 <= {rgb565[7:0], data_in};
                    
                if(status[1] == 1)
                    begin
                        next_addr <= next_addr+1;
                    end
                end
        end

endmodule