clear stimfirstlabels;
stimfirstlabels = cell(2,length(stimartfdefRej));
switch subjID    
    case 'P072'      
%         stimfirstlabels(1,1:14) = {'R O pi_1'};
%         stimfirstlabels(2,1:14) = {'R O pi_2'};
%         
%         stimfirstlabels(1,15:36) = {'R O pi_2'};
%         stimfirstlabels(2,15:36) = {'R O pi_3'};
%         
%         stimfirstlabels(1,37:45) = {'R O pi_3'};
%         stimfirstlabels(2,37:45) = {'R O pi_4'};
%         
%         stimfirstlabels(1,46:62) = {'R P as_1'};
%         stimfirstlabels(2,46:62) = {'R P as_2'};
%         
%         stimfirstlabels(1,63:82) = {'R P as_2'};
%         stimfirstlabels(2,63:82) = {'R P as_3'};
%         
%         stimfirstlabels(1,83:104) = {'R P as_3'};
%         stimfirstlabels(2,83:104) = {'R P as_4'};
%         
%         stimfirstlabels(1,105:119) = {'R P as_4'};
%         stimfirstlabels(2,105:119) = {'R P as_5'};
%         
%         stimfirstlabels(1,120:147) = {'R P as_5'};
%         stimfirstlabels(2,120:147) = {'R P as_6'};
%         
%         stimfirstlabels(1,148:163) = {'R C_1'};
%         stimfirstlabels(2,148:163) = {'R C_2'};
%         
%         stimfirstlabels(1,164:184) = {'R C_2'};
%         stimfirstlabels(2,164:184) = {'R C_3'};
%         
%         stimfirstlabels(1,185:199) = {'R C_3'};
%         stimfirstlabels(2,185:199) = {'R C_4'};
%         
%         stimfirstlabels(1,200:214) = {'R C_4'};
%         stimfirstlabels(2,200:214) = {'R C_5'};
%         
%         stimfirstlabels(1,215:219) = {'R C_5'};
%         stimfirstlabels(2,215:219) = {'R C_6'};
%         
%         stimfirstlabels(1,220:231) = {'ROF_1'};
%         stimfirstlabels(2,220:231) = {'ROF_2'};
%         
%         stimfirstlabels(1,232:250) = {'ROF_2'};
%         stimfirstlabels(2,232:250) = {'ROF_3'};
%         
%         stimfirstlabels(1,251:264) = {'ROF_3'};
%         stimfirstlabels(2,251:264) = {'ROF_4'};
%         
%         stimfirstlabels(1,265:279) = {'ROF_4'};
%         stimfirstlabels(2,265:279) = {'ROF_5'};
%         
%         stimfirstlabels(1,280:294) = {'ROF_5'};
%         stimfirstlabels(2,280:294) = {'ROF_6'};
%         
%         stimfirstlabels(1,295:307) = {'ROF_6'};
%         stimfirstlabels(2,295:307) = {'ROF_7'};
%         
%         stimfirstlabels(1,308:321) = {'L MH_1'};
%         stimfirstlabels(2,308:321) = {'L MH_2'};
%         
%         stimfirstlabels(1,322:334) = {'L MH_2'};
%         stimfirstlabels(2,322:334) = {'L MH_3'};
%         
%         stimfirstlabels(1,335:348) = {'L MH_3'};
%         stimfirstlabels(2,335:348) = {'L MH_4'};
%         
%         stimfirstlabels(1,349:360) = {'L MH_4'};
%         stimfirstlabels(2,349:360) = {'L MH_5'};
%         
%         stimfirstlabels(1,361:372) = {'L MH_5'};
%         stimfirstlabels(2,361:372) = {'L MH_6'};
%         
%         stimfirstlabels(1,373:384) = {'L MH_6'};
%         stimfirstlabels(2,373:384) = {'L MH_7'};
%         
%         stimfirstlabels(1,385:398) = {'L MH_7'};
%         stimfirstlabels(2,385:398) = {'L MH_8'};
               
        stimfirstlabels(1,1:17) = {'L MH_1'};
        stimfirstlabels(2,1:17) = {'L MH_2'};
        
        stimfirstlabels(1,18:30) = {'L MH_2'};
        stimfirstlabels(2,18:30) = {'L MH_3'};
        
        stimfirstlabels(1,31:44) = {'L MH_3'};
        stimfirstlabels(2,31:44) = {'L MH_4'};
        
        stimfirstlabels(1,45:56) = {'L MH_4'};
        stimfirstlabels(2,45:56) = {'L MH_5'};
        
        stimfirstlabels(1,57:68) = {'L MH_5'};
        stimfirstlabels(2,57:68) = {'L MH_6'};
        
        stimfirstlabels(1,69:80) = {'L MH_6'};
        stimfirstlabels(2,69:80) = {'L MH_7'};
        
        stimfirstlabels(1,81:94) = {'L MH_7'};
        stimfirstlabels(2,81:94) = {'L MH_8'};
                
    case 'P07' % 0303

        stimfirstlabels(1,1:25) = {'RAH_2'};
        stimfirstlabels(2,1:25) = {'RAH_3'};
        
        stimfirstlabels(1,26:64) = {'RAH_3'};
        stimfirstlabels(2,26:64) = {'RAH_4'};
        
        stimfirstlabels(1,65:101) = {'RAH_4'};
        stimfirstlabels(2,65:101) = {'RAH_5'};
        
        stimfirstlabels(1,102:122) = {'RAH_5'};
        stimfirstlabels(2,102:122) = {'RAH_6'};
        
        stimfirstlabels(1,123:137) = {'RAH_6'};
        stimfirstlabels(2,123:137) = {'RAH_7'};
        
        stimfirstlabels(1,138:150) = {'RAH_7'};
        stimfirstlabels(2,138:150) = {'RAH_8'};
        
        stimfirstlabels(1,151:174) = {'RMH_2'};
        stimfirstlabels(2,151:174) = {'RMH_3'};
        
        stimfirstlabels(1,175:203) = {'RMH_3'};
        stimfirstlabels(2,175:203) = {'RMH_4'};
        
        stimfirstlabels(1,204:219) = {'RMH_4'};
        stimfirstlabels(2,204:219) = {'RMH_5'};
        
        stimfirstlabels(1,220:233) = {'RMH_5'};
        stimfirstlabels(2,220:233) = {'RMH_6'};
        
        stimfirstlabels(1,234:252) = {'RMH_6'};
        stimfirstlabels(2,234:252) = {'RMH_7'};
        
        stimfirstlabels(1,254-1:269-1) = {'RMH_7'};
        stimfirstlabels(2,254-1:269-1) = {'RMH_8'};
        
        stimfirstlabels(1,270-1:291-1) = {'RPH_2'};
        stimfirstlabels(2,270-1:291-1) = {'RPH_3'};
        
        stimfirstlabels(1,292-1:319-1) = {'RPH_3'};
        stimfirstlabels(2,292-1:319-1) = {'RPH_4'};
        
        stimfirstlabels(1,320-1:336-1) = {'RPH_4'};
        stimfirstlabels(2,320-1:336-1) = {'RPH_5'};
        
        stimfirstlabels(1,337-1:356-1) = {'RPH_5'};
        stimfirstlabels(2,337-1:356-1) = {'RPH_6'};
        
        stimfirstlabels(1,357-1:374-1) = {'RPH_6'};
        stimfirstlabels(2,357-1:374-1) = {'RPH_7'};
        
        stimfirstlabels(1,375-1:401-1) = {'R O ai_2'};
        stimfirstlabels(2,375-1:401-1) = {'R O ai_3'};
        
        stimfirstlabels(1,402-1:419-1) = {'R O ai_3'};
        stimfirstlabels(2,402-1:419-1) = {'R O ai_4'};
        
        stimfirstlabels(1,420-1:432-1) = {'R O ai_5'};
        stimfirstlabels(2,420-1:432-1) = {'R O ai_6'};
        
        stimfirstlabels(1,433-1:459-1) = {'R P ps_2'};
        stimfirstlabels(2,433-1:459-1) = {'R P ps_3'};
        
        stimfirstlabels(1,460-1:479-1) = {'R P ps_3'};
        stimfirstlabels(2,460-1:479-1) = {'R P ps_4'};
        
        stimfirstlabels(1,480-1:499-2) = {'R P ps_4'};
        stimfirstlabels(2,480-1:499-2) = {'R P ps_5'};       
        
    case 'P082'
        % the 0706

        stimfirstlabels(1,1:15) = {'LAH_1'};
        stimfirstlabels(2,1:15) = {'LAH_2'};
        
        stimfirstlabels(1,16:30) = {'LAH_2'};
        stimfirstlabels(2,16:30) = {'LAH_3'};
        
        stimfirstlabels(1,31:46) = {'LAH_3'};
        stimfirstlabels(2,31:46) = {'LAH_4'};
        
        stimfirstlabels(1,47:63) = {'LAH_4'};
        stimfirstlabels(2,47:63) = {'LAH_5'};
        
        stimfirstlabels(1,64:79) = {'LAH_5'};
        stimfirstlabels(2,64:79) = {'LAH_6'};
        
        stimfirstlabels(1,80:94) = {'LAH_6'};
        stimfirstlabels(2,80:94) = {'LAH_7'};
        
        stimfirstlabels(1,95:109) = {'LAH_7'};
        stimfirstlabels(2,95:109) = {'LAH_8'};
        
        stimfirstlabels(1,110:131) = {'LMH_1'};
        stimfirstlabels(2,110:131) = {'LMH_2'};
        
        stimfirstlabels(1,130:146) = {'LMH_2'};
        stimfirstlabels(2,130:146) = {'LMH_3'};
        
        stimfirstlabels(1,147:163) = {'LMH_3'};
        stimfirstlabels(2,147:163) = {'LMH_4'};
        
        stimfirstlabels(1,164:180) = {'LMH_4'};
        stimfirstlabels(2,164:180) = {'LMH_5'};
        
        stimfirstlabels(1,181:196) = {'LMH_5'};
        stimfirstlabels(2,181:196) = {'LMH_6'};
        
        stimfirstlabels(1,197:213) = {'LMH_6'};
        stimfirstlabels(2,197:213) = {'LMH_7'};
        
        stimfirstlabels(1,214:230) = {'LMH_7'};
        stimfirstlabels(2,214:230) = {'LMH_8'};
        
        stimfirstlabels(1,231:249) = {'LPH_1'};
        stimfirstlabels(2,231:249) = {'LPH_2'};
        
        stimfirstlabels(1,250:264) = {'LPH_2'};
        stimfirstlabels(2,250:264) = {'LPH_3'};
        
        stimfirstlabels(1,265:280) = {'LPH_3'};
        stimfirstlabels(2,265:280) = {'LPH_4'};
        
        stimfirstlabels(1,281:297) = {'LPH_4'};
        stimfirstlabels(2,281:297) = {'LPH_5'};
        
        stimfirstlabels(1,298:314) = {'LPH_5'};
        stimfirstlabels(2,298:314) = {'LPH_6'};
        
        stimfirstlabels(1,315:330) = {'LPH_6'};
        stimfirstlabels(2,315:330) = {'LPH_7'};
        
        stimfirstlabels(1,331:349) = {'LPH_7'};
        stimfirstlabels(2,331:349) = {'LPH_8'};
        
    case 'P08' %% 0606 variable

        stimfirstlabels(1,1:15) = {'RAH_1'};
        stimfirstlabels(2,1:15) = {'RAH_2'};
        
        stimfirstlabels(1,[16:30, 137:153]) = {'RAH_2'};
        stimfirstlabels(2,[16:30, 137:153]) = {'RAH_3'};
        
        stimfirstlabels(1,31:52) = {'RAH_3'};
        stimfirstlabels(2,31:52) = {'RAH_4'};
        
        stimfirstlabels(1,53:68) = {'RAH_4'};
        stimfirstlabels(2,53:68) = {'RAH_5'};
        
        stimfirstlabels(1,69:84) = {'RAH_5'};
        stimfirstlabels(2,69:84) = {'RAH_6'};
        
        stimfirstlabels(1,85:101) = {'RAH_6'};
        stimfirstlabels(2,85:101) = {'RAH_7'};
        
        stimfirstlabels(1,102:118) = {'RAH_7'};
        stimfirstlabels(2,102:118) = {'RAH_8'};
        
        stimfirstlabels(1,119:136) = {'RMH_1'};
        stimfirstlabels(2,119:136) = {'RMH_2'};
        
        stimfirstlabels(1,154:172) = {'RMH_2'};
        stimfirstlabels(2,154:172) = {'RMH_3'};
        
        stimfirstlabels(1,173:187) = {'RMH_3'};
        stimfirstlabels(2,173:187) = {'RMH_4'};
        
        stimfirstlabels(1,188:204) = {'RMH_4'};
        stimfirstlabels(2,188:204) = {'RMH_5'};
        
        stimfirstlabels(1,205:222) = {'RMH_5'};
        stimfirstlabels(2,205:222) = {'RMH_6'};
        
        stimfirstlabels(1,223:237) = {'RMH_6'};
        stimfirstlabels(2,223:237) = {'RMH_7'};
        
        stimfirstlabels(1,238:254) = {'RMH_7'};
        stimfirstlabels(2,238:254) = {'RMH_8'};
        
        stimfirstlabels(1,255:270) = {'RPH_1'};
        stimfirstlabels(2,255:270) = {'RPH_2'};
        
        stimfirstlabels(1,271:285) = {'RPH_2'};
        stimfirstlabels(2,271:285) = {'RPH_3'};
        
        stimfirstlabels(1,286:300) = {'RPH_3'};
        stimfirstlabels(2,286:300) = {'RPH_4'};
        
        stimfirstlabels(1,301:317) = {'RPH_4'};
        stimfirstlabels(2,301:317) = {'RPH_5'};
        
        stimfirstlabels(1,318:333) = {'RPH_5'};
        stimfirstlabels(2,318:333) = {'RPH_6'};
        
        stimfirstlabels(1,334:352) = {'RPH_6'};
        stimfirstlabels(2,334:352) = {'RPH_7'};
        
        stimfirstlabels(1,353:369) = {'RPH_7'};
        stimfirstlabels(2,353:369) = {'RPH_8'};
    case 'P09'

        stimfirstlabels(1,1:20) = {'LAH_1'};
        stimfirstlabels(2,1:20) = {'LAH_2'};
        
        stimfirstlabels(1,21:37) = {'LAH_2'};
        stimfirstlabels(2,21:37) = {'LAH_3'};
        
        stimfirstlabels(1,38:53) = {'LAH_3'};
        stimfirstlabels(2,38:53) = {'LAH_4'};
              
        stimfirstlabels(1,54:69) = {'LAH_4'};
        stimfirstlabels(2,54:69) = {'LAH_5'};
        
        stimfirstlabels(1,70:85) = {'LAH_5'};
        stimfirstlabels(2,70:85) = {'LAH_6'};
        
        stimfirstlabels(1,86:103) = {'LAH_6'};
        stimfirstlabels(2,86:103) = {'LAH_7'};
        
        stimfirstlabels(1,104:122) = {'LAH_7'};
        stimfirstlabels(2,104:122) = {'LAH_8'};
        
        stimfirstlabels(1,122:137) = {'LMH_1'};
        stimfirstlabels(2,122:137) = {'LMH_2'};
        
        stimfirstlabels(1,138:152) = {'LMH_2'};
        stimfirstlabels(2,138:152) = {'LMH_3'};
        
        stimfirstlabels(1,153:168) = {'LMH_3'};
        stimfirstlabels(2,153:168) = {'LMH_4'};
        
        stimfirstlabels(1,169:185) = {'LMH_4'};
        stimfirstlabels(2,169:185) = {'LMH_5'};
        
        stimfirstlabels(1,186:205) = {'LMH_5'};
        stimfirstlabels(2,186:205) = {'LMH_6'};
        
        stimfirstlabels(1,206:227) = {'LMH_6'};
        stimfirstlabels(2,206:227) = {'LMH_7'};
        
        stimfirstlabels(1,228:238) = {'LMH_7'};
        stimfirstlabels(2,228:238) = {'LMH_8'};
        
        stimfirstlabels(1,239:261) = {'LPH_2'};
        stimfirstlabels(2,239:261) = {'LPH_3'};
        
        stimfirstlabels(1,262:282) = {'LPH_3'};
        stimfirstlabels(2,262:282) = {'LPH_4'};
        
        stimfirstlabels(1,283:296) = {'LPH_4'};
        stimfirstlabels(2,283:296) = {'LPH_5'};
        
        stimfirstlabels(1,297:312) = {'LPH_5'};
        stimfirstlabels(2,297:312) = {'LPH_6'};
        
        stimfirstlabels(1,313:327) = {'LPH_6'};
        stimfirstlabels(2,313:327) = {'LPH_7'};
        
        stimfirstlabels(1,328:342) = {'LPH_7'};
        stimfirstlabels(2,328:342) = {'LPH_8'};
        
        stimfirstlabels(1,343:360) = {'LPHG_1'};
        stimfirstlabels(2,343:360) = {'LPHG_2'};
        
        stimfirstlabels(1,361:377) = {'LPHG_2'};
        stimfirstlabels(2,361:377) = {'LPHG_3'};
        
        stimfirstlabels(1,378:393) = {'LPHG_3'};
        stimfirstlabels(2,378:393) = {'LPHG_4'};
        
        stimfirstlabels(1,394:409) = {'LPHG_4'};
        stimfirstlabels(2,394:409) = {'LPHG_5'};
        
        stimfirstlabels(1,410:429) = {'LPHG_5'};
        stimfirstlabels(2,410:429) = {'LPHG_6'};
        
        stimfirstlabels(1,430:444) = {'LPHG_6'};
        stimfirstlabels(2,430:444) = {'LPHG_7'};
        
        stimfirstlabels(1,445:446) = {'LPHG_7'};
        stimfirstlabels(2,445:446) = {'LPHG_8'};
        
  
    case 'P102'       
        stimfirstlabels(1,1:18) = {'LAH_1'};
        stimfirstlabels(2,1:19) = {'LAH_2'};
        
        stimfirstlabels(1,19:35) = {'LAH_2'};
        stimfirstlabels(2,19:35) = {'LAH_3'};
        
        stimfirstlabels(1,36:50) = {'LAH_3'};
        stimfirstlabels(2,36:50) = {'LAH_4'};
        
        stimfirstlabels(1,51:65) = {'LAH_4'};
        stimfirstlabels(2,51:65) = {'LAH_5'};
        
        stimfirstlabels(1,66:80) = {'LAH_5'};
        stimfirstlabels(2,66:80) = {'LAH_6'};
        
        stimfirstlabels(1,81:95) = {'LAH_6'};
        stimfirstlabels(2,81:95) = {'LAH_7'};
        
        stimfirstlabels(1,96:110) = {'LMH_1'};
        stimfirstlabels(2,96:110) = {'LMH_2'};
        
        stimfirstlabels(1,111:125) = {'LMH_2'};
        stimfirstlabels(2,111:125) = {'LMH_3'};
        
        stimfirstlabels(1,[126:140,216,217]) = {'LMH_3'};
        stimfirstlabels(2,[126:140,216,217]) = {'LMH_4'};
        
        stimfirstlabels(1,141:155) = {'LMH_4'};
        stimfirstlabels(2,141:155) = {'LMH_5'};
        
        stimfirstlabels(1,156:170) = {'LMH_5'};
        stimfirstlabels(2,156:170) = {'LMH_6'};
        
        stimfirstlabels(1,171:185) = {'LMH_6'};
        stimfirstlabels(2,171:185) = {'LMH_7'};
        
        stimfirstlabels(1,186:200) = {'LPH_1'};
        stimfirstlabels(2,186:200) = {'LPH_2'};
        
        stimfirstlabels(1,201:215) = {'LPH_2'};
        stimfirstlabels(2,201:215) = {'LPH_3'};
        
        stimfirstlabels(1,218:232) = {'LPH_3'};
        stimfirstlabels(2,218:232) = {'LPH_4'};
        
        stimfirstlabels(1,233:247) = {'LPH_4'};
        stimfirstlabels(2,233:247) = {'LPH_5'};
        
        stimfirstlabels(1,248:262) = {'LPH_5'};
        stimfirstlabels(2,248:262) = {'LPH_6'};
        
        stimfirstlabels(1,263:277) = {'LPH_6'};
        stimfirstlabels(2,263:277) = {'LPH_7'};
      case 'P10'

        stimfirstlabels(1,1:20) = {'RAH_1'};
        stimfirstlabels(2,1:20) = {'RAH_2'};
        
        stimfirstlabels(1,21:35) = {'RAH_2'};
        stimfirstlabels(2,21:35) = {'RAH_3'};
        
        stimfirstlabels(1,36:50) = {'RAH_3'};
        stimfirstlabels(2,36:50) = {'RAH_4'};
        
        stimfirstlabels(1,51:65) = {'RAH_4'};
        stimfirstlabels(2,51:65) = {'RAH_5'};
        
        stimfirstlabels(1,66:80) = {'RAH_5'};
        stimfirstlabels(2,66:80) = {'RAH_6'};
        
        stimfirstlabels(1,81:95) = {'RAH_6'};
        stimfirstlabels(2,81:95) = {'RAH_7'};
        
        stimfirstlabels(1,96:110) = {'RMH_1'};
        stimfirstlabels(2,96:110) = {'RMH_2'};
        
        stimfirstlabels(1,111:125) = {'RMH_2'};
        stimfirstlabels(2,111:125) = {'RMH_3'};
        
        stimfirstlabels(1,126:140) = {'RMH_3'};
        stimfirstlabels(2,126:140) = {'RMH_4'};
        
        stimfirstlabels(1,141:155) = {'RMH_4'};
        stimfirstlabels(2,141:155) = {'RMH_5'};
        
        stimfirstlabels(1,156:170) = {'RMH_5'};
        stimfirstlabels(2,156:170) = {'RMH_6'};
        
        stimfirstlabels(1,171:185) = {'RMH_6'};
        stimfirstlabels(2,171:185) = {'RMH_7'};
        
        stimfirstlabels(1,186:200) = {'RPH_1'};
        stimfirstlabels(2,186:200) = {'RPH_2'};
        
        stimfirstlabels(1,201:215) = {'RPH_2'};
        stimfirstlabels(2,201:215) = {'RPH_3'};
        
        stimfirstlabels(1,216:230) = {'RPH_3'};
        stimfirstlabels(2,216:230) = {'RPH_4'};
        
        stimfirstlabels(1,231:245) = {'RPH_4'};
        stimfirstlabels(2,231:245) = {'RPH_5'};
        
        stimfirstlabels(1,246:260) = {'RPH_5'};
        stimfirstlabels(2,246:260) = {'RPH_6'};
        
        stimfirstlabels(1,261:275) = {'RPH_6'};
        stimfirstlabels(2,261:275) = {'RPH_7'};
        
        
    case 'P112'
        stimfirstlabels(1,1:15) = {'RAH_1'};
        stimfirstlabels(2,1:15) = {'RAH_2'};
        
        stimfirstlabels(1,16:30) = {'RAH_2'};
        stimfirstlabels(2,16:30) = {'RAH_3'};
        
        stimfirstlabels(1,31:45) = {'RAH_3'};
        stimfirstlabels(2,31:45) = {'RAH_4'};
        
        stimfirstlabels(1,46:60) = {'RAH_4'};
        stimfirstlabels(2,46:60) = {'RAH_5'};
        
        stimfirstlabels(1,61:75) = {'RAH_5'};
        stimfirstlabels(2,61:75) = {'RAH_6'};
        
        stimfirstlabels(1,76:90) = {'RAH_6'};
        stimfirstlabels(2,76:90) = {'RAH_7'};
        
        stimfirstlabels(1,91:105) = {'RAH_7'};
        stimfirstlabels(2,91:105) = {'RAH_8'};
        
        stimfirstlabels(1,106:120) = {'RPH_1'};
        stimfirstlabels(2,106:120) = {'RPH_2'};
        
        stimfirstlabels(1,121:135) = {'RPH_2'};
        stimfirstlabels(2,121:135) = {'RPH_3'};
        
        stimfirstlabels(1,136:150) = {'RPH_3'};
        stimfirstlabels(2,136:150) = {'RPH_4'};
        
        stimfirstlabels(1,151:164) = {'RPH_4'};
        stimfirstlabels(2,151:164) = {'RPH_5'};
        
        stimfirstlabels(1,165:179) = {'RPH_5'};
        stimfirstlabels(2,165:179) = {'RPH_6'};
        
        stimfirstlabels(1,180:194) = {'RPH_6'};
        stimfirstlabels(2,180:194) = {'RPH_7'};
    case 'P11'
        
        stimfirstlabels(1,1:16) = {'LPH_1'};
        stimfirstlabels(2,1:16) = {'LPH_2'};
        
        stimfirstlabels(1,17:31) = {'LPH_2'};
        stimfirstlabels(2,17:31) = {'LPH_3'};
        
        stimfirstlabels(1,32:47) = {'LPH_3'};
        stimfirstlabels(2,32:47) = {'LPH_4'};
        
        stimfirstlabels(1,48:62) = {'LPH_4'};
        stimfirstlabels(2,48:62) = {'LPH_5'};
        
        stimfirstlabels(1,63:77) = {'LPH_5'};
        stimfirstlabels(2,63:77) = {'LPH_6'};
        
        stimfirstlabels(1,78:92) = {'LPH_6'};
        stimfirstlabels(2,78:92) = {'LPH_7'};
        
        stimfirstlabels(1,93:107) = {'LPH_7'};
        stimfirstlabels(2,93:107) = {'LPH_8'};
        
        stimfirstlabels(1,108:123) = {'LMSTG_1'};
        stimfirstlabels(2,108:123) = {'LMSTG_2'};
        
        stimfirstlabels(1,[124:138]) = {'LMSTG_2'};
        stimfirstlabels(2,[124:138]) = {'LMSTG_3'};
        
        stimfirstlabels(1,139:153) = {'LMSTG_3'};
        stimfirstlabels(2,139:153) = {'LMSTG_4'};
        
        stimfirstlabels(1,154:156) = {'LMSTG_4'};
        stimfirstlabels(2,154:156) = {'LMSTG_5'};
        
        stimfirstlabels(1,157:171) = {'LpITG_1'};
        stimfirstlabels(2,157:171) = {'LpITG_2'};
        
        stimfirstlabels(1,172:179) = {'LpITG_2'};
        stimfirstlabels(2,172:179) = {'LpITG_3'};
        
