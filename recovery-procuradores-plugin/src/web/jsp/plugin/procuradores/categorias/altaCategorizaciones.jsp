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


//Store de Despachos	
		
	var despachosRecord = Ext.data.Record.create([
		{name:'idDespExt'}
        ,{name:'despacho'}
    ]);
       
    
    var despachosStore = page.getStore({
		flow : 'categorizaciones/getListaDespachosExternos'
		,reader : new Ext.data.JsonReader({root:'listaDespachos', totalProperty : 'total'}, despachosRecord)
	});
		
	despachosStore.webflow({idUsuario:app.usuarioLogado.id});		
	



	var _handler =  function() {
		panelEdicion.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		panelEdicion.getForm().submit(
		{	
		    clientValidation: true,
			url: '/'+app.getAppName()+'/categorizaciones/guardarCategorizacion.htm',
			 success: function(form, action) {
		       panelEdicion.container.unmask();
		       page.fireEvent(app.event.DONE);
		    },
		    failure: function(form, action) {
		    	panelEdicion.container.unmask();
		        switch (action.failureType) {
		            case Ext.form.Action.CLIENT_INVALID:
		            	Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.camposObligatorios.texto" text="**Debe rellenar los campos obligatorios." />');
		                break;
		            case Ext.form.Action.CONNECT_FAILURE:	 
		            	Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.formalta.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');		            	           	
		                break;
		       }
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

	
	
	var selectDespachos = new Ext.form.ComboBox({
		name: 'nombreDespachos'
    	,store: despachosStore
    	,displayField: 'despacho'
    	,valueField: 'idDespExt'
    	,value: '${Categorizacion.despachoExterno.despacho}'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable: true
    	,allowBlank: true
    	,emptyText: 'Seleccionar...'
    	,loadingText: 'Searching...'
    	,pageSize: 10
    	,hiddenName:'selectDespachos'
   		,fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.seleccionable.despacho" text="**Despacho" />'
		,width: 250
		,forceSelection: true
		,listeners:{
			select: function(combo,  record,  index ) {	 		
                var iddesp = Ext.getCmp("idDespExt");
                iddesp.setValue(combo.getValue());  
	        } 
		}
	});

	selectDespachos.on('afterrender',function(combo){
		combo.mode='remote';
	});
		
	
	var idDespachoExt = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.campo.iddespacho" text="**IdDespacho" />'				
		, id: 'idDespExt'
		, name: 'idDespExt'	
		, value: '${Categorizacion.despachoExterno.id}'
		, hidden: true
	});
	
	
	
	var idcategorizacion = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.campo.idcategorizacion" text="**IdCategorizacion" />'				
		, name: 'id'
		, value: '${Categorizacion.id}'
		, hidden: true
	});
	
	
	
	var nombre = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.campo.nombre" text="**Nombre" />'
		, name:'nombre'
		, value:'${Categorizacion.nombre}'
		, width: 250
		, allowBlank: false
		, listeners: {
       		blur: function(cmp) {
		    	if (cmp.getValue().trim() == ''){
		    		cmp.setValue("");
		   		}	
       		}
    	}
	});	
	
	
	var codigo = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.formalta.campo.codigo" text="C&oacute;digo" />'
		, name:'codigo'
		, value:'${Categorizacion.codigo}'
		, width: 250
		, allowBlank: false
		, listeners: {
       		blur: function(cmp) {
		    	if (cmp.getValue().trim() == ''){
		    		cmp.setValue("");
		   		}	
       		}
    	}
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
					items: [ idcategorizacion, nombre, codigo , idDespachoExt, selectDespachos]
				}]
			}
			
			
		]
		,bbar : [btnGuardar, btnCancelar]
	});	

	
	page.add(panelEdicion);
	
</fwk:page>	