	<%-- Botones plazas --%>
	var btnBorrarPlaza = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,disabled: true
			,iconCls : 'icon_menos'
			,handler : function(){
					Ext.Msg.minWidth=360;			
					Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarBorrarPlaza" text="**Borrar plaza" />', '<s:message code="plugin.procuradores.turnado.confirmarBorrarPlazaMsg" text="**Estas seguro que desa borrar la plaza seleccionada y toda su configuracion?" />', this.evaluateAndSend);
			}
			,evaluateAndSend: function(seguir) {
				mainPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');      			
       			if(seguir== 'yes') {
       				//Borrar todo lo relacioando con la plaza
       				Ext.Ajax.request({
						url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpoLogico.htm'
						,params: {
									idPlaza: plazasGrid.getSelectionModel().getSelected().data.id
									,idEsquema: idEsquema
								}
						,method: 'POST'
						,success: function (result, request){
							var r = Ext.util.JSON.decode(result.responseText);
							//Guardar ids de tuplas y rangos
							for(var i=0; i< r.idTuplas.length; i++){
								idsTuplasBorradas.push(r.idTuplas[i].idTupla);
							}
							for(var i=0; i< r.idsRangos.length; i++){
								idsRangosBorrados.push(r.idsRangos[i].idRango);
							}
							//Webflows para cargar los grids
							plazasStore.webflow({idEsquema : idEsquema});
							tposStore.removeAll();
							rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
							
							//Gestion botones
							btnGuardar.setDisabled(false);
							btnBorrarPlaza.setDisabled(true);
							btnBorrarTPO.setDisabled(true);

							mainPanel.container.unmask();
						}
						,error: function(result, request){
							Ext.Msg.minWidth=360;
							Ext.Msg.alert("Error","Error borrando");
							mainPanel.container.unmask();
						}
					});
				}
				else {
					mainPanel.container.unmask();
				}
	    	} 
	});
	
	var btnLimpiarPlaza = new Ext.Button({
			text : '<s:message code="app.botones.limpiar" text="Limpiar" />'
			,iconCls : 'icon_limpiar'
			,listeners : {
					scope:this,
                    click:function(cmp, e){
                        plazasGrid.resetCombos();
                    }
			}
	});
	
	<%-- Botones TPO --%>
	var btnAñadirTPO = new Ext.Button({
			text : '<s:message code="app.agregar" text="**Agregar" />'
			,disabled: true
			,iconCls : 'icon_mas'
			,handler : function(){
				//Abrir ventana para añadir un nuevo TPO a la plaza seleccionada
				crearVentanaAñadirTPO(plazasGrid.getSelectionModel().getSelected().data.id);
				win.show();
			}
	});
	
	var btnBorrarTPO = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,disabled: true			
			,iconCls : 'icon_menos'
			,handler : function(){
					Ext.Msg.minWidth=360;			
					Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarBorrarProcedimiento" text="**Borrar tipo procedimiento" />', '<s:message code="plugin.procuradores.turnado.confirmarBorrarProcedimientoMsg" text="**Estas seguro que desa borrar el tipo de procedimiento seleccionado y toda su configuracion?" />', this.evaluateAndSend);
			}
			,evaluateAndSend: function(seguir) {    			
       			if(seguir== 'yes') {
       				mainPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
       				//Borrar todo lo relacioando con la plaza
       				Ext.Ajax.request({
						url: '/pfs/turnadoprocuradores/borrarConfigParaPlazaOTpoLogico.htm'
						,params: {
									idTpo: tposGrid.getSelectionModel().getSelected().data.id
									,idPlaza: plazasGrid.getSelectionModel().getSelected().data.id
									,idEsquema: idEsquema
								}
						,method: 'POST'
						,success: function (result, request){
							var r = Ext.util.JSON.decode(result.responseText);
							//Guardar ids de tuplas y rangos
							for(var i=0; i< r.idTuplas.length; i++){
								idsTuplasBorradas.push(r.idTuplas[i].idTupla);
							}
							for(var i=0; i< r.idsRangos.length; i++){
								idsRangosBorrados.push(r.idsRangos[i].idRango);
							}
							btnGuardar.setDisabled(false);
							//Webflob para cargar el grid
							tposStore.webflow({idEsquema : idEsquema,  idPlaza : plazasGrid.getSelectionModel().getSelected().data.id});
            				rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : plazasGrid.getSelectionModel().getSelected().data.id, nuevaConfig : infoConfiguracionTurnado.isVisible()});
            				btnBorrarTPO.setDisabled(true);
            				mainPanel.container.unmask();
						}
						,error: function(result, request){
							Ext.Msg.minWidth=360;
							Ext.Msg.alert("Error","Error borrando");
							mainPanel.container.unmask();
						}
					});
				}
				else{
					mainPanel.container.unmask();
				}
	    	}  
	});
	
	
	var btnLimpiarTPO = new Ext.Button({
			text : '<s:message code="app.botones.limpiar" text="Limpiar" />'
			,iconCls : 'icon_limpiar'
			,listeners : {
					scope:this,
                    click:function(cmp, e){
                        tposGrid.resetCombos();
                    }
			}
	});
	
	<%-- Grid plazas --%>
	var plaza = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'descripcion'}
	]);	
	
	var plazasStore = page.getStore({
		 flow: 'turnadoprocuradores/getPlazasGrid'
		,remoteSort: true
		,autoLoad: false
		,reader : new Ext.data.JsonReader({
	            root:'plazasEsquema'
	        }, plaza)
	});	
	
	var plazasCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.procuradores.turnado.grids.nombre" text="**Nombre"/>', dataIndex: 'descripcion', sortable: true}
	]);
	
	var smPlaza = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
            	if(tposGrid.getSelectionModel().hasSelection()) tposGrid.getSelectionModel().clearSelections();
            	if (!this.hasSelection()) {
            		return;
            	}
            	var idPlaza = r.data.id;
            	//Webflows para recargar grids
            	tposStore.webflow({idEsquema : idEsquema,  idPlaza : idPlaza});
            	rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : idPlaza, nuevaConfig : infoConfiguracionTurnado.isVisible()});
           		//Gestion botones
           		btnAñadirTPO.setDisabled(false);
            	btnBorrarPlaza.setDisabled(false);
            	btnBorrarTPO.setDisabled(true);
				btnNuevo.setDisabled(true);
				btnBorrarRango.setDisabled(true);
				btnEditarRango.setDisabled(true);
            }
         }
	});
	
	var plazasGrid = new Ext.grid.EditorGridPanel({
		store: plazasStore
		,cm: plazasCm
		,title:'<s:message code="plugin.procuradores.turnado.plaza" text="**Plazas"/>'
		,stripeRows: true
		,height:170
		,resizable:false
		,titleCollapse : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding-right:10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: smPlaza
		,bbar : [{
                xtype: 'label',
                text: '<s:message code="plugin.procuradores.turnado.grids.nombre" text="**Nombre"/>'+':',
                style: 'margin-left:5px;',
                width: 50
              },{
                  xtype:'textfield',                 
                  name: 'descripcion',
                  id: 'descripcionFilterPlazaGrid',
                  width: 50,
                  style: 'margin-left:3px;',
                  enableKeyEvents: true,
                  listeners:{
                    scope:this,
                    keyup:function(t, nv, ov, eOpts){
                        plazasGrid.filterStore(t);
                    }
                  } 
              },btnLimpiarPlaza,'->',btnBorrarPlaza]
        ,filterStore:function(t){
        	var me = this, i;
         	me.store.clearFilter(false);
         	var filters = [];
           	value = t.getValue();
            if (!Ext.isEmpty(value)){
                filters.push({property: t.getName(), value: t.getValue(), caseSensitive: false, anyMatch: true});
            }
        	me.store.filter(filters);
     	},
	    resetCombos:function(){
	        var me = this, i;
	        me.store.clearFilter(false);
	        Ext.getCmp('descripcionFilterPlazaGrid').reset();
	        //Gestion grids
	        if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
	        if(tposGrid.getSelectionModel().hasSelection()) tposGrid.getSelectionModel().clearSelections();
	        if(plazasGrid.getSelectionModel().hasSelection()) plazasGrid.getSelectionModel().clearSelections();
	        rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
	        tposStore.removeAll();
	        //Gestion botones
	        btnBorrarPlaza.setDisabled(true);
	        btnAñadirTPO.setDisabled(true);
	        btnBorrarTPO.setDisabled(true);
	        btnNuevo.setDisabled(true);
			btnBorrarRango.setDisabled(true);
			btnEditarRango.setDisabled(true);
	     }
	});
	
	<%-- Grid procedimientos --%>
	var tpo = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'descripcion'}
	]);				
	
	var tposStore = page.getStore({
		 flow: 'turnadoprocuradores/getTPOsGrid'
		,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'tipoProcedimientos'
	     }, tpo)
	});	
	
	var tposCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.procuradores.turnado.grids.nombre" text="**Nombre"/>', dataIndex: 'descripcion', sortable: true}
	]);
	
	var smTpo = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
            	if (!this.hasSelection()) {
            		return;
            	}
            	if(plazasGrid.getSelectionModel().getSelected()!=null){
            		var idTPO = r.data.id;
            		var idPlaza = plazasGrid.getSelectionModel().getSelected().data.id;
            		rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : idPlaza, idsTPOs : idTPO, nuevaConfig : infoConfiguracionTurnado.isVisible()});
					//Gestion botones
					btnBorrarTPO.setDisabled(false);
            		btnNuevo.setDisabled(true);
					btnBorrarRango.setDisabled(true);
					btnEditarRango.setDisabled(true);
            	}
            }
         }
	});
	
	var tposGrid = new Ext.grid.EditorGridPanel({
		store: tposStore
		,cm: tposCm
		,title:'<s:message code="plugin.procuradores.turnado.tpo" text="**Tipos procedimientos"/>'
		,stripeRows: true
		,height:170
		,resizable:false
		,titleCollapse : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,hidden: true
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding-left:10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: smTpo
		,bbar : [{
                xtype: 'label',
                text: '<s:message code="plugin.procuradores.turnado.grids.nombre" text="**Nombre"/>'+':',
                style: 'margin-left:5px;',
                width: 50
              },{
                  xtype:'textfield',                 
                  name: 'descripcion',
                  id: 'descripcionFilterTPOGrid',
                  width: 50,
                  style: 'margin-left:3px;',
                  enableKeyEvents: true,
                  listeners:{
                    scope:this,
                    keyup:function(t, nv, ov, eOpts){
                        tposGrid.filterStore(t);
                    }
                  } 
              },btnLimpiarTPO,'->',btnAñadirTPO,btnBorrarTPO]
        ,filterStore:function(t){
        	var me = this, i;
         	me.store.clearFilter(false);
         	var filters = [];
            value = t.getValue();
            if (!Ext.isEmpty(value)){
                filters.push({property: t.getName(), value: t.getValue(), caseSensitive: false, anyMatch: true});
            }
        	me.store.filter(filters);
     	},
	    resetCombos:function(){
	        var me = this, i;
	        me.store.clearFilter(false);
	        Ext.getCmp('descripcionFilterTPOGrid').reset();
	        if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
	        if(tposGrid.getSelectionModel().hasSelection()) tposGrid.getSelectionModel().clearSelections();
	        if(plazasGrid.getSelectionModel().getSelected()!=null){
				rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : plazasGrid.getSelectionModel().getSelected().data.id, nuevaConfig : infoConfiguracionTurnado.isVisible()});
            }
            else{
	        	rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
	        }
	        //Gestion botones
	        btnBorrarTPO.setDisabled(true);
	        btnNuevo.setDisabled(true);
			btnBorrarRango.setDisabled(true);
			btnEditarRango.setDisabled(true);
	     }
	});
	
	<%-- Funcion que abre pop-up añadir TPO --%>
	var crearVentanaAñadirTPO = function(idPlaza){
		var tposDisponiblesByPlaza =	page.getStore({
		     	flow: 'turnadoprocuradores/getTPODisponiblesByPlaza'
		     	,reader: new Ext.data.JsonReader({
		 	 		root : 'tipoProcedimientos'
		 	 		,fields:['id','codigo','descripcion']
		  		}) 
		});	
		tposDisponiblesByPlaza.webflow({ idEsquema : idEsquema, idPlaza: idPlaza});
		
		añadir = new Ext.FormPanel({
	        height: 55
	        ,autoWidth: true
	        ,bodyStyle: 'padding: 10px 10px 0 10px;'
	        ,defaults: {
	            allowBlank: false
	           ,msgTarget: 'side'
	           ,height:50
	        }
	        ,items: [
            	{
	            	xtype:'combo'
	          		,itemId:'comboAñadirTPO'
					,name:'comboAñadirTPO'
					,hiddenName:'comboAñadirTPO'
					,store:tposDisponiblesByPlaza
					,displayField:'descripcion'
					,valueField:'id'
					,mode: 'local'
					,emptyText:'----'
					,width:250
					,resizable:true
					,triggerAction: 'all'
					,allowBlank:false
					,forceSelection: true
					,fieldLabel : '<s:message code="plugin.procuradores.turnado.tipoProcedimiento" text="**Tipo procedimiento" />'
       			}]
           ,buttons: [
           		{
	               text: 'Aceptar',
	               handler: function(){
					   if(añadir.getComponent('comboAñadirTPO').getValue()!='' && añadir.getComponent('comboAñadirTPO').validate()){
					   		<%-- Guardar procedimiento seleccionado para la plaza seleccionada--%>
					   		Ext.Ajax.request({
									url: '/pfs/turnadoprocuradores/addNuevoTPOPlazas.htm'
									,params: {
												idTpo: añadir.getComponent('comboAñadirTPO').getValue()
												,idEsquema: idEsquema
												,arrayPlazas : idPlaza
											}
									,method: 'POST'
									,success: function (result, request){
										var r = Ext.util.JSON.decode(result.responseText);
										//Guardar ids tuplas por si se cancela operacion
										for(var i=0; i< r.idTuplas.length; i++){
											idsTuplasConfigDefinitivas.push(r.idTuplas[i].idTupla);
										}
										//Webflob para cargar el grid
										tposStore.webflow({idEsquema : idEsquema,  idPlaza : plazasGrid.getSelectionModel().getSelected().data.id});
			            				rangosStore.webflow({idEsquema : idEsquema,  idsPlazas : plazasGrid.getSelectionModel().getSelected().data.id, nuevaConfig : infoConfiguracionTurnado.isVisible()});
					   					btnGuardar.setDisabled(false);
					        			win.hide();
									}
									,error: function(result, request){
										Ext.Msg.minWidth=360;
										Ext.Msg.alert("Error","Error guardando");
									}
							});
	           			}
	           			else añadir.getComponent('comboAñadirTPO').addClass('x-form-invalid');
	               }
	           },
	           {
	               text: 'Cancelar',
	               handler: function(){
	                   win.hide();
	               }
	           }]
       });

		win = new Ext.Window({
	         width:400
	        ,minWidth:400
	        ,height:125
	        ,minHeight:125
	        ,layout:'fit'
	        ,border:false
	        ,closable:true
	        ,title:'<s:message code="plugin.procuradores.turnado.agregarTipoProcedimiento" text="**Agregar procedimiento" />'
	        ,iconCls:'icon-mas'
	        ,items:[añadir]
	        ,modal : true
		});
	}
	
	<%-- Panel filtros --%>
	var turnadoFiltrosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.procuradores.turnado.seleccionFiltrosField" text="**Selección plazas y procedimientos" />'
		,layout:'table'
		,autoHeight:true
		,border:true
		,hidden:false
		,bodyStyle:'padding:3px;padding-bottom:0px;cellspacing:20px;'
		,collapsible : true
		,collapsed : false
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:400 }
		,items : [
		 	{items:[plazasGrid]},
		 	{items:[tposGrid]}
		]
		,listeners: {
			expand:  function(){
				nombreEsquemaPanel.collapse(true);
				infoConfiguracionTurnado.expand(true);
			}
		}	
		,doLayout:function() {
				var margin = 40;
				this.setWidth(900-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	plazasStore.webflow({ idEsquema : idEsquema });
	