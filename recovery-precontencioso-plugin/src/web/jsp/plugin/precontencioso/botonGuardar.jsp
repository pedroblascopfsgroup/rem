//mostramos el botón guardar cuando la tarea no está terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){ 
							anyadirFechaFaltante(response);
						}
			});
		}
	});
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)
	{
		bottomBar.push(btnGuardar);
	}
	muestraBotonGuardar = 0;
</c:if>

if (muestraBotonGuardar==1){
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){ 
							anyadirFechaFaltante(response);
						}
			});
		}
	});
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)	{
		bottomBar.push(btnGuardar);
	}
}