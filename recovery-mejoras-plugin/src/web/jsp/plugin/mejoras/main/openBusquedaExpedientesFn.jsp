<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
{
    open: function(){
     	var mascara = new Ext.LoadMask(app.contenido.el.dom, {msg:'Abriendo búsqueda de expedientes...'});
        mascara.show();
        
        app.openTab("<s:message code="expedientes" text="**Expedientes"/>", 
	        "expedientes/listadoExpedientes",
	        {},
	        {id:'busqueda_expedientes',iconCls:'icon_busquedas'}
        );
     	
     	mascara.hide();   
    }
}