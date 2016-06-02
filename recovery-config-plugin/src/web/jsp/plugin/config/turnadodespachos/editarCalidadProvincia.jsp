<%@page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"%>
<%@ page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>


	<%--/*
		* Para asignar calidad a cada provincia del Despacho - JRA
		*/ 
	--%>
	
	var provincia = new Ext.ux.form.StaticTextField({
		name: 'provincia'
		,fieldLabel : '<s:message code="plugin.config.despachoExterno.turnado.tabEsquema.ambitoactuacion.provinciaSingular" text="**Provincia" />'
		,value: '${ambitoActuacion.provincia.descripcion}'
		//,renderer: 'htmlEncode'
		,width: 150
		,height: 30
		,labelStyle: 'font-weight:bolder;width:100'
		//,html: txtTiposGestor
		//,style:'margin-top:5px'
		,readOnly: true
	});
    
    var tiposCalidadLitData = <app:dict value="${tiposCalidadLitigio}" />;
    
    var cmbTipoCalidadLit = app.creaCombo({
		data: tiposCalidadLitData
    	,name : 'turnadoCodigoCalidadLitigios'
    	, value: '${ambitoActuacion.etcLitigio.codigo}'
    	,fieldLabel : '<s:message code="plugin.config.despachoExterno.turnado.ventana.label.tipocalidad" text="**Tipo calidad" />'
		,width : 130
    });
    
    var tiposCalidadConData = <app:dict value="${tiposCalidadConcursal}" />;
    
    var cmbTipoCalidadCon = app.creaCombo({
		data: tiposCalidadConData
    	,name : 'turnadoCodigoCalidadConcursal'
    	, value: '${ambitoActuacion.etcConcurso.codigo}'
    	,fieldLabel : '<s:message code="plugin.config.despachoExterno.turnado.ventana.label.tipocalidad" text="**Tipo calidad" />'
		,width : 130
    });

	var turnadoLitigiosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelLitigios.titulo" text="**Turnado Litigios" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:310 }
		,items : [
		 	{items:[<%-- cmbTipoImporteLit, --%>cmbTipoCalidadLit]}
		]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(310-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});

	var turnadoConcursosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelConcursos.titulo" text="**Turnado Concursos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:310 }
		,items : [
		 	{items:[<%-- cmbTipoImporteCon, --%>cmbTipoCalidadCon]}
		]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(310-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	var ambitoActuacionFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelCalidadProvincia.titulo" text="**Asginar calidad provincia" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [{items:[provincia,turnadoLitigiosFieldSet, turnadoConcursosFieldSet]}]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(400-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});

	var bottomPanel = new Ext.Panel({
			autoHeight:true
			,layout:'table'
			,border:false
			,layoutConfig:{columns:1}
			,viewConfig : {forceFit : true}
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{layout:'form'
						,items: [ambitoActuacionFieldSet]}
					]
		});
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			Ext.Ajax.request({
				url: page.resolveUrl('turnadodespachos/guardarCalidadProvincia'),
				params: {
					despacho: ${ambitoActuacion.despacho.id},
					codigoProvincia: ${ambitoActuacion.provincia.codigo},
					turnadoCodigoCalidadConcursal: cmbTipoCalidadCon.getValue(),
					turnadoCodigoCalidadLitigios: cmbTipoCalidadLit.getValue()										
				},
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
			});		
		}
	});

	var mainPanel = new Ext.FormPanel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,bbar: [btnGuardar, btnCancelar]
		,items:[{layout:'form', items: [bottomPanel]}
		]
	});	

	page.add(mainPanel);
	
</fwk:page>
