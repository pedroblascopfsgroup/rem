<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<fwk:page>

		<pfs:hidden name="banderaEditar" value="1"/>
		<pfs:hidden name="idConvenio" value="${idConvenio}"/>
		<pfs:hidden name="idProcedimiento" value="${convenio.procedimiento.id}"/>
			
		<pfs:textfield name="descripcionConvenio" labelKey="asunto.concurso.tabConvenios.descripcionConvenio" label="Descripcion convenio" value="${convenio.descripcionConvenio}"  />
	<pfs:textfield name="numeroAuto" labelKey="asunto.concurso.tabFaseComun.numeroAuto" label="**Nº auto" value="${numeroAuto}" readOnly="true"/>
	<pfs:ddCombo name="estado" labelKey="asunto.concurso.tabFaseComun.estado" label="**Estado" value="${convenio.estadoConvenio.id}"  dd="${estados}" />
	<pfs:ddCombo name="postura" labelKey="asunto.concurso.tabConvenio.Postura" label="**Postura"  value="${convenio.posturaConvenio.id}"  dd="${posturas}" />
	<pfs:ddCombo name="inicio" labelKey="asunto.concurso.tabConvenio.inicio" label="**Origen" value="${convenio.inicioConvenio.id}" dd="${inicios}" />
	<pfs:ddCombo name="tipo" labelKey="asunto.concurso.tabConvenio.tipo" label="**Tipo" value="${convenio.tipoConvenio.id}" dd="${tipos}" />
	<pfs:ddCombo name="tipoAdhesion" labelKey="asunto.concurso.tabConvenio.Adhesion" label="**Adherirse" value="${convenio.tipoAdhesion.id}" dd="${tipoAdhesion}" />
	<pfs:datefield name="fecha" labelKey="asunto.concurso.tabConvenio.fechaPropuesta" label="**Fecha propuesta" obligatory="true" value="${convenio.fecha}" />
	<pfs:currencyfield name="numeroProponentes" labelKey="asunto.concurso.tabConvenio.numProponentes" label="**Nº proponentes" value="${convenio.numProponentes}" />
	<pfs:currencyfield name="totalMasa" labelKey="asunto.concurso.tabConvenio.totalMasaPasiva" label="**Total masa pasiva" value="${convenio.totalMasa}" />
	<pfs:currencyfield name="porcentaje" labelKey="asunto.concurso.tabConvenio.porcentajeSobreMasa" label="Porcentaje S/masa pasiva"  value="${convenio.porcentaje}" />
	<pfs:currencyfield name="totalMasaOrd" labelKey="asunto.concurso.tabConvenio.totalMasaPasivaOrd" label="Total masa ordinaria" value="${convenio.totalMasaOrd}" />
	<pfs:currencyfield name="porcentajeOrd" labelKey="asunto.concurso.tabConvenio.porcentajeSobreMasaOrd" label="Porcentaje S/masa ordinaria" value="${convenio.porcentajeOrd}" />
	<pfs:textfield name="descripcion" width="510" labelKey="asunto.concurso.tabConvenios.observaciones" label="**Descripcion proponentes"  value="${convenio.descripcion}" />
	<pfs:textfield name="descripcionAdhesiones" width="490" labelKey="asunto.concurso.tabConvenio.descripAdhesiones" label="**Descripcion adhesiones" value="${convenio.descripcionAdhesiones}" />
	<pfs:ddCombo name="alternativa" labelKey="asunto.concurso.tabConvenios.alternativa" label="Alternativa" value="${convenio.tipoAlternativa.id}"   dd="${tipoAlternativa}" />	
	
		var descripcionTerceros = new Ext.form.TextArea({
			fieldLabel:'<s:message code="asunto.concurso.tabConvenio.descripTerceros" text="**Descripción terceros"/>'
			,width:150
			,value:'<s:message text="${convenio.descripcionTerceros}" javaScriptEscape="true" />'
		});

		var descripcionAnticipado = new Ext.form.TextArea({
			fieldLabel:'<s:message code="asunto.concurso.tabConvenio.descripAnticipado" text="**Resumen propuesta convenio anticipado"/>'
			,width:150
			,value :'<s:message text="${convenio.descripcionAnticipado}" javaScriptEscape="true" />'
		});
			
		var terceros = new Ext.form.FieldSet({
			title:'<s:message code="asunto.concurso.terceros.titulo" text="Convenios de terceros"/>'
			,width:650
			,defaults :  {border : false }
			,bodyStyle : 'padding:0px; margin:0px; padding:0px; '
			,items : [
				 { xtype : 'errorList', id:'errL' }
				,{ xtype: 'container'
				  ,defaults :  {xtype : 'container', autoHeight : true, border : false }
				  ,bodyStyle : 'padding:0px; margin:0px; padding:0px; '
				  ,items:[
			 	 		 { layout:'table'
			 	 		   ,bodyStyle : 'padding:0px; margin:0px; padding:0px; '
						   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
						   ,items:[ {items:[descripcionTerceros, tipoAdhesion]}, {items:[descripcionAnticipado, postura]}]
						 }
			 	   ]}
			]
		});

		var propio = new Ext.form.FieldSet({
			title:'<s:message code="asunto.concurso.propio.titulo" text="Convenio propio"/>'
			,width:630
			,defaults :  {border : false }
			,items : [
				 { xtype : 'errorList', id:'errL' }
				,{ layout:'table'
				  ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				  ,items:[
			 	 		 {items:[descripcionAdhesiones]}
			 	   ]}
			]
		});

		
		<pfs:defineParameters name="parametros" paramId=""
			banderaEditar="banderaEditar"
			idProcedimiento="idProcedimiento"
			idConvenio="idConvenio"
			estado="estado"
			postura="postura"
			inicio="inicio"
			tipo="tipo"
			tipoAdhesion="tipoAdhesion"
			fecha_date="fecha"
			numeroProponentes="numeroProponentes"
			totalMasa="totalMasa"
			porcentaje="porcentaje"
			totalMasaOrd="totalMasaOrd"
			porcentajeOrd="porcentajeOrd"
			descripcion="descripcion"
			descripcionAdhesiones="descripcionAdhesiones"
			descripcionAnticipado="descripcionAnticipado"
			descripcionTerceros="descripcionTerceros"
			alternativa="alternativa"
			descripcionConvenio="descripcionConvenio"
		/>
				
		var btnGuardar = new Ext.Button({
			text : '<s:message code="app.guardar" text="**Guardar" />'
			<app:test id="btnGuardarBien" addComa="true" />
			,iconCls : 'icon_ok'
			,handler : function() {
							page.webflow({
								flow: 'plugin/concursal/editarConvenio'
								,params: parametros
								,success : function(){ 
									page.fireEvent(app.event.DONE); 
								}
							});
					   }
		});
		
		var btnCancelar= new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){ page.fireEvent(app.event.CANCEL); }
		});
		
		var fichaConvenio = new Ext.Container({
			autoHeight : true
			,border : false
			,layout:'anchor'
			,items : [
			 	 { xtype : 'errorList', id:'errL' }
			 	,{
			 		autoHeight:true
			 		,border:false
			 		,bodyStyle:'padding-left:20px; padding-right:20px;'
					,defaults :  {layout:'table', autoHeight : true, border : true, width:655, cellCls : 'vtop', bodyStyle : 'padding-left:5px' }
			 		,items:[
			 		   	 {  layout:'table'
						   ,border : false
						   ,bodyStyle : 'padding:0px; margin:0px; padding:0px; ' 
						   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
						   ,items:[
						 	 {items:[descripcionConvenio,numeroAuto, fecha, estado, inicio,tipo]}
						    ,{items:[ numeroProponentes, totalMasa, porcentaje,totalMasaOrd, porcentajeOrd,alternativa]}
						 ]}
						 ,{ layout:'form'
						   ,border : false
						   ,bodyStyle : 'padding-left:16px'
						   ,items:[descripcion]}
						 , terceros
						 , propio
					 ]
					 ,bbar : [
						<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_EDITAR_CONVENIO_GUARDAR">btnGuardar,</sec:authorize> btnCancelar
					 ]
				  } 
			  ]
		});

		page.add(fichaConvenio);

</fwk:page>
