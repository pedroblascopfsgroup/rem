<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
	
	
(function(){
	var cfg = {labelStyle:"width:200px;font-weight:bolder",width:375};
	var limit = 10;
	var expediente=
		<json:object name="expediente">
			<json:property name="id" value="${expediente.id}" />
			<json:property name="fcreacion" value="${expediente.auditoria.fechaCrear}" />
			<json:property name="fmodificacion" value="${expediente.auditoria.fechaModificar}" />
			<json:property name="umodificacion" value="${expediente.auditoria.usuarioModificar}" />
			<json:property name="estado" value="${expediente.estadoExpediente}" />
			<json:property name="volumenRiesgo" value="${expediente.volumenRiesgoAbsoluto}" />
			<json:property name="volumenRiesgoVencido" value="${expediente.volumenRiesgoVencidoAbsoluto}" />
		</json:object>;
		
	
	
	
	var txtCodExpediente	= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.codigo" text="**Codigo"/>',expediente.id,cfg);
	var txtFechaCreacion	= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.creacion" text="**Fecha Creacion"/>',"<fwk:date value='${expediente.auditoria.fechaCrear}'/>",cfg);
	var situacionData = '${expediente.estadoItinerario.descripcion}';
	if('${expediente.arquetipo.itinerario.dDtipoItinerario.descripcion}'!='')
		situacionData = situacionData + ' / ${expediente.arquetipo.itinerario.dDtipoItinerario.descripcion}';
	var txtSituacion		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.situacion" text="**Situacion"/>',situacionData,cfg);
	var txtEstado			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.estado" text="**Estado"/>','${expediente.estadoExpediente.descripcion}',cfg);
	var txtDescripcion		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.descripcion" text="**Descripcion"/>','<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />',cfg);
	
	var txtDiasVencido		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.diasvencido" text="**Dias Venc"/>',${expediente.diasVencido},cfg);

	var txtVolRiesgos		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.riesgos" text="**Volumen riesgos"/>',app.format.moneyRenderer('${expediente.volumenRiesgoAbsoluto}'),cfg);
	var txtVolRiesgosVenc	= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.riesgosvencidos" text="**Volumen riesgos Vencidos"/>',app.format.moneyRenderer('${expediente.volumenRiesgoVencidoAbsoluto}'),cfg);
	var txtComite			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.comite" text="**Comite"/>','${expediente.comite.nombre}',cfg);
	var txtFechaComite		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.fechavto" text="**Fecha Comite"/>',"<fwk:date value='${expediente.fechaVencimiento}' />",cfg);
	
	var txtOficina			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.oficina" text="**Oficina"/>','${expediente.oficina.nombre}',cfg);
	var txtFechaUltModif	= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.ultimamodif" text="**Fecha Ultima Mod."/>',"<fwk:date value='${expediente.auditoria.fechaModificar}'/>",cfg);
	var txtUsuModif			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.usuariomodif" text="**Usuario Ult. Modificacion"/>',expediente.umodificacion,cfg);
	var txtManual			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.manual" text="**Manual"/>',app.format.booleanToYesNoRenderer(${expediente.manual}),cfg);
	
	var txtGestor			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.gestor" text="**Gestor"/>','${expediente.gestorActual}',cfg);
	var txtSupervisor		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>','${expediente.supervisorActual}',cfg);
	


	var datosPrincipalesFieldSet = new Ext.form.FieldSet({
		autoHeight:'false'
		,style:'padding:0px'
		,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,width:770
		,title:'<s:message code="menu.clientes.consultacliente.menu.DatosPrincipales" text="**Datos Principales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
				  {items:[txtCodExpediente,txtDescripcion,txtFechaCreacion]},
				  {items:[txtManual,txtUsuModif,txtFechaUltModif]}
		]
	
	});
	
	var datosGestionFieldSet = new Ext.form.FieldSet({
		autoHeight:'false'
		,style:'padding:0px'
		,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,width:770
		,title:'<s:message code="menu.clientes.consultacliente.menu.DatosGestion" text="**Datos Gestion"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
				  {items:[txtEstado,txtSituacion,txtGestor,txtSupervisor,txtFechaComite]},
				  {items:[txtDiasVencido,txtVolRiesgos,txtVolRiesgosVenc,txtComite,txtOficina]}
		]
	
	});
		
		//Panel propiamente dicho...
		var panel=new Ext.Panel({
		title:'<s:message code="contrato.consulta.tabcabecera.titulo" text="**Cabecera"/>'
			,autoScroll:true
			,width:770
			,autoHeight:true
			//,autoWidth : true
			,layout:'table'
			,bodyStyle:'padding:5px;margin:5px'
			,border : false
		    ,layoutConfig: {
		        columns: 1
		    }
			,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
			,items:[ datosPrincipalesFieldSet,datosGestionFieldSet]
			,nombreTab : 'cabecera'
		});
		
		return panel;

})()