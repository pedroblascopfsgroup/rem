<pfslayout:tabpage
	titleKey="plugin.config.despachoExterno.turnado.title"
	title="**Turnado de despacho" items="panelSuperior">

	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.litigios.tipoImporte"
		label="**Tipo importe" name="turnadoLitigiosTipoImporte"
		value="${despacho.turnadoCodigoImporteLitigios}" readOnly="true" />
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.litigios.tipoCalidad"
		label="**Tipo calidad" name="turnadoLitigiosTipoCalidad"
		value="${despacho.turnadoCodigoCalidadLitigios}" readOnly="true" />
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.concursos.tipoImporte"
		label="**Tipo importe" name="turnadoConcursosTipoImporte"
		value="${despacho.turnadoCodigoImporteConcursal}" readOnly="true" />
	
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.concursos.tipoCalidad"
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
		labelKey="plugin.config.despachoExterno.turnado.ambitoactuacion.comunidades"
		label="**Comunidades" name="comunidadesActuacion"
		value="${comunidades}" readOnly="true" />
	<pfsforms:textfield
		labelKey="plugin.config.despachoExterno.turnado.ambitoactuacion.provincias"
		label="**Provincias" name="provinciasActuacion" value="${provincias}"
		readOnly="true" />

	<c:if test="${not empty despacho.turnadoCodigoImporteLitigios or not empty despacho.turnadoCodigoImporteConcursal}">
	page.webflow({
		flow:'turnadodespachos/getEsquemaVigente'
		,params: null
		,success: function(data){
			debugger;
    	}
	});
	</c:if>

	var turnadoConcursosPanel = new Ext.Panel({
		layout:'table'
		,title : '<s:message
		code="plugin.config.despachoExterno.turnado.concursos.titulo"
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
		code="plugin.config.despachoExterno.turnado.litigios.titulo"
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
		code="plugin.config.despachoExterno.turnado.ambitoActuacion.titulo"
		text="**Ámbitos actuación" />'
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

	var panelSuperior = new Ext.Panel({
		layout:'table'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:3
		}
		//,autoWidth:true
		,style:'margin-right:20px;margin-left:10px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{width:330,items:[turnadoLitigiosPanel]}
			  ,{width:330,items:[turnadoConcursosPanel]}
			  ,{width:330,items:[ambitosActuacionPanel]}
			  ]
	});


</pfslayout:tabpage>