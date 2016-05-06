<pfslayout:tabpage titleKey="plugin.config.despachoExterno.consultadespacho.adicionales.title" title="**Datos adicionales" items="datos">
	
	<%-- PRODUCTO-1272 Campos visibles solo para BANKIA por ahora --%>
	
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.contratoVigor" label="**Contrato en vigor" name="contratoVigor" value="${despachoExtras.contratoVigor}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.servicioIntegral" label="**Servicio integral" name="servicioIntegral" value="${despachoExtras.servicioIntegral}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.concursos" label="**Concursos" name="concursos" value="${despachoExtras.clasifDespachoConcursos}" readOnly="true" labelWidth="80"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.perfil" label="**Perfil" name="perfil" value="${despachoExtras.clasifDespachoPerfil}" readOnly="true" labelWidth="80"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.codEstAse" label="**Estado letrado" name="codEstAse" value="${despachoExtras.codEstAse}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaContacto" label="**Oficina Contacto" name="oficinaContacto" value="${despachoExtras.oficinaContacto}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadContacto" label="**Entidad Contacto" name="entidadContacto" value="${despachoExtras.entidadContacto}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadLiquidacion" label="**Entidad liquidacion" name="entidadLiquidacion" value="${despachoExtras.entidadLiquidacion}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaLiquidacion" label="**Oficina liquidacion" name="oficinaLiquidacion" value="${despachoExtras.oficinaLiquidacion}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.digconLiquidacion" label="**Digitos Control liq." name="digconLiquidacion" value="${despachoExtras.digconLiquidacion}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaLiquidacion" label="**Cuenta liquidacion" name="cuentaLiquidacion" value="${despachoExtras.cuentaLiquidacion}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadProvisiones" label="**Entidad provisiones" name="entidadProvisiones" value="${despachoExtras.entidadProvisiones}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaProvisiones" label="**Oficina provisiones" name="oficinaProvisiones" value="${despachoExtras.oficinaProvisiones}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.digconProvisiones" label="**Digitos Control prov." name="digconProvisiones" value="${despachoExtras.digconProvisiones}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaProvisiones" label="**Cuenta provisiones" name="cuentaProvisiones" value="${despachoExtras.cuentaProvisiones}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadEntregas" label="**Entidad entregas" name="entidadEntregas" value="${despachoExtras.entidadEntregas}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaEntregas" label="**Oficina entregas" name="oficinaEntregas" value="${despachoExtras.oficinaEntregas}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.digconEntregas" label="**Digitos Control ent." name="digconEntregas" value="${despachoExtras.digconEntregas}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaEntregas" label="**Cuenta entregas" name="cuentaEntregas" value="${despachoExtras.cuentaEntregas}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.centroRecuperacion" label="**Centro Recuperacion" name="centroRecuperacion" value="${despachoExtras.centroRecuperacion}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.tieneAsesoria" label="**Asesoria" name="tieneAsesoria" value="${despachoExtras.asesoria}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.impuesto" label="**impuesto" name="impuesto" value="${despachoExtras.ivaDescripcion}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.irpfAplicado" label="**irpfAplicado" name="irpfAplicado" value="${despachoExtras.irpfAplicado}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.fechaServicioIntegral" label="**Fecha SI" name="fechaServicioIntegral" value="${despachoExtras.fechaServicioIntegral}" readOnly="true" width="230" labelWidth="180"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.relacionBankia" label="**Relacion Bankia" name="relacionBankia" value="${despachoExtras.relacionBankia}" readOnly="true" width="230" labelWidth="180"/>
	
	
	var clasificacionFieldSet = new Ext.form.FieldSet({
		autoHeight:'true'
		,width:190
		,style:'padding:5px'
 		,border:true
		//,layout : 'table'
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.config.despachoExternoExtras.fieldSet.title" text="**Clasificacion despacho"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:170}
		//,items : [{items:concursos},{items:perfil}]
		,items : [concursos,perfil]
	});	
	
	var provinciaRecord = Ext.data.Record.create([
		 {name:'codigo'}
		 ,{name:'descripcion'}

	]);
	var provinciasStrore = page.getStore({
		 flow: '' 
		,reader: new Ext.data.JsonReader({
	    	 root : 'data'
	     }, provinciaRecord)
	});
	

	var provinciasCm = new Ext.grid.ColumnModel([	    
		{dataIndex: 'codigo', hidden: true}
		,{dataIndex: 'descripcion', sortable: true}
		]);

	
	var provinciasGrid = new Ext.grid.GridPanel({
		store: provinciasStrore
		,cm: provinciasCm
		,title:'<s:message code="plugin.config.despachoExternoExtras.field.provincias" text="**Provincias" />'
		,hideHeaders: true
		,autoWidth:true
		,height: 250
		,width: 200
		,autoExpandColumn: true
		,titleCollapse : true
		,style:'padding-left:2px;padding-bottom:10px;padding-right:10px'
	});


	<c:forEach items="${ambitoDespachoExtras}" var="provinciasExtras">		
		var provinciaRecordAInsertar = provinciasGrid.getStore().recordType; 
		
   		var p = new provinciaRecordAInsertar({
   			codigo: '${provinciasExtras.codigo}',
   			descripcion: '${provinciasExtras.descripcion}'
   		});
		provinciasStrore.insert(0, p); 
	</c:forEach>
	
	<%-- Fin Campos PRODUCTO-1272 --%>


	<pfs:defineParameters name="modDespParams" paramId="${despacho.id}" />
	
	var recargar = function (){
		app.openTab('${despacho.despacho}'
					,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
					,{id:${despacho.id}}
					,{id:'DespachoExterno${despacho.id}'}
				)
	};
	
	<pfs:buttonedit name="btModificar" 
			flow=""  
			windowTitleKey="plugin.config.despachoExterno.modificar.windowName" 
			parameters="modDespParams" 
			windowTitle="**Modificar despacho" 
			defaultWidth="800"
			on_success="recargar" />
	
	<pfs:panel titleKey="plugin.config.despachoExterno.consultadespacho.adicionales.grid.title" name="datos" columns="3" collapsible="" title="**Datos Despacho" bbar="btModificar" >
		<pfs:items items="clasificacionFieldSet, provinciasGrid"/>
		<pfs:items items="contratoVigor, servicioIntegral, codEstAse, oficinaContacto, entidadContacto, entidadLiquidacion, oficinaLiquidacion, digconLiquidacion, cuentaLiquidacion" />
		<pfs:items items="entidadProvisiones, oficinaProvisiones, digconProvisiones, cuentaProvisiones, entidadEntregas, oficinaEntregas, digconEntregas, cuentaEntregas, centroRecuperacion, tieneAsesoria, relacionBankia" />
		
	</pfs:panel>	
</pfslayout:tabpage>