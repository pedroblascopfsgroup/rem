<%@page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"%>
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
	
	var maxWidth=800;
	    
	var plazasPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.plaza" text="**Plaza" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"}]);
	
	var procedimientoPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.tipoProcedimiento" text="**Tipo procedimiento" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"}]);
    
    var ventanaEdicion = function(valor) {
		if(valor=="otro"){
			var w = app.openWindow({
				flow : 'turnadoprocuradores/seleccionarPlaza'
				,width :  600
				,closable: true
				,title : '<s:message code="plugin.procuradores.turnado.tabSeleccionarPlaza" text="**Seleccionar plazas" />'
				,params : ''
			});
		}
		
		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var btnNuevoRango = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.nuevoRango" text="**Nuevo rango" />'
		,iconCls : 'icon_mas'
		,disabled: false
		,minWidth:60
		,handler: function() {
 						<%-- ventanaEdicion("nuevo_rango"); --%>
	            		page.fireEvent(app.event.DONE);	
	       		}
	});
    
    var btnOtro = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.otraConfiguracion" text="**Insertar otra configuraci&oacute;n" />'
		,iconCls : ''
		,disabled: false
		,minWidth:60
		,handler: function() {
						ventanaEdicion("otro");
	            		page.fireEvent(app.event.DONE);	
	       		}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.guardar" text="**Guardar" />'
		,iconCls : ''
		,disabled: false
		,minWidth:60
		,handler: function() {
 						<%-- ventanaEdicion("guardar"); --%>
	            		page.fireEvent(app.event.DONE);	
	       		}
	});
	
	
    
   var configuracion = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'tpo'}
		 ,{name:'desde'}
		 ,{name:'hasta'}
		 ,{name:'procurador'}
		 ,{name:'porcentaje'}
	]);				
	
	var configuracionStore = page.getStore({
		 flow: '' 
		,reader: new Ext.data.JsonReader({
	    	 root : 'configuracion'
	    	,totalProperty : 'total'
	     }, configuracion)
	});	
	

	var configuracionCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.procuradores.turnado.tipoProcedimiento" text="**TPO"/>', dataIndex: 'tpo'}
		,{header: '<s:message code="plugin.procuradores.turnado.desde" text="**Desde"/>', dataIndex: 'desde'}
		,{header: '<s:message code="plugin.procuradores.turnado.hasta" text="**Haste"/>', dataIndex: 'hasta'}
		,{header: '<s:message code="plugin.procuradores.turnado.procurador" text="**Procurador"/>', dataIndex: 'procurador'}
		,{header: '<s:message code="plugin.procuradores.turnado.porcentaje" text="**Porcentaje"/>', dataIndex: 'porcentaje'}
	]);
		
	var configuracionGrid = new Ext.grid.EditorGridPanel({
		store: configuracionStore
		,cm: configuracionCm
		,title:'<s:message code="plugin.procuradores.turnado.gridConfigurar" text="**Configuraciones del esquema"/>'
		,stripeRows: true
		,autoHeight:true
		,autoWidth:true
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,bbar:['->',btnNuevoRango,btnOtro,btnGuardar]

	});     
	
	var tabConfiguracion = new Ext.Panel({
		autoWidth:true
		,autoHeight:true
		,layout:'table'
        ,layoutConfig: { columns: 2 }
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{items:[plazasPanel,
		 			{
	                title : ''
	                ,layout:'table' 
	                ,border : true
	                ,layoutConfig: { columns: 2 }
	                ,autoScroll:true
	                ,bodyStyle:'padding:5px;'
	                ,name: 'turn_procu_lista_plazas'
	                ,id:'turn_procu_lista_plazas'
	                //,autoHeight:true
	                //,autoWidth : true
	                ,height: 100
	                ,width:325
            		}]}
		 	,{items:[procedimientoPanel,
		 			{
	                title : ''
	                ,layout:'table' 
	                ,border : true
	                ,layoutConfig: { columns: 2 }
	                ,autoScroll:true
	                ,bodyStyle:'padding:5px;'
	                ,name: 'turn_procu_lista_procedimientos'
	                ,id:'turn_procu_lista_procedimientos'
	                //,autoHeight:true
	                //,autoWidth : true
	                ,height: 100
	                ,width:325
            		}]}			
				]
		
	});
	
	
	page.add(tabConfiguracion);
	page.add(configuracionGrid);
	
	
	
</fwk:page>


