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
	<c:set var="provincias" value="" scope="page" />
	<c:forEach var="ambito" items='${ambitoGreograficoDespacho}'
		varStatus="stat">
		<c:if test="${not empty ambito.comunidad}">
			<c:set var="comunidades"
				value="${stat.first ? '' : comunidades}${!stat.first and not empty comunidades ? ' / ' : ' '}${ambito.comunidad.descripcion}"
				scope="page" />
		</c:if>
		<c:if test="${not empty ambito.provincia}">
			<c:set var="provincias"
				value="${stat.first ? '' : provincias}${!stat.first and not empty provincias ? ' / ' : ' '}${ambito.provincia.descripcion}"
				scope="page" />
		</c:if>
	</c:forEach>
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.tabEsquema.ambitoactuacion.comunidades"
		label="**Comunidades" name="comunidadesActuacion"
		value="${comunidades}" readOnly="true" />
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.tabEsquema.ambitoactuacion.provincias"
		label="**Provincias" name="provinciasActuacion" value="${provincias}"
		readOnly="true" />

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
		,style:'margin-right:20px;margin-left:10px'
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
		,style:'margin-right:20px;margin-left:10px'
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
		,style:'margin-right:20px;margin-left:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{layout:'form',items:[comunidadesActuacion, provinciasActuacion]}
		]
	});

	
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
						,{id:${despacho.id}}
						,{id:'DespachoExterno${despacho.id}'}
					)
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
	});
	</sec:authorize>

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
			columns:3
		}
		//,autoWidth:true
		,style:'margin-right:20px;margin-left:10px;'
		,border:true
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{width:330,items:[turnadoLitigiosPanel]}
			  ,{width:330,items:[turnadoConcursosPanel]}
			  ,{width:330,items:[ambitosActuacionPanel]}
			  ]
<sec:authorize ifAllGranted="ROLE_ESQUEMA_TURNADO_EDITAR">
		, bbar : [btnEditarTurnadoLetrado,labelError]
</sec:authorize>
	});
	
</pfslayout:tabpage>