var histPoliticaStore;
var btnPolNuevo;
var btnPolModificar;
var btnPolVerAnalisis;	
var btnPolMarcarVigente;
var btnPolCancelarPropuesta;

var editarPolitica = function(texto, idPolitica, visibilidadSuperusuario) {
    var w = app.openWindow({
        flow : 'politica/datosPolitica'
        ,closable:true
        ,title:texto
        ,params :{idPolitica : idPolitica, idPersona:panel.getPersonaId(), isSuperusuario:visibilidadSuperusuario}
        ,width:850
      });
    w.on(app.event.DONE, function(){
        w.close(); 
        histPoliticaStore.webflow({id:panel.getPersonaId()});
        reloadEstados(0);
    });
    w.on(app.event.CANCEL, function(){w.close()});
}

var verAnalisis = function(texto,idPolitica) {
	  var w = app.openWindow({
        flow : 'politica/verAnalisisPolitica'
        ,closable:true
        ,title:texto
        ,params :{idPolitica : idPolitica, idPersona:panel.getPersonaId(), verAnalisis:false}
        ,width:950
      });
	  w.on(app.event.DONE, function(){
        w.close(); 
      });
      w.on(app.event.CANCEL, function(){w.close()});
}


var marcarVigente = function(texto,idPolitica) {
	  Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmacion" />',
                      '<s:message code="politica.marcarVigencia" text="**¿Esta seguro que desea marcar la política como vigente?" />', 
                      function(result){
				        if(result == 'yes') {
					      var mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
					      mask.show();  
				        var rec = histPoliticaGrid.getSelectionModel().getSelected();
				        if (!rec) return;   
				        var idPolitica = rec.get("idUltimaPolitica");
					        page.webflow({
					            flow: 'politica/marcarPoliticaVigente'
					            ,params :{idPolitica : idPolitica}
					            ,success: function(){
					            	mask.hide();
							        histPoliticaStore.webflow({id:panel.getPersonaId()});
							        reloadEstados(0);
					            }					            
					            ,error: function(){
					            	mask.hide();
							        histPoliticaStore.webflow({id:panel.getPersonaId()});
							        reloadEstados(0);
					            }					            
					        });
				         }       
       				  });
}


var cancelarPropuesta = function(texto,idPolitica) {
  Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmacion" />',
                     '<s:message code="politica.cancelarPolitica" text="**¿Esta seguro que desea cancelar la política?" />', 
                     function(result){
			        if(result == 'yes') {
					  var mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
					  mask.show();  
			        
			        var rec = histPoliticaGrid.getSelectionModel().getSelected();
			        if (!rec) return;   
			        var idPolitica = rec.get("idUltimaPolitica");
				        page.webflow({
				            flow: 'politica/cancelarPropuesta'
				            ,params :{idPolitica : idPolitica}
					            ,success: function(){
					            	mask.hide();
							        histPoliticaStore.webflow({id:panel.getPersonaId()});
							        reloadEstados(0);
							        
							    }
					            ,error: function(){
					            	mask.hide();
							        histPoliticaStore.webflow({id:panel.getPersonaId()});
							        reloadEstados(0);
					            }					            
				        });
			         }       
      				  });
}


