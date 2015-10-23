<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>

	//TAB DATOS GENERALES
	
	<%@ include file="tabs/tabDatosGenerales.jsp" %> 
	var datosGenerales = createDatosGeneralesTab();
	
	// TAB EXPEDIENTE
	<%@ include file="tabs/tabExpediente.jsp" %>
	var expediente = createExpedienteTab();
	
	//TAB CONTRATO
	<%@ include file="tabs/tabContrato.jsp" %>
	var contrato = createContratoTab();
	
	//filtro pestañas
	var filtroTabPanel= new Ext.TabPanel({
		items:[datosGenerales,expediente,contrato]
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