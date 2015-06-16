<pfslayout:tabpage titleKey="plugin.config.despachoExterno.consultadespacho.cabecera.title" title="**Despacho" items="datos,zonificacion">
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho" name="tipoDespacho" value="${despacho.tipoDespacho.descripcion}" readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.despacho" label="**Despacho" name="despacho" value="${despacho.despacho}" readOnly="true"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.tipoVia" label="**Tipo de Via" name="tipoVia" value="${despacho.tipoVia}" readOnly="true" width="75"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.domicilio" label="**Domicilio" name="domicilio" value="${despacho.domicilio}" readOnly="true"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.domicilioPlaza" label="**Numero" name="domicilioPlaza" value="${despacho.domicilioPlaza}" width="50" readOnly="true"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.personaContacto" label="**Persona de contacto" name="personaContacto" value="${despacho.personaContacto}" readOnly="true" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.telefono1" label="**Telefono 1" name="telefono1" value="${despacho.telefono1}" readOnly="true" labelWidth="150"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.telefono2" label="**Telefono 2" name="telefono2" value="${despacho.telefono2}" readOnly="true" labelWidth="150"/>
	var txtTiposGestor='';
	<c:forEach items="${tiposGestorPropiedad}" var="tiposGestor">
		txtTiposGestor = txtTiposGestor + '<p>- ${tiposGestor.descripcion}</p>';
	</c:forEach>

	var tiposGestor_labelStyle='font-weight:bolder;width:100';
	var tiposGestor = new Ext.ux.form.StaticTextField({
		name: 'tiposGestor'
		,fieldLabel : '<s:message code="plugin.config.despachoExterno.field.tiposGestor" text="**Tipos de Gestor" />'
		//,value: txtTiposGestor
		//,renderer: 'htmlEncode'
		,width: 150
		,height: 200
		,labelStyle: tiposGestor_labelStyle
		,html: txtTiposGestor
		//,style:'margin-top:5px'
		,readOnly: true
	});
	
	<%--ZONIFICACIÓN --%>
	
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.zona.nivel.descripcion" label="**Nivel" name="nivelDespacho" value="${despacho.zona!=null?despacho.zona.nivel.descripcion:''}" readOnly="true"/>
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.field.zona.descripcion" label="**Zona" name="zonaDespacho" value="${despacho.zona!=null?despacho.zona.descripcion:''}" readOnly="true" labelWidth="150"/>
	
	
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
	
	<pfs:panel titleKey="plugin.config.despachoExterno.consultadespacho.cabecera.control.datos" name="datos" columns="2" collapsible="" title="**Datos Despacho" bbar="btModificar" >
		<pfs:items items="despacho, tipoDespacho,tiposGestor"/>
		<pfs:items items="tipoVia, domicilio, domicilioPlaza, personaContacto, telefono1,telefono2"/>
	</pfs:panel>
	
	<pfs:buttonedit name="btModificarZonificacion"
			flow="plugin/config/despachoExterno/ADMmodificarZonificacionDespachoExterno"  
			windowTitleKey="plugin.config.despachoExterno.zonificar.windowName" 
			parameters="modDespParams" 
			windowTitle="**Modificar zonificación despacho" on_success="recargar"/>
	
	<pfs:panel titleKey="plugin.config.despachoExterno.consultadespacho.cabecera.control.zonificacion" name="zonificacion" columns="2" collapsible="" title="**Zonificacion" bbar="btModificarZonificacion" >
		<pfs:items items="nivelDespacho"/>
		<pfs:items items="zonaDespacho"/>
	</pfs:panel>
</pfslayout:tabpage>