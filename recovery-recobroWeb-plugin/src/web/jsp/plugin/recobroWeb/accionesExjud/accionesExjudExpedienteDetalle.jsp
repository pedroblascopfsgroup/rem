<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>
		
	var labelStyle='font-weight:bolder;width:150px'	

	var booleanRenderer = function(value){
		if(value=='true'){
			return "Sí";
		}
		else if(value=='false'){
			return "No";
		}
	};
	

	//No se mostrará este campo BCFI-560
	var id = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.id" text="**Id" />'
		,id:'id'
		,value:'${acc.id}'
		,name:'accion.importe'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var fechaExtraccion = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.fechaExtraccion" text="**Fecha extraccion" />'
		,id:'fechaExtraccion'
		,value:app.format.dateRenderer('${acc.fechaExtraccion}')
		,name:'accion.fechaExtraccion'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var idAccion = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.idAccion" text="**Id acción" />'
		,id:'idAccion'
		,value:'${acc.codigoAccion}'
		,name:'accion.idAccion'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var idEnvio = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.idEnvio" text="**Id envio" />'
		,id:'idEnvio'
		,value:'${acc.idEnvio}'
		,name:'accion.idEnvio'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var propietario = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.propietario" text="**propietario" />'
		,id:'propietario'
		,value:'${acc.propietarios.id}'
		,name:'accion.propietario'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var persona = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.persona" text="**Persona" />'
		,id:'persona'
		,value:'${acc.persona.id}'
		,name:'accion.persona'
		,labelStyle:labelStyle
		,readOnly: true
	});   
	
	var codClienteEntidad = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.codClienteEntidad" text="**codClienteEntidad" />'
		,id:'codClienteEntidad'
		,value:'${acc.codigoEntidadPersona}'
		,name:'accion.codClienteEntidad'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var contrato = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.contrato" text="**contrato" />'
		,id:'contrato'
		,value:'${acc.contrato.id}'
		,name:'accion.contrato'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var cntContrato = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.cntContrato" text="**cntContrato" />'
		,id:'cntContrato'
		,value:'${acc.codigoContrato}'
		,name:'accion.cntContrato'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var palancasPermitidas = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.palancasPermitidas" text="**palancasPermitidas" />'
		,id:'palancasPermitidas'
		,value:''
		,name:'accion.palancasPermitidas'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var fechaGestion = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.fechaGestion" text="**Fecha gestión" />'
		,id:'fechaGestion'
		,value:app.format.dateRenderer('${acc.fechaGestion}')
		,name:'accion.fechaGestion'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var horaGestion = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.horaGestion" text="**horaGestion" />'
		,id:'horaGestion'
		,value:'${acc.horaGestion}'
		,name:'accion.horaGestion'
		,labelStyle:labelStyle
		,readOnly: true
	});
		
	var tipoGestion = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.tipoGestion" text="**tipoGestion" />'
		,id:'tipoGestion'
		,value:'${acc.tipoGestion.descripcion}'
		,name:'accion.tipoGestion'
		,labelStyle:labelStyle
		,readOnly: true
	});	
		
	var telefono = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.telefono" text="**telefono" />'
		,id:'telefono'
		,value:'${acc.telefono}'
		,name:'accion.telefono'
		,labelStyle:labelStyle
		,readOnly: true
	});	
		
	var direccion = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.direccion" text="**direccion" />'
		,id:'direccion'
		,value:'${acc.direccion}'
		,name:'accion.direccion'
		,labelStyle:labelStyle
		,readOnly: true
	});	
		
	var codigoDireccion = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.direccion" text="**codigoDireccion" />'
		,id:'codigoDireccion'
		,value:'${acc.codigoDir}'
		,name:'accion.codigoDireccion'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var codigoGestion = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.codigoGestion" text="**codigoGestion" />'
		,id:'codigoGestion'
		,value:'${acc.tipoGestion.codigo}'
		,name:'accion.codigoGestion'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var observacionesGestor = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.observacionesGestor" text="**Observaciones Gestor" />'
		,id:'Gestor'
		,value:'${acc.observacionesGestor}'
		,name:'accion.observacionesGestor'
		,labelStyle:labelStyle
		,readOnly: true
		,width: 200
	});	
	
	var resultadoGestionTelefonica = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.resultadoGestionTelefonica" text="**resultadoGestionTelefonica" />'
		,id:'resultadoGestionTelefonica'
		,value:'${acc.resultadoGestionTelefonica.descripcion}'
		,name:'accion.resultadoGestionTelefonica'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var resultadoMensajeria = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.resultadoMensajeria" text="**Resultado mensajería" />'
		,id:'resultadoMensajeria'
		,value:'${acc.resultadoMensajeria.agencia.codigo}'+'-'+'${acc.resultadoMensajeria.resultadoGestionMensajeria.descripcion}'
		,name:'accion.resultadoGestionTelefonica'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var importeComprometido = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.importeComprometido" text="**importeComprometido" />'
		,id:'importeComprometido'
		,value:'${acc.importeComprometido}'
		,name:'accion.importeComprometido'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var fechaPagoComprometido = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.fechaPagoComprometido" text="**Fecha pago comprometido" />'
		,id:'fechaPagoComprometido'
		,value:app.format.dateRenderer('${acc.fechaPagoComprometido}')
		,name:'accion.fechaPagoComprometido'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var importePropuesto = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.importePropuesto" text="**importePropuesto" />'
		,id:'importePropuesto'
		,value:'${acc.importePropuesto}'
		,name:'accion.importePropuesto'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var importeAceptado = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.importeAceptado" text="**importeAceptado" />'
		,id:'importeAceptado'
		,value:'${acc.importeAceptado}'
		,name:'accion.importeAceptado'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.cerrar" text="**Cerrar" />'
		<app:test id="btnGuardarDetalleAccion" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function(){			
			 page.fireEvent(app.event.DONE); 			
		}
	});
	
	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
	}
	
	var datosPrincipalesFieldSet = fieldSet( '<s:message code="plugin.recobroWeb.accionExtrajudicial.detalle.datosPrincipales" text="**Datos Principales"/>'
                 ,[{items:[idAccion, fechaExtraccion, idEnvio, propietario, persona, codClienteEntidad, contrato, cntContrato, palancasPermitidas, fechaGestion, horaGestion, observacionesGestor]} 
                 , {items:[tipoGestion, telefono, direccion, codigoDireccion, resultadoGestionTelefonica, importeComprometido, fechaPagoComprometido, importePropuesto, importeAceptado, resultadoMensajeria]} ]);
	
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,width:500
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
		
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false,width:1000}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[datosPrincipalesFieldSet]
					}
				]
			}
		]
		,bbar : [
			btnGuardar
		]
	});
	

	page.add(panelEdicion);
	
</fwk:page>