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
		*/ --%>
	var provinciasNombreData = <app:dict value="${listaProvinciasDespachoNombre}" />;
	var comboProvinciasNombre = app.creaCombo({
		data: provinciasNombreData
    	, name : 'turnadoProvinciasNombre'
    	,fieldLabel : '<s:message code="plugin.config.despachoExterno.turnado.ventana.provincias" text="**Provincias" />'
		,width : 130
    });
	
	<pfs:textfield name="calidadProvDesp" labelKey="plugin.config.despachoExterno.turnado.ventana.panelCalidadProvincia.porcentajeCalidad"
		label="**% Calidad Provincia" value ="" obligatory="false" width="50" />
	
	var arrayProvinciasPorcentaje = [ 
	<c:forEach var="porcentajeProvincia" items="${listaProvinciasPorcentaje}" varStatus="status">
		<c:if test="${status.index>0}">,</c:if>'<c:out value="${porcentajeProvincia}" />'
	</c:forEach>
	];
	
	var index;
	comboProvinciasNombre.on('select', function(){
		var v = comboProvinciasNombre.getValue();
		var record = comboProvinciasNombre.findRecord(comboProvinciasNombre.valueField || comboProvinciasNombre.displayField, v);
		index = comboProvinciasNombre.store.indexOf(record);
		calidadProvDesp.setValue(arrayProvinciasPorcentaje[index]);
	});	
	
	var ambitoActuacionFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelCalidadProvincia.titulo" text="**Asginar calidad provincia" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [{items:[comboProvinciasNombre,calidadProvDesp]}]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(600-margin);
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
	
	var validarCampos = function() {
		
		if(comboProvinciasNombre.getValue() == '')
			return '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelCalidadProvincia.validacion3" text="**No se ha seleccionado ninguna provincia"/>';
				
		if (calidadProvDesp.getValue() == '' || !(calidadProvDesp.getValue() >= 0 && calidadProvDesp.getValue() <= 100)) {
			return '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelCalidadProvincia.validacion1" text="**Calidad provincia debe tener un valor comprendido entre 0 y 100%"/>';
		}
		
		var totalPercent = 0.0;
		var contador = 0;
		<c:forEach items="${listaProvinciasPorcentaje}" varStatus="status" var="calidad">
            if(index != contador)
                 totalPercent = totalPercent + parseFloat(arrayProvinciasPorcentaje[contador]);
            contador++;
        </c:forEach>
        if(parseFloat(totalPercent) + parseFloat(calidadProvDesp.getValue()) > 100)
			return '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelCalidadProvincia.validacion2" text="**La suma de las calidades de las provincias exceden el 100% de los casos."/>';
		
		return null;
	};
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var res = validarCampos();
	    	if(res == null){
				Ext.Ajax.request({
					url: page.resolveUrl('turnadodespachos/guardarCalidadProvincia')
					,params: {
						despacho: ${despachoId}
						,codigoProvincia: comboProvinciasNombre.getValue()
						,calidadProvincia: calidadProvDesp.getValue()									
					}
					,method: 'POST'
					,success: function ( result, request ) {
						page.fireEvent(app.event.DONE);
					}
				});
			}
			else {
				Ext.MessageBox.show({
		           title: 'Guardado'
		           ,msg: res
		           ,width:300
		           ,buttons: Ext.MessageBox.OK
		       });
		    }			
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