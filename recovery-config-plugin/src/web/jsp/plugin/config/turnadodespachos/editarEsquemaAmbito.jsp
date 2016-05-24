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
	var config = {width: 150, height: 100, labelStyle:"width:100px;font-weight:bolder"};
    
    var comunidadesData = <app:dict value="${listaComunidadesAutonomas}" />;
    var comboComunidades = app.creaDblSelect(comunidadesData 
    	,'<s:message code="plugin.config.despachoExterno.turnado.ventana.comunidades" text="**Comunidades" />'
    	,config);
    	
    var arrayComunidadesLetrado = [ 
	<c:forEach var="codigoComunidad" items="${listaComunidadesDespacho}" varStatus="status">
		<c:if test="${status.index>0}">,</c:if>'<c:out value="${codigoComunidad}" />'
	</c:forEach>
	];
    
	comboComunidades.setValue(arrayComunidadesLetrado);    	
    
	var provinciasData = <app:dict value="${listaProvincias}" />;
    var comboProvincias = app.creaDblSelect(provinciasData 
    	,'<s:message code="plugin.config.despachoExterno.turnado.ventana.provincias" text="**Provincias" />'
    	,config);
    	
    var arrayProvinciasLetrado = [ 
	<c:forEach var="codigoProvincia" items="${listaProvinciasDespacho}" varStatus="status">
		<c:if test="${status.index>0}">,</c:if>'<c:out value="${codigoProvincia}" />'
	</c:forEach>
	];
    
	comboProvincias.setValue(arrayProvinciasLetrado);
	
	var ambitoActuacionFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelAmbActuacion.titulo" text="**Ambito actuación" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [{items:[comboComunidades,comboProvincias]}]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(500-margin);
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
				url: page.resolveUrl('turnadodespachos/guardarEsquemaDespacho'),
				params: {
					id:${despacho.id},
					turnadoCodigoImporteLitigios: '',
					turnadoCodigoImporteConcursal: '',
					turnadoCodigoCalidadConcursal: '',
					turnadoCodigoCalidadLitigios: '',
					listaComunidades: comboComunidades.getValue(),
					listaProvincias: comboProvincias.getValue() 										
				},
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
			});			
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});

	var mainPanel = new Ext.FormPanel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,bbar: [btnGuardar,btnCancelar]
		,items:[{layout:'form', items: [bottomPanel]}
		]
	});	

	page.add(mainPanel);
	
</fwk:page>