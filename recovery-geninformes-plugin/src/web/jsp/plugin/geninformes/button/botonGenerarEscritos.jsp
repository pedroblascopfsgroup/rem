<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

new Ext.Button({
    text:'<s:message code="plugin.geninformes.escritos.button.title" text="**Generar Escritos"/>'
    ,iconCls:'icon_comite_actas'
    ,handler: function() {
    	var idAsunto = null;
            
        if (typeof data === 'undefined'){
         	idAsunto = '${asunto.id}';
        }else{
        	idAsunto = data.id;
        }
        
        w = new Ext.Window({
            autoLoad: {
                    url : app.resolveFlow('geninfgenerarescritos/abreFormSeleccion')
                    ,scripts : true
                    ,params : {idAsunto:idAsunto}
            }
            ,width:520
            ,title : '<s:message code="plugin.geninformes.escritos.window.title" text="**Generar Escritos" />'
            ,height:140
            ,closable:false
            ,resizable: true
            ,modal:true
            ,layout:'form'
            ,autoShow:true    
            ,x:300
            ,y:150
            ,bodyBorder : false
        });
        
        w.on(app.event.DONE, function(){
            w.close();
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
        w.show();
    }
})
            
