<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

new Ext.Button({
    text:'<s:message code="plugin.expediente.exceptuacion.boton.persona.title" text="**Exceptuar persona"/>'
    ,iconCls:'icon_deletePersona'
    ,handler: function() {
        w = new Ext.Window({
            autoLoad: {
                    url : app.resolveFlow('exceptuacion/abrirVentanaExceptuacion')
                    ,scripts : true
                    ,params : {id:data.id,tipo:'1'}
            }
            ,width:500
            ,title : '<s:message code="plugin.expediente.exceptuacion.boton.persona.title" text="**Exceptuar persona" />'
            ,height:250
            ,closable:true
            ,resizable: true
            ,modal:true
            ,layout:'fit'
            ,autoShow:true    
            ,x:250
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
            
