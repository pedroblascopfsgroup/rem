<pfslayout:tabpage
	titleKey="plugin.config.despachoExterno.turnado.tabEsquema.title"
	title="**Turnado de despacho" items="panelSuperior">

	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.tabEsquema.litigios.tipoImporte"
		label="**Tipo importe" name="turnadoLitigiosTipoImporte"
		value="${despacho.turnadoCodigoImporteLitigios}" readOnly="true" />
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.tabEsquema.litigios.tipoCalidad"
		label="**Tipo calidad" name="turnadoLitigiosTipoCalidad"
		value="${despacho.turnadoCodigoCalidadLitigios}" readOnly="true" />
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.tabEsquema.concursos.tipoImporte"
		label="**Tipo importe" name="turnadoConcursosTipoImporte"
		value="${despacho.turnadoCodigoImporteConcursal}" readOnly="true" />
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.tabEsquema.concursos.tipoCalidad"
		label="**Tipo calidad" name="turnadoConcursosTipoCalidad"
		value="${despacho.turnadoCodigoCalidadConcursal}" readOnly="true" />		
		
	<c:set var="comunidades" value="" scope="page" />
	<c:forEach var="ambito" items='${ambitoGreograficoDespacho}'
		varStatus="stat">
		<c:if test="${not empty ambito.comunidad}">
			<c:set var="comunidades"
				value="${stat.first ? '' : comunidades}${!stat.first and not empty comunidades ? ' / ' : ' '}${ambito.comunidad.descripcion}"
				scope="page" />
		</c:if>
	</c:forEach>

	var comunidadesActuacion = new Ext.ux.form.StaticTextField({
		name: 'comunidadesActuacion'
		,fieldLabel : '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.ambitoactuacion.comunidades" text="**Comunidades" />'
		,value: '${comunidades}'
		//,renderer: 'htmlEncode'
		,width: 150
		,height: 200
		,labelStyle: 'font-weight:bolder;width:100'
		//,html: txtTiposGestor
		//,style:'margin-top:5px'
		,readOnly: true
	});

	var turnadoConcursosPanel = new Ext.Panel({
		layout:'table'
		,title : '<s:message
		code="plugin.config.despachoExterno.turnado.tabEsquema.concursos.titulo"
		text="**Turnado Concursos" />'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:1
		}
		//,autoWidth:true
		,style:'padding: 10px;'
		,bodyStyle:'padding:5px;cellspacing:20px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{layout:'form',items:[turnadoConcursosTipoImporte, turnadoConcursosTipoCalidad]}
		]
	});

	var turnadoLitigiosPanel = new Ext.Panel({
		layout:'table'
		,title : '<s:message
		code="plugin.config.despachoExterno.turnado.tabEsquema.litigios.titulo"
		text="**Turnado Litigios" />'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:1
		}
		//,autoWidth:true
		,style:'padding: 10px;'
		,bodyStyle:'padding:5px;cellspacing:20px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{layout:'form',items:[turnadoLitigiosTipoImporte, turnadoLitigiosTipoCalidad]}
		]
	});

	var ambitosActuacionPanel = new Ext.Panel({
		layout:'table'
		,title : '<s:message
		code="plugin.config.despachoExterno.turnado.tabEsquema.ambitoActuacion.titulo"
		text="**&Aacute;mbitos actuaci&oacute;n" />'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:1
		}
		//,autoWidth:true
		,style:'padding: 10px;'
		,bodyStyle:'padding:5px;cellspacing:20px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{layout:'form',items:[comunidadesActuacion]}
		]
	});
	
	
	
	var provincia = Ext.data.Record.create([
		 {name:'codigo'}
		 ,{name:'nombreProvincia'}
		 ,{name:'calidadLitigio'}
		 ,{name:'calidadConcurso'}
		 ,{name:'borrable', type:'boolean'}
		 ,{name:'activable', type:'boolean'}
	]);
	var idDespacho = ${despacho.id};

	var provinciasStore = page.getStore({
		 flow: 'turnadodespachos/buscarProvincias' 
		//,limit: limit
		//,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'listaProvincias'
	    	// ,totalProperty : 'total'
	     }, provincia)
	});
	
	var pagingBar=fwk.ux.getPaging(provinciasStore);
	
	var provinciasCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'codigo', hidden: true}
		,{header: '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.ambitoactuacion.provincias" text="**Provincia"/>', dataIndex: 'nombreProvincia', sortable: true}
		,{header: '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.litigios.calidadLitigio" text="**Calidad Litigio"/>', dataIndex: 'calidadLitigio', sortable: true}
		,{header: '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.concursos.calidadConcurso" text="**Calidad Concurso"/>', dataIndex: 'calidadConcurso', sortable: true}
		]);
	
	var sm = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if (!this.hasSelection()) {
            		return;
            	}
            	var borrable = r.data.borrable;
            	var activable = r.data.activable;
            }
         }
	});
	
	
	var provinciasGrid = new Ext.grid.EditorGridPanel({
		store: provinciasStore
		,cm: provinciasCm
		,title:'<s:message code="plugin.config.esquematurnado.editar.provinciasDespacho" text="**Provincias despacho"/>'
		,stripeRows: true
		//,autoHeight:true
		,autoWidth:false
		,height: 250
		//,resizable:false
		,collapsible : false
		,titleCollapse : false
		//,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {forceFit : true}
		//,monitorResize: true
		//,clicksToEdit:0
		,selModel: sm
		//,bbar : [btnNuevo,btnBorrarProvincia]

	});
	
	provinciasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var codProvincia=rec.get('codigo');
		var w = app.openWindow({
					flow : 'turnadodespachos/ventanaAsignarCalidadProvincia'
					,width :  400
					,closable: true
					,title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.tituloCalidadProvincia" text="**Edici&oacute;n calidad provincia" />'
					,params : {id:${despacho.id},codProvincia:codProvincia}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.openTab('${despacho.despacho}'
						,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
						,{id:${despacho.id}, numTab:4}
						,{id:'DespachoExterno${despacho.id}'}
					)
				});
				w.on(app.event.CANCEL, function(){ w.close(); });		
	});
	
	<!-- ¿Esto aplica a algo? -->
	var ventanaEdicion = function(id) {
		var w = app.openWindow({
			flow : 'turnadodespachos/ventanaEditarLetrado'
			,width :  600
			,closable: true
			,title : '<s:message code="plugin.config.esquematurnado.ventana.editar" text="**Edición esquema" />'
			,params : {id:${despacho.id}}
		});
		w.on(app.event.DONE, function(){
			w.close();
			esquemasStore.webflow(getParametrosDto());
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};

	<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_EDITAR">
	var labelError = new Ext.form.Label({style:'font-weight:bold'});
	labelError.setText('<s:message code="plugin.config.esquematurnado.editar.sinEsquemaVigente" text="**no existe ningún esquema de turnado vigente."/>', false);
	var btnEditarTurnadoLetrado = new Ext.Button({
			text : '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.boton.editar" text="**Editar turnado" />'
			,iconCls : 'icon_edit'
			,disabled: true
			,handler : function(){ 
				var w = app.openWindow({
					flow : 'turnadodespachos/ventanaEditarLetrado'
					,width :  600
					,closable: true
					,title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.titulo" text="**Edici&oacute;n de turnado" />'
					,params : {id:${despacho.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.openTab('${despacho.despacho}'
						,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
						,{id:${despacho.id},numTab:4}
						,{id:'DespachoExterno${despacho.id}'}
					)
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
	});
	
	var btnEditarAmbitoActuacion = new Ext.Button({
			text : '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.boton.editarAmbitoActuacion" text="**Editar ambito" />'
			,iconCls : 'icon_edit'
			,disabled: true
			,handler : function(){ 
				var w = app.openWindow({
					flow : 'turnadodespachos/ventanaEditarAmbito'
					,width :  500
					,closable: true
					,title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.tituloEditarAmbito" text="**Edici&oacute;n de ambito" />'
					,params : {id:${despacho.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.openTab('${despacho.despacho}'
						,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
						,{id:${despacho.id},numTab:4}
						,{id:'DespachoExterno${despacho.id}'}
					)
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
	});
	
	</sec:authorize>

provinciasStore.webflow({idDespacho:idDespacho});

	page.webflow({
		flow:'turnadodespachos/getEsquemaVigente'
		,params: null
		,success: function(data){

			<%-- No hay esquema de turnado, salimos  --%>
			if (data.id==null || data.id=='') {
				return;
			}
			
			<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_EDITAR">
			btnEditarTurnadoLetrado.setDisabled(false);
			btnEditarAmbitoActuacion.setDisabled(false);
			labelError.setText('');
			</sec:authorize>
			
			<c:if test="${not empty despacho.turnadoCodigoImporteLitigios or not empty despacho.turnadoCodigoImporteConcursal}">
			for(var i = 0; i < data.configuracion.length; i++) {
				config = data.configuracion[i];
				
				if(config.tipo == 'LI' && config.codigo == turnadoLitigiosTipoImporte.value) {
					turnadoLitigiosTipoImporte.value = config.descripcion;
				}
				else if(config.tipo == 'LC' && config.codigo == turnadoLitigiosTipoCalidad.value) {
					turnadoLitigiosTipoCalidad.value = config.descripcion;
				}
				else if(config.tipo == 'CI' && config.codigo == turnadoConcursosTipoImporte.value) {
					turnadoConcursosTipoImporte.value = config.descripcion;
				}
				else if(config.tipo == 'CC' && config.codigo == turnadoConcursosTipoCalidad.value) {
					turnadoConcursosTipoCalidad.value = config.descripcion;
				}
			}
			</c:if>
    	}
	});
	
	var panelSuperior = new Ext.Panel({
		title:'<s:message code="plugin.config.despachoExterno.turnado.ventana.panel.titulo" text="**Datos turnado"/>'
		,layout:'table'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		//,autoWidth:true
		,style:'margin-right:20px;margin-left:10px;'
		,border:true
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{width:330,items:[turnadoLitigiosPanel]}
			  ,{width:330,items:[turnadoConcursosPanel]}
			,{width:330,items:[ambitosActuacionPanel]}
			,{width:330,items:[provinciasGrid]}
			  ]
<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_EDITAR">
		, bbar : [btnEditarTurnadoLetrado,labelError,btnEditarAmbitoActuacion]
</sec:authorize>
	});

</pfslayout:tabpage>