var createHistorialPoliticasPanel = function() {

    btnPolNuevo = new Ext.Button({
        text : '<s:message code="app.nuevo" text="**Nuevo" />'
        ,iconCls : 'icon_mas'
        ,handler: function() {
        	var superUsuario = isSuperusuario;
        	
        	editarPolitica('<s:message code="politica.alta" text="**Alta Política" />', 0, superUsuario);
        }
    });

    btnPolModificar = new Ext.Button({
        text : '<s:message code="app.editar" text="**Modificar" />'
        ,iconCls : 'icon_edit'
        ,handler: function() 
        {
        	var rec = histPoliticaGrid.getSelectionModel().getSelected();
        	var idUltimaPolitica = rec.get('idUltimaPolitica');
        	var isPropuestaSuperusuario = rec.get('propuestaSuperusuario');
        	var superUsuario = isPropuestaSuperusuario && isSuperusuario;
        	
        	editarPolitica('<s:message code="politica.editar" text="**Editar Política" />' , idUltimaPolitica, superUsuario);}
    });

	btnPolVerAnalisis = new Ext.Button({
        text : '<s:message code="politica.verAnalisis" text="**Ver Análisis" />'
        ,iconCls : 'icon_edit'
        ,handler: function() {verAnalisis('<s:message code="politica.analisis" text="**Análisis Política" />' , histPoliticaGrid.getSelectionModel().getSelections()[0].data.id);}
    });


	btnPolMarcarVigente = new Ext.Button({
        text : '<s:message code="politica.marcarVigente" text="**Marcar vigente" />'
        ,iconCls : 'icon_ok'
        ,handler: function() {marcarVigente('<s:message code="politica.analisis" text="**Análisis Política" />' , histPoliticaGrid.getSelectionModel().getSelections()[0].data.id);}
    });

	btnPolCancelarPropuesta = new Ext.Button({
        text : '<s:message code="politica.cancelarPropuesta" text="**Cancelar propuesta" />'
        ,iconCls : 'icon_menos'
        ,handler: function() {cancelarPropuesta('<s:message code="politica.analisis" text="**Análisis Política" />' , histPoliticaGrid.getSelectionModel().getSelections()[0].data.id);}
    });


	btnPolNuevo.disable();
    btnPolModificar.disable();
	btnPolVerAnalisis.disable();	
    btnPolMarcarVigente.disable();
    btnPolCancelarPropuesta.disable();

	if (isSuperusuario)    
    	btnPolNuevo.enable();

    var politica = Ext.data.Record.create([
        {name : 'id'}
        ,{name : 'idUltimaPolitica'}
        ,{name : 'fecha'}
        ,{name : 'estado'}
        ,{name : 'tipo'}
        ,{name : 'motivo'}
        ,{name : 'objetivos'}
        ,{name : 'objCumplidos'}
        ,{name : 'objIncumplidos'}
        ,{name : 'propuesta'}
        ,{name : 'propuestaSuperusuario'}
		,{name : 'idAnalisis'}
		,{name: 'idExpediente'}
    ]);

    histPoliticaStore = page.getStore({
        event:'listado'
         ,storeId : 'politicaHistoricoStore'
        ,flow : 'politica/listadoHistPoliticas'
        ,reader : new Ext.data.JsonReader(
            {root:'politicas'}
            , politica
        )
    });
    
    histPoliticaStore.on('load', function(){
    
    	if(histPoliticaGrid.getSelectionModel().getSelected()!=null){
	    	var rec = histPoliticaStore.getById(histPoliticaGrid.getSelectionModel().getSelected().get('id'));    
	        var propuesta=rec.get('propuesta');
	        
	        if(propuesta) {
	            btnPolModificar.enable();
	        } else {
	            btnPolModificar.disable();
	        }
	        
			if(rec.get('idAnalisis')!=null && rec.get('idAnalisis')!=''){
				btnPolVerAnalisis.enable();
			}else{
				btnPolVerAnalisis.disable();
			}
			
			var propuestaSuperusuario=rec.get('propuestaSuperusuario');
			if (propuestaSuperusuario && isSuperusuario)
			{
			    btnPolMarcarVigente.enable();
			    btnPolCancelarPropuesta.enable();
			}
			else
			{
			    btnPolMarcarVigente.disable();
			    btnPolCancelarPropuesta.disable();
			
			}
		}
    });
    
    histPoliticaStore.webflow({id:panel.getPersonaId()});

    var politicaCm = new Ext.grid.ColumnModel([                                                                                                                         
        {header : '<s:message code="politica.fecha" text="**Fecha" />', dataIndex : 'fecha'}
        ,{header : '<s:message code="politica.estado" text="**Estado" />',  dataIndex : 'estado'}
        ,{header : '<s:message code="politica.politica" text="**Pol&iacute;tica" />', dataIndex : 'tipo'}
        ,{header : '<s:message code="politica.motivo" text="**Motivo" />', dataIndex : 'motivo'}
        ,{header : '<s:message code="politica.objetivos" text="**Objetivos" />', dataIndex : 'objetivos'}
        ,{header : '<s:message code="politica.objetivosCumplidos" text="**O. Cumplidos" />', dataIndex : 'objCumplidos'}
        ,{header : '<s:message code="politica.objetivosIncumplidos" text="**O. Incumplidos" />', dataIndex : 'objIncumplidos'}
        ,{header : '<s:message code="politica.expediente" text="**Expediente" />', dataIndex : 'idExpediente'}
    ]);
                
    var configHistPolit = {
        title: '<s:message code="politica.historial" text="**Historial de políticas" />'
        ,style: 'padding-bottom:10px'
        ,autoHeight: false
        ,height: 150
        ,bbar : [btnPolModificar,btnPolVerAnalisis,'->',btnPolNuevo,btnPolMarcarVigente,btnPolCancelarPropuesta]}

    var histPoliticaGrid = app.crearGrid(histPoliticaStore, politicaCm, configHistPolit);
     
    histPoliticaGrid.on('rowclick',function(grid, rowIndex, e){
        var rec = grid.getStore().getAt(rowIndex);
        var propuesta=rec.get('propuesta');
        if(propuesta) {
            btnPolModificar.enable();
        } else {
            btnPolModificar.disable();
        }
		if(rec.get('idAnalisis')!=null && rec.get('idAnalisis')!=''){
			btnPolVerAnalisis.enable();
		}else{
			btnPolVerAnalisis.disable();
		}
		
		var propuestaSuperusuario=rec.get('propuestaSuperusuario');
		if (propuestaSuperusuario && isSuperusuario)
		{
		    btnPolMarcarVigente.enable();
		    btnPolCancelarPropuesta.enable();
		}
		else
		{
		    btnPolMarcarVigente.disable();
		    btnPolCancelarPropuesta.disable();
		
		}
		
        // Ver tabPoliticaDatos.jsp
        reloadEstados(rec.get('id'), rec.get('idExpediente'), panel);
        objetivosGrid.getBottomToolbar().disable();        
    });



    return histPoliticaGrid;
};
