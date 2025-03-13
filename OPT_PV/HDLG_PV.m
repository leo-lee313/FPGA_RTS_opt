file_name = 'C11PV.txt';
file_name1 = 'C12PV.txt';
file_name2 = 'C13PV.txt';
file_name3 = 'C53PV.txt';
file_name4 = 'C14PV.txt';
file_name5 = 'C15PV.txt';
file_name6 = 'C16PV.txt';
file_name7 = 'C17PV.txt';
file_name8 = 'C18PV.txt';
file_name9 = 'C19PV.txt';
file_name10 = 'C20PV.txt';
file = fopen(file_name,'w');
file1 = fopen(file_name1,'w');
file2 = fopen(file_name2,'w');
file3 = fopen(file_name3,'w');
file4 = fopen(file_name4,'w');
file5 = fopen(file_name5,'w');
file6 = fopen(file_name6,'w');
file7 = fopen(file_name7,'w');
file8 = fopen(file_name8,'w');
file9 = fopen(file_name9,'w');
file10 = fopen(file_name10,'w');
DD=[dadd,dmul,0,0,ddiv,dsin,dcos,dcompare,dlimit,dexp];
LEIXING=['add';'mul';'aaa';'aaa';'div';'sin';'cos';'cop';'lim';'exp'];
NSHULIANG=[NADD,NMUL,0,0,NDIV,NSIN,NCOS,NCOMPARE,NLIMIT,NEXP];
SHULIANG=[dm1,dm2,0,0,dmd,dmsin,dmcos,0,0,dmexp];
[PARAMETERNAME, PARAMETERNUM] = textread('PARAMETER.txt' , '%s%s');
[HISTORYNAME, HISTORYLEI,HISTORYWHERE] = textread('HISTORY.txt' , '%s%s%s');
[INPUTNAME] = textread('INPUT.txt' , '%s');
PWMNUM=1;
parasign=zeros(1,length(PARAMETERNAME));
histsign=zeros(1,length(HISTORYNAME));
inpusign=zeros(1,length(INPUTNAME));
comparesign=zeros(1,NCOMPARE);
limitsign=zeros(1,NLIMIT);
fprintf(file9,['reg [11:0] counter;','\n']);
fprintf(file9,['always @ ( posedge clk or posedge sta) begin','\n']);
fprintf(file9,['	if(sta) ','\n']);
fprintf(file9,['	   begin','\n']);
fprintf(file9,['		   counter <= 12''d0;','\n']);
fprintf(file9,['		end','\n']);
fprintf(file9,['	else begin','\n']);
fprintf(file9,['		   counter <= counter + 12''d1;','\n']);
fprintf(file9,['   end','\n']);
fprintf(file9,['end','\n']);
fprintf(file9,['wire [1000:0] sta_sig;','\n']);
fprintf(file9,['signalgene signalgene(','\n']);
fprintf(file9,['													   .clk(clk),','\n']);
fprintf(file9,['													   .sta(sta),','\n']);
fprintf(file9,['														.sim_time(sim_time),','\n']);
fprintf(file9,['													   .counter(counter),','\n']);
fprintf(file9,['													   .done_sig(sta_sig)','\n']);
fprintf(file9,['													  );	','\n']);
% for i=1:length(PWMNUM)
%     fprintf(file9,['wire [`SINGLE - 1:0] ',PWMNAME{i},';\n']);
%     f_rec = str2double(PWMNUM{i});
%     count_max_rec = floor( 1/(4*f_rec*delta_t) - 1 );
%     count_max_inv = 1/(count_max_rec);
%     par16=sprintf('%tx',count_max_inv);
%     fprintf(file9,['PWM #(3''b001 , ',num2str(count_max_rec),'  , 1 , 32''d0 , 32''h',par16,' , 3''b000 , 3''b001 , 3''b010 , 3''b011 , 3''b100) PWM_',PWMNAME{i},'(\n']);
%     fprintf(file9,['		  .clk(clk),\n']);
%     fprintf(file9,['		  .rst(rst),\n']);
%     fprintf(file9,['	 	  .rst_user(rst_user),\n']);
%     fprintf(file9,['		  .sta(sta),\n']);
%     fprintf(file9,['		  .sta_user(sta_user),\n']);
%     fprintf(file9,['\n']);
%     fprintf(file9,['	     .triangle_out(',PWMNAME{i},')\n']);
%     fprintf(file9,['		 );\n']);
% end

