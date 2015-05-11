<pfslayout:tabpage titleKey="plugin.config.despachoExterno.categorizaciones.procuradores.title" title="**Configuración Procuradores" items="datos">


//Store de Categorizaciones	
	
	var categorizacionesRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
    ]);
       
    var categorizacionesStore = page.getStore({
		flow : 'categorizaciones/getListaCategorizacionesDelDespacho'
		,reader : new Ext.data.JsonReader({root:'categorizaciones', totalProperty : 'total'}, categorizacionesRecord)
	});
		
	categorizacionesStore.webflow({idDespacho: '${despacho.id}'});		



 	var obtenerConfDespachoExt = function() {		
		if('${despacho.id}' == ""){
			Ext.Msg.alert('<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.sinDespacho.titulo" text="**Error"/>','<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.sinDespacho.texto" text="**No se ha podido obtener el despacho." />');		
		}else{
			page.webflow({
	   			flow:'configuraciondespachoexterno/getConfiguracionDespachoExterno'
	   			,params:{
	 				idDespacho: '${despacho.id}'
				},
				success: function(form, action) {
					Ext.getCmp("idConfDespExt").setValue(form.idConfDespExt);					
					Ext.getCmp("despIntegral").setValue(form.despachoIntegal);
					Ext.getCmp("checkAvisos").setValue(form.avisos);
	 				//Ext.getCmp("checkPausados").setValue(form.pausados);
					Ext.getCmp("comboCtgResol").setValue(form.idcategorizacionResoluciones);
					Ext.getCmp("comboCtgTareas").setValue(form.idcategorizacionTareas);
			    },
				failure: function(result, request){
	       		   	Ext.Msg.alert('<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.errorComunicacion.titulo" text="**Error"/>','<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.errorComunicacion.texto" text="**Error de comunicación." />');		            	           	
				}  		
	   		});
   		}
 	};




	
	var guardarConfDespachoExterno = function() {	
		if('${despacho.id}' == ""){
			Ext.Msg.alert('<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.sinDespacho.titulo" text="**Error"/>','<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.sinDespacho.texto" text="**No se ha podido obtener el despacho." />');		
		}else{
			panel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
			page.webflow({
	   			flow:'configuraciondespachoexterno/guardarConfDespachoExterno'
	   			,params:{
	 				idDespacho:'${despacho.id}'
	 				,id: Ext.getCmp("idConfDespExt").getValue()
	 				,despachoIntegral: Ext.getCmp("despIntegral").getValue()
	 				,avisos: Ext.getCmp("checkAvisos").getValue()
	 				//,pausados: Ext.getCmp("checkPausados").getValue()
	 				,idCategorizacionTareas: Ext.getCmp("comboCtgTareas").getValue()
	 				,idCategorizacionResoluciones: Ext.getCmp("comboCtgResol").getValue()	 				
				},
				success: function(form, action) {
			       panel.container.unmask();
			       page.fireEvent(app.event.DONE);
			       Ext.Msg.alert('<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.guardadoCorrectamente.titulo" text="**Confirmación"/>','<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.guardadoCorrectamente.texto" text="**Datos guardados correctamente." />');		            	           				       
			    },
				failure: function(result, request){
					panel.container.unmask();
	       		   	Ext.Msg.alert('<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.errorComunicacion.titulo" text="**Error"/>','<s:message code="plugin.config.despachoExterno.categorizaciones.validacion.errorComunicacion.texto" text="**Error de comunicación." />');		            	           	
				}  		
	   		});
   		}
 	};
    	
	
	
	
	var btnLimpiar = new Ext.Button({
		text : '<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler : function(){		
			comboCtgResol.setValue("");
			comboCtgTareas.setValue("");
			checkDespIntegral.setValue("");
			checkAvisos.setValue("");
			//checkPausados.setValue("");
		}
	});
	
	
	

	var btnGuardar = new Ext.Button({
		text:'<s:message code="plugin.config.despachoExterno.categorizaciones.boton.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : guardarConfDespachoExterno
	});
	
	
	
//Combo Categorizaciones Resoluciones		
	
	var comboCtgResol = new Ext.form.ComboBox({
		name: 'comboCtgResol'
    	,store: categorizacionesStore
    	,id: 'comboCtgResol'
    	,displayField: 'nombre'
    	,valueField: 'id'
    	,value: '${idcategorizacionResoluciones}'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable: false
    	,emptyText: 'Seleccionar...'
   		,fieldLabel: '<s:message code="plugin.config.despachoExterno.categorizaciones.field.ctgResol" text="**Categorización resoluciones" />'
		,labelStyle: 'font-weight:bolder;width:200'
		,forceSelection: true
	});
		
	
	

//Combo Categorizaciones Tareas	
	
	var comboCtgTareas = new Ext.form.ComboBox({
		name: 'comboCtgTareas'
    	,store: categorizacionesStore
    	,id: 'comboCtgTareas'
    	,displayField: 'nombre'
    	,valueField: 'id'
    	,value: '${idcategorizacionTareas}'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable: false
    	,emptyText: 'Seleccionar...'
   		,fieldLabel: '<s:message code="plugin.config.despachoExterno.categorizaciones.field.ctgTareas" text="**Categorización tareas" />'		
		,labelStyle: 'font-weight:bolder;width:200'
		,forceSelection: true
	});
	


	var checkPausados = new Ext.form.Checkbox({
         fieldLabel: '<s:message code="plugin.config.despachoExterno.categorizaciones.field.checkPausados" text="**Pausados"/>'
         ,id: 'checkPausados'
		 ,labelStyle: 'font-weight:bolder;width:200'
		 ,value: '${pausados}'
    });
     
     

	var checkAvisos = new Ext.form.Checkbox({
         fieldLabel: '<s:message code="plugin.config.despachoExterno.categorizaciones.field.checkAvisos" text="**Avisos"/>'
         ,id: 'checkAvisos'
		 ,labelStyle: 'font-weight:bolder;width:200'
		 ,value: '${avisos}'
    });
	
	
	var checkDespIntegral = new Ext.form.Checkbox({
         fieldLabel: '<s:message code="plugin.config.despachoExterno.categorizaciones.field.despachoIntegral" text="**Despacho integral"/>'
         ,id: 'despIntegral'
		 ,labelStyle: 'font-weight:bolder;width:200'
		 ,value: '${despachoIntegal}'
     });
     
     
     
    var idConfDespExt = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.config.despachoExterno.categorizaciones.field.idConfDespExt" text="**IdConfDespExt" />'				
		, id: 'idConfDespExt'
		, name: 'idConfDespExt'
		, labelStyle: 'font-weight:bolder;width:200'
		, hidden: true
		, value: '${idConfDespExt}'		
	});
     

	
	
    var panelFormulario = new Ext.form.FormPanel({
		layout:'form'
		,border:false
		,bodyStyle:'cellspacing:10px;padding-right:10px;'		
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset',border:false}
				,width:'1000'			
				,items:[idConfDespExt
						, checkDespIntegral
						, checkAvisos
						//, checkPausados						
						//, comboCtgTareas
						, comboCtgResol]
			}
		]      
	}); 




	Ext.onReady(function(){	
		categorizacionesStore.on('load', function(){  
			obtenerConfDespachoExt();		
		});
	});

	
	
	<pfs:panel titleKey="plugin.config.despachoExterno.categorizaciones.panel.title" name="datos" columns="1" collapsible="" title="**Configuración categorizaciones" autoexpand="true" bbar="btnGuardar,btnLimpiar" >
		<pfs:items items="panelFormulario"/>
	</pfs:panel>

</pfslayout:tabpage>