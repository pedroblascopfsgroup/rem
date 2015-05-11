<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
	var labelStyle='font-weight:bolder;width:150';
	
	var oficina='<s:message text="${expediente.oficina.nombre}" javaScriptEscape="true" />';

	var idEntidad = '${expediente.id}';
	var idTipoEntidad = 'idTipoEntidadInformacion';
	var idEntidadInformacion = new Ext.form.Hidden({name:'idEntidadInformacion', value :idEntidad}) ;

	strTipoEntidad="Expediente";
	
	//Nombre y Apellidos del 1er titular del Contrato de pase del expediente
	descripcionEntidad='<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />';
	
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />', idEntidad,{labelStyle:labelStyle});

	var txtDescripcionEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.descripcionentidad" text="**Descripcion" />', descripcionEntidad,{labelStyle:labelStyle});

	//textfield que va a contener la oficina de la entidad
	var txtOficina = app.creaLabel('<s:message code="plugin.coreextension.oficina.descripcion" text="**Oficina actual" />',oficina,{labelStyle:labelStyle});

	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,bodyStyle:'padding:5px'
		,items:[txtEntidad,txtDescripcionEntidad,txtOficina]
		,autoHeight:true
	});

	<c:if test="${oficinas!=null}">
		var dictOficinas =
		<json:object name="dictOficinas">
			<json:array name="oficinas" items="${oficinas}" var="ofi">
					<json:object>
						<json:property name="codigo" value="${ofi.id}" />
						<json:property name="descripcion" value="${ofi.codigo}- ${ofi.nombre}" />
					</json:object>
			</json:array>
		</json:object>
	</c:if>

	var optionsOficinasStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'oficinas'
	       ,data : dictOficinas
	});

	var comboOficinas = new Ext.form.ComboBox({
				name:oficina
				<app:test id="oficinasCombo" addComa="true" />
				,hiddenName:'oficina'
				,store:optionsOficinasStore
				,valueField:'codigo'
				,displayField:'descripcion'
				,mode: 'local'
				,editable: false
				,triggerAction: 'all'
				,width:300
				,fieldLabel : '<s:message code="plugin.coreextension.oficina.seleccion" text="**Oficinas"/>'
	});
		
	var arr = [panelDatosEntidad,comboOficinas,idEntidadInformacion];

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			 	page.fireEvent(app.event.CANCEL);  	
			}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (comboOficinas.validate() && comboOficinas.getValue()!=null && comboOficinas.getValue()!=''){
				page.webflow({
					flow:'expediente/plugin.core.expedientes.enviarCambioOficina'
					,formPanel : panelEdicion
					,params: {idExpediente:idEntidad, idOficina:comboOficinas.getValue()}
					,success : function(){ page.fireEvent(app.event.DONE) }
				});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expediente.solicitudCancelacion.detalleNulo"/>')
			}
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,border : false
		,bodyStyle:'padding:5px'
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,autoHeight:true
				,xtype:'fieldset'
				,items : arr
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	
	page.add(panelEdicion);

/*	if(optionsOficinasStore.getCount()==1){	
		var text = optionsOficinasStore.getAt(0).get(comboOficinas.displayField).replace("&#039;",'´');
		comboOficinas.setValue(text);
		comboOficinas.setDisabled(true);
		btnGuardar.setDisabled(true);
	}
*/
</fwk:page>	