for lei=1:length(LEIXING)
    for ilie=1:SHULIANG(lei)
        fprintf(file,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong;	','\n']);
        fprintf(file,['ctrl_time_',num2str(cssi(lei,ilie)),' ctrl_time_',LEIXING(lei,:),'_',num2str(ilie),'_A(','\n']);
        fprintf(file,['	                                            .clk(clk),','\n']);
        fprintf(file,['													        .sta(sta),','\n']);
        fprintf(file,['													        .counter(counter),','\n']);
        for jj=1:cssi(lei,ilie)
             fprintf(file,['															  .time_',num2str(jj),'(12''d',num2str(ZONE1{jj,1,ilie,lei}),'),//',num2str(ZONE1{jj,2,ilie,lei}),'\n']);
             if str2double(ZONE1{jj,3,ilie,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE1{jj,4,ilie,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE1{jj,4,ilie,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,4,ilie,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE1{jj,3,ilie,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE1{jj,4,ilie,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,4,ilie,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE1{jj,4,ilie,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE1{jj,4,ilie,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,4,ilie,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE1{jj,4,ilie,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE1{jj,4,ilie,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,4,ilie,lei},'),','\n']);
             end
             if str2double(ZONE1{jj,3,ilie,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE1{jj,4,ilie,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,4,ilie,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE1{jj,4,ilie,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE1{jj,4,ilie,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE1{jj,4,ilie,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE1{jj,1,ilie,lei}-datadelay ==0
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,4,ilie,lei},'_64','),','\n']);
                 elseif ZONE1{jj,1,ilie,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE1{jj,1,ilie,lei}-datadelay),')  DELAY_NCLK_','',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE1{jj,4,ilie,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE1{jj,4,ilie,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,4,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE1{jj,3,ilie,lei})==8 
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,3,ilie,lei}))
                     if str2double(ZONE1{jj,4,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,3,ilie,lei})}
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,3,ilie,lei})} - DD(str2double(ZONE1{jj,3,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(compare_',ZONE1{jj,4,ilie,lei},'_lyf','),','\n']);
                             elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','','(compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','','compare_',ZONE1{jj,4,ilie,lei},'_lyf',')\n']);
                             fprintf(file1,['						               .q(','','compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','','compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','','(compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,3,ilie,lei})} + DD(str2double(ZONE1{jj,3,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','','compare_',ZONE1{jj,4,ilie,lei},'_lyf',' ),\n']);
                                fprintf(file1,['								.cout( ','','compare_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
             if str2double(ZONE1{jj,3,ilie,lei})==9
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,3,ilie,lei}))
                     if str2double(ZONE1{jj,4,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,3,ilie,lei})}
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,3,ilie,lei})} - DD(str2double(ZONE1{jj,3,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(limit_',ZONE1{jj,4,ilie,lei},'_lyf','),','\n']);
                             elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','','(limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','','limit_',ZONE1{jj,4,ilie,lei},'_lyf',')\n']);
                             fprintf(file1,['						               .q(','','limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','','limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','','(limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,3,ilie,lei})} + DD(str2double(ZONE1{jj,3,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','','limit_',ZONE1{jj,4,ilie,lei},'_lyf',' ),\n']);
                                fprintf(file1,['								.cout( ','','limit_',ZONE1{jj,4,ilie,lei},'_lyf_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
             if str2double(ZONE1{jj,3,ilie,lei})==11
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,4,ilie,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE1{jj,3,ilie,lei})==1||str2double(ZONE1{jj,3,ilie,lei})==2||str2double(ZONE1{jj,3,ilie,lei})==5||str2double(ZONE1{jj,3,ilie,lei})==6||str2double(ZONE1{jj,3,ilie,lei})==7||str2double(ZONE1{jj,3,ilie,lei})==10
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,3,ilie,lei}))
                     if str2double(ZONE1{jj,4,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,3,ilie,lei})}
                         yushu=mod(i,SHULIANG(str2double(ZONE1{jj,3,ilie,lei})))+1;
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,3,ilie,lei})} - DD(str2double(ZONE1{jj,3,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                         elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result),','\n']);
                             fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,3,ilie,lei})} + DD(str2double(ZONE1{jj,3,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE1{jj,3,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
        end
        fprintf(file,['													        .y(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong)','\n']);
        fprintf(file,['													        );	','\n']);
        if lei==1||lei==2||lei==5||lei==6||lei==7
            fprintf(file,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong;	','\n']);
            fprintf(file,['ctrl_time_',num2str(cssi(lei,ilie)),' ctrl_time_',LEIXING(lei,:),'_',num2str(ilie),'_B(','\n']);
            fprintf(file,['	                                            .clk(clk),','\n']);
            fprintf(file,['													        .sta(sta),','\n']);
            fprintf(file,['													        .counter(counter),','\n']);
            for jj=1:cssi(lei,ilie)
                 fprintf(file,['															  .time_',num2str(jj),'(12''d',num2str(ZONE1{jj,1,ilie,lei}),'),//',num2str(ZONE1{jj,2,ilie,lei}),'\n']);
             if str2double(ZONE1{jj,5,ilie,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE1{jj,6,ilie,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE1{jj,6,ilie,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,6,ilie,lei},'_lyf','),','\n']);
             end
              if str2double(ZONE1{jj,5,ilie,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE1{jj,6,ilie,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,6,ilie,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE1{jj,6,ilie,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE1{jj,6,ilie,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,6,ilie,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE1{jj,6,ilie,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE1{jj,6,ilie,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,6,ilie,lei},'),','\n']);
             end
             if str2double(ZONE1{jj,5,ilie,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE1{jj,6,ilie,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,6,ilie,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE1{jj,6,ilie,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE1{jj,6,ilie,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE1{jj,6,ilie,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE1{jj,1,ilie,lei}-datadelay ==0
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,6,ilie,lei},'_64','),','\n']);
                 elseif ZONE1{jj,1,ilie,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE1{jj,1,ilie,lei}-datadelay),')  DELAY_NCLK_','',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE1{jj,6,ilie,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE1{jj,6,ilie,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,6,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE1{jj,5,ilie,lei})==8 
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,5,ilie,lei}))
                     if str2double(ZONE1{jj,6,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,5,ilie,lei})}
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,5,ilie,lei})} - DD(str2double(ZONE1{jj,5,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(compare_',ZONE1{jj,6,ilie,lei},'_lyf','),','\n']);
                             elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','','(compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','','compare_',ZONE1{jj,6,ilie,lei},'_lyf',')\n']);
                             fprintf(file1,['						               .q(','','compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','','compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','','(compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,5,ilie,lei})} + DD(str2double(ZONE1{jj,5,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','','compare_',ZONE1{jj,6,ilie,lei},'_lyf',' ),\n']);
                                fprintf(file1,['								.cout( ','','compare_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
             if str2double(ZONE1{jj,5,ilie,lei})==9
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,5,ilie,lei}))
                     if str2double(ZONE1{jj,6,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,5,ilie,lei})}
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,5,ilie,lei})} - DD(str2double(ZONE1{jj,5,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(limit_',ZONE1{jj,6,ilie,lei},'_lyf','),','\n']);
                             elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','','(limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','','limit_',ZONE1{jj,6,ilie,lei},'_lyf',')\n']);
                             fprintf(file1,['						               .q(','','limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','','limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','','(limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,5,ilie,lei})} + DD(str2double(ZONE1{jj,5,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','','limit_',ZONE1{jj,6,ilie,lei},'_lyf',' ),\n']);
                                fprintf(file1,['								.cout( ','','limit_',ZONE1{jj,6,ilie,lei},'_lyf_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
                 if str2double(ZONE1{jj,5,ilie,lei})==11
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,6,ilie,lei},'_lyf','),','\n']);
                 end
                 if str2double(ZONE1{jj,5,ilie,lei})==1||str2double(ZONE1{jj,5,ilie,lei})==2||str2double(ZONE1{jj,5,ilie,lei})==5||str2double(ZONE1{jj,5,ilie,lei})==6||str2double(ZONE1{jj,5,ilie,lei})==7||str2double(ZONE1{jj,5,ilie,lei})==10
                     for i = 1:NSHULIANG(str2double(ZONE1{jj,5,ilie,lei}))
                         if str2double(ZONE1{jj,6,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,5,ilie,lei})}
                             yushu=mod(i,SHULIANG(str2double(ZONE1{jj,5,ilie,lei})))+1;
                             yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,5,ilie,lei})} - DD(str2double(ZONE1{jj,5,ilie,lei}));
                             if yanshi==0
                                 fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                             elseif  yanshi<=12
                                 fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                                 fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                                 fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                                 fprintf(file1,['						               .clk(clk),','\n']);
                                 fprintf(file1,['											.rst(rst),','\n']);
                                 fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result),','\n']);
                                 fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                                 fprintf(file1,['					                 );','\n']);
                             else
                                 fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                                 fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                                fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                    fprintf(file1,['						               .clk(clk),','\n']);
                                    fprintf(file1,['											.rst(rst),','\n']);
                                    fprintf(file1,['											.rst_user(rst_user),','\n']);
                                    fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                    fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,5,ilie,lei})} + DD(str2double(ZONE1{jj,5,ilie,lei})) - 2),']),\n']);
                                    fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                    fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE1{jj,5,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                    fprintf(file1,['					                 );','\n']);
                             end
                         end
                     end
                 end
            end
            fprintf(file,['													        .y(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong)','\n']);
            fprintf(file,['													        );	','\n']); 
        end
        if lei==6||lei==7
            fprintf(file,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong;	','\n']);
            fprintf(file,['ctrl_time_',num2str(cssi(lei,ilie)),' ctrl_time_',LEIXING(lei,:),'_',num2str(ilie),'_C(','\n']);
            fprintf(file,['	                                            .clk(clk),','\n']);
            fprintf(file,['													        .sta(sta),','\n']);
            fprintf(file,['													        .counter(counter),','\n']);
            for jj=1:cssi(lei,ilie)
                 fprintf(file,['															  .time_',num2str(jj),'(12''d',num2str(ZONE1{jj,1,ilie,lei}),'),//',num2str(ZONE1{jj,2,ilie,lei}),'\n']);
             if str2double(ZONE1{jj,7,ilie,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE1{jj,8,ilie,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE1{jj,8,ilie,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,8,ilie,lei},'_lyf','),','\n']);
             end
              if str2double(ZONE1{jj,7,ilie,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE1{jj,8,ilie,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,8,ilie,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE1{jj,8,ilie,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE1{jj,8,ilie,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,8,ilie,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE1{jj,8,ilie,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE1{jj,8,ilie,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,8,ilie,lei},'),','\n']);
             end
             if str2double(ZONE1{jj,7,ilie,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE1{jj,8,ilie,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,8,ilie,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE1{jj,8,ilie,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE1{jj,8,ilie,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE1{jj,8,ilie,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE1{jj,1,ilie,lei}-datadelay ==0
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,8,ilie,lei},'_64','),','\n']);
                 elseif ZONE1{jj,1,ilie,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE1{jj,1,ilie,lei}-datadelay),')  DELAY_NCLK_','',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE1{jj,8,ilie,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE1{jj,8,ilie,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,8,ilie,lei},'_64_',num2str(ZONE1{jj,1,ilie,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE1{jj,7,ilie,lei})==8 
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,7,ilie,lei}))
                     if str2double(ZONE1{jj,8,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,7,ilie,lei})}
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,7,ilie,lei})} - DD(str2double(ZONE1{jj,7,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(compare_',ZONE1{jj,8,ilie,lei},'_lyf','),','\n']);
                             elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf',')\n']);
                             fprintf(file1,['						               .q(','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,7,ilie,lei})} + DD(str2double(ZONE1{jj,7,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf',' ),\n']);
                                fprintf(file1,['								.cout( ','','(compare_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
             if str2double(ZONE1{jj,7,ilie,lei})==9
                 for i = 1:NSHULIANG(str2double(ZONE1{jj,7,ilie,lei}))
                     if str2double(ZONE1{jj,8,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,7,ilie,lei})}
                         yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,7,ilie,lei})} - DD(str2double(ZONE1{jj,7,ilie,lei}));
                         if yanshi==0
                             fprintf(file,['															  .value_',num2str(jj),'(limit_',ZONE1{jj,8,ilie,lei},'_lyf','),','\n']);
                             elseif  yanshi<=12
                             fprintf(file,['															  .value_',num2str(jj),'(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf',')\n']);
                             fprintf(file1,['						               .q(','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file,['															  .value_',num2str(jj),'(','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,7,ilie,lei})} + DD(str2double(ZONE1{jj,7,ilie,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf',' ),\n']);
                                fprintf(file1,['								.cout( ','','(limit_',ZONE1{jj,8,ilie,lei},'_lyf_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
                 if str2double(ZONE1{jj,7,ilie,lei})==11
                     fprintf(file,['															  .value_',num2str(jj),'(',ZONE1{jj,8,ilie,lei},'_lyf','),','\n']);
                 end
                 if str2double(ZONE1{jj,7,ilie,lei})==1||str2double(ZONE1{jj,7,ilie,lei})==2||str2double(ZONE1{jj,7,ilie,lei})==5||str2double(ZONE1{jj,7,ilie,lei})==6||str2double(ZONE1{jj,7,ilie,lei})==7||str2double(ZONE1{jj,7,ilie,lei})==10
                     for i = 1:NSHULIANG(str2double(ZONE1{jj,7,ilie,lei}))
                         if str2double(ZONE1{jj,8,ilie,lei})==ZONE2{i,2,str2double(ZONE1{jj,7,ilie,lei})}
                             yushu=mod(i,SHULIANG(str2double(ZONE1{jj,7,ilie,lei})))+1;
                             yanshi = ZONE1{jj,1,ilie,lei} - ZONE2{i,1,str2double(ZONE1{jj,7,ilie,lei})} - DD(str2double(ZONE1{jj,7,ilie,lei}));
                             if yanshi==0
                                 fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                             elseif  yanshi<=12
                                 fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                                 fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                                 fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                                 fprintf(file1,['						               .clk(clk),','\n']);
                                 fprintf(file1,['											.rst(rst),','\n']);
                                 fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result),','\n']);
                                 fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                                 fprintf(file1,['					                 );','\n']);
                             else
                                 fprintf(file,['															  .value_',num2str(jj),'(','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                                 fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                                fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                    fprintf(file1,['						               .clk(clk),','\n']);
                                    fprintf(file1,['											.rst(rst),','\n']);
                                    fprintf(file1,['											.rst_user(rst_user),','\n']);
                                    fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE1{jj,1,ilie,lei}-4),']),\n']);
                                    fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(ZONE1{jj,7,ilie,lei})} + DD(str2double(ZONE1{jj,7,ilie,lei})) - 2),']),\n']);
                                    fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                    fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE1{jj,7,ilie,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                    fprintf(file1,['					                 );','\n']);
                             end
                         end
                     end
                 end
            end
            fprintf(file,['													        .y(',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong)','\n']);
            fprintf(file,['													        );	','\n']); 
        end      
        if lei ==1
            fprintf(file,['wire ',LEIXING(lei,:),'_',num2str(ilie),'_add_sub_ctrl_fuyong;	','\n']);
            fprintf(file,['ctrl_time_ADDSUB_',num2str(cssi(lei,ilie)),' ',LEIXING(lei,:),'_',num2str(ilie),'_add_sub(','\n']);
            fprintf(file,['	                                            .clk(clk),','\n']);
            fprintf(file,['													        .sta(sta),','\n']);
            fprintf(file,['													        .counter(counter),','\n']);
            for jj=1:cssi(lei,ilie)
                 fprintf(file,['															  .time_',num2str(jj),'(12''d',num2str(ZONE1{jj,1,ilie,lei}),'),//',num2str(ZONE1{jj,2,ilie,lei}),'\n']);
                 if str2double(ZONE1{jj,7,ilie,lei})==1
                     fprintf(file,['															  .value_',num2str(jj),'(`add),','\n']);
                 else
                     fprintf(file,['															  .value_',num2str(jj),'(`sub),','\n']);
                 end
            end
            fprintf(file,['													        .y(',LEIXING(lei,:),'_',num2str(ilie),'_add_sub_ctrl_fuyong)','\n']);
            fprintf(file,['													        );	','\n']);
        end
    end
end
for lei=1:length(LEIXING)
    if lei == 1
        for ilie=1:SHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result',';\n']);
            fprintf(file4,['ADD_SUB_64	',LEIXING(lei,:),'_',num2str(ilie),'_ctrl_fuyong(','\n']);
            fprintf(file4,['										  .aclr(rst),','\n']);
            fprintf(file4,['										  .clk_en(`ena_math),','\n']);
            fprintf(file4,['										  .add_sub(',LEIXING(lei,:),'_',num2str(ilie),'_add_sub_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .clock(clk),','\n']);
            fprintf(file4,['										  .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .datab(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .result(',LEIXING(lei,:),'_',num2str(ilie),'_result)','\n']);
            fprintf(file4,['										 );','\n']);
        end
    end
    if lei == 2
        for ilie=1:SHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result',';\n']);
            fprintf(file4,['multiplier_64	',LEIXING(lei,:),'_',num2str(ilie),'_ctrl_fuyong(','\n']);
            fprintf(file4,['										  .aclr(rst),','\n']);
            fprintf(file4,['										  .clk_en(`ena_math),','\n']);
            fprintf(file4,['										  .clock(clk),','\n']);
            fprintf(file4,['										  .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .datab(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .result(',LEIXING(lei,:),'_',num2str(ilie),'_result)','\n']);
            fprintf(file4,['										 );','\n']);
        end
    end
    if lei == 5
        for ilie=1:SHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result',';\n']);
            fprintf(file4,['Divide_64	',LEIXING(lei,:),'_',num2str(ilie),'_ctrl_fuyong(','\n']);
            fprintf(file4,['										  .aclr(rst),','\n']);
            fprintf(file4,['										  .clk_en(`ena_math),','\n']);
            fprintf(file4,['										  .clock(clk),','\n']);
            fprintf(file4,['										  .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .datab(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .result(',LEIXING(lei,:),'_',num2str(ilie),'_result)','\n']);
            fprintf(file4,['										 );','\n']);
        end
    end
    if lei == 10
        for ilie=1:SHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result',';\n']);
            fprintf(file4,['exp_64	',LEIXING(lei,:),'_',num2str(ilie),'_ctrl_fuyong(','\n']);
            fprintf(file4,['										  .aclr(rst),','\n']);
            fprintf(file4,['										  .clk_en(`ena_math),','\n']);
            fprintf(file4,['										  .clock(clk),','\n']);
            fprintf(file4,['										  .data(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong),','\n']);
            fprintf(file4,['										  .result(',LEIXING(lei,:),'_',num2str(ilie),'_result)','\n']);
            fprintf(file4,['										 );','\n']);
        end
    end
    if lei == 6
        for ilie=1:SHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong_32',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong_32',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong_32',';\n']);
            fprintf(file9,['wire [`SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result_32',';\n']);
            fprintf(file9,['reg [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_theta',';\n']);
            fprintf(file9,['wire [`SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_theta_32',';\n']);
            fprintf(file4,['always@ (posedge clk or posedge rst_user) begin','\n']);
            fprintf(file4,['   if (rst_user==1''b1)','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <=64''h0;','\n']);
            fprintf(file4,['	else if((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b1)||((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong[63]==1''b1)))','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <= ',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong;','\n']);
            fprintf(file4,['	else if((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong[63]==1''b0))','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <= ',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong;','\n']);
            fprintf(file4,['	else if((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong[63]==1''b1))','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <= ',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong;','\n']);
            fprintf(file4,['end','\n']);
            fprintf(file4,['EXTENDED_SINGLE2SINGLE	double2single_',LEIXING(lei,:),'_',num2str(ilie),'_theta','(','\n']);
            fprintf(file4,['	                                            .aclr(rst),','\n']);
            fprintf(file4,['													        .clk_en(`ena_math),','\n']);
            fprintf(file4,['													        .clock(clk),','\n']);
            fprintf(file4,['													        .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_theta),','\n']);
            fprintf(file4,['													        .result(',LEIXING(lei,:),'_',num2str(ilie),'_theta_32',')','\n']);
            fprintf(file4,['													        );','\n']);
            fprintf(file4,['Sin_control_system_water	',LEIXING(lei,:),'_',num2str(ilie),'_ctrl_fuyong(','\n']);
            fprintf(file4,['							.clk(clk),','\n']);
            fprintf(file4,['							.theta(',LEIXING(lei,:),'_',num2str(ilie),'_theta_32),','\n']);
            fprintf(file4,['							.sin(',LEIXING(lei,:),'_',num2str(ilie),'_result_32)','\n']);
            fprintf(file4,['										 );','\n']);
            fprintf(file4,['SINGLE2EXTENDED_SINGLE	single2float_',LEIXING(lei,:),'_',num2str(ilie),'_result','(','\n']);
            fprintf(file4,['	                                            .aclr(rst),','\n']);
            fprintf(file4,['													        .clk_en(`ena_math),','\n']);
            fprintf(file4,['													        .clock(clk),','\n']);
            fprintf(file4,['													        .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_result_32),','\n']);
            fprintf(file4,['													        .result(',LEIXING(lei,:),'_',num2str(ilie),'_result',')','\n']);
            fprintf(file4,['													        );','\n']);
            
        end
    end
    if lei == 7
        for ilie=1:SHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong_32',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong_32',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong_32',';\n']);
            fprintf(file9,['wire [`SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_result_32',';\n']);
            fprintf(file9,['reg [`EXTENDED_SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_theta',';\n']);
            fprintf(file9,['wire [`SINGLE - 1:0] ',LEIXING(lei,:),'_',num2str(ilie),'_theta_32',';\n']);
            fprintf(file4,['always@ (posedge clk or posedge rst_user) begin','\n']);
            fprintf(file4,['   if (rst_user==1''b1)','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <=64''h0;','\n']);
            fprintf(file4,['	else if((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b1)||((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong[63]==1''b1)))','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <= ',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong;','\n']);
            fprintf(file4,['	else if((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong[63]==1''b0))','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <= ',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong;','\n']);
            fprintf(file4,['	else if((',LEIXING(lei,:),'_',num2str(ilie),'_C_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong[63]==1''b0)&&(',LEIXING(lei,:),'_',num2str(ilie),'_B_ctrl_fuyong[63]==1''b1))','\n']);
            fprintf(file4,['	   ',LEIXING(lei,:),'_',num2str(ilie),'_theta <= ',LEIXING(lei,:),'_',num2str(ilie),'_A_ctrl_fuyong;','\n']);
            fprintf(file4,['end','\n']);
            fprintf(file4,['EXTENDED_SINGLE2SINGLE	double2single_',LEIXING(lei,:),'_',num2str(ilie),'_theta','(','\n']);
            fprintf(file4,['	                                            .aclr(rst),','\n']);
            fprintf(file4,['													        .clk_en(`ena_math),','\n']);
            fprintf(file4,['													        .clock(clk),','\n']);
            fprintf(file4,['													        .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_theta),','\n']);
            fprintf(file4,['													        .result(',LEIXING(lei,:),'_',num2str(ilie),'_theta_32',')','\n']);
            fprintf(file4,['													        );','\n']);
            fprintf(file4,['Cos_control_system_water	',LEIXING(lei,:),'_',num2str(ilie),'_ctrl_fuyong(','\n']);
            fprintf(file4,['							.clk(clk),','\n']);
            fprintf(file4,['							.theta(',LEIXING(lei,:),'_',num2str(ilie),'_theta_32),','\n']);
            fprintf(file4,['							.cos(',LEIXING(lei,:),'_',num2str(ilie),'_result_32)','\n']);
            fprintf(file4,['										 );','\n']);
            fprintf(file4,['SINGLE2EXTENDED_SINGLE	single2float_',LEIXING(lei,:),'_',num2str(ilie),'_result','(','\n']);
            fprintf(file4,['	                                            .aclr(rst),','\n']);
            fprintf(file4,['													        .clk_en(`ena_math),','\n']);
            fprintf(file4,['													        .clock(clk),','\n']);
            fprintf(file4,['													        .dataa(',LEIXING(lei,:),'_',num2str(ilie),'_result_32),','\n']);
            fprintf(file4,['													        .result(',LEIXING(lei,:),'_',num2str(ilie),'_result',')','\n']);
            fprintf(file4,['													        );','\n']);
        end
    end
    if lei == 8
        for ilie=1:NSHULIANG(lei)
            fprintf(file9,['reg [`EXTENDED_SINGLE - 1:0] ','compare_',num2str(ilie),'_reg',';\n']);
            fprintf(file9,['wire ','compareone_',num2str(ilie),'_lyf',';\n']);
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ','compare_',num2str(ilie),'_lyf',';\n']);
            fprintf(file7,['Comparator_64 Comparator_',num2str(ilie),'(\n']);
             fprintf(file7,['								 .clk(clk),','\n']);
             fprintf(file7,['								 .rst(rst),','\n']);
             if str2double(ZONE2{ilie,3,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE2{ilie,4,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE2{ilie,4,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file7,['								 .input_1(',ZONE2{ilie,4,lei},'_lyf),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE2{ilie,4,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE2{ilie,1,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,4,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,4,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,4,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,4,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file7,['								 .input_1(',ZONE2{ilie,4,lei},'),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE2{ilie,4,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE2{ilie,4,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE2{ilie,4,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE2{ilie,4,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE2{ilie,1,lei}-datadelay ==0
                     fprintf(file7,['								 .input_1(',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 elseif ZONE2{ilie,1,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE2{ilie,1,lei}-datadelay),')  DELAY_NCLK_','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE2{ilie,4,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file7,['								 .input_1(',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE2{ilie,4,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file7,['								 .input_1(',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE2{ilie,3,lei})==8 
                 fprintf(file7,['								 .input_1(','(compare_',ZONE2{ilie,4,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==9
                 fprintf(file7,['								 .input_1(','(limit_',ZONE2{ilie,4,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==11
                 fprintf(file7,['								 .input_1(',ZONE2{ilie,4,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==1||str2double(ZONE2{ilie,3,lei})==2||str2double(ZONE2{ilie,3,lei})==5||str2double(ZONE2{ilie,3,lei})==6||str2double(ZONE2{ilie,3,lei})==7||str2double(ZONE2{ilie,3,lei})==10
                 for compaa = 1 : NSHULIANG(str2double(ZONE2{ilie,3,lei}))
                     if str2double(ZONE2{ilie,4,lei})==ZONE2{compaa,2,str2double(ZONE2{ilie,3,lei})}
                         yushu=mod(compaa,SHULIANG(str2double(ZONE2{ilie,3,lei})))+1;
                         yanshi = ZONE2{ilie,1,lei} - ZONE2{compaa,1,str2double(ZONE2{ilie,3,lei})} - DD(str2double(ZONE2{ilie,3,lei}));
                         if yanshi==0
                             fprintf(file7,['								 .input_1(',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                         elseif  yanshi<=12
                             fprintf(file7,['								 .input_1(',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result),','\n']);
                             fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file7,['								 .input_1(',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{compaa,1,str2double(ZONE2{ilie,3,lei})} + DD(str2double(ZONE2{ilie,3,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
             if str2double(ZONE2{ilie,5,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE2{ilie,6,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE2{ilie,6,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file7,['								 .input_2(',ZONE2{ilie,6,lei},'_lyf),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE2{ilie,6,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE2{ilie,1,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,6,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,6,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,6,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,6,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file7,['								 .input_2(',ZONE2{ilie,6,lei},'),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE2{ilie,6,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE2{ilie,6,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE2{ilie,6,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE2{ilie,6,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE2{ilie,1,lei}-datadelay ==0
                     fprintf(file7,['								 .input_2(',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 elseif ZONE2{ilie,1,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE2{ilie,1,lei}-datadelay),')  DELAY_NCLK_','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE2{ilie,6,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file7,['								 .input_2(',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE2{ilie,6,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file7,['								 .input_2(',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE2{ilie,5,lei})==8 
                 fprintf(file7,['								 .input_2(','(compare_',ZONE2{ilie,6,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==9
                 fprintf(file7,['								 .input_2(','(limit_',ZONE2{ilie,6,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==11
                 fprintf(file7,['								 .input_2(',ZONE2{ilie,6,lei},'_lyf','),','\n']);
             end
            if str2double(ZONE2{ilie,5,lei})==1||str2double(ZONE2{ilie,5,lei})==2||str2double(ZONE2{ilie,5,lei})==5||str2double(ZONE2{ilie,5,lei})==6||str2double(ZONE2{ilie,5,lei})==7||str2double(ZONE2{ilie,5,lei})==10
                 for compaa = 1 : NSHULIANG(str2double(ZONE2{ilie,5,lei}))
                     if str2double(ZONE2{ilie,6,lei})==ZONE2{compaa,2,str2double(ZONE2{ilie,5,lei})}
                         yushu=mod(compaa,SHULIANG(str2double(ZONE2{ilie,5,lei})))+1;
                         yanshi = ZONE2{ilie,1,lei} - ZONE2{compaa,1,str2double(ZONE2{ilie,5,lei})} - DD(str2double(ZONE2{ilie,5,lei}));
                         if yanshi==0
                             fprintf(file7,['								 .input_2(',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                         elseif  yanshi<=12
                             fprintf(file7,['								 .input_2(',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result),','\n']);
                             fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file7,['								 .input_2(',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{compaa,1,str2double(ZONE2{ilie,5,lei})} + DD(str2double(ZONE2{ilie,5,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
            end
            fprintf(file7,['								 .output_1','(compareone_',num2str(ilie),'_lyf',')','\n']);
            fprintf(file7,['							   );','\n']);
            fprintf(file7,['always@(posedge clk or posedge rst) begin','\n']);
            fprintf(file7,['	if(rst) begin','\n']);
            fprintf(file7,['		compare_',num2str(ilie),'_reg <= 64''h0000000000000000;','\n']);
            fprintf(file7,['	end','\n']);
            fprintf(file7,['	else if(compareone_',num2str(ilie),'_lyf) begin','\n']);
            fprintf(file7,['		compare_',num2str(ilie),'_reg <= 64''h3FF0000000000000;','\n']);
            fprintf(file7,['	end','\n']);
            fprintf(file7,['	else if(!compareone_',num2str(ilie),'_lyf) begin','\n']);
            fprintf(file7,['		compare_',num2str(ilie),'_reg <= 64''h0000000000000000;','\n']);
            fprintf(file7,['	end','\n']);
            fprintf(file7,['end','\n']);
            fprintf(file7,['assign compare_',num2str(ilie),'_lyf = compare_',num2str(ilie),'_reg;','\n']);
        end
    end
    if lei == 9
        for ilie=1:NSHULIANG(lei)
            fprintf(file9,['wire [`EXTENDED_SINGLE - 1:0] ','limit_',num2str(ilie),'_lyf',';\n']);
            fprintf(file8,['limit_control_system64_water limit_',num2str(ilie),'(\n']);
             fprintf(file8,['								 .clk(clk),','\n']);
             fprintf(file8,['								 .rst(rst),','\n']);
             if str2double(ZONE2{ilie,3,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE2{ilie,4,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE2{ilie,4,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file8,['									  .upper_limit(',ZONE2{ilie,4,lei},'_lyf),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE2{ilie,4,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE2{ilie,1,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,4,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,4,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,4,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,4,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file8,['									  .upper_limit(',ZONE2{ilie,4,lei},'),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE2{ilie,4,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE2{ilie,4,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE2{ilie,4,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE2{ilie,4,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE2{ilie,1,lei}-datadelay ==0
                     fprintf(file8,['									  .upper_limit(',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 elseif ZONE2{ilie,1,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE2{ilie,1,lei}-datadelay),')  DELAY_NCLK_','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE2{ilie,4,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file8,['									  .upper_limit(',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE2{ilie,4,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file8,['									  .upper_limit(',ZONE2{ilie,4,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE2{ilie,3,lei})==8 
                 fprintf(file8,['									  .upper_limit(','(compare_',ZONE2{ilie,4,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==9
                 fprintf(file8,['									  .upper_limit(','(limit_',ZONE2{ilie,4,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==11
                 fprintf(file8,['									  .upper_limit(',ZONE2{ilie,4,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,3,lei})==1||str2double(ZONE2{ilie,3,lei})==2||str2double(ZONE2{ilie,3,lei})==5||str2double(ZONE2{ilie,3,lei})==6||str2double(ZONE2{ilie,3,lei})==7||str2double(ZONE2{ilie,3,lei})==10
                 for compaa = 1 : NSHULIANG(str2double(ZONE2{ilie,3,lei}))
                     if str2double(ZONE2{ilie,4,lei})==ZONE2{compaa,2,str2double(ZONE2{ilie,3,lei})}
                         yushu=mod(compaa,SHULIANG(str2double(ZONE2{ilie,3,lei})))+1;
                         yanshi = ZONE2{ilie,1,lei} - ZONE2{compaa,1,str2double(ZONE2{ilie,3,lei})} - DD(str2double(ZONE2{ilie,3,lei}));
                         if yanshi==0
                             fprintf(file8,['									  .upper_limit(',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                         elseif  yanshi<=12
                             fprintf(file8,['									  .upper_limit(',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result),','\n']);
                             fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file8,['									  .upper_limit(',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{compaa,1,str2double(ZONE2{ilie,3,lei})} + DD(str2double(ZONE2{ilie,3,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE2{ilie,3,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
             if str2double(ZONE2{ilie,5,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE2{ilie,6,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE2{ilie,6,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file8,['									  .down_limit(',ZONE2{ilie,6,lei},'_lyf),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE2{ilie,6,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE2{ilie,1,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,6,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,6,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,6,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,6,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file8,['									  .down_limit(',ZONE2{ilie,6,lei},'),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE2{ilie,6,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE2{ilie,6,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE2{ilie,6,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE2{ilie,6,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE2{ilie,1,lei}-datadelay ==0
                     fprintf(file8,['									  .down_limit(',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 elseif ZONE2{ilie,1,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE2{ilie,1,lei}-datadelay),')  DELAY_NCLK_','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE2{ilie,6,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file8,['									  .down_limit(',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE2{ilie,6,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file8,['									  .down_limit(',ZONE2{ilie,6,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE2{ilie,5,lei})==8 
                 fprintf(file8,['									  .down_limit(','(compare_',ZONE2{ilie,6,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==9
                 fprintf(file8,['									  .down_limit(','(limit_',ZONE2{ilie,6,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,5,lei})==11
                 fprintf(file8,['									  .down_limit(',ZONE2{ilie,6,lei},'_lyf','),','\n']);
             end
            if str2double(ZONE2{ilie,5,lei})==1||str2double(ZONE2{ilie,5,lei})==2||str2double(ZONE2{ilie,5,lei})==5||str2double(ZONE2{ilie,5,lei})==6||str2double(ZONE2{ilie,5,lei})==7||str2double(ZONE2{ilie,5,lei})==10
                 for compaa = 1 : NSHULIANG(str2double(ZONE2{ilie,5,lei}))
                     if str2double(ZONE2{ilie,6,lei})==ZONE2{compaa,2,str2double(ZONE2{ilie,5,lei})}
                         yushu=mod(compaa,SHULIANG(str2double(ZONE2{ilie,5,lei})))+1;
                         yanshi = ZONE2{ilie,1,lei} - ZONE2{compaa,1,str2double(ZONE2{ilie,5,lei})} - DD(str2double(ZONE2{ilie,5,lei}));
                         if yanshi==0
                             fprintf(file8,['									  .down_limit(',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                         elseif  yanshi<=12
                             fprintf(file8,['									  .down_limit(',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result),','\n']);
                             fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file8,['									  .down_limit(',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{compaa,1,str2double(ZONE2{ilie,5,lei})} + DD(str2double(ZONE2{ilie,5,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE2{ilie,5,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
            end
			if str2double(ZONE2{ilie,7,lei})==0
                 for para =1:length(PARAMETERNAME)
                     if strcmp(ZONE2{ilie,8,lei},PARAMETERNAME{para,1})
                         if parasign(para) == 0
                             parasign(para) = 1;
                             par=str2double(PARAMETERNUM{para,1});
                             fprintf(file2,['parameter ',ZONE2{ilie,8,lei},'_lyf']);
                             par16=sprintf('%bx',par);
                             fprintf(file2,[' = 64''h',par16]);
                             fprintf(file2,[';\n']);
                             break;
                         end
                     end
                 end
                 fprintf(file8,['					              .x',ZONE2{ilie,8,lei},'_lyf),','\n']);
             end
             if str2double(ZONE2{ilie,7,lei})==3
                 for hist =1:length(HISTORYNAME)
                     if strcmp(ZONE2{ilie,8,lei},HISTORYNAME{hist,1})
                         if histsign(hist) == 0
                             histsign(hist) = 1;
							 if str2double(HISTORYLEI{hist,1})==1||str2double(HISTORYLEI{hist,1})==2||str2double(HISTORYLEI{hist,1})==5||str2double(HISTORYLEI{hist,1})==6||str2double(HISTORYLEI{hist,1})==7||str2double(HISTORYLEI{hist,1})==10
                                 for i = 1:NSHULIANG(str2double(HISTORYLEI{hist,1}))
                                     if str2double(HISTORYWHERE{hist,1})==ZONE2{i,2,str2double(HISTORYLEI{hist,1})}
                                         yushu=mod(i,SHULIANG(str2double(HISTORYLEI{hist,1})))+1;
                                         yanshi = ZONE2{ilie,1,lei} - ZONE2{i,1,str2double(HISTORYLEI{hist,1})} - DD(str2double(HISTORYLEI{hist,1}));
                                         if  yanshi>=-10
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20;\n']);
                                             fprintf(file6,['DELAY_NCLK  #(64,20)  DELAY_NCLK_','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20(','\n']);
                                             fprintf(file6,['						               .clk(clk),','\n']);
                                             fprintf(file6,['											.rst(rst),','\n']);
                                             fprintf(file6,['						               .d(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result),','\n']);
                                             fprintf(file6,['						               .q(','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20)','\n']);
                                             fprintf(file6,['					                 );','\n']);
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,8,lei},';\n']);
                                             fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,8,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2+20),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result_20',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,8,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         else
                                             fprintf(file6,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,8,lei},';\n']);
                                            fprintf(file6,['System_FIFO_64_1	FIFO_',ZONE2{ilie,8,lei},' (\n']);
                                                fprintf(file6,['						               .clk(clk),','\n']);
                                                fprintf(file6,['											.rst(rst),','\n']);
                                                fprintf(file6,['											.rst_user(rst_user),','\n']);
                                                fprintf(file6,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                                fprintf(file6,['											.before_enawrite(sta_sig[',num2str(ZONE2{i,1,str2double(HISTORYLEI{hist,1})} + DD(str2double(HISTORYLEI{hist,1})) - 2),']),\n']);
                                                fprintf(file6,['								.cin( ','',LEIXING(str2double(HISTORYLEI{hist,1}),:),'_',num2str(yushu),'_result',' ),\n']);
                                                fprintf(file6,['								.cout( ','',ZONE2{ilie,8,lei},' )\n']);
                                                fprintf(file6,['					                 );','\n']);
                                         end
                                     end
                                 end
                             end
                             break;
                         end
                     end
                 end
                 fprintf(file8,['					              .x',ZONE2{ilie,8,lei},'),','\n']);
             end
             if str2double(ZONE2{ilie,7,lei})==4
                 for inpu =1:length(INPUTNAME)
                     if strcmp(ZONE2{ilie,8,lei},INPUTNAME{inpu,1})
                         if inpusign(inpu) == 0
                             inpusign(inpu) = 1;
                             fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,8,lei},'_64',';\n']);
                             fprintf(file5,['SINGLE2EXTENDED_SINGLE	single2float_',ZONE2{ilie,8,lei},'(','\n']);
                             fprintf(file5,['	                                            .aclr(rst),','\n']);
                             fprintf(file5,['													        .clk_en(`ena_math),','\n']);
                             fprintf(file5,['													        .clock(clk),','\n']);
                             fprintf(file5,['													        .dataa(',ZONE2{ilie,8,lei},'),','\n']);
                             fprintf(file5,['													        .result(',ZONE2{ilie,8,lei},'_64)','\n']);
                             fprintf(file5,['													        );','\n']);
                             break;
                         end
                     end
                 end
                 if ZONE2{ilie,1,lei}-datadelay ==0
                     fprintf(file8,['					              .x',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 elseif ZONE2{ilie,1,lei}-datadelay<=10
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['DELAY_NCLK  #(64,',num2str(ZONE2{ilie,1,lei}-datadelay),')  DELAY_NCLK_','',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'(\n']);
                     fprintf(file5,['						               .clk(clk),','\n']);
                     fprintf(file5,['											.rst(rst),','\n']);
                     fprintf(file5,['						               .d(','',ZONE2{ilie,8,lei},'_64),\n']);
                     fprintf(file5,['						               .q(','',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),')\n']);
                     fprintf(file5,['					                 );','\n']);
                     fprintf(file8,['					              .x',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 else
                     fprintf(file5,['wire [`EXTENDED_SINGLE - 1:0] ',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),';\n']);
                     fprintf(file5,['System_FIFO_64_1	FIFO_','',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' (\n']);
                    fprintf(file5,['						               .clk(clk),','\n']);
                    fprintf(file5,['											.rst(rst),','\n']);
                    fprintf(file5,['											.rst_user(rst_user),','\n']);
                    fprintf(file5,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                    fprintf(file5,['											.before_enawrite(sta_sig[',num2str(datadelay - 2),']),\n']);
                    fprintf(file5,['								.cin( ','',ZONE2{ilie,8,lei},'_64',' ),\n']);
                    fprintf(file5,['								.cout( ','',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),' )\n']);
                    fprintf(file5,['					                 );','\n']);
                    fprintf(file8,['					              .x',ZONE2{ilie,8,lei},'_64_',num2str(ZONE2{ilie,1,lei}-datadelay),'),','\n']);
                 end
             end
             if str2double(ZONE2{ilie,7,lei})==8 
                 fprintf(file8,['					              .x','(compare_',ZONE2{ilie,8,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,7,lei})==9
                 fprintf(file8,['					              .x','(limit_',ZONE2{ilie,8,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,7,lei})==11
                 fprintf(file8,['					              .x',ZONE2{ilie,8,lei},'_lyf','),','\n']);
             end
             if str2double(ZONE2{ilie,7,lei})==1||str2double(ZONE2{ilie,7,lei})==2||str2double(ZONE2{ilie,7,lei})==5||str2double(ZONE2{ilie,7,lei})==6||str2double(ZONE2{ilie,7,lei})==7||str2double(ZONE2{ilie,7,lei})==10
                 for compaa = 1 : NSHULIANG(str2double(ZONE2{ilie,7,lei}))
                     if str2double(ZONE2{ilie,8,lei})==ZONE2{compaa,2,str2double(ZONE2{ilie,7,lei})}
                         yushu=mod(compaa,SHULIANG(str2double(ZONE2{ilie,7,lei})))+1;
                         yanshi = ZONE2{ilie,1,lei} - ZONE2{compaa,1,str2double(ZONE2{ilie,7,lei})} - DD(str2double(ZONE2{ilie,7,lei}));
                         if yanshi==0
                             fprintf(file8,['					              .x',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result','),','\n']);
                         elseif  yanshi<=12
                             fprintf(file8,['					              .x',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),';\n']);
                             fprintf(file1,['DELAY_NCLK  #(64,',num2str(yanshi),')  DELAY_NCLK_','',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),'(','\n']);
                             fprintf(file1,['						               .clk(clk),','\n']);
                             fprintf(file1,['											.rst(rst),','\n']);
                             fprintf(file1,['						               .d(','',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result),','\n']);
                             fprintf(file1,['						               .q(','',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_',num2str(yanshi),')','\n']);
                             fprintf(file1,['					                 );','\n']);
                         else
                             fprintf(file8,['					              .x',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),'),','\n']);
                             fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),';\n']);
                            fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' (\n']);
                                fprintf(file1,['						               .clk(clk),','\n']);
                                fprintf(file1,['											.rst(rst),','\n']);
                                fprintf(file1,['											.rst_user(rst_user),','\n']);
                                fprintf(file1,['											.before_enaread(sta_sig[',num2str(ZONE2{ilie,1,lei}-4),']),\n']);
                                fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ZONE2{compaa,1,str2double(ZONE2{ilie,7,lei})} + DD(str2double(ZONE2{ilie,7,lei})) - 2),']),\n']);
                                fprintf(file1,['								.cin( ','',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result',' ),\n']);
                                fprintf(file1,['								.cout( ','',LEIXING(str2double(ZONE2{ilie,7,lei}),:),'_',num2str(yushu),'_result_FIFO_',num2str(yanshi),' )\n']);
                                fprintf(file1,['					                 );','\n']);
                         end
                     end
                 end
             end
            fprintf(file8,['					              .y','(limit_',num2str(ilie),'_lyf','),','\n']);
            fprintf(file8,['							   );','\n']);
        end
    end
end
%end
% for kkk=1:length(OUTPUT)
%     if str2double(OUTPUTTYPE{kkk}) == 1||str2double(OUTPUTTYPE{kkk}) == 2||str2double(OUTPUTTYPE{kkk}) == 5||str2double(OUTPUTTYPE{kkk}) == 6||str2double(OUTPUTTYPE{kkk}) == 7||str2double(OUTPUTTYPE{kkk}) == 10
%         for jjj=1:SHULIANG(str2double(OUTPUTTYPE{kkk}))
%             for iii=1:length(ZONE1(:,1,1,1))
%                 if ZONE1{iii,2,jjj,str2double(OUTPUTTYPE{kkk})} == str2double(OUTPUTWHERE{kkk})
%                     ENDTIME(kkk)=ZONE1{iii,1,jjj,str2double(OUTPUTTYPE{kkk})};
%                     ENDWHERE(kkk)=jjj;
%                 end
%             end
%         end
%     end
% end
% %ei=0;
% %while ei<length(OUTPUT)/4
%     %fprintf(file10,['FIFO_Source_Exchange	FIFO_output_',num2str(ei),' (','\n']);
%     %fprintf(file10,['	.data ( {']);
%     outtime=max(ENDTIME);
%     for kkk=1:length(OUTPUT)
%         if outtime-ENDTIME(kkk) ==0
%              %fprintf(file10,[LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result,']);
%              fprintf(file1,['assign ',OUTPUT{kkk},'=',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result,']);
%          elseif outtime-ENDTIME(kkk)<=10
%              %fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result_',num2str(outtime-ENDTIME(kkk)),';\n']);
%              fprintf(file1,['DELAY_NCLK  #(64,',num2str(outtime-ENDTIME(kkk)),')  DELAY_NCLK_','',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result_',num2str(outtime-ENDTIME(kkk)),'(\n']);
%              fprintf(file1,['						               .clk(clk),','\n']);
%              fprintf(file1,['											.rst(rst),','\n']);
%              fprintf(file1,['						               .d(','',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result),\n']);
%              fprintf(file1,['						               .q(','',OUTPUT{kkk},')\n']);
%              fprintf(file1,['					                 );','\n']);
%              %fprintf(file10,[LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result_',num2str(outtime-ENDTIME(kkk)),',']);
%          else
%              %fprintf(file1,['wire [`EXTENDED_SINGLE - 1:0] ',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result_',num2str(outtime-ENDTIME(kkk)),';\n']);
%              fprintf(file1,['System_FIFO_64_1	FIFO_','',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result_',num2str(outtime-ENDTIME(kkk)),' (\n']);
%             fprintf(file1,['						               .clk(clk),','\n']);
%             fprintf(file1,['											.rst(rst),','\n']);
%             fprintf(file1,['											.rst_user(rst_user),','\n']);
%             fprintf(file1,['											.before_enaread(sta_sig[',num2str(outtime-4),']),\n']);
%             fprintf(file1,['											.before_enawrite(sta_sig[',num2str(ENDTIME(kkk) - 2),']),\n']);
%             fprintf(file1,['								.cin( ','',LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result',' ),\n']);
%             fprintf(file1,['								.cout( ','',OUTPUT{kkk},' )\n']);
%             fprintf(file1,['					                 );','\n']);
%             %fprintf(file10,[LEIXING(str2double(OUTPUTTYPE{kkk}),:),'_',num2str(ENDWHERE(kkk)),'_result_',num2str(outtime-ENDTIME(kkk)),',']);
%          end
%     end
%     %ei=ei+1;
% %end
% fprintf(file10,['module Control_System(\n							 clk,\n							 sta,\n							 sta_ad,\n']);
% fprintf(file10,['							 sta_user,\n							 rst,\n							 rst_user,\n							 output_num,\n']);
% fprintf(file10,['							 control_valuation_sig,	\n							 sim_time,\n\n']);
% for mm=1:length(INPUTNAME)
%     signPWM=0;
%     for nn=1:length(PWMNAME)
%         if contains(PWMNAME{nn},INPUTNAME{mm})
%             signPWM=1;
%             break;
%         end
%     end
%     if signPWM==0
%         fprintf(file10,['								',INPUTNAME{mm},',\n']);
%     end
% end
% fprintf(file10,['\n']);
% for mm=1:length(OUTPUT)
%     fprintf(file10,['								',OUTPUT{mm},',\n']);
% end
% fprintf(file10,['							 exchange_data_sig,\n']);
% fprintf(file10,['							 exchange_Source_sig\n']);
% fprintf(file10,['							);\n']);
% fprintf(file10,['input clk;\ninput sta;\ninput sta_ad;\ninput sta_user;\ninput rst;\ninput rst_user;\ninput control_valuation_sig;\ninput exchange_Source_sig;\ninput [`WIDTH_TIME - 1:0] sim_time;\ninput [7:0] output_num;\n']);
% for mm=1:length(INPUTNAME)
%     signPWM=0;
%     for nn=1:length(PWMNAME)
%         if contains(PWMNAME{nn},INPUTNAME{mm})
%             signPWM=1;
%             break;
%         end
%     end
%     if signPWM==0
%         fprintf(file10,['input [`SINGLE - 1:0] ',INPUTNAME{mm},',\n']);
%     end
% end
% fprintf(file10,['output exchange_data_sig;\n']);
% for mm=1:length(OUTPUT)
%     fprintf(file10,['output [`EXTENDED_SINGLE - 1:0] ',OUTPUT{mm},',\n']);
% end
endf = fclose(file);
endf = fclose(file1);
endf = fclose(file2);
endf = fclose(file3);
endf = fclose(file4);
endf = fclose(file5);
endf = fclose(file6);
endf = fclose(file7);
endf = fclose(file8);
endf = fclose(file9);