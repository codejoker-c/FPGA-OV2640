module camera_top(
        //����ͷ����ӿ�
        output       sio_c,//����ͷsio_c�ź�
        inout        sio_d,//����ͷsio_d�ź�
        output       reset,//reset�źţ���Ҫ���ߣ���������üĴ���
        output       pwdn,//pwdn�źţ����ͣ��رպĵ�ģʽ
        output       xclk,//xclk�źţ��ɲ���
        input        pclk,href,vsync,//���ڿ���ͼ�����ݴ���������ź�
        input  [7:0] camera_data ,//ͼ�������ź�
        //VGA����ӿ�
        output [3:0]  red_out,green_out,blue_out,//rgb������Ϣ
        output x_valid,//��ʱ���ź�
        output y_valid,//��ʱ���ź�
        //ʱ��
        input  clk,//�Ӱ���ʼ�գ�100mhz
        //��λ�ӿ�
        input rst,//�ߵ�ƽ��Ч
        //��������
        input get_bluetooth,//��pmod
        //����ܽӿ�
        output [6:0] display//��Ӧ����ܽӿ�
    );

    wire [7:0]out_bluetooth;//�������ݴ���
    bluetooth bt(.clk(clk),.rst(rst),.get(get_bluetooth),.out(out_bluetooth));

    display7 dis(.iData(out_bluetooth[3:0]),.oData(display));
    wire clk_vga ;//vgaʱ�� 24mhz
    wire clk_init_reg;//��ʼ���Ĵ�����ʱ�ӣ�25mhz

    clk_wiz_0 div(.clk_in1(clk),.clk_out1(clk_vga),.clk_out2(clk_init_reg));

    camera_init init(.clk(clk_init_reg),.sio_c(sio_c),.sio_d(sio_d),.reset(reset),.pwdn(pwdn),.rst(rst),.xclk(xclk));

    wire [11:0] ram_data;//д����
    wire  wr_en;//����д��Ч
    wire [18:0] ram_addr;//д��ַ
    camera_get_pic get_pic(.rst(rst),.pclk(pclk),.href(href),.vsync(vsync),.data_in(camera_data),.data_out(ram_data),.wr_en(wr_en),.out_addr(ram_addr));

    wire [11:0]   rd_data;//������
    wire [18:0]   rd_addr;//����ַ

   blk_mem_gen_0 buffer(.clka(clk),.ena(1),.wea(wr_en),.addra(ram_addr),.dina(ram_data),.clkb(clk),.enb(1),.addrb(rd_addr),.doutb(rd_data));

    wire [11:0]deald_color;//�����������ź�
    deal_pic deal(.clk(clk),.in_rgb(rd_data),.oper(out_bluetooth),.out_rgb(deald_color));
    vga_display vga(.clk_vga(clk_vga),.rst(rst),.color_data_in(deald_color),.ram_addr(rd_addr),.x_valid(x_valid),.y_valid(y_valid),.red(red_out),.green(green_out),.blue(blue_out));
    
endmodule
