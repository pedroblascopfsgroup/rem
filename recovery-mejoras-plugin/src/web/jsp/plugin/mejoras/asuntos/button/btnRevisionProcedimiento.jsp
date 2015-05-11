<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

	new Ext.Button({
        text:'<s:message code="plugin.mejoras.asuntos.btnRevisionProcedimientos" text="**Revision procedimientos" />'
        ,iconCls:'icon_elevar_comite'
        ,handler: function() {
        
         var page = new fwk.Page("pfs", "", "", "");
        	var idAsunto=data.id;
        	
        	var w = app.openWindow({
							flow : 'revisionprocedimiento/getPageRevisionProcedimiento'
							,width:950
							,closable:true
							,title : '<s:message code="plugin.mejoras.asuntos.btnRevisionProcedimientos" text="**Revision procedimientos" />' 
							,params : {idAsunto:idAsunto}
						});
			w.on(app.event.DONE, function(){
					
							w.close();
						});
			w.on(app.event.CANCEL, function(){ 
			w.close(); });
           
        }
    })
    
    
   
				