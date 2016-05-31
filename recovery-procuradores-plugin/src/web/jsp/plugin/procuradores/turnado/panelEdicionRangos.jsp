	var labelStyle='font-weight:bolder;width:70px';
	
	var despachosData = {"diccionario":[<c:forEach var="despacho" items="${despachosProcuradores}" varStatus="status"><c:if test="${status.index>0}">,</c:if>{"id":"${despacho.id}","nombre":"${despacho.nombre}"}</c:forEach>]};
	var despachosStore = new Ext.data.JsonStore({
	       fields: ['id', 'nombre']
	       ,data : despachosData
	       ,root: 'diccionario'
	});
	
	var importeMinimo = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.deudaIrregular**" text="**Imp. minimo" />'
		,allowNegative:false
		,allowDecimals:true
		,value:''
		,name:'impoMin'
		,labelStyle:labelStyle
		,maxValue:99999999999999
		,minValue: 0.01
		,width: 100
	});
	
	var importeMaximo = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.deudaIrregular**" text="**Imp. maximo" />'
		,allowNegative:false
		,allowDecimals:true
		,value:''
		,name:'impoMax'
		,labelStyle:labelStyle
		,maxValue:99999999999999
		,minValue: 0.01
		,width: 100
	});
	
	var cmbFieldLabel = new Ext.form.Label({
		fieldLabel : '<s:message code="plugin.procuradores.turnado.plaza**" text="**Despachos" />'
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
		,width:150
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
        		configDespachosPanel.add(crearTuplaDespacho(item.get('id'),item.get('nombre')));
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
	
	var btnGuardarRangos =  new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
				if(!validarPorcentajes()){
					alert("**Advertencia: el total de porcentajes de los despachos debe ser 100%");
				}				
			}
	});
	
	var btnCancelarRangos =  new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			rangoImportesFieldSet.setDisabled(true);
			importeMinimo.reset();
			importeMaximo.reset();
		}
	});
	
	var configDespachosPanel = new Ext.form.FieldSet({
		width: 205
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
		title:'<s:message code="plugin.config.despachoExterno.turnado.ventana.panelLitigios.titulo**" text="**Configuracion rango" />'
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
    var crearTuplaDespacho = function(id, despacho){
		//Añadir id del despacho que se va a añadir al array auxiliar
		arrayDespachosAux.push(id);  
		return despachoHzPanel = app.creaPanelHz({itemId:'despacho-panel-'+id, style : "margin-top:4px;margin-bottom:4px;"}
					,[{html:"<b>"+despacho+"</b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"}
					  ,{					
    					xtype: 'numberfield'
    					,fieldLabel: despacho
	                	,name: 'item-porcentaje-'+id
	                	,maxValue: 100
		                ,minValue: 0
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
	
	<%-- Funcion validar si plaza ya seleccionada --%>
    var dimeSiDespachoYaSeleccionado = function(idDespacho){
    	var flag;
    	var despachoItem = rangoImportesFieldSet.find('itemId','despacho-panel-'+idDespacho);
    	if(despachoItem.length>0) flag=true;
    	else flag=false;
		botonAddDespacho.setDisabled(flag);
		botonRemoveDespacho.setDisabled(!flag);	
    }
    
	<%-- Funcion validar si el total de porcentajes seleccionados es 100 --%>
	var validarPorcentajes = function(){
		debugger;
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
	
	<%--Fin funciones --%>
	
	var gestionarPanelEdicionRangos = function(flag, operacion, value){
		debugger;
		rangoImportesFieldSet.setDisabled(flag);
		if(operacion == 'EDIT'){
			importeMinimo.setValue(value.data.importeDesde);
			importeMaximo.setValue(value.data.importeHasta);
		}
		else if (operacion == 'NEW'){
			importeMinimo.reset();
			importeMaximo.reset();
		}
	}