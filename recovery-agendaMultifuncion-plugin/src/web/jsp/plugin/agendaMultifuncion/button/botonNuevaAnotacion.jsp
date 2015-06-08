<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

new Ext.Button({
    text:'<s:message code="asunto.boton.anotacion" text="**Anotacion"/>'
    ,iconCls:'icon_comunicacion'
    ,handler: function() {
    	var idAsunto = null;
            
        if (typeof data === 'undefined'){
         	idAsunto = '${asunto.id}';
        }else{
        	idAsunto = data.id;
        }
        
        w = new Ext.Window({
            autoLoad: {
                    url : app.resolveFlow('recoveryagendamultifuncionanotacion/anotacionWindow')
                    ,scripts : true
                    ,params : {id:idAsunto,codUg:'3'}
            }
            ,width:600
            ,title : '<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.window.title" text="**Crear anotacion" />'
            ,height:600
            ,closable:false
            ,resizable: true
            ,modal:true
            ,layout:'fit'
            ,autoShow:true    
            ,x:50
            ,y:0
            ,bodyBorder : false
        });
        
        w.on(app.event.DONE, function(){
            w.close();
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
        w.show();
    }
})
            
