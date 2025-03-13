%datadelay=0;
datadelay=12;
tc=15;
C=2000;
FLOYDPARAMETER;
opPARAMETERdo;
dloglast=1;

[ADDtype1, ADDwhere1, ADDtype2, ADDwhere2, ADDsign] = textread('ADDWT.txt' , '%s%s%s%s%s');
[MULtype1, MULwhere1, MULtype2, MULwhere2] = textread('MULWT.txt' , '%s%s%s%s');
[DIVtype1, DIVwhere1, DIVtype2, DIVwhere2] = textread('DIVWT.txt' , '%s%s%s%s');
[SINtype1, SINwhere1,SINtype2, SINwhere2,SINtype3, SINwhere3] = textread('SINWT.txt' , '%s%s%s%s%s%s');
[COStype1, COSwhere1,COStype2, COSwhere2,COStype3, COSwhere3] = textread('COSWT.txt' , '%s%s%s%s%s%s');
[COMPAREtype1, COMPAREwhere1, COMPAREtype2, COMPAREwhere2] = textread('COMPAREWT.txt' , '%s%s%s%s');
[LIMITtype1, LIMITwhere1, LIMITtype2, LIMITwhere2, LIMITtype3, LIMITwhere3] = textread('LIMITWT.txt' , '%s%s%s%s%s%s');
[EXPtype1, EXPwhere1] = textread('EXPWT.txt' , '%s%s');
[LOGtype1, LOGwhere1, LOGwhere2, LOGtime] = textread('LOGWT.txt' , '%s%s%s%s');
NADD=length(ADDtype1);
NMUL=length(MULtype1);
NDIV=length(DIVtype1);
NSIN=length(SINtype1);
NCOS=length(COStype1);
NCOMPARE=length(COMPAREtype1);
NLIMIT=length(LIMITwhere3);
NEXP=length(EXPtype1);
NLOG=length(LOGtype1);
where=[ADDwhere1;ADDwhere2;MULwhere1;MULwhere2;DIVwhere1;DIVwhere2;SINwhere1;SINwhere2;SINwhere3;COSwhere1;COSwhere2;COSwhere3;COMPAREwhere1;COMPAREwhere2;LIMITwhere1;LIMITwhere2;LIMITwhere3;EXPwhere1;LOGwhere1];
type=[ADDtype1;ADDtype2;MULtype1;MULtype2;DIVtype1;DIVtype2;SINtype1;SINtype2;SINtype3;COStype1;COStype2;COStype3;COMPAREtype1;COMPAREtype2;LIMITtype1;LIMITtype2;LIMITtype3;EXPtype1;LOGtype1];
for i=1:2*NADD+2*NMUL+2*NDIV+3*NSIN+3*NCOS+2*NCOMPARE+3*NLIMIT+NEXP+NLOG
    numtype(i)=str2num(cell2mat(type(i)));
end
INPUT=[type where];
counti=0;
for i = 1:length(numtype)
    if numtype(i)==0||numtype(i)==3||numtype(i)==4||numtype(i)==11
        counti=counti+1;
        INPUT034(counti,:)=INPUT(i,:);
    end
end
for i = 1:NLOG
    counti=counti+1;
    INPUT034(counti,1)=num2cell(11);
    INPUT034(counti,2)=LOGwhere2(i);
end
uINPUT034=unique(INPUT034(:,2));
% counti=0;
% INPUT11=[];
% for i = 1:NLOG
%     counti=counti+1;
%     INPUT11(counti,1)=num2cell(11);
%     INPUT11(counti,2)=LOGwhere2(i);
% end
% uINPUT11=unique(INPUT11(:,2));
FLOYDD=Inf(NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034));
FLOYDD=-FLOYDD;
for i=1:NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034)
    for j=1:NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034)
        FLOYDR(i,j)=j;
    end 
end
fcal=[1,2,5,6,7,8,9,10];
fcalline=[length(uINPUT034),length(uINPUT034)+NADD,length(uINPUT034)+NADD+NMUL,length(uINPUT034)+NADD+NMUL+NDIV,...
    length(uINPUT034)+NADD+NMUL+NDIV+NSIN,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS,...
    length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT];
%a=strfind(cellstr(uINPUT034),cellstr(DIVwhere2(1)))
branch=0;

