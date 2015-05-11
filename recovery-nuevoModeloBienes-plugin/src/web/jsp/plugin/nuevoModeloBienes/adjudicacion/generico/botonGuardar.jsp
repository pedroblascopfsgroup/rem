//mostramos el botón guardar cuando la tarea no está terminada y cuando no hay errores de validacion
var contEjecuciones = 0;
var errorProcesado = '';

var ejecutaGuardar = function() {

	var formulario = panelEdicion.getForm();		
	if (formulario.isValid()){
		panelEdicion.el.mask('Calculando');
		
		
		
		 Ext.MessageBox.show({
            title: 'Avanzando tareas...<br><br>No cierre ni refresque el navegador mientras se completa este proceso, de lo contrario deberá volver a lanzarlo para el resto de bienes que no se hubieran completado',
            progressText: 'Calculando...',
            width:300,
            progress:true,
            closable:false
        });
        
		var valores = panelEdicion.getForm().getFieldValues();
		btnGuardar.setVisible(false);
		var progreso = contEjecuciones/idsTareasArr.length;
		Ext.MessageBox.updateProgress(progreso, Math.round(100*progreso)+'% completado');
		ajaxGuardar(valores);
		
	} else{
		Ext.Msg.alert('Error', 'Debe rellenar los campos obligatorios.');
	}
	
};

var avanzaProgreso = function() {
	contEjecuciones++;
	var progreso = contEjecuciones/idsTareasArr.length;
	Ext.MessageBox.updateProgress(progreso, Math.round(100*progreso)+'% completado');
};

var ajaxGuardar = function(valores){
				
	if (contEjecuciones < idsTareasArr.length) {				
		valores.idTarea = idsTareasArr[contEjecuciones];			
		Ext.Ajax.request({
			url: '/'+app.getAppName()+'/adjudicados/saveValues.htm',
			params: valores,
			method: 'POST',
			success: function(result, action) {
				avanzaProgreso();								
				var r = Ext.util.JSON.decode(result.responseText)
				if(r.msgError!=null && r.msgError!=''){
					errorProcesado = r.msgError;
				}			
				ajaxGuardar(valores);			       
		    },
		    error : function (result, request){
		    	avanzaProgreso();
			 	//panelEdicion.el.unmask();
			 	procesarError(request);
			 	ajaxGuardar(valores);
				//anyadirFechaFaltante(response);
			},
		    failure: function(form, action) {
		    	avanzaProgreso();
		    	//panelEdicion.container.unmask();
		    	procesarError(action);
		    	ajaxGuardar(valores);
		        <%--switch (action.failureType) {
		            case Ext.form.Action.CLIENT_INVALID:
		                Ext.Msg.alert('Error', 'Debe rellenar los campos obligatorios.');
		                break;
		            case Ext.form.Action.CONNECT_FAILURE:	            	
		                Ext.Msg.alert('Error', 'Error de comunicación');
		                break;
		       } --%>
		    }
		});
	} else {	
        Ext.MessageBox.hide();
		panelEdicion.el.unmask();
		if (errorProcesado != '') {
			Ext.MessageBox.show({
			           title: 'Información de los errores producidos durante el procesado de las tareas',
			           msg: errorProcesado,
			           width:450,
			           buttons: Ext.MessageBox.OK
			    });
		}
		page.fireEvent(app.event.DONE);
	}	
	
};

var procesarError = function(action){
	var msg = 'Error al procesar la tarea con id: ' + action.params.idTarea + ' del procedimiento con id: ' + action.params.idProcedimiento + '.';
   	errorProcesado = (errorProcesado=='') ? msg : '\n' + msg;
};

<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	

	var btnGuardar = new Ext.Button({
		text : 'Guardar'
		,iconCls : 'icon_ok'
	});

	btnGuardar.on('click', ejecutaGuardar);

	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)
	{
		bottomBar.push(btnGuardar);
	}
	muestraBotonGuardar = 0;
</c:if>

if (muestraBotonGuardar==1){
	var btnGuardar = new Ext.Button({
		text : 'Guardar'
		,iconCls : 'icon_ok'
	});

	btnGuardar.on('click', ejecutaGuardar);
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)
	{
		bottomBar.push(btnGuardar);
	}
}