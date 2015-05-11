<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
//----------------------------------------------------------------
// Inicio actuaciones Realizadas
//----------------------------------------------------------------

var crearConclusiones=function(){
	
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:120px'
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'	
	var style='margin-bottom:1px;margin-top:1px';
	
	//TIPO ACUERDO
	var tipoAcuerdoCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.conclusiones.tipoAcuerdoCombo" text="**Tipo Acuerdo" />'
		,value : '${acuerdo.tipoAcuerdo.descripcion}'
		,name : 'tipoAcuerdoCombo'
		,labelStyle:labelStyle
	});
	//SOLICITANTE
	
 	var solicitanteCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.conclusiones.solicitanteCombo" text="**Solicitante" />'
		,value : '${acuerdo.solicitante.descripcion}'
		,name : 'solicitante'
		,labelStyle:labelStyle
	});
	
	//ESTADO
	 var estadoCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.conclusiones.estadoCombo" text="**Estado" />'
		,value : '${acuerdo.estadoAcuerdo.descripcion}'
		,name : 'estado'
		,labelStyle:labelStyle
		,readOnly:true
	});

	//OBSERVACIONES

	var observacionesConclusion = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.conclusiones.observaciones" text="**Observaciones"/>'
		,width:200
		,readOnly:true
		,labelStyle:labelStyle
		<app:test id="observacionesConclusion" addComa="true"/>	
	});
	
	observacionesConclusion.setValue('<s:message javaScriptEscape="true" text="${acuerdo.observaciones}"/>' );

	//TIPO DE PAGO
	var tipoPagoCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.conclusiones.tipoPagoCombo" text="**Tipo Pago" />'
		,value : '${acuerdo.tipoPagoAcuerdo.descripcion}'
		,name : 'tipoPagoAcuerdo'
		,labelStyle:labelStyle
	});

	//IMPORTE PAGO
	var importePago= new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.conclusiones.importePago" text="**Importe Pago" />'
		,value : '${acuerdo.importePago}'
		,name : 'importePago'
		,labelStyle:labelStyle
	});

	//PERIODO
	var periodo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.conclusiones.periodicidadCombo" text="**Periodicidad" />'
		,value : '${acuerdo.periodo} ${acuerdo.periodicidadAcuerdo.descripcion}'
		,name : 'periodicidadAcuerdo'
		,labelStyle:labelStyle
	});

	<c:if test="${puedeEditar || (esGestor && acuerdo.estaVigente)}">
		var btnEditConclusiones = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="btnEditConclusiones" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      	       var w = app.openWindow({
			          flow : 'acuerdos/editarAcuerdo'
			          ,closable:false
			          ,width : 800
			          ,title : '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />'
			          ,params : {idAsunto:${idAsunto},idAcuerdo:${acuerdo.id}, readOnly:false}
			       });
			       w.on(app.event.DONE, function(){
			          w.close();
			          page.fireEvent(app.event.DONE);
			       });
			       w.on(app.event.CANCEL, function(){ w.close(); });
	     	}
	    });
	</c:if>
	
   return {
		title:'<s:message code="acuerdos.conclusiones.titulos" text="**Conclusiones de la Propuesta"/>'
		,xtype:'fieldset'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false ,width:350}
		,items : [
		 	{items:[
		 		tipoAcuerdoCombo
		 		,solicitanteCombo
		 		,estadoCombo
				,tipoPagoCombo
		 		<c:if test="${puedeEditar || (esGestor && acuerdo.estaVigente)}">
		 			, btnEditConclusiones
		 		</c:if>
		 	]}
		 	,{items:[
		 		importePago
				,periodo
		 		,observacionesConclusion
		 	]}
		]
		,doLayout:function() {
				var margin = 50;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	}   
   
 };

//----------------------------------------------------------------
//Fin Actuaciones Realizadas
//----------------------------------------------------------------