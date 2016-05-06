<pfslayout:tabpage titleKey="plugin.config.despachoExterno.consultadespacho.cabecera.title" title="**Despacho" items="datos,zonificacion">
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho" name="tipoDespacho" value="${despacho.tipoDespacho.descripcion}" readOnly="true" width="350" labelWidth="150" />
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.despacho" label="**Despacho" name="despacho" value="${despacho.despacho}" readOnly="true"  width="350" labelWidth="150" />
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.tipoVia" label="**Tipo de Via" name="tipoVia" value="${despacho.tipoVia}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.domicilio" label="**Domicilio" name="domicilio" value="${despacho.domicilio}" readOnly="true" width="350" labelWidth="150" />
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.domicilioPlaza" label="**Numero" name="domicilioPlaza" value="${despacho.domicilioPlaza}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.personaContacto" label="**Persona de contacto" name="personaContacto" value="${despacho.personaContacto}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.telefono1" label="**Telefono 1" name="telefono1" value="${despacho.telefono1}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.telefono2" label="**Telefono 2" name="telefono2" value="${despacho.telefono2}" readOnly="true" width="350" labelWidth="150"/>
	
	
	<%-- PRODUCTO-1272 Campos visibles solo para BANKIA por ahora --%>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.cp" label="**CP" name="codigoPostal" value="${despacho.codigoPostal}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.fax" label="**Fax" name="fax" value="${despachoExtras.fax}" readOnly="true" width="350" labelWidth="150"/>	
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.fechaAlta" label="**Fecha alta" name="fechaAlta" value="${despachoExtras.fechaAlta}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.correoElectronico" label="**correoElectronico" name="correoElectronico" value="${despachoExtras.correoElectronico}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.tipoDocumento" label="**tipoDocumento" name="tipoDocumento" value="${despachoExtras.tipoDoc}" readOnly="true" width="350" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExternoExtras.field.documento" label="**documento CIF" name="documentoCif" value="${despachoExtras.documentoCif}" readOnly="true" width="350" labelWidth="150"/>
	
	<%-- Fin Campos nuevos --%>
	
	<%-- Se cambia la forma de mostrar los tipos de Gestores, para que se muestre en una lista --%>
	var tipoGestor = Ext.data.Record.create([
		 {name:'codigo'}
		 ,{name:'descripcionTipoGestor'}

	]);
	var tiposGestorStore = page.getStore({
		 flow: '' 
		,reader: new Ext.data.JsonReader({
	    	 root : 'data'
	     }, tipoGestor)
	});
	

	var tiposGestorCm = new Ext.grid.ColumnModel([	    
		{dataIndex: 'codigo', hidden: true}
		,{dataIndex: 'descripcionTipoGestor', sortable: true}
		]);

	
	var tiposGestorGrid = new Ext.grid.GridPanel({
		store: tiposGestorStore
		,cm: tiposGestorCm
		,title:'<s:message code="plugin.config.despachoExterno.field.tiposGestor" text="**Tipos de Gestor" />'
		,hideHeaders: true
		,autoWidth:true
		,height: 150
		,width: 200
		,autoExpandColumn: true
		,titleCollapse : true
		,style:'padding-left:50px;padding-bottom:10px'
	});


	<c:forEach items="${tiposGestorPropiedad}" var="tiposGestor">		
		var tipoGestorAInsertar = tiposGestorGrid.getStore().recordType; 
		
   		var p = new tipoGestorAInsertar({
   			codigo: '${tiposGestor.codigo}',
   			descripcionTipoGestor: '${tiposGestor.descripcion}'
   		});
		tiposGestorStore.insert(0, p); 
	</c:forEach>
	<%-- Fin modificaciones PRODUCTO-1272 --%>
	
	
	<%--ZONIFICACIÓN --%>
	
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.zona.nivel.descripcion" label="**Nivel" name="nivelDespacho" value="${despacho.zona!=null?despacho.zona.nivel.descripcion:''}" readOnly="true" labelWidth="100"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.zona.descripcion" label="**Zona" name="zonaDespacho" value="${despacho.zona!=null?despacho.zona.descripcion:''}" readOnly="true" labelWidth="100"/>
	
	
	<pfs:defineParameters name="modDespParams" paramId="${despacho.id}" />
	
	var recargar = function (){
		app.openTab('${despacho.despacho}'
					,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
					,{id:${despacho.id}}
					,{id:'DespachoExterno${despacho.id}'}
				)
	};
	
	<pfs:buttonedit name="btModificar" 
			flow="plugin/config/despachoExterno/ADMmodificarDespachoExterno"  
			windowTitleKey="plugin.config.despachoExterno.modificar.windowName" 
			parameters="modDespParams" 
			windowTitle="**Modificar despacho" 
			defaultWidth="800"
			on_success="recargar" />
			
	<pfs:panel titleKey="plugin.config.despachoExterno.consultadespacho.cabecera.control.datos" name="datos" columns="4" collapsible="" title="**Datos Despacho" bbar="btModificar" >
		<pfs:items items="despacho, tipoDespacho, tiposGestorGrid"/>
		<pfs:items items="tipoVia, domicilio, domicilioPlaza, personaContacto, telefono1, telefono2"/>		
	</pfs:panel>
	
	<%--PRODUCTO-1272 Para Bankia se mostraran los nuevos campos --%>
	<c:if test="${usuarioEntidad == 'BANKIA'}">
		<pfs:panel titleKey="plugin.config.despachoExterno.consultadespacho.cabecera.control.datos" name="datos" columns="4" collapsible="" title="**Datos Despacho" bbar="btModificar" >
			<pfs:items items="despacho, tipoDespacho, tiposGestorGrid, tipoDocumento, documentoCif, fechaAlta"/>
			<pfs:items items="tipoVia, domicilio, domicilioPlaza, codigoPostal, personaContacto, telefono1,telefono2, fax, correoElectronico"/>		
		</pfs:panel>
	</c:if>

	<pfs:buttonedit name="btModificarZonificacion"
			flow="plugin/config/despachoExterno/ADMmodificarZonificacionDespachoExterno"  
			windowTitleKey="plugin.config.despachoExterno.zonificar.windowName" 
			parameters="modDespParams" 
			windowTitle="**Modificar zonificación despacho" on_success="recargar"/>
	
	var zonificacion = new Ext.Panel ({
		title : '<s:message code="plugin.config.despachoExterno.consultadespacho.cabecera.control.zonificacion" text="**Zonificacion" />',
        style:'margin-right:20px;margin-left:10px;margin-top:30px',
    	autoHeight:true,
        bodyStyle: 'padding:10px;',
        layout: 'form',
        items:[nivelDespacho,zonaDespacho],
        bbar:[btModificarZonificacion]
    });
	
</pfslayout:tabpage>