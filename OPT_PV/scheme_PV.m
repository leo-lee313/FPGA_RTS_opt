dmzlimit=zeros(1,NLIMIT);
dm3=zeros(1,NADD);
dm4=zeros(1,NMUL);
dmzd=zeros(1,NDIV);
dmzsin=zeros(1,NSIN);
dmzcos=zeros(1,NCOS);
dmzexp=zeros(1,NEXP);
dmzcompare=zeros(1,NCOMPARE);
for o=1:NADD
    dm3(o)=dj(o)-1;
end
for o=1:NMUL
    dm4(o)=dc(o)-1;
end
for o=1:NDIV
    dmzd(o)=dd(o)-1;
end
for o=1:NSIN
    dmzsin(o)=ddsin(o)-1;
end
for o=1:NCOS
    dmzcos(o)=ddcos(o)-1;
end
for o=1:NEXP
    dmzexp(o)=ddexp(o)-1;
end
for o=1:NCOMPARE
    dmzcompare(o)=ddcompare(o)-1;
end
for o=1:NLIMIT
    dmzlimit(o)=ddlimit(o)-1;
end
dm3=int16(dm3');
dm4=int16(dm4');
dmzd=int16(dmzd');
dmzsin=int16(dmzsin');
dmzcos=int16(dmzcos');
dmzexp=int16(dmzexp');
dmzcompare=int16(dmzcompare');
dmzlimit=int16(dmzlimit');
xdiv=linspace(1,NDIV,NDIV);
xdiv=xdiv';
xsin=linspace(1,NSIN,NSIN);
xsin=xsin';
xcos=linspace(1,NCOS,NCOS);
xcos=xcos';
xexp=linspace(1,NEXP,NEXP);
xexp=xexp';
xcompare=linspace(1,NCOMPARE,NCOMPARE);
xcompare=xcompare';
xlimit=linspace(1,NLIMIT,NLIMIT);
xlimit=xlimit';
dm7div=[num2cell(dmzd),num2cell(xdiv), DIVtype1, DIVwhere1, DIVtype2, DIVwhere2];
dm7divp=sortrows(dm7div,1);
dm7sin=[num2cell(dmzsin),num2cell(xsin), SINtype1, SINwhere1, SINtype2, SINwhere2, SINtype3, SINwhere3];
dm7sinp=sortrows(dm7sin,1);
dm7cos=[num2cell(dmzcos),num2cell(xcos), COStype1, COSwhere1, COStype2, COSwhere2, COStype3, COSwhere3];
dm7cosp=sortrows(dm7cos,1);
dm7exp=[num2cell(dmzexp),num2cell(xexp), EXPtype1, EXPwhere1];
dm7expp=sortrows(dm7exp,1);
dm7compare=[num2cell(dmzcompare),num2cell(xcompare), COMPAREtype1, COMPAREwhere1, COMPAREtype2, COMPAREwhere2];
dm7comparep=sortrows(dm7compare,1);
dm7limit=[num2cell(dmzlimit),num2cell(xlimit), LIMITtype1, LIMITwhere1, LIMITtype2, LIMITwhere2, LIMITtype3, LIMITwhere3];
dm7limitp=sortrows(dm7limit,1);
x=linspace(1,NADD,NADD);
x=x';
dm7=[num2cell(dm3),num2cell(x), ADDtype1, ADDwhere1, ADDtype2, ADDwhere2, ADDsign];
y=linspace(1,NMUL,NMUL);
y=y';
dm8=[num2cell(dm4),num2cell(y), MULtype1, MULwhere1, MULtype2, MULwhere2];
dm5=sortrows(dm7,1);
dm6=sortrows(dm8,1);
cssi=zeros(10,100);

% for cc=1:NMUL
%     checkmul=mod(cc,dm2)+1;
%     cssi(checkmul)=cssi(checkmul)+1;
%     C1(cssi(checkmul),:,checkmul)=dm6(cc,:);
% end    
% for jj=1:NADD
%     checkadd=mod(jj,dm1)+1;
%     jssi(checkadd)=jssi(checkadd)+1;
%     J1(jssi(checkadd),:,checkadd)=dm5(jj,:);
% end   
% ZONE2(jj,;,2)=dm5;
% ZONE2(cc,1;6,1)=dm6;
% ZONE2(cc,1;6,3)=dm7divp;
% ZONE2(cc,1;4,4)=dm7sinp;
% ZONE2(cc,1;4,5)=dm7cosp;
% ZONE2(cc,1;4,6)=dm7expp;
checklimit=0;
for cc=1:NLIMIT
    checklimit=checklimit+1;
    cssi(9,checklimit)=cssi(9,checklimit)+1;
    ZONE1(cssi(9,checklimit),1:8,checkcos,9)=dm7limitp(cc,:);
    ZONE2(cc,1:8,9)=dm7limitp(cc,:);
end
for jj=1:NADD
    checkadd=mod(jj,dm1)+1;
    cssi(1,checkadd)=cssi(1,checkadd)+1;
    ZONE1(cssi(1,checkadd),1:7,checkadd,1)=dm5(jj,:);
    ZONE2(jj,1:7,1)=dm5(jj,:);
end
for cc=1:NMUL
    checkmul=mod(cc,dm2)+1;
    cssi(2,checkmul)=cssi(2,checkmul)+1;
    ZONE1(cssi(2,checkmul),1:6,checkmul,2)=dm6(cc,:);
    ZONE2(cc,1:6,2)=dm6(cc,:);
end  
for cc=1:NDIV
    checkdiv=mod(cc,dmd)+1;
    cssi(5,checkdiv)=cssi(5,checkdiv)+1;
    ZONE1(cssi(5,checkdiv),1:6,checkdiv,5)=dm7divp(cc,:);
    ZONE2(cc,1:6,5)=dm7divp(cc,:);
end 
for cc=1:NSIN
    checksin=mod(cc,dmsin)+1;
    cssi(6,checksin)=cssi(6,checksin)+1;
    ZONE1(cssi(6,checksin),1:8,checksin,6)=dm7sinp(cc,:);
    ZONE2(cc,1:8,6)=dm7sinp(cc,:);
end 
for cc=1:NCOS
    checkcos=mod(cc,dmcos)+1;
    cssi(7,checkcos)=cssi(7,checkcos)+1;
    ZONE1(cssi(7,checkcos),1:8,checkcos,7)=dm7cosp(cc,:);
    ZONE2(cc,1:8,7)=dm7cosp(cc,:);
end 
checkcompare=0;
for cc=1:NCOMPARE
    checkcompare=checkcompare+1;
    cssi(8,checkcompare)=cssi(8,checkcompare)+1;
    ZONE1(cssi(8,checkcompare),1:6,checkcompare,8)=dm7comparep(cc,:);
    ZONE2(cc,1:6,8)=dm7comparep(cc,:);
end

for cc=1:NEXP
    checkexp=mod(cc,dmexp)+1;
    cssi(10,checkexp)=cssi(10,checkexp)+1;
    ZONE1(cssi(10,checkexp),1:4,checkexp,10)=dm7expp(cc,:);
    ZONE2(cc,1:4,10)=dm7expp(cc,:);
end 
