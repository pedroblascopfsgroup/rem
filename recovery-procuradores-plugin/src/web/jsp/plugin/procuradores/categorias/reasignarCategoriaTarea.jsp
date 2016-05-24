<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>


	var limit = 25;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
		,idResolucion: '${idResolucion}'
	};
	
	var categoriasRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'idcategorizacion'}
        ,{name:'nombre'}
        ,{name:'descripcion'}
        ,{name:'orden'}
    ]);
    
    var categoriasStore = page.getStore({
		id:'categoriasStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'categoriasStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'categorias/getListaCategoriasDeLaCategorizacionActivaDelUsuario'
		,reader : new Ext.data.JsonReader({root:'categorias',totalProperty : 'total'}, categoriasRecord)
	});	
	

	categoriasStore.webflow(paramsBusquedaInicial);

	var _handler =  function() {
		panelEdicion.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		panelEdicion.getForm().submit(
		{	
		    clientValidation: true,
			url: '/'+app.getAppName()+'/categorias/actualizaCategoriaDeLaResolucion.htm',
			 success: function(form, action) {
		       panelEdicion.container.unmask();
		       page.fireEvent(app.event.DONE);
		    },
		    failure: function(form, action) {
<%--		    	panelEdicion.container.unmask(); --%>
<%--		        switch (action.failureType) { --%>
<%--		            case Ext.form.Action.CLIENT_INVALID: --%>
<%-- 		            	Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.camposObligatorios.texto" text="**Debe rellenar los campos obligatorios." />'); --%>
<%--		                break; --%>
<%--		            case Ext.form.Action.CONNECT_FAILURE:	  --%>
<%-- 		            	Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');		            	           	 --%>
<%--		                break; --%>
<%--		       } --%>
		    }
		});
	};

	var btnGuardar = new Ext.Button({
		text : 'Guardar'
		,iconCls : 'icon_ok'
		,handler : _handler
	});

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});

	
	
 	var selectCategorias = new Ext.form.ComboBox({ 
 		name: 'selectCategorias' 
    	,store: categoriasStore 
     	,displayField: 'nombre' 
     	,valueField: 'id' 
     	,value: '' 
     	,mode: 'local' 
     	,triggerAction: 'all' 
     	,editable: true 
     	,allowBlank: true 
     	,emptyText: 'Seleccionar...' 
     	,loadingText: 'Searching...' 
     	,hiddenName:'selectCategorias' 
    		,fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.seleccionable.categorias" text="**Categorias" />' 
 		,width: 250 
 		,forceSelection: true 
 		,listeners:{ 
 			select: function(combo,  record,  index ) {	 		 
                 var iddesp = Ext.getCmp("idDespExt"); 
                 iddesp.setValue(combo.getValue());  
 	        }  
 		} 
 	}); 

		
	
	var idResolucion = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.campo.idresolucion" text="**IdResolucion" />'				
		, id: 'idResolucion'
		, name: 'idResolucion'	
		, value: '${idResolucion}'
		, hidden: true
	});
	
				
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }			
			,{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{
					items: [ idResolucion, selectCategorias]
				}]
			}
			
			
		]
		,bbar : [btnGuardar, btnCancelar]
	});	

	
	page.add(panelEdicion);
	
</fwk:page>	