%     case 'P112'
%         stimfirstlabels(1,[1:16]) = {'LPSTG_1'};
%         stimfirstlabels(2,[1:16]) = {'LPSTG_2'};
%         
%         stimfirstlabels(1,17:31) = {'LPSTG_2'};
%         stimfirstlabels(2,17:31) = {'LPSTG_3'};
%         
%         stimfirstlabels(1,32:46) = {'LPSTG_3'};
%         stimfirstlabels(2,32:46) = {'LPSTG_4'};
%         
%         stimfirstlabels(1,47:61) = {'LPSTG_4'};
%         stimfirstlabels(2,47:61) = {'LPSTG_5'};
%         
%         stimfirstlabels(1,62:76) = {'LPSTG_5'};
%         stimfirstlabels(2,62:76) = {'LPSTG_6'};
%         
%         stimfirstlabels(1,159:164) = {'LPSTGr_5'};
%         stimfirstlabels(2,159:164) = {'LPSTGr_6'};
%         
%         stimfirstlabels(1,[77:82]) = {'LPSTG_6'};
%         stimfirstlabels(2,[77:82]) = {'LPSTG_7'};
%         
%         stimfirstlabels(1,83:97) = {'LSMG_1'};
%         stimfirstlabels(2,83:97) = {'LSMG_2'};
%        
%         stimfirstlabels(1,145:151) = {'LSMGr_1'};
%         stimfirstlabels(2,145:151) = {'LSMGr_2'};
%         
%         stimfirstlabels(1,98:112) = {'LSMG_2'};
%         stimfirstlabels(2,98:112) = {'LSMG_3'};
%         
%         stimfirstlabels(1,152:153) = {'LSMGr_2'};
%         stimfirstlabels(2,152:153) = {'LSMGr_3'};
%         
%         stimfirstlabels(1,113:127) = {'LSMG_3'};
%         stimfirstlabels(2,113:127) = {'LSMG_4'};
%         
%         stimfirstlabels(1,154:156) = {'LSMGr_3'};
%         stimfirstlabels(2,154:156) = {'LSMGr_4'};
%         
%         stimfirstlabels(1,128:142) = {'LSMG_4'};
%         stimfirstlabels(2,128:142) = {'LSMG_5'};
%         
%         stimfirstlabels(1,157:158) = {'LSMG_4'};
%         stimfirstlabels(2,157:158) = {'LSMG_5'};
%         
%         stimfirstlabels(1,143:144) = {'LSMG_5'};
%         stimfirstlabels(2,143:144) = {'LSMG_6'};
%     case 'P113'
    case 'P05'
        stimfirstlabels(1,1:6) = {'REnt_1'};
        stimfirstlabels(2,1:6) = {'REnt_2'};
        
        stimfirstlabels(1,7:16) = {'REnt_5'};
        stimfirstlabels(2,7:16) = {'REnt_6'};
        
        stimfirstlabels(1,17:21) = {'REnt_6'};
        stimfirstlabels(2,17:21) = {'REnt_7'};
        
        stimfirstlabels(1,22:29) = {'REnt_7'};
        stimfirstlabels(2,22:29) = {'REnt_8'};
        
        stimfirstlabels(1,30:35) = {'RAH_1'};
        stimfirstlabels(2,30:35) = {'RAH_2'};
        
        stimfirstlabels(1,36:44) = {'RAH_7'};
        stimfirstlabels(2,36:44) = {'RAH_8'};
        
        stimfirstlabels(1,45:53) = {'RMH_1'};
        stimfirstlabels(2,45:53) = {'RMH_2'};
        
        stimfirstlabels(1,54:56) = {'RMH_5'};
        stimfirstlabels(2,54:56) = {'RMH_6'};
        
        stimfirstlabels(1,57:71) = {'RMH_6'};
        stimfirstlabels(2,57:71) = {'RMH_7'};
        
        stimfirstlabels(1,72:78) = {'RMH_7'};
        stimfirstlabels(2,72:78) = {'RMH_8'};
        
        stimfirstlabels(1,79:86) = {'RPH_1'};
        stimfirstlabels(2,79:86) = {'RPH_2'};
        
        stimfirstlabels(1,87:96) = {'RPH_5'};
        stimfirstlabels(2,87:96) = {'RPH_6'};
        
        stimfirstlabels(1,97:105) = {'RPH_6'};
        stimfirstlabels(2,97:105) = {'RPH_7'};
        
        stimfirstlabels(1,106:113) = {'RPH_7'};
        stimfirstlabels(2,106:113) = {'RPH_8'};
        
        stimfirstlabels(1,114:126) = {'RMTG_1'};
        stimfirstlabels(2,114:126) = {'RMTG_2'};
         
        stimfirstlabels(1,127:133) = {'RAG_1'};
        stimfirstlabels(2,127:133) = {'RAG_2'};
         
        stimfirstlabels(1,134:140) = {'RAG_2'};
        stimfirstlabels(2,134:140) = {'RAG_3'};
         
        stimfirstlabels(1,141:147) = {'RAG_3'};
        stimfirstlabels(2,141:147) = {'RAG_4'};
         
        stimfirstlabels(1,148:157) = {'RFl_1'};
        stimfirstlabels(2,148:157) = {'RFl_2'};
         
        stimfirstlabels(1,158:173) = {'RFl_11'};
        stimfirstlabels(2,158:173) = {'RFl_12'};
         
        stimfirstlabels(1,174:181) = {'LEnt_1'};
        stimfirstlabels(2,174:181) = {'LEnt_2'};
         
        stimfirstlabels(1,182:186) = {'LEnt_5'};
        stimfirstlabels(2,182:186) = {'LEnt_6'};
         
        stimfirstlabels(1,187:191) = {'LEnt_6'};
        stimfirstlabels(2,187:191) = {'LEnt_7'};
         
        stimfirstlabels(1,192:196) = {'LEnt_7'};
        stimfirstlabels(2,192:196) = {'LEnt_8'};
         
        stimfirstlabels(1,197:200) = {'LAH_1'};
        stimfirstlabels(2,197:200) = {'LAH_2'};
         
        stimfirstlabels(1,201:208) = {'LAH_5'};
        stimfirstlabels(2,201:208) = {'LAH_6'};
         
        stimfirstlabels(1,209:224) = {'LAH_6'};
        stimfirstlabels(2,209:224) = {'LAH_7'};
         
        stimfirstlabels(1,225:230) = {'LAH_7'};
        stimfirstlabels(2,225:230) = {'LAH_8'};
         
        stimfirstlabels(1,231:240) = {'LMH_1'};
        stimfirstlabels(2,231:240) = {'LMH_2'};
         
        stimfirstlabels(1,241:249) = {'LMH_5'};
        stimfirstlabels(2,241:249) = {'LMH_6'};
        
        stimfirstlabels(1,250:256) = {'LMH_6'};
        stimfirstlabels(2,250:256) = {'LMH_7'};
        
        stimfirstlabels(1,257:263) = {'LMH_7'};
        stimfirstlabels(2,257:263) = {'LMH_8'};
        
        stimfirstlabels(1,264:269) = {'LPH_1'};
        stimfirstlabels(2,264:269) = {'LPH_2'};
          
        stimfirstlabels(1,270:276) = {'LPH_5'};
        stimfirstlabels(2,270:276) = {'LPH_6'};
          
        stimfirstlabels(1,277:281) = {'LPH_6'};
        stimfirstlabels(2,277:281) = {'LPH_7'};
          
        stimfirstlabels(1,282:287) = {'LPH_7'};
        stimfirstlabels(2,282:287) = {'LPH_8'};
          
        stimfirstlabels(1,288:292) = {'LMTG_1'};
        stimfirstlabels(2,288:292) = {'LMTG_2'};
          
        stimfirstlabels(1,293:297) = {'LAG_1'};
        stimfirstlabels(2,293:297) = {'LAG_2'};
          
        stimfirstlabels(1,298:302) = {'LAG_2'};
        stimfirstlabels(2,298:302) = {'LAG_3'};
          
        stimfirstlabels(1,303:308) = {'LAG_3'};
        stimfirstlabels(2,303:308) = {'LAG_4'};
         
    case 'P06'
        stimfirstlabels(1,1:13) = {'RAH_1'};
        stimfirstlabels(2,1:13) = {'RAH_2'};
        
        stimfirstlabels(1,14:27) = {'RAH_2'};
        stimfirstlabels(2,14:27) = {'RAH_3'};
        
        stimfirstlabels(1,28:54) = {'RAH_4'};
        stimfirstlabels(2,28:54) = {'RAH_5'};
        
        stimfirstlabels(1,55:66) = {'RAH_5'};
        stimfirstlabels(2,55:66) = {'RAH_6'};
        
        stimfirstlabels(1,67:76) = {'RAH_6'};
        stimfirstlabels(2,67:76) = {'RAH_7'};
        
        stimfirstlabels(1,77:80) = {'RAH_7'};
        stimfirstlabels(2,77:80) = {'RAH_8'};
        
        stimfirstlabels(1,81:92) = {'RMH_1'};
        stimfirstlabels(2,81:92) = {'RMH_2'};
        
        stimfirstlabels(1,93:104) = {'RMH_2'};
        stimfirstlabels(2,93:104) = {'RMH_3'};
        
        stimfirstlabels(1,105:124) = {'RMH_3'};
        stimfirstlabels(2,105:124) = {'RMH_4'};
        
        stimfirstlabels(1,125:136) = {'RMH_4'};
        stimfirstlabels(2,125:136) = {'RMH_5'};
        
        stimfirstlabels(1,137:147) = {'RMH_5'};
        stimfirstlabels(2,137:147) = {'RMH_6'};
        
        stimfirstlabels(1,148:155) = {'RMH_6'};
        stimfirstlabels(2,148:155) = {'RMH_7'};
        
        stimfirstlabels(1,156:158) = {'RMH_7'};
        stimfirstlabels(2,156:158) = {'RMH_8'};
        
        stimfirstlabels(1,159:169) = {'RPH_1'};
        stimfirstlabels(2,159:169) = {'RPH_2'};
        
        stimfirstlabels(1,170:179) = {'RPH_2'};
        stimfirstlabels(2,170:179) = {'RPH_3'};
        
        stimfirstlabels(1,180:200) = {'RPH_3'};
        stimfirstlabels(2,180:200) = {'RPH_4'};
        
        stimfirstlabels(1,201:217) = {'RPH_4'};
        stimfirstlabels(2,201:217) = {'RPH_5'};
        
        stimfirstlabels(1,218:227) = {'RPH_5'};
        stimfirstlabels(2,218:227) = {'RPH_6'};
        
        stimfirstlabels(1,228:236) = {'RPH_6'};
        stimfirstlabels(2,228:236) = {'RPH_7'};
        
        stimfirstlabels(1,237:259) = {'RPH_7'};
        stimfirstlabels(2,237:259) = {'RPH_8'};
        
        stimfirstlabels(1,260:274) = {'RMiSTG_1'};
        stimfirstlabels(2,260:274) = {'RMiSTG_2'};
        
        stimfirstlabels(1,275:286) = {'RMiSTG_2'};
        stimfirstlabels(2,275:286) = {'RMiSTG_3'};
        
        stimfirstlabels(1,287:294) = {'RMiSTG_3'};
        stimfirstlabels(2,287:294) = {'RMiSTG_4'};
        
        stimfirstlabels(1,295:302) = {'RMiSTG_4'};
        stimfirstlabels(2,295:302) = {'RMiSTG_5'};
        
        stimfirstlabels(1,303:314) = {'RPoMTG_1'};
        stimfirstlabels(2,303:314) = {'RPoMTG_2'};
        
        stimfirstlabels(1,315:332) = {'RPoMTG_2'};
        stimfirstlabels(2,315:332) = {'RPoMTG_3'};
        
        stimfirstlabels(1,333:342) = {'RPoMTG_3'};
        stimfirstlabels(2,333:342) = {'RPoMTG_4'};
        
        stimfirstlabels(1,343:365) = {'RPOF_1'};
        stimfirstlabels(2,343:365) = {'RPOF_2'};
        
        stimfirstlabels(1,366:376) = {'RPOF_2'};
        stimfirstlabels(2,366:376) = {'RPOF_3'};
        
        stimfirstlabels(1,377:401) = {'RPOF_3'};
        stimfirstlabels(2,377:401) = {'RPOF_4'};
        
        stimfirstlabels(1,402:415) = {'RPO_1'};
        stimfirstlabels(2,402:415) = {'RPO_2'};
        
        stimfirstlabels(1,416:428) = {'RPO_2'};
        stimfirstlabels(2,416:428) = {'RPO_3'};
        
        stimfirstlabels(1,429:446) = {'RPO_3'};
        stimfirstlabels(2,429:446) = {'RPO_4'};
        
        stimfirstlabels(1,447:463) = {'RPO_4'};
        stimfirstlabels(2,447:463) = {'RPO_5'};
        
        stimfirstlabels(1,464:474) = {'RFl_1'};
        stimfirstlabels(2,464:474) = {'RFl_2'};
        
        stimfirstlabels(1,475:488) = {'RFl_2'};
        stimfirstlabels(2,475:488) = {'RFl_3'};
         
        stimfirstlabels(1,489:501) = {'RFl_3'};
        stimfirstlabels(2,489:501) = {'RFl_4'};
        
        stimfirstlabels(1,502:512) = {'RFl_4'};
        stimfirstlabels(2,502:512) = {'RFl_5'};
        
        stimfirstlabels(1,513:518) = {'RFl_5'};
        stimfirstlabels(2,513:518) = {'RFl_6'};
        
        stimfirstlabels(1,519:527) = {'LMH_1'};
        stimfirstlabels(2,519:527) = {'LMH_2'};
        
        stimfirstlabels(1,528:533) = {'LMH_2'};
        stimfirstlabels(2,528:533) = {'LMH_3'};
        
        stimfirstlabels(1,534:546) = {'LMH_3'};
        stimfirstlabels(2,534:546) = {'LMH_4'};
        
        stimfirstlabels(1,547:554) = {'LMH_4'};
        stimfirstlabels(2,547:554) = {'LMH_5'};
        
        stimfirstlabels(1,555:561) = {'LMH_5'};
        stimfirstlabels(2,555:561) = {'LMH_6'};
        
        stimfirstlabels(1,562:568) = {'LMH_6'};
        stimfirstlabels(2,562:568) = {'LMH_7'};
        
        stimfirstlabels(1,569:582) = {'LPoT_1'};
        stimfirstlabels(2,569:582) = {'LPoT_2'};
        
        stimfirstlabels(1,583:590) = {'LPoT_2'};
        stimfirstlabels(2,583:590) = {'LPoT_3'};
        
        stimfirstlabels(1,591:597) = {'LPoT_3'};
        stimfirstlabels(2,591:597) = {'LPoT_4'};
                
        stimfirstlabels(1,598:601) = {'LPoT_4'};
        stimfirstlabels(2,598:601) = {'LPoT_5'};
        
        stimfirstlabels(1,602:608) = {'LFl_1'};
        stimfirstlabels(2,602:608) = {'LFl_2'};
        
        stimfirstlabels(1,609:617) = {'LFl_2'};
        stimfirstlabels(2,609:617) = {'LFl_3'};
        
        stimfirstlabels(1,618:625) = {'LFl_3'};
        stimfirstlabels(2,618:625) = {'LFl_4'};
        
    case 'P12'
        stimfirstlabels(1,1:24) = {'LEN_1'};
        stimfirstlabels(2,1:24) = {'LEN_2'};
        
        stimfirstlabels(1,25:41) = {'LEN_2'};
        stimfirstlabels(2,25:41) = {'LEN_3'};
        
        stimfirstlabels(1,42:58) = {'LEN_3'};
        stimfirstlabels(2,42:58) = {'LEN_4'};
        
        stimfirstlabels(1,59:76) = {'LEN_4'};
        stimfirstlabels(2,59:76) = {'LEN_5'};
        
        stimfirstlabels(1,77:94) = {'LEN_5'};
        stimfirstlabels(2,77:94) = {'LEN_6'};
              
        stimfirstlabels(1,95:112) = {'LAH_1'};
        stimfirstlabels(2,95:112) = {'LAH_2'};
        
        stimfirstlabels(1,113:130) = {'LAH_2'};
        stimfirstlabels(2,113:130) = {'LAH_3'};
        
        stimfirstlabels(1,131:147) = {'LAH_3'};
        stimfirstlabels(2,131:147) = {'LAH_4'};
        
        stimfirstlabels(1,148:162) = {'LAH_4'};
        stimfirstlabels(2,148:162) = {'LAH_5'};
        
        stimfirstlabels(1,163:180) = {'LAH_5'};
        stimfirstlabels(2,163:180) = {'LAH_6'};
        
        stimfirstlabels(1,181:197) = {'LAH_6'};
        stimfirstlabels(2,181:197) = {'LAH_7'};
        
    otherwise
        warning('subjID not valid');
end
