<%@ tag body-content="scriptless" %>
<%@ attribute name="value" required="true" type="es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion"%>
<%
	es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion tarea= (es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion)jspContext.getAttribute("value");
	boolean esNotificacion= (tarea.getCodigoTarea()!=null && tarea.getCodigoTarea().equals("3")&&!tarea.getAlerta());
	java.util.Date fecha = null;
	if(esNotificacion)
	    fecha=tarea.getFechaInicio();
	else
	    fecha=tarea.getFechaVenc();
	java.util.Calendar mesMin,mesMax,semanaMin,semanaMax,hoyMin,hoyMax;
	java.util.Calendar cal=java.util.Calendar.getInstance();
    try {
        int result=-1;
        
        //Fecha de la tarea (Vencimiento o Inicio, segun tipo)
        cal.setTime(fecha);
    	//Limitadores hoy    
        hoyMin=java.util.Calendar.getInstance();
        hoyMin.set(java.util.Calendar.HOUR_OF_DAY,java.util.Calendar.getInstance().getMinimum(java.util.Calendar.HOUR_OF_DAY));
        hoyMin.set(java.util.Calendar.MINUTE, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.MINUTE));
        hoyMin.set(java.util.Calendar.SECOND, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.SECOND));       
        
    	hoyMax=java.util.Calendar.getInstance();
    	hoyMax.set(java.util.Calendar.HOUR_OF_DAY, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.HOUR_OF_DAY));
    	hoyMax.set(java.util.Calendar.MINUTE, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.MINUTE));
    	hoyMax.set(java.util.Calendar.SECOND, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.SECOND));
    	
    	//Limitadores Semana
    	semanaMin=java.util.Calendar.getInstance();
       	semanaMin.set(java.util.Calendar.DAY_OF_WEEK,java.util.Calendar.MONDAY);
       	semanaMin.set(java.util.Calendar.HOUR_OF_DAY, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.HOUR_OF_DAY));
       	semanaMin.set(java.util.Calendar.MINUTE, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.MINUTE));
       	semanaMin.set(java.util.Calendar.SECOND, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.SECOND));
       	
       	semanaMax=java.util.Calendar.getInstance();
       	semanaMax.set(java.util.Calendar.DAY_OF_WEEK,java.util.Calendar.SUNDAY);
       	semanaMax.set(java.util.Calendar.HOUR_OF_DAY, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.HOUR_OF_DAY));
       	semanaMax.set(java.util.Calendar.MINUTE, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.MINUTE));
       	semanaMax.set(java.util.Calendar.SECOND, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.SECOND));
       	
    	//Limitadores Mes
	    mesMin=java.util.Calendar.getInstance();
    	mesMin.set(java.util.Calendar.DAY_OF_MONTH,java.util.Calendar.getInstance().getMinimum(java.util.Calendar.DAY_OF_MONTH));
    	mesMin.set(java.util.Calendar.HOUR_OF_DAY, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.HOUR_OF_DAY));
    	mesMin.set(java.util.Calendar.MINUTE, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.MINUTE));
    	mesMin.set(java.util.Calendar.SECOND, java.util.Calendar.getInstance().getMinimum(java.util.Calendar.SECOND));
    	
		mesMax=java.util.Calendar.getInstance();
		mesMax.set(java.util.Calendar.DAY_OF_MONTH,java.util.Calendar.getInstance().getMaximum(java.util.Calendar.DAY_OF_MONTH));
		mesMax.set(java.util.Calendar.HOUR_OF_DAY, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.HOUR_OF_DAY));
		mesMax.set(java.util.Calendar.MINUTE, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.MINUTE));
		mesMax.set(java.util.Calendar.SECOND, java.util.Calendar.getInstance().getMaximum(java.util.Calendar.SECOND));
	               	
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
        
        jspContext.setAttribute("result", result);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>${result}