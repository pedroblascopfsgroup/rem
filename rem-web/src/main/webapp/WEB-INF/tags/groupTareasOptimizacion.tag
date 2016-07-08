<%@ tag body-content="scriptless" %>
<%@ attribute name="value" required="true" type="es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.GroupTareasDataInfo"%>
<%
Object obj = jspContext.getAttribute("value");
es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.GroupTareasDataInfo tarea = null;
int result=-1;
if(obj != null){
    try{
        tarea= (es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.GroupTareasDataInfo) obj;    
    }catch(Exception e){
        e.printStackTrace();
    }
    if(tarea != null){
        boolean esNotificacion= (tarea.getCodigoTarea()!=null && tarea.getCodigoTarea().equals("3") && tarea.getAlerta()==0);
        java.util.Date fecha = null;
        if(esNotificacion)
            fecha=tarea.getFechaInicio();
        else
            fecha=tarea.getFechaVenc();
        if(fecha != null && !"".equals(fecha)){            
            java.util.Calendar mesMin,mesMax,semanaMin,semanaMax,hoyMin,hoyMax;
            java.util.Calendar cal=java.util.Calendar.getInstance();
            try {         
                //Fecha de la tarea (Vencimiento o Inicio, segun tipo)
                cal.setTime(fecha);
                //Limitadores hoy    
                hoyMin=java.util.Calendar.getInstance();
                hoyMin.set(java.util.Calendar.HOUR_OF_DAY,-1);
                hoyMax=java.util.Calendar.getInstance();
                hoyMax.set(java.util.Calendar.HOUR_OF_DAY,java.util.Calendar.getInstance().getMaximum(java.util.Calendar.HOUR_OF_DAY));
                //Limitadores Semana
                semanaMin=java.util.Calendar.getInstance();
                   semanaMin.set(java.util.Calendar.DAY_OF_WEEK,java.util.Calendar.MONDAY);
                   semanaMax=java.util.Calendar.getInstance();
                   semanaMax.set(java.util.Calendar.DAY_OF_WEEK,java.util.Calendar.SUNDAY);
                //Limitadores Mes
                mesMin=java.util.Calendar.getInstance();
                mesMin.set(java.util.Calendar.DAY_OF_MONTH,java.util.Calendar.getInstance().getMinimum(java.util.Calendar.DAY_OF_MONTH));
                mesMax=java.util.Calendar.getInstance();
                mesMax.set(java.util.Calendar.DAY_OF_MONTH,java.util.Calendar.getInstance().getMaximum(java.util.Calendar.DAY_OF_MONTH));
                               
                  if(!esNotificacion){
                      //Vencidas/Incumplidas (result = 0)
                    // fecha < hoyMin
                    if(cal.before(hoyMin)){
                        result=0;
                    }   
                    else{
                        //Hoy (result = 1)
                        // hoyMin < fecha < hoyMax
                        if(cal.after(hoyMin)&&cal.before(hoyMax))
                            result=1;
                        else
                            //    esta Semana (result = 2)
                            // MinimoSemana < fecha < MaxSemana
                            if(cal.after(semanaMin)&&cal.before(semanaMax))
                                result=2;
                            else
                                  //Este Mes (result = 3)
                                  // MinimoMes < fecha < MaxMes
                                   if(cal.after(mesMin) && cal.before(mesMax))
                                       result=3;
                                   else 
                                    //Proximos meses (result = 4)
                                    // fecha > MaxMes
                                    if(cal.after(mesMax))
                                        result = 4;                        
                    }    
                }else{
                    //Cuando es Notificacion, se evalua al reves
                    //Hoy (result=5)
                    // hoyMin < fecha < hoyMax
                    if(cal.after(hoyMin)&&cal.before(hoyMax))
                        result=1;
                    else
                        //Esta Semana
                        // semanaMin < fecha < hoyMin
                        if(cal.after(semanaMin) && cal.before(hoyMin))
                            result=2;
                        else
                            //Este Mes
                            // mesMin < fecha < semanaMin
                            if(cal.after(mesMin)&&cal.before(semanaMin))
                                result=3;
                            else
                                //Meses Anteriores
                                // fecha < mesMin
                                if(cal.before(mesMin))
                                    result=5;
                }                     
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
try{
    jspContext.setAttribute("result", result);
} catch (Exception e) {
    e.printStackTrace();
}
%>${result}