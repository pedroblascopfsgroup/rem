	var labelStyle='font-weight:bolder;width:70px';
	
	var despachosData = {"diccionario":[<c:forEach var="despacho" items="${despachosProcuradores}" varStatus="status"><c:if test="${status.index>0}">,</c:if>{"id":"${despacho.id}","nombre":"${despacho.nombre}"}</c:forEach>]};
	var despachosStore = new Ext.data.JsonStore({
	       fields: ['id', 'nombre']
	       ,data : despachosData
	       ,root: 'diccionario'
	});
	
	var importeMinimo = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.procuradores.turnado.impoMinimo" text="**Imp. mínimo" />'
		,allowNegative:false
		,allowDecimals:true
		,value:''
		,name:'impoMin'
		,labelStyle:labelStyle
		,maxValue:99999999999999
		,minValue: 0
		,width: 120
	});
	
	var importeMaximo = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.procuradores.turnado.impoMaximo" text="**Imp. máximo" />'
		,allowNegative:false
		,allowDecimals:true
		,value:''
		,name:'impoMax'
		,labelStyle:labelStyle
		,maxValue:99999999999999
		,minValue: 0
		,width: 120
	});
	
	var cmbFieldLabel = new Ext.form.Label({
		fieldLabel : '<s:message code="plugin.procuradores.turnado.despachos" text="**Despachos" />'
		,labelStyle:labelStyle
	});
    
    var cmbDespachos = new Ext.form.ComboBox({
	    name:'turnadoProcuComboDespachos'
	    ,store: despachosStore
	    ,valueField: 'id' 
	    ,displayField:'nombre'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,obligatory: true
		,width:170
		,allowBlank:false
	    ,editable : false
		,listeners: {
			select: function(){
				//Se hacen comprobaciones de los botones
				dimeSiDespachoYaSeleccionado(this.getValue());
			}
		}
	});
	
	var botonAddDespacho = new Ext.Button({
        iconCls:'icon_mas'
        ,disabled : true
        ,handler : function(){
			if(cmbDespachos.getValue().trim()!='' && cmbDespachos.getValue()!=null){
				var item = despachosStore.getAt(despachosStore.find('id', cmbDespachos.getValue()));
        		configDespachosPanel.add(crearTuplaDespacho(item.get('id'),item.get('nombre'),null));
        		configDespachosPanel.doLayout();
        		//Se actualizan botones
        		dimeSiDespachoYaSeleccionado(item.get('id'));
       		}	
		}
    });
    
	var botonRemoveDespacho = new Ext.Button({
        iconCls:'icon_menos'
        ,disabled : true
        ,handler: function(){
        	if(cmbDespachos.getValue().trim()!='' && cmbDespachos.getValue()!=null){
        		//Eliminar componente
        		eliminarTuplaDespacho(cmbDespachos.getValue());
        		configDespachosPanel.doLayout();
	        	//Se actualizan botones
	        	dimeSiDespachoYaSeleccionado(cmbDespachos.getValue());
	        }
        }
    });
    
    var despachosPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[cmbDespachos, {style : "margin-right:4px;"},botonAddDespacho, botonRemoveDespacho]);
	
	var action = "ADD";
	var btnGuardarRangos =  new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
				if(!validarPorcentajes()){
					Ext.Msg.minWidth=360;
					Ext.Msg.alert('Advertencia','<s:message code="plugin.procuradores.turnado.mensajeErrorPorcentajes" text="**El total de porcentajes de los despachos debe ser 100%" />');
				}
				else if(!validaImportes()){
					Ext.Msg.minWidth=360;
					Ext.Msg.alert('Advertencia','<s:message code="plugin.procuradores.turnado.mensajeErrorImportes" text="**Por favor, revise los importes introducidos" />');
				}	
				else{
					//Llamada al save rango
					guardarOrUpdateRango(action);
				}			
			}
	});
	
	var btnCancelarRangos =  new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			gestionarPanelEdicionRangos(true,"NEW",null,null);
		}
	});
	
	var configDespachosPanel = new Ext.form.FieldSet({
		width: 225
		,height:100
		,border:true
		,hidde: true
		,autoScroll: true
		,defaults : {xtype:'fieldSet' ,cellCls : 'vtop', style: 'padding:10px;'}
		,items:[]
	});
	
	var rangoImportesInnerPanel = new Ext.form.FieldSet({
		height:290
		,border:false
		,defaults : {hiddeLabel: true, labelWidth: 0, cellCls : 'vtop', style: 'padding:0px;'}
		,items:[importeMinimo,importeMaximo,cmbFieldLabel,despachosPanel,configDespachosPanel]
	});
	
	var rangoImportesFieldSet = new Ext.Panel({
		title:'<s:message code="plugin.procuradores.turnado.tituloConfRangos" text="**Configuración rango" />'
		,height:290
		,border:true
		,disabled: true
		,style: 'padding-left:2px;'
		,defaults : {xtype:'fieldSet' ,cellCls : 'vtop'}
		,bbar : [btnGuardarRangos, btnCancelarRangos]
		,items:[rangoImportesInnerPanel]
		,doLayout:function() {
				this.setWidth(250);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});	
	<%--Funciones --%>
	
	var arrayDespachosAux = [];
	
	<%-- Funcion crear tupla de despacho-porcentaje --%>
    var crearTuplaDespacho = function(id, despacho,porcentaje){
		//Añadir id del despacho que se va a añadir al array auxiliar
		arrayDespachosAux.push(id);  
		return despachoHzPanel = app.creaPanelHz({itemId:'despacho-panel-'+id, style : "margin-top:4px;margin-bottom:4px;"}
					,[{html:"<b>"+despacho+"</b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"}
					  ,{					
    					xtype: 'numberfield'
    					,fieldLabel: despacho
	                	,name: 'item-porcentaje-'+id
	                	,maxValue: 100
		                ,minValue: 0.01
		                ,value: porcentaje
		                ,width:50 
		                ,itemId: 'item-porcentaje-'+id
		                ,listeners: {
		                	render: function(c) {
						      Ext.QuickTips.register({
						        target: c.getEl(),
						        text: 'Porcentaje correspondiente al despacho',
						        enabled: true,
						        showDelay: 20,
						        trackMouse: true,
						        autoShow: true
						      });
					    	}
					    }
           			}]);        			
	}
	
	<%-- Funcion borra tupla de despacho-porcentaje --%>
	var eliminarTuplaDespacho = function(id){
		var despachoItem = rangoImportesFieldSet.find('itemId','despacho-panel-'+id);
		if(despachoItem.length>0){
			despachoItem[0].destroy();
			//Borrar id del despacho borrado del array auxiliar
			var index = arrayDespachosAux.indexOf(id);
			if(index > -1) arrayDespachosAux.splice(index, 1);
		}
	}
	
	<%-- Funcion validar si despacho ya seleccionada --%>
    var dimeSiDespachoYaSeleccionado = function(idDespacho){
    	var flag;
    	var despachoItem = rangoImportesFieldSet.find('itemId','despacho-panel-'+idDespacho);
    	if(despachoItem.length>0) flag=true;
    	else flag=false;
		botonAddDespacho.setDisabled(flag);
		botonRemoveDespacho.setDisabled(!flag);	
    }
    
    <%-- Funcion que resetea el panel de despachos seleccionado --%>
   	var resetDespachosPanel = function(){
   		if(arrayDespachosAux.length>0){
			while(arrayDespachosAux.length>0){
				eliminarTuplaDespacho(arrayDespachosAux[0]);
			}
		}
   	}
    
	<%-- Funcion validar si el total de porcentajes seleccionados es 100 --%>
	var validarPorcentajes = function(){
		var sumatorio = 0;
		
		if(arrayDespachosAux.length>0){
			for(i = 0; i< arrayDespachosAux.length;i++){
				var item = rangoImportesFieldSet.find('itemId','item-porcentaje-'+arrayDespachosAux[i]);
				if(item.length>0){
					sumatorio = sumatorio + item[0].getValue();
				}
			}
		}
		
		return (sumatorio==100);
	}
	
	<%-- Funcion que valida los importes introducidos --%>
	var validaImportes = function(){
		if(importeMaximo.validate() 
		    && importeMinimo.validate()
			&& importeMinimo.getValue()< importeMaximo.getValue()) return true;
		return false;
	}
	
	<%-- Funcion que devuelve un array de "despacho_porcentaje" --%>
	var dameRelacionDespachoPorcentaje = function(){
		var lista = [];
		
		if(arrayDespachosAux.length>0){
			for(i = 0; i< arrayDespachosAux.length;i++){
				var item = rangoImportesFieldSet.find('itemId','item-porcentaje-'+arrayDespachosAux[i]);
				if(item.length>0){
					lista.push(arrayDespachosAux[i]+"_"+item[0].getValue());
				}
			}
		}
		
		return lista;
	}
	
	<%-- Funcion guardar o actualizar rango --%>
	var guardarOrUpdateRango = function(action){
		mainPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		var src = "";
		var params= {
				impMin: importeMinimo.getValue()
				,impMax: importeMaximo.getValue()
				,arrayDespachos: dameRelacionDespachoPorcentaje()
		};
		if(action=="ADD"){
			src="/pfs/turnadoprocuradores/addRangoConfigEsquema.htm";
			<%-- Cuando es nueva configuracion, añadir rangos a todas las tuplas creadas, y ademas, mostrar solo rangos, sin tuplas --%>
			if(infoConfiguracionTurnado.isVisible()){
				params.idsplazasTpo=idsTuplasConfig;
			}
			else params.idConf=rangosGrid.getSelectionModel().getSelected().data.idPlazaTpo;
		}
		else if(action=="UPD"){
			src="/pfs/turnadoprocuradores/updateRangoConfigEsquema.htm";
			params.idConf=rangosGrid.getSelectionModel().getSelected().data.rangoId;
		}
		Ext.Ajax.request({
			url: src
			,params: params
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				if(r.fwk!=null && r.fwk.fwkExceptions!=null && r.fwk.fwkExceptions[0]!=null){
					Ext.Msg.minWidth=360;
					Ext.Msg.alert('Advertencia', r.fwk.fwkExceptions[0]);
				}
				else{
					if(action=="UPD"){
						//Guardar ids nuevos, borrados y modificaciones
						//Borrados
						for(var i=0; i< r.idsRangosBorrados.length; i++){
							idsRangosBorrados.push(r.idsRangosBorrados[i].idRango);
						}
						//Modificados
						for(var i=0; i< r.modificacionesRangos.length; i++){
							modificacionesRangos.push(r.modificacionesRangos[i].idRango);
						}
					}
					if(!infoConfiguracionTurnado.isVisible()){
						//Guardar ids nuevos
						for(var i=0; i< r.idsRangos.length; i++){
							idsRangosCreados.push(r.idsRangos[i].idRango);
						}
					}
				  	gestionarPanelEdicionRangos(true,"NEW",null,null);
				  	//Webflob para cargar el grid
					if(infoConfiguracionTurnado.isVisible()){
						rangosStore.webflow({idEsquema : idEsquema, idsPlazas:nuevasPlazasConfig, nuevaConfig : infoConfiguracionTurnado.isVisible()});
					}
					else rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
					btnGuardar.setDisabled(false);
				}
				mainPanel.container.unmask();	
			}
			,error: function(result, request){
				mainPanel.container.unmask();
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error comprobando si ya existe configuracion para la plaza seleccionada");
			}
		});
	}
	
	<%--Fin funciones --%>
	
	var gestionarPanelEdicionRangos = function(flag, operacion, value,despachos){
		plazasGrid.setDisabled(!flag);
		tposGrid.setDisabled(!flag);
		rangosGrid.setDisabled(!flag);
		if(flag){
			if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
		}
		rangoImportesFieldSet.setDisabled(flag);
		if(operacion == 'EDIT'){
			action="UPD";
			importeMinimo.setValue(value.data.importeDesde);
			importeMaximo.setValue(value.data.importeHasta);
			for(var i=0; i< despachos.length;i++){
				var despacho = despachos[i].split("_");
				configDespachosPanel.add(crearTuplaDespacho(despacho[0],despacho[1],despacho[2]));
        		configDespachosPanel.doLayout();
       		}
       		if(infoConfiguracionTurnado.isVisible()) gestionarPanelNuevoTPO();
		}
		else if (operacion == 'NEW'){
			action="ADD";
			importeMinimo.reset();
			importeMaximo.reset();
			cmbDespachos.reset();
			resetDespachosPanel();
			if(infoConfiguracionTurnado.isVisible()) gestionarPanelNuevoTPO();
		}
	}