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
		,width:205
		,allowBlank:false
	    ,editable : false
	});
    
    var crearTuplaDespacho = function(index, despacho){
		return despachoHzPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"}
					,[{
		                	xtype: 'checkbox'
		                	,boxLabel: despacho
		                	,name: 'item-plaza-'+index
		                	,itemId: 'item-plaza-'+index
		                	,listeners: {
				  		   		check: function(c){
				  		   					var item = rangoImportesFieldSet.find('itemId','item-porcentaje-'+index)[0];
				  		   					item.setDisabled(!c.isDirty());
				  		   				}
				  		   	}
	            	 }
				     ,{					
    					xtype: 'numberfield'
	                	,name: 'item-porcentaje-'+index
	                	,maxValue: 100
		                ,minValue: 0
		                ,width:50 
		                ,itemId: 'item-porcentaje-'+index
		                ,disabled: true
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

	var btnGuardarRangos =  new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){				
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
		,border:true
		,hidde: true
		,defaults : {xtype:'fieldSet' ,cellCls : 'vtop', style: 'padding:10px;'}
		,items:[]
	});
	
	var rangoImportesInnerPanel = new Ext.form.FieldSet({
		height:290
		,border:false
		,defaults : {hiddeLabel: true, labelWidth: 0, cellCls : 'vtop', style: 'padding:10px;'}
		,items:[importeMinimo,importeMaximo,cmbFieldLabel,cmbDespachos,configDespachosPanel]
	});
	
	var rangoImportesFieldSet = new Ext.Panel({
		title:'<s:message code="plugin.config.despachoExterno.turnado.ventana.panelLitigios.titulo**" text="**Configuracion rango" />'
		,height:290
		,border:true
		,disabled: true
		,autoScroll: 'auto'
		,style: 'padding-left:2px;'
		,defaults : {xtype:'fieldSet' ,cellCls : 'vtop'}
		,bbar : [btnGuardarRangos, btnCancelarRangos]
		,items:[rangoImportesInnerPanel]
		,doLayout:function() {
				this.setWidth(250);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});	
	
	var validarPorcentajes = function(){
		var sumatorio = 0;
		sumatorio = sumatorio;
		//TODO RECORRER VALORES DE DESPACHOS Y SUMAR
		return (sumatorio==100);
	}
	
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