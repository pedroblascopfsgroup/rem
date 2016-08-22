
<%@tag import="es.capgemini.pfs.politica.model.Objetivo"%><%@ tag body-content="scriptless" %>
<%@ attribute name="value" required="true" type="java.util.Date"%>
<%
	java.util.Date fecha = (java.util.Date)jspContext.getAttribute("value");
	java.util.Calendar mesMin,mesMax,semanaMin,semanaMax,hoyMin,hoyMax;
	java.util.Calendar cal=java.util.Calendar.getInstance();
    try {
        int result=-1;
        
        //Fecha del objetivo
        cal.setTime(fecha);
    	//Limitadores hoy    
        hoyMin=java.util.Calendar.getInstance();
        hoyMin.set(java.util.Calendar.HOUR_OF_DAY,java.util.Calendar.getInstance().getMinimum(java.util.Calendar.HOUR_OF_DAY));
        hoyMin.set(java.util.Calendar.MINUTE,java.util.Calendar.getInstance().getMinimum(java.util.Calendar.MINUTE));
    	hoyMax=java.util.Calendar.getInstance();
    	hoyMax.set(java.util.Calendar.HOUR_OF_DAY,java.util.Calendar.getInstance().getMaximum(java.util.Calendar.HOUR_OF_DAY));
    	hoyMin.set(java.util.Calendar.MINUTE,java.util.Calendar.getInstance().getMaximum(java.util.Calendar.MINUTE));
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
	               	
      	
   		//Vencidas/Incumplidas (result = 0)
         if(cal.before(hoyMin)){
             result=0;
         }   
         else{
         	//Hoy (result = 1)
         	// hoyMinObj < fecha < hoyMax
         	if(cal.after(hoyMin)&&cal.before(hoyMax))
         	    result=1;
         	else
             	//	esta Semana (result = 2)
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
        
        
        jspContext.setAttribute("result", result);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>${result}