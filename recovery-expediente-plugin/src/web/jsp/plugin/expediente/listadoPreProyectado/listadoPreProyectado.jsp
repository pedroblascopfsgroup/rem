<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	//TAB DATOS GENERALES
	
	//Combo Estado Gestión
	var comboEstadoGestion = new Ext.form.ComboBox({
<%-- 		store: '' --%>
<%-- 		,displayField:'descripcion' --%>
<%-- 		,valueField:'codigo' --%>
		mode:'local'
		,style:'margin:0px'
		,width:170
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.estadoGestion" text="**Estado gestión"/>'
	});
	
	//Combo Tipo persona
	var comboTipoPersona = new Ext.form.ComboBox({
	<%-- 		store: '' --%>
	<%-- 		,displayField:'descripcion' --%>
	<%-- 		,valueField:'codigo' --%>
		mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.tipoPersona" text="**Tipo Persona"/>'
	});
	
	// Field riesgo total
	var mmRiesgoTotal = app.creaMinMaxMoneda('<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.riesgoTotal" text="**Riesgo Total" />', 'riesgo',{width : 80, labelWidth:105});
	
	// Field deuda irregular
	var mmDeudaIrregular = app.creaMinMaxMoneda('<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.deudaIrregular" text="**Deuda Irregular" />', 'deuda',{width : 80, labelWidth:105});
	
	//Combo Agrupar por
	var comboAgruparPor = new Ext.form.ComboBox({
	<%-- 		store: '' --%>
	<%-- 		,displayField:'descripcion' --%>
	<%-- 		,valueField:'codigo' --%>
		mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.agruparPor" text="**Agrupar por"/>'
	});
	
	var tramos = <app:dict value="${tramo}" />;
	var propuestas = <app:dict value="${propuesta}" />;
	
	//Doble sel tramo
	var dobleSelTramo = app.creaDblSelect(tramos
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.tramo" text="**Tramo" />'
                              ,{<app:test id="dobleSelTramo" />});
                              
    //Doble sel propuesta
	var dobleSelPropuesta = app.creaDblSelect(propuestas
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.propuesta" text="**Propuesta" />'
                              ,{<app:test id="dobleSelPropuesta" />});


	//filtro Datos Generales
	var filtrosTabDatosGenerales = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales" text="**Datos del expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboEstadoGestion,comboTipoPersona,mmRiesgoTotal.panel,mmDeudaIrregular.panel,comboAgruparPor]	
		
				},
				{
					layout:'form'
					,items: [dobleSelTramo,dobleSelPropuesta]
				}]
		
	});
	
	// TAB EXPEDIENTE
	
	//filtro Expediente
	
	

	var filtrosTabExpediente = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente" text="**Expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
	});
	
	//Filtro Contrato

	var filtrosTabContrato = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato" text="**Contrato" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
	});
	
	//filtro pestañas
	var filtroTabPanel= new Ext.TabPanel({
		items:[filtrosTabDatosGenerales, filtrosTabExpediente, filtrosTabContrato]
		,layoutOnTabChange:true
		,autoScroll:true
		,autoHeight:true
		,autoWidth:true
		,border:false
		,activeItem:0
	});
	
	
	var btnBuscar = new Ext.Button({
			text:'Buscar'
			,iconCls:'icon_busquedas'		
	});
		
	 var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a XLS" />'
        ,iconCls:'icon_exportar_csv'
    });
    
    var btnReset = app.crearBotonResetCampos({
		text:'Limpiar'
		,iconCls:'magifier_zoom_out'
	});
	
	//Agrego los filtros al panel
	var panelFiltros = new Ext.FormPanel({
		title: '<s:message code="preproyectado.listado.filtros" text="**Filtro de PreProyectado" />'
		,defaults : {xtype:'panel' ,cellCls: 'vtop'}
		,bodyStyle:'cellspacing:10px;'
		,collapsible:true
		,titleCollapse:true
		,border:true
		,autoHeight:true
		,items:[filtroTabPanel]
 		,tbar : [btnBuscar,btnReset,btnExportarXls,'->',app.crearBotonAyuda()] 
	});
	
	//panel principal
	var mainPanel = new Ext.Panel({
		items:[
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[panelFiltros]
			}
		]
		,autoHeight : true
	    ,border: false
	});
	
		
	//añadimos el panel principal a la pagina
	page.add(mainPanel);

</fwk:page>