for i = 1 : NADD
    if str2num(cell2mat(ADDtype1(i))) == 0||str2num(cell2mat(ADDtype1(i))) == 3||str2num(cell2mat(ADDtype1(i))) == 4||str2num(cell2mat(ADDtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(ADDwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+i)=dadd; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(ADDtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(ADDwhere1(i))),fcalline(1)+i)=dadd; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NADD
    if str2num(cell2mat(ADDtype2(i))) == 0||str2num(cell2mat(ADDtype2(i))) == 3||str2num(cell2mat(ADDtype2(i))) == 4||str2num(cell2mat(ADDtype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(ADDwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+i)=dadd; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(ADDtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(ADDwhere1(i))),fcalline(1)+i)=dadd; 
            end
        end
        for kk=1:length(fcal)
            if str2num(cell2mat(ADDtype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(ADDwhere2(i))),fcalline(1)+i)=dadd; 
            end
        end
        branch=branch+1;
    end
end  
for i = 1 : NMUL
    if str2num(cell2mat(MULtype1(i))) == 0||str2num(cell2mat(MULtype1(i))) == 3||str2num(cell2mat(MULtype1(i))) == 4||str2num(cell2mat(MULtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(MULwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+i)=dmul; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(MULtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(MULwhere1(i))),fcalline(2)+i)=dmul; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NMUL
    if str2num(cell2mat(MULtype2(i))) == 0||str2num(cell2mat(MULtype2(i))) == 3||str2num(cell2mat(MULtype2(i))) == 4||str2num(cell2mat(MULtype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(MULwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+i)=dmul; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(MULtype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(MULwhere2(i))),fcalline(2)+i)=dmul; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NDIV
    if str2num(cell2mat(DIVtype1(i))) == 0||str2num(cell2mat(DIVtype1(i))) == 3||str2num(cell2mat(DIVtype1(i))) == 4||str2num(cell2mat(DIVtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(DIVwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+i)=ddiv; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(DIVtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(DIVwhere1(i))),fcalline(3)+i)=ddiv; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NDIV
    if str2num(cell2mat(DIVtype2(i))) == 0||str2num(cell2mat(DIVtype2(i))) == 3||str2num(cell2mat(DIVtype2(i))) == 4||str2num(cell2mat(DIVtype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(DIVwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+i)=ddiv; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(DIVtype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(DIVwhere2(i))),fcalline(3)+i)=ddiv; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NSIN
    if str2num(cell2mat(SINtype1(i))) == 0||str2num(cell2mat(SINtype1(i))) == 3||str2num(cell2mat(SINtype1(i))) == 4||str2num(cell2mat(SINtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(SINwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+i)=dsin; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(SINtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(SINwhere1(i))),fcalline(4)+i)=dsin; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NSIN
    if str2num(cell2mat(SINtype2(i))) == 0||str2num(cell2mat(SINtype2(i))) == 3||str2num(cell2mat(SINtype2(i))) == 4||str2num(cell2mat(SINtype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(SINwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+i)=dsin; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(SINtype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(SINwhere2(i))),fcalline(4)+i)=dsin; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NSIN
    if str2num(cell2mat(SINtype3(i))) == 0||str2num(cell2mat(SINtype3(i))) == 3||str2num(cell2mat(SINtype3(i))) == 4||str2num(cell2mat(SINtype3(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(SINwhere3(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+i)=dsin; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(SINtype3(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(SINwhere3(i))),fcalline(4)+i)=dsin; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NCOS
    if str2num(cell2mat(COStype1(i))) == 0||str2num(cell2mat(COStype1(i))) == 3||str2num(cell2mat(COStype1(i))) == 4||str2num(cell2mat(COStype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(COSwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+i)=dcos; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(COStype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(COSwhere1(i))),fcalline(5)+i)=dcos; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NCOS
    if str2num(cell2mat(COStype2(i))) == 0||str2num(cell2mat(COStype2(i))) == 3||str2num(cell2mat(COStype2(i))) == 4||str2num(cell2mat(COStype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(COSwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+i)=dcos; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(COStype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(COSwhere2(i))),fcalline(5)+i)=dcos; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NCOS
    if str2num(cell2mat(COStype3(i))) == 0||str2num(cell2mat(COStype3(i))) == 3||str2num(cell2mat(COStype3(i))) == 4||str2num(cell2mat(COStype3(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(COSwhere3(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+i)=dcos; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(COStype3(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(COSwhere3(i))),fcalline(5)+i)=dcos; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NCOMPARE
    if str2num(cell2mat(COMPAREtype1(i))) == 0||str2num(cell2mat(COMPAREtype1(i))) == 3||str2num(cell2mat(COMPAREtype1(i))) == 4||str2num(cell2mat(COMPAREtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(COMPAREwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+i)=dcompare; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(COMPAREtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(COMPAREwhere1(i))),fcalline(6)+i)=dcompare; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NCOMPARE
    if str2num(cell2mat(COMPAREtype2(i))) == 0||str2num(cell2mat(COMPAREtype2(i))) == 3||str2num(cell2mat(COMPAREtype2(i))) == 4||str2num(cell2mat(COMPAREtype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(COMPAREwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+i)=dcompare; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(COMPAREtype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(COMPAREwhere2(i))),fcalline(6)+i)=dcompare; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NLIMIT
    if str2num(cell2mat(LIMITtype1(i))) == 0||str2num(cell2mat(LIMITtype1(i))) == 3||str2num(cell2mat(LIMITtype1(i))) == 4||str2num(cell2mat(LIMITtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(LIMITwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+i)=dlimit; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(LIMITtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(LIMITwhere1(i))),fcalline(7)+i)=dlimit; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NLIMIT
    if str2num(cell2mat(LIMITtype2(i))) == 0||str2num(cell2mat(LIMITtype2(i))) == 3||str2num(cell2mat(LIMITtype2(i))) == 4||str2num(cell2mat(LIMITtype2(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(LIMITwhere2(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+i)=dlimit; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(LIMITtype2(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(LIMITwhere2(i))),fcalline(7)+i)=dlimit; 
            end
        end 
        branch=branch+1;
    end
end
for i = 1 : NLIMIT
    if str2num(cell2mat(LIMITtype3(i))) == 0||str2num(cell2mat(LIMITtype3(i))) == 3||str2num(cell2mat(LIMITtype3(i))) == 4||str2num(cell2mat(LIMITtype3(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(LIMITwhere3(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+i)=dlimit; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(LIMITtype3(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(LIMITwhere3(i))),fcalline(7)+i)=dlimit; 
            end
        end 
        branch=branch+1;
    end
end
for i = 1 : NEXP
    if str2num(cell2mat(EXPtype1(i))) == 0||str2num(cell2mat(EXPtype1(i))) == 3||str2num(cell2mat(EXPtype1(i))) == 4||str2num(cell2mat(EXPtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(EXPwhere1(i)))==1
               FLOYDD(j,length(uINPUT034)+NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+i)=dexp; 
            end
        end
    else
        for kk=1:length(fcal)
            if str2num(cell2mat(EXPtype1(i))) == fcal(kk)
                FLOYDD(fcalline(kk)+str2num(cell2mat(EXPwhere1(i))),fcalline(8)+i)=dexp; 
            end
        end
        branch=branch+1;
    end
end
for i = 1 : NLOG
    if str2num(cell2mat(LOGtype1(i))) == 0||str2num(cell2mat(LOGtype1(i))) == 3||str2num(cell2mat(LOGtype1(i))) == 4||str2num(cell2mat(LOGtype1(i))) == 11
        for j = 1 :length(uINPUT034)
            if strcmp(cellstr(uINPUT034(j)),cellstr(LOGwhere1(i)))==1
				for k = 1 :length(uINPUT034)
					if strcmp(cellstr(uINPUT034(k)),cellstr(LOGwhere2(1)))==1
					   FLOYDD(j,k)=str2num(cell2mat(LOGtime(i))); 
					end
				end
            end
        end
    else
		for k = 1 :length(uINPUT034)
			if strcmp(cellstr(uINPUT034(k)),cellstr(LOGwhere2(i)))==1
                for kk=1:length(fcal)
                    if str2num(cell2mat(LOGtype1(i))) == fcal(kk)
                        FLOYDD(fcalline(kk)+str2num(cell2mat(LOGwhere1(i))),k)=str2num(cell2mat(LOGtime(i))); 
                    end
                end
			end
        end
        branch=branch+1;
    end
end
for k=1:NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034)
    for i=1:NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034)
        for j=1:NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034)
            if FLOYDD(i,k)+FLOYDD(k,j)>FLOYDD(i,j)
                FLOYDD(i,j)=FLOYDD(i,k)+FLOYDD(k,j);
                FLOYDR(i,j)=FLOYDR(i,k);
            end 
        end 
    end
end
maxFLOYDD=max(max(FLOYDD));
[maxx,maxy]=find(FLOYDD==max(max(FLOYDD)));
nflo=0;
while 1
    if(FLOYDR(maxx(1), maxy(1)) ~= maxy(1))
      maxx(1) = FLOYDR(maxx(1), maxy(1));
      nflo=nflo+1;
      if nflo == 10000
          error('控制系统存在环路，需要手动解环');
      end
    else
      break;
    end
end
if maxy(1)>length(uINPUT034)&&maxy(1)<=NADD+length(uINPUT034)
    lastd=dadd;
elseif maxy(1)>NADD+length(uINPUT034)&&maxy(1)<=NADD+NMUL+length(uINPUT034)
    lastd=dmul;
elseif maxy(1)>NADD+NMUL+length(uINPUT034)&&maxy(1)<=NADD+NMUL+NDIV+length(uINPUT034)
    lastd=ddiv;
elseif maxy(1)>NADD+NMUL+NDIV+length(uINPUT034)&&maxy(1)<=NADD+NMUL+NDIV+NSIN+length(uINPUT034)
    lastd=dsin;
elseif maxy(1)>NADD+NMUL+NDIV+NSIN+length(uINPUT034)&&maxy(1)<=NADD+NMUL+NDIV+NSIN+NCOS+length(uINPUT034)
    lastd=dcos;
elseif maxy(1)>NADD+NMUL+NDIV+NSIN+NCOS+length(uINPUT034)&&maxy(1)<=NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+length(uINPUT034)
    lastd=dcompare;
elseif maxy(1)>NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+length(uINPUT034)&&maxy(1)<=NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+length(uINPUT034)
    lastd=dlimit;
elseif maxy(1)>NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+length(uINPUT034)&&maxy(1)<=NADD+NMUL+NDIV+NSIN+NCOS+NCOMPARE+NLIMIT+NEXP+length(uINPUT034)
    lastd=dexp;
else
    lastd=dloglast;
end
TMIN=maxFLOYDD+datadelay+tc+1-lastd;
distmin= '最短时间';
disp(distmin)
disp(TMIN)
ADDSct=binvar(NADD,TMIN,'full');
ADDQct=binvar(NADD,TMIN,'full');
ADDGct=binvar(NADD,TMIN,'full');
ADDTQc=intvar(NADD,1,'full');
ADDTGc=intvar(NADD,1,'full');

ADDq=intvar(NADD,1,'full');
ADDp=intvar(NADD,1,'full');
ADDa=intvar(NADD,1,'full');
ADDb=intvar(NADD,1,'full');
W1=intvar(1,1,'full');
MULSct=binvar(NMUL,TMIN,'full');
MULQct=binvar(NMUL,TMIN,'full');
MULGct=binvar(NMUL,TMIN,'full');
MULTQc=intvar(NMUL,1,'full');
MULTGc=intvar(NMUL,1,'full');

MULq=intvar(NMUL,1,'full');
MULp=intvar(NMUL,1,'full');
MULa=intvar(NMUL,1,'full');
MULb=intvar(NMUL,1,'full');
W2=intvar(1,1,'full');
DIVSct=binvar(NDIV,TMIN,'full');
DIVQct=binvar(NDIV,TMIN,'full');
DIVGct=binvar(NDIV,TMIN,'full');
DIVTQc=intvar(NDIV,1,'full');
DIVTGc=intvar(NDIV,1,'full');

DIVq=intvar(NDIV,1,'full');
DIVp=intvar(NDIV,1,'full');
DIVa=intvar(NDIV,1,'full');
DIVb=intvar(NDIV,1,'full');
W3=intvar(1,1,'full');
SINSct=binvar(NSIN,TMIN,'full');
SINQct=binvar(NSIN,TMIN,'full');
SINGct=binvar(NSIN,TMIN,'full');
SINTQc=intvar(NSIN,1,'full');
SINTGc=intvar(NSIN,1,'full');

SINq=intvar(NSIN,1,'full');
SINp=intvar(NSIN,1,'full');
SINa=intvar(NSIN,1,'full');
SINb=intvar(NSIN,1,'full');
W4=intvar(1,1,'full');
COSSct=binvar(NCOS,TMIN,'full');
COSQct=binvar(NCOS,TMIN,'full');
COSGct=binvar(NCOS,TMIN,'full');
COSTQc=intvar(NCOS,1,'full');
COSTGc=intvar(NCOS,1,'full');

COSq=intvar(NCOS,1,'full');
COSp=intvar(NCOS,1,'full');
COSa=intvar(NCOS,1,'full');
COSb=intvar(NCOS,1,'full');
W5=intvar(1,1,'full');
COMPARESct=binvar(NCOMPARE,TMIN,'full');
COMPAREQct=binvar(NCOMPARE,TMIN,'full');
COMPAREGct=binvar(NCOMPARE,TMIN,'full');
COMPARETQc=intvar(NCOMPARE,1,'full');
COMPARETGc=intvar(NCOMPARE,1,'full');

COMPAREq=intvar(NCOMPARE,1,'full');
COMPAREp=intvar(NCOMPARE,1,'full');
COMPAREa=intvar(NCOMPARE,1,'full');
COMPAREb=intvar(NCOMPARE,1,'full');
W6=intvar(1,1,'full');
LIMITSct=binvar(NLIMIT,TMIN,'full');
LIMITQct=binvar(NLIMIT,TMIN,'full');
LIMITGct=binvar(NLIMIT,TMIN,'full');
LIMITTQc=intvar(NLIMIT,1,'full');
LIMITTGc=intvar(NLIMIT,1,'full');

LIMITq=intvar(NLIMIT,1,'full');
LIMITp=intvar(NLIMIT,1,'full');
LIMITa=intvar(NLIMIT,1,'full');
LIMITb=intvar(NLIMIT,1,'full');
W7=intvar(1,1,'full');
EXPSct=binvar(NEXP,TMIN,'full');
EXPQct=binvar(NEXP,TMIN,'full');
EXPGct=binvar(NEXP,TMIN,'full');
EXPTQc=intvar(NEXP,1,'full');
EXPTGc=intvar(NEXP,1,'full');

EXPq=intvar(NEXP,1,'full');
EXPp=intvar(NEXP,1,'full');
EXPa=intvar(NEXP,1,'full');
EXPb=intvar(NEXP,1,'full');
W8=intvar(1,1,'full');
LOGSct=binvar(NLOG,TMIN,'full');
LOGQct=binvar(NLOG,TMIN,'full');
LOGGct=binvar(NLOG,TMIN,'full');
LOGTQc=intvar(NLOG,1,'full');
LOGTGc=intvar(NLOG,1,'full');

LOGq=intvar(NLOG,1,'full');
LOGp=intvar(NLOG,1,'full');
LOGa=intvar(NLOG,1,'full');
LOGb=intvar(NLOG,1,'full');
W9=intvar(1,1,'full');
branchcon=binvar(branch,1,'full');
Cons=[];  
NBR=0;
for i = 1 : NADD
    if str2num(cell2mat(ADDtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(ADDwhere1(i)))==1
                Cons=[Cons,ADDTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(ADDtype1(i))) == 0||str2num(cell2mat(ADDtype1(i))) == 3||str2num(cell2mat(ADDtype1(i))) == 4

    else
        if str2num(cell2mat(ADDtype1(i))) == 1
            Cons=[Cons,ADDTQc(i)>=ADDTQc(str2num(cell2mat(ADDwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(ADDTQc(str2num(cell2mat(ADDwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(ADDTQc(str2num(cell2mat(ADDwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype1(i))) == 2
            Cons=[Cons,ADDTQc(i)>=MULTQc(str2num(cell2mat(ADDwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(MULTQc(str2num(cell2mat(ADDwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(MULTQc(str2num(cell2mat(ADDwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype1(i))) == 5
            Cons=[Cons,ADDTQc(i)>=DIVTQc(str2num(cell2mat(ADDwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(DIVTQc(str2num(cell2mat(ADDwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(DIVTQc(str2num(cell2mat(ADDwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype1(i))) == 6
            Cons=[Cons,ADDTQc(i)>=SINTQc(str2num(cell2mat(ADDwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(SINTQc(str2num(cell2mat(ADDwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(SINTQc(str2num(cell2mat(ADDwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype1(i))) == 7
            Cons=[Cons,ADDTQc(i)>=COSTQc(str2num(cell2mat(ADDwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(COSTQc(str2num(cell2mat(ADDwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(COSTQc(str2num(cell2mat(ADDwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype1(i))) == 8
            Cons=[Cons,ADDTQc(i)>=COMPARETQc(str2num(cell2mat(ADDwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(COMPARETQc(str2num(cell2mat(ADDwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(COMPARETQc(str2num(cell2mat(ADDwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(ADDtype1(i))) == 9
            Cons=[Cons,ADDTQc(i)>=LIMITTQc(str2num(cell2mat(ADDwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(LIMITTQc(str2num(cell2mat(ADDwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(LIMITTQc(str2num(cell2mat(ADDwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(ADDtype1(i))) == 10
            Cons=[Cons,ADDTQc(i)>=EXPTQc(str2num(cell2mat(ADDwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(EXPTQc(str2num(cell2mat(ADDwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(EXPTQc(str2num(cell2mat(ADDwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if str2num(cell2mat(ADDtype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(ADDwhere2(i)))==1
                Cons=[Cons,ADDTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
	if str2num(cell2mat(ADDtype2(i))) == 0||str2num(cell2mat(ADDtype2(i))) == 3||str2num(cell2mat(ADDtype2(i))) == 4

    else
        if str2num(cell2mat(ADDtype2(i))) == 1
            Cons=[Cons,ADDTQc(i)>=ADDTQc(str2num(cell2mat(ADDwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(ADDTQc(str2num(cell2mat(ADDwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(ADDTQc(str2num(cell2mat(ADDwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype2(i))) == 2
            Cons=[Cons,ADDTQc(i)>=MULTQc(str2num(cell2mat(ADDwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(MULTQc(str2num(cell2mat(ADDwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(MULTQc(str2num(cell2mat(ADDwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype2(i))) == 5
            Cons=[Cons,ADDTQc(i)>=DIVTQc(str2num(cell2mat(ADDwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(DIVTQc(str2num(cell2mat(ADDwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(DIVTQc(str2num(cell2mat(ADDwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype2(i))) == 6
            Cons=[Cons,ADDTQc(i)>=SINTQc(str2num(cell2mat(ADDwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(SINTQc(str2num(cell2mat(ADDwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(SINTQc(str2num(cell2mat(ADDwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype2(i))) == 7
            Cons=[Cons,ADDTQc(i)>=COSTQc(str2num(cell2mat(ADDwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(COSTQc(str2num(cell2mat(ADDwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(COSTQc(str2num(cell2mat(ADDwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(ADDtype2(i))) == 8
            Cons=[Cons,ADDTQc(i)>=COMPARETQc(str2num(cell2mat(ADDwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(COMPARETQc(str2num(cell2mat(ADDwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(COMPARETQc(str2num(cell2mat(ADDwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(ADDtype2(i))) == 9
            Cons=[Cons,ADDTQc(i)>=LIMITTQc(str2num(cell2mat(ADDwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(LIMITTQc(str2num(cell2mat(ADDwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(LIMITTQc(str2num(cell2mat(ADDwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(ADDtype2(i))) == 10
            Cons=[Cons,ADDTQc(i)>=EXPTQc(str2num(cell2mat(ADDwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,ADDTQc(i)-(EXPTQc(str2num(cell2mat(ADDwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,ADDTQc(i)-(EXPTQc(str2num(cell2mat(ADDwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(ADDtype2(i))) == 0||str2num(cell2mat(ADDtype2(i))) == 3||str2num(cell2mat(ADDtype2(i))) == 4)&&(str2num(cell2mat(ADDtype1(i))) == 0||str2num(cell2mat(ADDtype1(i))) == 3||str2num(cell2mat(ADDtype1(i))) == 4)
        Cons=[Cons,ADDTQc(i)>=datadelay+1];
    end
end
distcn= 'addover';
disp(distcn)
for i = 1 : NMUL
    if str2num(cell2mat(MULtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(MULwhere1(i)))==1
                Cons=[Cons,MULTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(MULtype1(i))) == 0||str2num(cell2mat(MULtype1(i))) == 3||str2num(cell2mat(MULtype1(i))) == 4

    else
        if str2num(cell2mat(MULtype1(i))) == 1
            Cons=[Cons,MULTQc(i)>=ADDTQc(str2num(cell2mat(MULwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(ADDTQc(str2num(cell2mat(MULwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(ADDTQc(str2num(cell2mat(MULwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype1(i))) == 2
            Cons=[Cons,MULTQc(i)>=MULTQc(str2num(cell2mat(MULwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(MULTQc(str2num(cell2mat(MULwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(MULTQc(str2num(cell2mat(MULwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype1(i))) == 5
            Cons=[Cons,MULTQc(i)>=DIVTQc(str2num(cell2mat(MULwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(DIVTQc(str2num(cell2mat(MULwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(DIVTQc(str2num(cell2mat(MULwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype1(i))) == 6
            Cons=[Cons,MULTQc(i)>=SINTQc(str2num(cell2mat(MULwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(SINTQc(str2num(cell2mat(MULwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(SINTQc(str2num(cell2mat(MULwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype1(i))) == 7
            Cons=[Cons,MULTQc(i)>=COSTQc(str2num(cell2mat(MULwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(COSTQc(str2num(cell2mat(MULwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(COSTQc(str2num(cell2mat(MULwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype1(i))) == 8
            Cons=[Cons,MULTQc(i)>=COMPARETQc(str2num(cell2mat(MULwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(COMPARETQc(str2num(cell2mat(MULwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(COMPARETQc(str2num(cell2mat(MULwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(MULtype1(i))) == 9
            Cons=[Cons,MULTQc(i)>=LIMITTQc(str2num(cell2mat(MULwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(LIMITTQc(str2num(cell2mat(MULwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(LIMITTQc(str2num(cell2mat(MULwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(MULtype1(i))) == 10
            Cons=[Cons,MULTQc(i)>=EXPTQc(str2num(cell2mat(MULwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(EXPTQc(str2num(cell2mat(MULwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(EXPTQc(str2num(cell2mat(MULwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if str2num(cell2mat(MULtype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(MULwhere2(i)))==1
                Cons=[Cons,MULTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
	if str2num(cell2mat(MULtype2(i))) == 0||str2num(cell2mat(MULtype2(i))) == 3||str2num(cell2mat(MULtype2(i))) == 4

    else
        if str2num(cell2mat(MULtype2(i))) == 1
            Cons=[Cons,MULTQc(i)>=ADDTQc(str2num(cell2mat(MULwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(ADDTQc(str2num(cell2mat(MULwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(ADDTQc(str2num(cell2mat(MULwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype2(i))) == 2
            Cons=[Cons,MULTQc(i)>=MULTQc(str2num(cell2mat(MULwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(MULTQc(str2num(cell2mat(MULwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(MULTQc(str2num(cell2mat(MULwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype2(i))) == 5
            Cons=[Cons,MULTQc(i)>=DIVTQc(str2num(cell2mat(MULwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(DIVTQc(str2num(cell2mat(MULwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(DIVTQc(str2num(cell2mat(MULwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype2(i))) == 6
            Cons=[Cons,MULTQc(i)>=SINTQc(str2num(cell2mat(MULwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(SINTQc(str2num(cell2mat(MULwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(SINTQc(str2num(cell2mat(MULwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype2(i))) == 7
            Cons=[Cons,MULTQc(i)>=COSTQc(str2num(cell2mat(MULwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(COSTQc(str2num(cell2mat(MULwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(COSTQc(str2num(cell2mat(MULwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(MULtype2(i))) == 8
            Cons=[Cons,MULTQc(i)>=COMPARETQc(str2num(cell2mat(MULwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(COMPARETQc(str2num(cell2mat(MULwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(COMPARETQc(str2num(cell2mat(MULwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(MULtype2(i))) == 9
            Cons=[Cons,MULTQc(i)>=LIMITTQc(str2num(cell2mat(MULwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(LIMITTQc(str2num(cell2mat(MULwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(LIMITTQc(str2num(cell2mat(MULwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(MULtype2(i))) == 10
            Cons=[Cons,MULTQc(i)>=EXPTQc(str2num(cell2mat(MULwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,MULTQc(i)-(EXPTQc(str2num(cell2mat(MULwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,MULTQc(i)-(EXPTQc(str2num(cell2mat(MULwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(MULtype2(i))) == 0||str2num(cell2mat(MULtype2(i))) == 3||str2num(cell2mat(MULtype2(i))) == 4)&&(str2num(cell2mat(MULtype1(i))) == 0||str2num(cell2mat(MULtype1(i))) == 3||str2num(cell2mat(MULtype1(i))) == 4)
        Cons=[Cons,MULTQc(i)>=datadelay+1];
    end
end
distcn= 'mulover';
disp(distcn)
for i = 1 : NDIV
    if str2num(cell2mat(DIVtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(DIVwhere1(i)))==1
                Cons=[Cons,DIVTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(DIVtype1(i))) == 0||str2num(cell2mat(DIVtype1(i))) == 3||str2num(cell2mat(DIVtype1(i))) == 4

    else
        if str2num(cell2mat(DIVtype1(i))) == 1
            Cons=[Cons,DIVTQc(i)>=ADDTQc(str2num(cell2mat(DIVwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(ADDTQc(str2num(cell2mat(DIVwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(ADDTQc(str2num(cell2mat(DIVwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype1(i))) == 2
            Cons=[Cons,DIVTQc(i)>=MULTQc(str2num(cell2mat(DIVwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(MULTQc(str2num(cell2mat(DIVwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(MULTQc(str2num(cell2mat(DIVwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype1(i))) == 5
            Cons=[Cons,DIVTQc(i)>=DIVTQc(str2num(cell2mat(DIVwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(DIVTQc(str2num(cell2mat(DIVwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(DIVTQc(str2num(cell2mat(DIVwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype1(i))) == 6
            Cons=[Cons,DIVTQc(i)>=SINTQc(str2num(cell2mat(DIVwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(SINTQc(str2num(cell2mat(DIVwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(SINTQc(str2num(cell2mat(DIVwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype1(i))) == 7
            Cons=[Cons,DIVTQc(i)>=COSTQc(str2num(cell2mat(DIVwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(COSTQc(str2num(cell2mat(DIVwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(COSTQc(str2num(cell2mat(DIVwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype1(i))) == 8
            Cons=[Cons,DIVTQc(i)>=COMPARETQc(str2num(cell2mat(DIVwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(COMPARETQc(str2num(cell2mat(DIVwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(COMPARETQc(str2num(cell2mat(DIVwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(DIVtype1(i))) == 9
            Cons=[Cons,DIVTQc(i)>=LIMITTQc(str2num(cell2mat(DIVwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(LIMITTQc(str2num(cell2mat(DIVwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(LIMITTQc(str2num(cell2mat(DIVwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(DIVtype1(i))) == 10
            Cons=[Cons,DIVTQc(i)>=EXPTQc(str2num(cell2mat(DIVwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(EXPTQc(str2num(cell2mat(DIVwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(EXPTQc(str2num(cell2mat(DIVwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if str2num(cell2mat(DIVtype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(DIVwhere2(i)))==1
                Cons=[Cons,DIVTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
	if str2num(cell2mat(DIVtype2(i))) == 0||str2num(cell2mat(DIVtype2(i))) == 3||str2num(cell2mat(DIVtype2(i))) == 4

    else
        if str2num(cell2mat(DIVtype2(i))) == 1
            Cons=[Cons,DIVTQc(i)>=ADDTQc(str2num(cell2mat(DIVwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(ADDTQc(str2num(cell2mat(DIVwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(ADDTQc(str2num(cell2mat(DIVwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype2(i))) == 2
            Cons=[Cons,DIVTQc(i)>=MULTQc(str2num(cell2mat(DIVwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(MULTQc(str2num(cell2mat(DIVwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(MULTQc(str2num(cell2mat(DIVwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype2(i))) == 5
            Cons=[Cons,DIVTQc(i)>=DIVTQc(str2num(cell2mat(DIVwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(DIVTQc(str2num(cell2mat(DIVwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(DIVTQc(str2num(cell2mat(DIVwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype2(i))) == 6
            Cons=[Cons,DIVTQc(i)>=SINTQc(str2num(cell2mat(DIVwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(SINTQc(str2num(cell2mat(DIVwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(SINTQc(str2num(cell2mat(DIVwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype2(i))) == 7
            Cons=[Cons,DIVTQc(i)>=COSTQc(str2num(cell2mat(DIVwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(COSTQc(str2num(cell2mat(DIVwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(COSTQc(str2num(cell2mat(DIVwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(DIVtype2(i))) == 8
            Cons=[Cons,DIVTQc(i)>=COMPARETQc(str2num(cell2mat(DIVwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(COMPARETQc(str2num(cell2mat(DIVwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(COMPARETQc(str2num(cell2mat(DIVwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(DIVtype2(i))) == 9
            Cons=[Cons,DIVTQc(i)>=LIMITTQc(str2num(cell2mat(DIVwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(LIMITTQc(str2num(cell2mat(DIVwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(LIMITTQc(str2num(cell2mat(DIVwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(DIVtype2(i))) == 10
            Cons=[Cons,DIVTQc(i)>=EXPTQc(str2num(cell2mat(DIVwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,DIVTQc(i)-(EXPTQc(str2num(cell2mat(DIVwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,DIVTQc(i)-(EXPTQc(str2num(cell2mat(DIVwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(DIVtype2(i))) == 0||str2num(cell2mat(DIVtype2(i))) == 3||str2num(cell2mat(DIVtype2(i))) == 4)&&(str2num(cell2mat(DIVtype1(i))) == 0||str2num(cell2mat(DIVtype1(i))) == 3||str2num(cell2mat(DIVtype1(i))) == 4)
        Cons=[Cons,DIVTQc(i)>=datadelay+1];
    end
end
distcn= 'divover';
disp(distcn)
for i = 1 : NSIN
    if str2num(cell2mat(SINtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(SINwhere1(i)))==1
                Cons=[Cons,SINTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(SINtype1(i))) == 0||str2num(cell2mat(SINtype1(i))) == 3||str2num(cell2mat(SINtype1(i))) == 4
		Cons=[Cons,SINTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(SINtype1(i))) == 1
            Cons=[Cons,SINTQc(i)>=ADDTQc(str2num(cell2mat(SINwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(ADDTQc(str2num(cell2mat(SINwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(ADDTQc(str2num(cell2mat(SINwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype1(i))) == 2
            Cons=[Cons,SINTQc(i)>=MULTQc(str2num(cell2mat(SINwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(MULTQc(str2num(cell2mat(SINwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(MULTQc(str2num(cell2mat(SINwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype1(i))) == 5
            Cons=[Cons,SINTQc(i)>=DIVTQc(str2num(cell2mat(SINwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(DIVTQc(str2num(cell2mat(SINwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(DIVTQc(str2num(cell2mat(SINwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype1(i))) == 6
            Cons=[Cons,SINTQc(i)>=SINTQc(str2num(cell2mat(SINwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(SINTQc(str2num(cell2mat(SINwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(SINTQc(str2num(cell2mat(SINwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype1(i))) == 7
            Cons=[Cons,SINTQc(i)>=COSTQc(str2num(cell2mat(SINwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(COSTQc(str2num(cell2mat(SINwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(COSTQc(str2num(cell2mat(SINwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype1(i))) == 8
            Cons=[Cons,SINTQc(i)>=COMPARETQc(str2num(cell2mat(SINwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(COMPARETQc(str2num(cell2mat(SINwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(COMPARETQc(str2num(cell2mat(SINwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(SINtype1(i))) == 9
            Cons=[Cons,SINTQc(i)>=LIMITTQc(str2num(cell2mat(SINwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(LIMITTQc(str2num(cell2mat(SINwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(LIMITTQc(str2num(cell2mat(SINwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(SINtype1(i))) == 10
            Cons=[Cons,SINTQc(i)>=EXPTQc(str2num(cell2mat(SINwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(EXPTQc(str2num(cell2mat(SINwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(EXPTQc(str2num(cell2mat(SINwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if str2num(cell2mat(SINtype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(SINwhere2(i)))==1
                Cons=[Cons,SINTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(SINtype2(i))) == 0||str2num(cell2mat(SINtype2(i))) == 3||str2num(cell2mat(SINtype2(i))) == 4
		Cons=[Cons,SINTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(SINtype2(i))) == 1
            Cons=[Cons,SINTQc(i)>=ADDTQc(str2num(cell2mat(SINwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(ADDTQc(str2num(cell2mat(SINwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(ADDTQc(str2num(cell2mat(SINwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype2(i))) == 2
            Cons=[Cons,SINTQc(i)>=MULTQc(str2num(cell2mat(SINwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(MULTQc(str2num(cell2mat(SINwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(MULTQc(str2num(cell2mat(SINwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype2(i))) == 5
            Cons=[Cons,SINTQc(i)>=DIVTQc(str2num(cell2mat(SINwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(DIVTQc(str2num(cell2mat(SINwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(DIVTQc(str2num(cell2mat(SINwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype2(i))) == 6
            Cons=[Cons,SINTQc(i)>=SINTQc(str2num(cell2mat(SINwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(SINTQc(str2num(cell2mat(SINwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(SINTQc(str2num(cell2mat(SINwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype2(i))) == 7
            Cons=[Cons,SINTQc(i)>=COSTQc(str2num(cell2mat(SINwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(COSTQc(str2num(cell2mat(SINwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(COSTQc(str2num(cell2mat(SINwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype2(i))) == 8
            Cons=[Cons,SINTQc(i)>=COMPARETQc(str2num(cell2mat(SINwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(COMPARETQc(str2num(cell2mat(SINwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(COMPARETQc(str2num(cell2mat(SINwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(SINtype2(i))) == 9
            Cons=[Cons,SINTQc(i)>=LIMITTQc(str2num(cell2mat(SINwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(LIMITTQc(str2num(cell2mat(SINwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(LIMITTQc(str2num(cell2mat(SINwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(SINtype2(i))) == 10
            Cons=[Cons,SINTQc(i)>=EXPTQc(str2num(cell2mat(SINwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(EXPTQc(str2num(cell2mat(SINwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(EXPTQc(str2num(cell2mat(SINwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if str2num(cell2mat(SINtype3(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(SINwhere3(i)))==1
                Cons=[Cons,SINTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(SINtype3(i))) == 0||str2num(cell2mat(SINtype3(i))) == 3||str2num(cell2mat(SINtype3(i))) == 4
		Cons=[Cons,SINTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(SINtype3(i))) == 1
            Cons=[Cons,SINTQc(i)>=ADDTQc(str2num(cell2mat(SINwhere3(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(ADDTQc(str2num(cell2mat(SINwhere3(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(ADDTQc(str2num(cell2mat(SINwhere3(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype3(i))) == 2
            Cons=[Cons,SINTQc(i)>=MULTQc(str2num(cell2mat(SINwhere3(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(MULTQc(str2num(cell2mat(SINwhere3(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(MULTQc(str2num(cell2mat(SINwhere3(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype3(i))) == 5
            Cons=[Cons,SINTQc(i)>=DIVTQc(str2num(cell2mat(SINwhere3(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(DIVTQc(str2num(cell2mat(SINwhere3(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(DIVTQc(str2num(cell2mat(SINwhere3(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype3(i))) == 6
            Cons=[Cons,SINTQc(i)>=SINTQc(str2num(cell2mat(SINwhere3(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(SINTQc(str2num(cell2mat(SINwhere3(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(SINTQc(str2num(cell2mat(SINwhere3(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype3(i))) == 7
            Cons=[Cons,SINTQc(i)>=COSTQc(str2num(cell2mat(SINwhere3(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(COSTQc(str2num(cell2mat(SINwhere3(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(COSTQc(str2num(cell2mat(SINwhere3(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(SINtype3(i))) == 8
            Cons=[Cons,SINTQc(i)>=COMPARETQc(str2num(cell2mat(SINwhere3(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(COMPARETQc(str2num(cell2mat(SINwhere3(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(COMPARETQc(str2num(cell2mat(SINwhere3(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(SINtype3(i))) == 9
            Cons=[Cons,SINTQc(i)>=LIMITTQc(str2num(cell2mat(SINwhere3(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(LIMITTQc(str2num(cell2mat(SINwhere3(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(LIMITTQc(str2num(cell2mat(SINwhere3(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(SINtype3(i))) == 10
            Cons=[Cons,SINTQc(i)>=EXPTQc(str2num(cell2mat(SINwhere3(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,SINTQc(i)-(EXPTQc(str2num(cell2mat(SINwhere3(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,SINTQc(i)-(EXPTQc(str2num(cell2mat(SINwhere3(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(SINtype3(i))) == 0||str2num(cell2mat(SINtype3(i))) == 3||str2num(cell2mat(SINtype3(i))) == 4)&&(str2num(cell2mat(SINtype2(i))) == 0||str2num(cell2mat(SINtype2(i))) == 3||str2num(cell2mat(SINtype2(i))) == 4)&&(str2num(cell2mat(SINtype1(i))) == 0||str2num(cell2mat(SINtype1(i))) == 3||str2num(cell2mat(SINtype1(i))) == 4)
        Cons=[Cons,MULTQc(i)>=datadelay+1];
    end
end
distcn= 'sinover';
disp(distcn)
for i = 1 : NCOS
    if str2num(cell2mat(COStype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(COSwhere1(i)))==1
                Cons=[Cons,COSTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(COStype1(i))) == 0||str2num(cell2mat(COStype1(i))) == 3||str2num(cell2mat(COStype1(i))) == 4
		Cons=[Cons,COSTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(COStype1(i))) == 1
            Cons=[Cons,COSTQc(i)>=ADDTQc(str2num(cell2mat(COSwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(ADDTQc(str2num(cell2mat(COSwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(ADDTQc(str2num(cell2mat(COSwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype1(i))) == 2
            Cons=[Cons,COSTQc(i)>=MULTQc(str2num(cell2mat(COSwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(MULTQc(str2num(cell2mat(COSwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(MULTQc(str2num(cell2mat(COSwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype1(i))) == 5
            Cons=[Cons,COSTQc(i)>=DIVTQc(str2num(cell2mat(COSwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(DIVTQc(str2num(cell2mat(COSwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(DIVTQc(str2num(cell2mat(COSwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype1(i))) == 6
            Cons=[Cons,COSTQc(i)>=SINTQc(str2num(cell2mat(COSwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(SINTQc(str2num(cell2mat(COSwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(SINTQc(str2num(cell2mat(COSwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype1(i))) == 7
            Cons=[Cons,COSTQc(i)>=COSTQc(str2num(cell2mat(COSwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(COSTQc(str2num(cell2mat(COSwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(COSTQc(str2num(cell2mat(COSwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype1(i))) == 8
            Cons=[Cons,COSTQc(i)>=COMPARETQc(str2num(cell2mat(COSwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(COMPARETQc(str2num(cell2mat(COSwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(COMPARETQc(str2num(cell2mat(COSwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COStype1(i))) == 9
            Cons=[Cons,COSTQc(i)>=LIMITTQc(str2num(cell2mat(COSwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(LIMITTQc(str2num(cell2mat(COSwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(LIMITTQc(str2num(cell2mat(COSwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COStype1(i))) == 10
            Cons=[Cons,COSTQc(i)>=EXPTQc(str2num(cell2mat(COSwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(EXPTQc(str2num(cell2mat(COSwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(EXPTQc(str2num(cell2mat(COSwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if str2num(cell2mat(COStype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(COSwhere2(i)))==1
                Cons=[Cons,COSTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(COStype2(i))) == 0||str2num(cell2mat(COStype2(i))) == 3||str2num(cell2mat(COStype2(i))) == 4
		Cons=[Cons,COSTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(COStype2(i))) == 1
            Cons=[Cons,COSTQc(i)>=ADDTQc(str2num(cell2mat(COSwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(ADDTQc(str2num(cell2mat(COSwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(ADDTQc(str2num(cell2mat(COSwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype2(i))) == 2
            Cons=[Cons,COSTQc(i)>=MULTQc(str2num(cell2mat(COSwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(MULTQc(str2num(cell2mat(COSwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(MULTQc(str2num(cell2mat(COSwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype2(i))) == 5
            Cons=[Cons,COSTQc(i)>=DIVTQc(str2num(cell2mat(COSwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(DIVTQc(str2num(cell2mat(COSwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(DIVTQc(str2num(cell2mat(COSwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype2(i))) == 6
            Cons=[Cons,COSTQc(i)>=SINTQc(str2num(cell2mat(COSwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(SINTQc(str2num(cell2mat(COSwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(SINTQc(str2num(cell2mat(COSwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype2(i))) == 7
            Cons=[Cons,COSTQc(i)>=COSTQc(str2num(cell2mat(COSwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(COSTQc(str2num(cell2mat(COSwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(COSTQc(str2num(cell2mat(COSwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype2(i))) == 8
            Cons=[Cons,COSTQc(i)>=COMPARETQc(str2num(cell2mat(COSwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(COMPARETQc(str2num(cell2mat(COSwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(COMPARETQc(str2num(cell2mat(COSwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COStype2(i))) == 9
            Cons=[Cons,COSTQc(i)>=LIMITTQc(str2num(cell2mat(COSwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(LIMITTQc(str2num(cell2mat(COSwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(LIMITTQc(str2num(cell2mat(COSwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COStype2(i))) == 10
            Cons=[Cons,COSTQc(i)>=EXPTQc(str2num(cell2mat(COSwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(EXPTQc(str2num(cell2mat(COSwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(EXPTQc(str2num(cell2mat(COSwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if str2num(cell2mat(COStype3(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(COSwhere3(i)))==1
                Cons=[Cons,COSTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(COStype3(i))) == 0||str2num(cell2mat(COStype3(i))) == 3||str2num(cell2mat(COStype3(i))) == 4
		Cons=[Cons,COSTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(COStype3(i))) == 1
            Cons=[Cons,COSTQc(i)>=ADDTQc(str2num(cell2mat(COSwhere3(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(ADDTQc(str2num(cell2mat(COSwhere3(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(ADDTQc(str2num(cell2mat(COSwhere3(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype3(i))) == 2
            Cons=[Cons,COSTQc(i)>=MULTQc(str2num(cell2mat(COSwhere3(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(MULTQc(str2num(cell2mat(COSwhere3(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(MULTQc(str2num(cell2mat(COSwhere3(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype3(i))) == 5
            Cons=[Cons,COSTQc(i)>=DIVTQc(str2num(cell2mat(COSwhere3(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(DIVTQc(str2num(cell2mat(COSwhere3(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(DIVTQc(str2num(cell2mat(COSwhere3(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype3(i))) == 6
            Cons=[Cons,COSTQc(i)>=SINTQc(str2num(cell2mat(COSwhere3(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(SINTQc(str2num(cell2mat(COSwhere3(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(SINTQc(str2num(cell2mat(COSwhere3(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype3(i))) == 7
            Cons=[Cons,COSTQc(i)>=COSTQc(str2num(cell2mat(COSwhere3(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(COSTQc(str2num(cell2mat(COSwhere3(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(COSTQc(str2num(cell2mat(COSwhere3(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COStype3(i))) == 8
            Cons=[Cons,COSTQc(i)>=COMPARETQc(str2num(cell2mat(COSwhere3(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(COMPARETQc(str2num(cell2mat(COSwhere3(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(COMPARETQc(str2num(cell2mat(COSwhere3(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COStype3(i))) == 9
            Cons=[Cons,COSTQc(i)>=LIMITTQc(str2num(cell2mat(COSwhere3(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(LIMITTQc(str2num(cell2mat(COSwhere3(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(LIMITTQc(str2num(cell2mat(COSwhere3(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COStype3(i))) == 10
            Cons=[Cons,COSTQc(i)>=EXPTQc(str2num(cell2mat(COSwhere3(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,COSTQc(i)-(EXPTQc(str2num(cell2mat(COSwhere3(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,COSTQc(i)-(EXPTQc(str2num(cell2mat(COSwhere3(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(COStype3(i))) == 0||str2num(cell2mat(COStype3(i))) == 3||str2num(cell2mat(COStype3(i))) == 4)&&(str2num(cell2mat(COStype2(i))) == 0||str2num(cell2mat(COStype2(i))) == 3||str2num(cell2mat(COStype2(i))) == 4)&&(str2num(cell2mat(COStype1(i))) == 0||str2num(cell2mat(COStype1(i))) == 3||str2num(cell2mat(COStype1(i))) == 4)
        Cons=[Cons,MULTQc(i)>=datadelay+1];
    end
end
distcn= 'cosover';
disp(distcn)
for i = 1 : NCOMPARE
    if str2num(cell2mat(COMPAREtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(COMPAREwhere1(i)))==1
                Cons=[Cons,COMPARETQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(COMPAREtype1(i))) == 0||str2num(cell2mat(COMPAREtype1(i))) == 3||str2num(cell2mat(COMPAREtype1(i))) == 4

    else
        if str2num(cell2mat(COMPAREtype1(i))) == 1
            Cons=[Cons,COMPARETQc(i)>=ADDTQc(str2num(cell2mat(COMPAREwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(ADDTQc(str2num(cell2mat(COMPAREwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(ADDTQc(str2num(cell2mat(COMPAREwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype1(i))) == 2
            Cons=[Cons,COMPARETQc(i)>=MULTQc(str2num(cell2mat(COMPAREwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(MULTQc(str2num(cell2mat(COMPAREwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(MULTQc(str2num(cell2mat(COMPAREwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype1(i))) == 5
            Cons=[Cons,COMPARETQc(i)>=DIVTQc(str2num(cell2mat(COMPAREwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(DIVTQc(str2num(cell2mat(COMPAREwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(DIVTQc(str2num(cell2mat(COMPAREwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype1(i))) == 6
            Cons=[Cons,COMPARETQc(i)>=SINTQc(str2num(cell2mat(COMPAREwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(SINTQc(str2num(cell2mat(COMPAREwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(SINTQc(str2num(cell2mat(COMPAREwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype1(i))) == 7
            Cons=[Cons,COMPARETQc(i)>=COSTQc(str2num(cell2mat(COMPAREwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(COSTQc(str2num(cell2mat(COMPAREwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(COSTQc(str2num(cell2mat(COMPAREwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype1(i))) == 8
            Cons=[Cons,COMPARETQc(i)>=COMPARETQc(str2num(cell2mat(COMPAREwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(COMPARETQc(str2num(cell2mat(COMPAREwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(COMPARETQc(str2num(cell2mat(COMPAREwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COMPAREtype1(i))) == 9
            Cons=[Cons,COMPARETQc(i)>=LIMITTQc(str2num(cell2mat(COMPAREwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(LIMITTQc(str2num(cell2mat(COMPAREwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(LIMITTQc(str2num(cell2mat(COMPAREwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COMPAREtype1(i))) == 10
            Cons=[Cons,COMPARETQc(i)>=EXPTQc(str2num(cell2mat(COMPAREwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(EXPTQc(str2num(cell2mat(COMPAREwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(EXPTQc(str2num(cell2mat(COMPAREwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if str2num(cell2mat(COMPAREtype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(COMPAREwhere2(i)))==1
                Cons=[Cons,COMPARETQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
	if str2num(cell2mat(COMPAREtype2(i))) == 0||str2num(cell2mat(COMPAREtype2(i))) == 3||str2num(cell2mat(COMPAREtype2(i))) == 4

    else
        if str2num(cell2mat(COMPAREtype2(i))) == 1
            Cons=[Cons,COMPARETQc(i)>=ADDTQc(str2num(cell2mat(COMPAREwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(ADDTQc(str2num(cell2mat(COMPAREwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(ADDTQc(str2num(cell2mat(COMPAREwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype2(i))) == 2
            Cons=[Cons,COMPARETQc(i)>=MULTQc(str2num(cell2mat(COMPAREwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(MULTQc(str2num(cell2mat(COMPAREwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(MULTQc(str2num(cell2mat(COMPAREwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype2(i))) == 5
            Cons=[Cons,COMPARETQc(i)>=DIVTQc(str2num(cell2mat(COMPAREwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(DIVTQc(str2num(cell2mat(COMPAREwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(DIVTQc(str2num(cell2mat(COMPAREwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype2(i))) == 6
            Cons=[Cons,COMPARETQc(i)>=SINTQc(str2num(cell2mat(COMPAREwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(SINTQc(str2num(cell2mat(COMPAREwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(SINTQc(str2num(cell2mat(COMPAREwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype2(i))) == 7
            Cons=[Cons,COMPARETQc(i)>=COSTQc(str2num(cell2mat(COMPAREwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(COSTQc(str2num(cell2mat(COMPAREwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(COSTQc(str2num(cell2mat(COMPAREwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(COMPAREtype2(i))) == 8
            Cons=[Cons,COMPARETQc(i)>=COMPARETQc(str2num(cell2mat(COMPAREwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(COMPARETQc(str2num(cell2mat(COMPAREwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(COMPARETQc(str2num(cell2mat(COMPAREwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COMPAREtype2(i))) == 9
            Cons=[Cons,COMPARETQc(i)>=LIMITTQc(str2num(cell2mat(COMPAREwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(LIMITTQc(str2num(cell2mat(COMPAREwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(LIMITTQc(str2num(cell2mat(COMPAREwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(COMPAREtype2(i))) == 10
            Cons=[Cons,COMPARETQc(i)>=EXPTQc(str2num(cell2mat(COMPAREwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,COMPARETQc(i)-(EXPTQc(str2num(cell2mat(COMPAREwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,COMPARETQc(i)-(EXPTQc(str2num(cell2mat(COMPAREwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(COMPAREtype2(i))) == 0||str2num(cell2mat(COMPAREtype2(i))) == 3||str2num(cell2mat(COMPAREtype2(i))) == 4)&&(str2num(cell2mat(COMPAREtype1(i))) == 0||str2num(cell2mat(COMPAREtype1(i))) == 3||str2num(cell2mat(COMPAREtype1(i))) == 4)
        Cons=[Cons,COMPARETQc(i)>=datadelay+1];
    end
end
distcn= 'comover';
disp(distcn)
for i = 1 : NLIMIT
    if str2num(cell2mat(LIMITtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(LIMITwhere1(i)))==1
                Cons=[Cons,LIMITTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(LIMITtype1(i))) == 0||str2num(cell2mat(LIMITtype1(i))) == 3||str2num(cell2mat(LIMITtype1(i))) == 4

    else
        if str2num(cell2mat(LIMITtype1(i))) == 1
            Cons=[Cons,LIMITTQc(i)>=ADDTQc(str2num(cell2mat(LIMITwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(ADDTQc(str2num(cell2mat(LIMITwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(ADDTQc(str2num(cell2mat(LIMITwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype1(i))) == 2
            Cons=[Cons,LIMITTQc(i)>=MULTQc(str2num(cell2mat(LIMITwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(MULTQc(str2num(cell2mat(LIMITwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(MULTQc(str2num(cell2mat(LIMITwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype1(i))) == 5
            Cons=[Cons,LIMITTQc(i)>=DIVTQc(str2num(cell2mat(LIMITwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(DIVTQc(str2num(cell2mat(LIMITwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(DIVTQc(str2num(cell2mat(LIMITwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype1(i))) == 6
            Cons=[Cons,LIMITTQc(i)>=SINTQc(str2num(cell2mat(LIMITwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(SINTQc(str2num(cell2mat(LIMITwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(SINTQc(str2num(cell2mat(LIMITwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype1(i))) == 7
            Cons=[Cons,LIMITTQc(i)>=COSTQc(str2num(cell2mat(LIMITwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(COSTQc(str2num(cell2mat(LIMITwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(COSTQc(str2num(cell2mat(LIMITwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype1(i))) == 8
            Cons=[Cons,LIMITTQc(i)>=COMPARETQc(str2num(cell2mat(LIMITwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(COMPARETQc(str2num(cell2mat(LIMITwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(COMPARETQc(str2num(cell2mat(LIMITwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LIMITtype1(i))) == 9
            Cons=[Cons,LIMITTQc(i)>=LIMITTQc(str2num(cell2mat(LIMITwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(LIMITTQc(str2num(cell2mat(LIMITwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(LIMITTQc(str2num(cell2mat(LIMITwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LIMITtype1(i))) == 10
            Cons=[Cons,LIMITTQc(i)>=EXPTQc(str2num(cell2mat(LIMITwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(EXPTQc(str2num(cell2mat(LIMITwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(EXPTQc(str2num(cell2mat(LIMITwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if str2num(cell2mat(LIMITtype2(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(LIMITwhere2(i)))==1
                Cons=[Cons,LIMITTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
	if str2num(cell2mat(LIMITtype2(i))) == 0||str2num(cell2mat(LIMITtype2(i))) == 3||str2num(cell2mat(LIMITtype2(i))) == 4

    else
        if str2num(cell2mat(LIMITtype2(i))) == 1
            Cons=[Cons,LIMITTQc(i)>=ADDTQc(str2num(cell2mat(LIMITwhere2(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(ADDTQc(str2num(cell2mat(LIMITwhere2(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(ADDTQc(str2num(cell2mat(LIMITwhere2(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype2(i))) == 2
            Cons=[Cons,LIMITTQc(i)>=MULTQc(str2num(cell2mat(LIMITwhere2(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(MULTQc(str2num(cell2mat(LIMITwhere2(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(MULTQc(str2num(cell2mat(LIMITwhere2(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype2(i))) == 5
            Cons=[Cons,LIMITTQc(i)>=DIVTQc(str2num(cell2mat(LIMITwhere2(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(DIVTQc(str2num(cell2mat(LIMITwhere2(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(DIVTQc(str2num(cell2mat(LIMITwhere2(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype2(i))) == 6
            Cons=[Cons,LIMITTQc(i)>=SINTQc(str2num(cell2mat(LIMITwhere2(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(SINTQc(str2num(cell2mat(LIMITwhere2(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(SINTQc(str2num(cell2mat(LIMITwhere2(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype2(i))) == 7
            Cons=[Cons,LIMITTQc(i)>=COSTQc(str2num(cell2mat(LIMITwhere2(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(COSTQc(str2num(cell2mat(LIMITwhere2(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(COSTQc(str2num(cell2mat(LIMITwhere2(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype2(i))) == 8
            Cons=[Cons,LIMITTQc(i)>=COMPARETQc(str2num(cell2mat(LIMITwhere2(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(COMPARETQc(str2num(cell2mat(LIMITwhere2(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(COMPARETQc(str2num(cell2mat(LIMITwhere2(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LIMITtype2(i))) == 9
            Cons=[Cons,LIMITTQc(i)>=LIMITTQc(str2num(cell2mat(LIMITwhere2(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(LIMITTQc(str2num(cell2mat(LIMITwhere2(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(LIMITTQc(str2num(cell2mat(LIMITwhere2(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LIMITtype2(i))) == 10
            Cons=[Cons,LIMITTQc(i)>=EXPTQc(str2num(cell2mat(LIMITwhere2(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(EXPTQc(str2num(cell2mat(LIMITwhere2(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(EXPTQc(str2num(cell2mat(LIMITwhere2(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if str2num(cell2mat(LIMITtype3(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(LIMITwhere3(i)))==1
                Cons=[Cons,LIMITTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(LIMITtype3(i))) == 0||str2num(cell2mat(LIMITtype3(i))) == 3||str2num(cell2mat(LIMITtype3(i))) == 4

    else
        if str2num(cell2mat(LIMITtype3(i))) == 1
            Cons=[Cons,LIMITTQc(i)>=ADDTQc(str2num(cell2mat(LIMITwhere3(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(ADDTQc(str2num(cell2mat(LIMITwhere3(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(ADDTQc(str2num(cell2mat(LIMITwhere3(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype3(i))) == 2
            Cons=[Cons,LIMITTQc(i)>=MULTQc(str2num(cell2mat(LIMITwhere3(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(MULTQc(str2num(cell2mat(LIMITwhere3(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(MULTQc(str2num(cell2mat(LIMITwhere3(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype3(i))) == 5
            Cons=[Cons,LIMITTQc(i)>=DIVTQc(str2num(cell2mat(LIMITwhere3(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(DIVTQc(str2num(cell2mat(LIMITwhere3(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(DIVTQc(str2num(cell2mat(LIMITwhere3(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype3(i))) == 6
            Cons=[Cons,LIMITTQc(i)>=SINTQc(str2num(cell2mat(LIMITwhere3(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(SINTQc(str2num(cell2mat(LIMITwhere3(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(SINTQc(str2num(cell2mat(LIMITwhere3(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype3(i))) == 7
            Cons=[Cons,LIMITTQc(i)>=COSTQc(str2num(cell2mat(LIMITwhere3(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(COSTQc(str2num(cell2mat(LIMITwhere3(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(COSTQc(str2num(cell2mat(LIMITwhere3(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LIMITtype3(i))) == 8
            Cons=[Cons,LIMITTQc(i)>=COMPARETQc(str2num(cell2mat(LIMITwhere3(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(COMPARETQc(str2num(cell2mat(LIMITwhere3(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(COMPARETQc(str2num(cell2mat(LIMITwhere3(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LIMITtype3(i))) == 9
            Cons=[Cons,LIMITTQc(i)>=LIMITTQc(str2num(cell2mat(LIMITwhere3(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(LIMITTQc(str2num(cell2mat(LIMITwhere3(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(LIMITTQc(str2num(cell2mat(LIMITwhere3(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LIMITtype3(i))) == 10
            Cons=[Cons,LIMITTQc(i)>=EXPTQc(str2num(cell2mat(LIMITwhere3(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,LIMITTQc(i)-(EXPTQc(str2num(cell2mat(LIMITwhere3(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,LIMITTQc(i)-(EXPTQc(str2num(cell2mat(LIMITwhere3(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
	if (str2num(cell2mat(LIMITtype2(i))) == 0||str2num(cell2mat(LIMITtype2(i))) == 3||str2num(cell2mat(LIMITtype2(i))) == 4)&&(str2num(cell2mat(LIMITtype1(i))) == 0||str2num(cell2mat(LIMITtype1(i))) == 3||str2num(cell2mat(LIMITtype1(i))) == 4)&&(str2num(cell2mat(LIMITtype3(i))) == 0||str2num(cell2mat(LIMITtype3(i))) == 3||str2num(cell2mat(LIMITtype3(i))) == 4)
        Cons=[Cons,LIMITTQc(i)>=datadelay+1];
    end
end
distcn= 'limover';
disp(distcn)
for i = 1 : NEXP
    if str2num(cell2mat(EXPtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(EXPwhere1(i)))==1
                Cons=[Cons,EXPTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(EXPtype1(i))) == 0||str2num(cell2mat(EXPtype1(i))) == 3||str2num(cell2mat(EXPtype1(i))) == 4
		Cons=[Cons,EXPTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(EXPtype1(i))) == 1
            Cons=[Cons,EXPTQc(i)>=ADDTQc(str2num(cell2mat(EXPwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(ADDTQc(str2num(cell2mat(EXPwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(ADDTQc(str2num(cell2mat(EXPwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(EXPtype1(i))) == 2
            Cons=[Cons,EXPTQc(i)>=MULTQc(str2num(cell2mat(EXPwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(MULTQc(str2num(cell2mat(EXPwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(MULTQc(str2num(cell2mat(EXPwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(EXPtype1(i))) == 5
            Cons=[Cons,EXPTQc(i)>=DIVTQc(str2num(cell2mat(EXPwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(DIVTQc(str2num(cell2mat(EXPwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(DIVTQc(str2num(cell2mat(EXPwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(EXPtype1(i))) == 6
            Cons=[Cons,EXPTQc(i)>=SINTQc(str2num(cell2mat(EXPwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(SINTQc(str2num(cell2mat(EXPwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(SINTQc(str2num(cell2mat(EXPwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(EXPtype1(i))) == 7
            Cons=[Cons,EXPTQc(i)>=COSTQc(str2num(cell2mat(EXPwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(COSTQc(str2num(cell2mat(EXPwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(COSTQc(str2num(cell2mat(EXPwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(EXPtype1(i))) == 8
            Cons=[Cons,EXPTQc(i)>=COMPARETQc(str2num(cell2mat(EXPwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(COMPARETQc(str2num(cell2mat(EXPwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(COMPARETQc(str2num(cell2mat(EXPwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(EXPtype1(i))) == 9
            Cons=[Cons,EXPTQc(i)>=LIMITTQc(str2num(cell2mat(EXPwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(LIMITTQc(str2num(cell2mat(EXPwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(LIMITTQc(str2num(cell2mat(EXPwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(EXPtype1(i))) == 10
            Cons=[Cons,EXPTQc(i)>=EXPTQc(str2num(cell2mat(EXPwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,EXPTQc(i)-(EXPTQc(str2num(cell2mat(EXPwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,EXPTQc(i)-(EXPTQc(str2num(cell2mat(EXPwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if (str2num(cell2mat(EXPtype1(i))) == 0||str2num(cell2mat(EXPtype1(i))) == 3||str2num(cell2mat(EXPtype1(i))) == 4)
        Cons=[Cons,MULTQc(i)>=datadelay+1];
    end
end
for i = 1 : NLOG
    if str2num(cell2mat(LOGtype1(i))) == 11
        for k = 1 :length(LOGwhere2)
            if strcmp(cellstr(LOGwhere2(k)),cellstr(LOGwhere1(i)))==1
                Cons=[Cons,LOGTQc(i)>=LOGTQc(k)+str2num(cell2mat(LOGtime(k)))];
            end
        end
    end
    if str2num(cell2mat(LOGtype1(i))) == 0||str2num(cell2mat(LOGtype1(i))) == 3||str2num(cell2mat(LOGtype1(i))) == 4
		Cons=[Cons,LOGTQc(i)>=datadelay+1];
    else
        if str2num(cell2mat(LOGtype1(i))) == 1
            Cons=[Cons,LOGTQc(i)>=ADDTQc(str2num(cell2mat(LOGwhere1(i))))+dadd];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(ADDTQc(str2num(cell2mat(LOGwhere1(i))))+dadd)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(ADDTQc(str2num(cell2mat(LOGwhere1(i))))+dadd)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LOGtype1(i))) == 2
            Cons=[Cons,LOGTQc(i)>=MULTQc(str2num(cell2mat(LOGwhere1(i))))+dmul];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(MULTQc(str2num(cell2mat(LOGwhere1(i))))+dmul)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(MULTQc(str2num(cell2mat(LOGwhere1(i))))+dmul)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LOGtype1(i))) == 5
            Cons=[Cons,LOGTQc(i)>=DIVTQc(str2num(cell2mat(LOGwhere1(i))))+ddiv];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(DIVTQc(str2num(cell2mat(LOGwhere1(i))))+ddiv)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(DIVTQc(str2num(cell2mat(LOGwhere1(i))))+ddiv)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LOGtype1(i))) == 6
            Cons=[Cons,LOGTQc(i)>=SINTQc(str2num(cell2mat(LOGwhere1(i))))+dsin];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(SINTQc(str2num(cell2mat(LOGwhere1(i))))+dsin)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(SINTQc(str2num(cell2mat(LOGwhere1(i))))+dsin)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LOGtype1(i))) == 7
            Cons=[Cons,LOGTQc(i)>=COSTQc(str2num(cell2mat(LOGwhere1(i))))+dcos];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(COSTQc(str2num(cell2mat(LOGwhere1(i))))+dcos)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(COSTQc(str2num(cell2mat(LOGwhere1(i))))+dcos)>=-C*branchcon(NBR)];
        end
        if str2num(cell2mat(LOGtype1(i))) == 8
            Cons=[Cons,LOGTQc(i)>=COMPARETQc(str2num(cell2mat(LOGwhere1(i))))+dcompare];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(COMPARETQc(str2num(cell2mat(LOGwhere1(i))))+dcompare)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(COMPARETQc(str2num(cell2mat(LOGwhere1(i))))+dcompare)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LOGtype1(i))) == 9
            Cons=[Cons,LOGTQc(i)>=LIMITTQc(str2num(cell2mat(LOGwhere1(i))))+dlimit];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(LIMITTQc(str2num(cell2mat(LOGwhere1(i))))+dlimit)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(LIMITTQc(str2num(cell2mat(LOGwhere1(i))))+dlimit)>=-C*branchcon(NBR)];
        end
		if str2num(cell2mat(LOGtype1(i))) == 10
            Cons=[Cons,LOGTQc(i)>=EXPTQc(str2num(cell2mat(LOGwhere1(i))))+dexp];
            NBR=NBR+1;
            Cons=[Cons,LOGTQc(i)-(EXPTQc(str2num(cell2mat(LOGwhere1(i))))+dexp)<=C*branchcon(NBR)];
            Cons=[Cons,LOGTQc(i)-(EXPTQc(str2num(cell2mat(LOGwhere1(i))))+dexp)>=-C*branchcon(NBR)];
        end
    end
    if (str2num(cell2mat(LOGtype1(i))) == 0||str2num(cell2mat(LOGtype1(i))) == 3||str2num(cell2mat(LOGtype1(i))) == 4)
        Cons=[Cons,MULTQc(i)>=datadelay+1];
    end
end
for t=1:TMIN
     ADDzz = 0;
     for c=1:NADD
         ADDzz = ADDzz + ADDSct(c,t);
     end
     Cons=[Cons,W1(1,1)>=ADDzz];
end
 for c=1:NADD
     ADDqq = 0;
     for t=1:TMIN
         ADDqq = ADDqq + ADDQct(c,t);
     end
     ADDq(c,1) = ADDqq;
     Cons=[Cons,ADDq(c,1)==1];
 end

  for c=1:NADD
     ADDpp = 0;
     for t=1:TMIN
         ADDpp = ADDpp + ADDGct(c,t);
     end
     ADDp(c,1) = ADDpp;
     Cons=[Cons,ADDp(c,1)==1];
  end
  
  for c=1:NADD
      Cons=[Cons,ADDSct(c,1)==ADDQct(c,1)-ADDGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NADD
            Cons=[Cons,ADDSct(c,t)==ADDSct(c,t-1)+ADDQct(c,t)-ADDGct(c,t)];
        end
  end
   
  for c=1:NADD
     ADDaa = 0;
     for t=1:TMIN
         ADDaa = ADDaa + t*ADDQct(c,t);
     end
     ADDa(c,1) = ADDaa;
     Cons=[Cons,ADDTQc(c,1)==ADDa(c,1)];
  end
  
    for c=1:NADD
     ADDbb = 0;
     for t=1:TMIN
         ADDbb = ADDbb + t*ADDGct(c,t);
     end
     ADDb(c,1) = ADDbb;
     Cons=[Cons,ADDTGc(c,1)==ADDb(c,1)];
    end
    
   for c=1:NADD
     for t=1:TMIN-tc
         Cons=[Cons,ADDGct(c,t+tc)==ADDQct(c,t)];
     end
   end
   for t=1:TMIN
     MULzz = 0;
     for c=1:NMUL
         MULzz = MULzz + MULSct(c,t);
     end
     Cons=[Cons,W2(1,1)>=MULzz];
end
 for c=1:NMUL
     MULqq = 0;
     for t=1:TMIN
         MULqq = MULqq + MULQct(c,t);
     end
     MULq(c,1) = MULqq;
     Cons=[Cons,MULq(c,1)==1];
 end

  for c=1:NMUL
     MULpp = 0;
     for t=1:TMIN
         MULpp = MULpp + MULGct(c,t);
     end
     MULp(c,1) = MULpp;
     Cons=[Cons,MULp(c,1)==1];
  end
  
  for c=1:NMUL
      Cons=[Cons,MULSct(c,1)==MULQct(c,1)-MULGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NMUL
            Cons=[Cons,MULSct(c,t)==MULSct(c,t-1)+MULQct(c,t)-MULGct(c,t)];
        end
  end
   
  for c=1:NMUL
     MULaa = 0;
     for t=1:TMIN
         MULaa = MULaa + t*MULQct(c,t);
     end
     MULa(c,1) = MULaa;
     Cons=[Cons,MULTQc(c,1)==MULa(c,1)];
  end
  
    for c=1:NMUL
     MULbb = 0;
     for t=1:TMIN
         MULbb = MULbb + t*MULGct(c,t);
     end
     MULb(c,1) = MULbb;
     Cons=[Cons,MULTGc(c,1)==MULb(c,1)];
    end
    
   for c=1:NMUL
     for t=1:TMIN-tc
         Cons=[Cons,MULGct(c,t+tc)==MULQct(c,t)];
     end
   end
   for t=1:TMIN
     DIVzz = 0;
     for c=1:NDIV
         DIVzz = DIVzz + DIVSct(c,t);
     end
     Cons=[Cons,W3(1,1)>=DIVzz];
end
 for c=1:NDIV
     DIVqq = 0;
     for t=1:TMIN
         DIVqq = DIVqq + DIVQct(c,t);
     end
     DIVq(c,1) = DIVqq;
     Cons=[Cons,DIVq(c,1)==1];
 end

  for c=1:NDIV
     DIVpp = 0;
     for t=1:TMIN
         DIVpp = DIVpp + DIVGct(c,t);
     end
     DIVp(c,1) = DIVpp;
     Cons=[Cons,DIVp(c,1)==1];
  end
  
  for c=1:NDIV
      Cons=[Cons,DIVSct(c,1)==DIVQct(c,1)-DIVGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NDIV
            Cons=[Cons,DIVSct(c,t)==DIVSct(c,t-1)+DIVQct(c,t)-DIVGct(c,t)];
        end
  end
   
  for c=1:NDIV
     DIVaa = 0;
     for t=1:TMIN
         DIVaa = DIVaa + t*DIVQct(c,t);
     end
     DIVa(c,1) = DIVaa;
     Cons=[Cons,DIVTQc(c,1)==DIVa(c,1)];
  end
  
    for c=1:NDIV
     DIVbb = 0;
     for t=1:TMIN
         DIVbb = DIVbb + t*DIVGct(c,t);
     end
     DIVb(c,1) = DIVbb;
     Cons=[Cons,DIVTGc(c,1)==DIVb(c,1)];
    end
    
   for c=1:NDIV
     for t=1:TMIN-tc
         Cons=[Cons,DIVGct(c,t+tc)==DIVQct(c,t)];
     end
   end
   for t=1:TMIN
     SINzz = 0;
     for c=1:NSIN
         SINzz = SINzz + SINSct(c,t);
     end
     Cons=[Cons,W4(1,1)>=SINzz];
end
 for c=1:NSIN
     SINqq = 0;
     for t=1:TMIN
         SINqq = SINqq + SINQct(c,t);
     end
     SINq(c,1) = SINqq;
     Cons=[Cons,SINq(c,1)==1];
 end

  for c=1:NSIN
     SINpp = 0;
     for t=1:TMIN
         SINpp = SINpp + SINGct(c,t);
     end
     SINp(c,1) = SINpp;
     Cons=[Cons,SINp(c,1)==1];
  end
  
  for c=1:NSIN
      Cons=[Cons,SINSct(c,1)==SINQct(c,1)-SINGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NSIN
            Cons=[Cons,SINSct(c,t)==SINSct(c,t-1)+SINQct(c,t)-SINGct(c,t)];
        end
  end
   
  for c=1:NSIN
     SINaa = 0;
     for t=1:TMIN
         SINaa = SINaa + t*SINQct(c,t);
     end
     SINa(c,1) = SINaa;
     Cons=[Cons,SINTQc(c,1)==SINa(c,1)];
  end
  
    for c=1:NSIN
     SINbb = 0;
     for t=1:TMIN
         SINbb = SINbb + t*SINGct(c,t);
     end
     SINb(c,1) = SINbb;
     Cons=[Cons,SINTGc(c,1)==SINb(c,1)];
    end
    
   for c=1:NSIN
     for t=1:TMIN-tc
         Cons=[Cons,SINGct(c,t+tc)==SINQct(c,t)];
     end
   end
   for t=1:TMIN
     COSzz = 0;
     for c=1:NCOS
         COSzz = COSzz + COSSct(c,t);
     end
     Cons=[Cons,W5(1,1)>=COSzz];
end
 for c=1:NCOS
     COSqq = 0;
     for t=1:TMIN
         COSqq = COSqq + COSQct(c,t);
     end
     COSq(c,1) = COSqq;
     Cons=[Cons,COSq(c,1)==1];
 end

  for c=1:NCOS
     COSpp = 0;
     for t=1:TMIN
         COSpp = COSpp + COSGct(c,t);
     end
     COSp(c,1) = COSpp;
     Cons=[Cons,COSp(c,1)==1];
  end
  
  for c=1:NCOS
      Cons=[Cons,COSSct(c,1)==COSQct(c,1)-COSGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NCOS
            Cons=[Cons,COSSct(c,t)==COSSct(c,t-1)+COSQct(c,t)-COSGct(c,t)];
        end
  end
   
  for c=1:NCOS
     COSaa = 0;
     for t=1:TMIN
         COSaa = COSaa + t*COSQct(c,t);
     end
     COSa(c,1) = COSaa;
     Cons=[Cons,COSTQc(c,1)==COSa(c,1)];
  end
  
    for c=1:NCOS
     COSbb = 0;
     for t=1:TMIN
         COSbb = COSbb + t*COSGct(c,t);
     end
     COSb(c,1) = COSbb;
     Cons=[Cons,COSTGc(c,1)==COSb(c,1)];
    end
    
   for c=1:NCOS
     for t=1:TMIN-tc
         Cons=[Cons,COSGct(c,t+tc)==COSQct(c,t)];
     end
   end
   for t=1:TMIN
     COMPAREzz = 0;
     for c=1:NCOMPARE
         COMPAREzz = COMPAREzz + COMPARESct(c,t);
     end
     Cons=[Cons,W6(1,1)>=COMPAREzz];
end
 for c=1:NCOMPARE
     COMPAREqq = 0;
     for t=1:TMIN
         COMPAREqq = COMPAREqq + COMPAREQct(c,t);
     end
     COMPAREq(c,1) = COMPAREqq;
     Cons=[Cons,COMPAREq(c,1)==1];
 end

  for c=1:NCOMPARE
     COMPAREpp = 0;
     for t=1:TMIN
         COMPAREpp = COMPAREpp + COMPAREGct(c,t);
     end
     COMPAREp(c,1) = COMPAREpp;
     Cons=[Cons,COMPAREp(c,1)==1];
  end
  
  for c=1:NCOMPARE
      Cons=[Cons,COMPARESct(c,1)==COMPAREQct(c,1)-COMPAREGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NCOMPARE
            Cons=[Cons,COMPARESct(c,t)==COMPARESct(c,t-1)+COMPAREQct(c,t)-COMPAREGct(c,t)];
        end
  end
   
  for c=1:NCOMPARE
     COMPAREaa = 0;
     for t=1:TMIN
         COMPAREaa = COMPAREaa + t*COMPAREQct(c,t);
     end
     COMPAREa(c,1) = COMPAREaa;
     Cons=[Cons,COMPARETQc(c,1)==COMPAREa(c,1)];
  end
  
    for c=1:NCOMPARE
     COMPAREbb = 0;
     for t=1:TMIN
         COMPAREbb = COMPAREbb + t*COMPAREGct(c,t);
     end
     COMPAREb(c,1) = COMPAREbb;
     Cons=[Cons,COMPARETGc(c,1)==COMPAREb(c,1)];
    end
    
   for c=1:NCOMPARE
     for t=1:TMIN-tc
         Cons=[Cons,COMPAREGct(c,t+tc)==COMPAREQct(c,t)];
     end
   end
   for t=1:TMIN
     LIMITzz = 0;
     for c=1:NLIMIT
         LIMITzz = LIMITzz + LIMITSct(c,t);
     end
     Cons=[Cons,W7(1,1)>=LIMITzz];
end
 for c=1:NLIMIT
     LIMITqq = 0;
     for t=1:TMIN
         LIMITqq = LIMITqq + LIMITQct(c,t);
     end
     LIMITq(c,1) = LIMITqq;
     Cons=[Cons,LIMITq(c,1)==1];
 end

  for c=1:NLIMIT
     LIMITpp = 0;
     for t=1:TMIN
         LIMITpp = LIMITpp + LIMITGct(c,t);
     end
     LIMITp(c,1) = LIMITpp;
     Cons=[Cons,LIMITp(c,1)==1];
  end
  
  for c=1:NLIMIT
      Cons=[Cons,LIMITSct(c,1)==LIMITQct(c,1)-LIMITGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NLIMIT
            Cons=[Cons,LIMITSct(c,t)==LIMITSct(c,t-1)+LIMITQct(c,t)-LIMITGct(c,t)];
        end
  end
   
  for c=1:NLIMIT
     LIMITaa = 0;
     for t=1:TMIN
         LIMITaa = LIMITaa + t*LIMITQct(c,t);
     end
     LIMITa(c,1) = LIMITaa;
     Cons=[Cons,LIMITTQc(c,1)==LIMITa(c,1)];
  end
  
    for c=1:NLIMIT
     LIMITbb = 0;
     for t=1:TMIN
         LIMITbb = LIMITbb + t*LIMITGct(c,t);
     end
     LIMITb(c,1) = LIMITbb;
     Cons=[Cons,LIMITTGc(c,1)==LIMITb(c,1)];
    end
    
   for c=1:NLIMIT
     for t=1:TMIN-tc
         Cons=[Cons,LIMITGct(c,t+tc)==LIMITQct(c,t)];
     end
   end
   for t=1:TMIN
     EXPzz = 0;
     for c=1:NEXP
         EXPzz = EXPzz + EXPSct(c,t);
     end
     Cons=[Cons,W8(1,1)>=EXPzz];
end
 for c=1:NEXP
     EXPqq = 0;
     for t=1:TMIN
         EXPqq = EXPqq + EXPQct(c,t);
     end
     EXPq(c,1) = EXPqq;
     Cons=[Cons,EXPq(c,1)==1];
 end

  for c=1:NEXP
     EXPpp = 0;
     for t=1:TMIN
         EXPpp = EXPpp + EXPGct(c,t);
     end
     EXPp(c,1) = EXPpp;
     Cons=[Cons,EXPp(c,1)==1];
  end
  
  for c=1:NEXP
      Cons=[Cons,EXPSct(c,1)==EXPQct(c,1)-EXPGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NEXP
            Cons=[Cons,EXPSct(c,t)==EXPSct(c,t-1)+EXPQct(c,t)-EXPGct(c,t)];
        end
  end
   
  for c=1:NEXP
     EXPaa = 0;
     for t=1:TMIN
         EXPaa = EXPaa + t*EXPQct(c,t);
     end
     EXPa(c,1) = EXPaa;
     Cons=[Cons,EXPTQc(c,1)==EXPa(c,1)];
  end
  
    for c=1:NEXP
     EXPbb = 0;
     for t=1:TMIN
         EXPbb = EXPbb + t*EXPGct(c,t);
     end
     EXPb(c,1) = EXPbb;
     Cons=[Cons,EXPTGc(c,1)==EXPb(c,1)];
    end
    
   for c=1:NEXP
     for t=1:TMIN-tc
         Cons=[Cons,EXPGct(c,t+tc)==EXPQct(c,t)];
     end
   end
   for t=1:TMIN
     LOGzz = 0;
     for c=1:NLOG
         LOGzz = LOGzz + LOGSct(c,t);
     end
     Cons=[Cons,W9(1,1)>=LOGzz];
end
 for c=1:NLOG
     LOGqq = 0;
     for t=1:TMIN
         LOGqq = LOGqq + LOGQct(c,t);
     end
     LOGq(c,1) = LOGqq;
     Cons=[Cons,LOGq(c,1)==1];
 end

  for c=1:NLOG
     LOGpp = 0;
     for t=1:TMIN
         LOGpp = LOGpp + LOGGct(c,t);
     end
     LOGp(c,1) = LOGpp;
     Cons=[Cons,LOGp(c,1)==1];
  end
  
  for c=1:NLOG
      Cons=[Cons,LOGSct(c,1)==LOGQct(c,1)-LOGGct(c,1)];
  end
  
  for t=2:TMIN
        for c=1:NLOG
            Cons=[Cons,LOGSct(c,t)==LOGSct(c,t-1)+LOGQct(c,t)-LOGGct(c,t)];
        end
  end
   
  for c=1:NLOG
     LOGaa = 0;
     for t=1:TMIN
         LOGaa = LOGaa + t*LOGQct(c,t);
     end
     LOGa(c,1) = LOGaa;
     Cons=[Cons,LOGTQc(c,1)==LOGa(c,1)];
  end
  
    for c=1:NLOG
     LOGbb = 0;
     for t=1:TMIN
         LOGbb = LOGbb + t*LOGGct(c,t);
     end
     LOGb(c,1) = LOGbb;
     Cons=[Cons,LOGTGc(c,1)==LOGb(c,1)];
    end
    
   for c=1:NLOG
     for t=1:TMIN-tc
         Cons=[Cons,LOGGct(c,t+tc)==LOGQct(c,t)];
     end
   end
   zbr=0;
   for B=1:branch
        zbr=zbr+branchcon(B);
   end
m=500*W1(1,1)+100*W2(1,1)+1000*W3(1,1)+2000*W4(1,1)+2000*W5(1,1)+2000*W8(1,1)+50*zbr;   
objective = m;
ops = sdpsettings('solver','cplex');
ops.cplex.timelimit=40000;
solvesdp(Cons,objective,ops)
dc=double(MULTQc); %展示 x 的求解值
dj=double(ADDTQc); %展示 x 的求解值
dd=double(DIVTQc); %展示 x 的求解值
ddsin=double(SINTQc);
ddcos=double(COSTQc);
ddexp=double(EXPTQc);
ddcompare=double(COMPARETQc);
ddlimit=double(LIMITTQc);
dm1=double(W1);%add
dm2=double(W2);%mul
dmd=double(W3);%add
dmsin=double(W4);%add
dmcos=double(W5);%add
dmexp=double(W8);%add
dm1=int16(dm1);
dm2=int16(dm2);
dmd=int16(dmd);
dmsin=int16(dmsin);
dmcos=int16(dmcos);
dmexp=int16(dmexp);
double(objective) %展示目标函数