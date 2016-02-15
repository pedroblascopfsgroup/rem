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
			url: '/'+app.getAppName()+'/recrecordatorio/saveRecRecordatorio.htm',
			params : {
						fecha:app.format.dateRenderer(fechaSeny.getValue())
					 },
			 success: function(form, action) {
		       panelEdicion.container.unmask();
		       page.fireEvent(app.event.DONE);
		    },
		    failure: function(form, action) {
		    	panelEdicion.container.unmask();
				Ext.Msg.alert('<s:message code="plugin.procuradores.recordatorio.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.recordatorio.formalta.validacion.camposObligatorios.texto" text="**Debe rellenar los campos obligatorios." />');
		    }
		});
	};
	
	var _handlerResolver =  function() {
		panelEdicion.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		panelEdicion.getForm().submit(
		{	
		    clientValidation: true,
			url: '/'+app.getAppName()+'/recrecordatorio/resolverRecordatorio.htm',
			params : {
						idRecordatorio: '${recordatorio.id}'
					 },
			 success: function(form, action) {
		       panelEdicion.container.unmask();
		       page.fireEvent(app.event.DONE);
		    },
		    failure: function(form, action) {
		    	panelEdicion.container.unmask();
				Ext.Msg.alert('<s:message code="plugin.procuradores.recordatorio.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.recordatorio.formalta.validacion.resolverResolucion.texto" text="**No se ha podido resolver el recordatorio." />');
		    }
		});
	};

	var btnGuardar = new Ext.Button({
		text : 'Guardar'
		,iconCls : 'icon_ok'
		,handler : _handler
	});


	var btnResolver = new Ext.Button({
		text : 'Cerrar recordatorio'
		,iconCls : 'icon_collapse'
		,handler : _handlerResolver
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});

	
	
 	var selectCategorias = new Ext.form.ComboBox({ 
 		name: 'categoria' 
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
     	,hiddenName:'categoria' 
    		,fieldLabel: '<s:message code="plugin.procuradores.recordatorios.formalta.seleccionable.categorias" text="**Categorias" />' 
 		,width: 250 
 		,forceSelection: true 
 		,value: '${recordatorio.categoria.nombre}'
 		
 	}); 
 	
 	
	
	var tituloRecordatorio=new Ext.form.TextField({
    	fieldLabel:'<s:message code="plugin.procuradores.recordatorios.formalta.nuevo.titulo" text="**Titulo" />'
    	,id:'tituloRec'
    	,width:400
		,name:'titulo'
		,allowBlank:false
		,value: '${recordatorio.titulo}'
    });

 	
 	var descricpionRecordatorio = new Ext.form.HtmlEditor({
			id:'descripcionRec'
			,hideLabel:false
			,width:400
			,maxLength:3500
			,height : 70
			,hideParent:true
			,enableColors: true
        	,enableAlignments: true
        	,enableFont:true
        	,enableFontSize:true
        	,enableFormat:true
        	,enableLinks:true
        	,enableLists:false
        	,enableSourceEdit:false
        	,fieldLabel:'<s:message code="plugin.procuradores.recordatorios.formalta.nuevo.descricpion" text="**Descripción" />'
        	,name:'descripcion'
        	,value: '${recordatorio.descripcion}'
	});

	var fechaSeny = new Ext.ux.form.XDateField({
		id:fechaSeny
		,width:100
		,height:20
		,fieldLabel:'<s:message code="plugin.procuradores.recordatorios.formalta.nuevo.fsenyalizaciion" text="**Fecha señalamiento" />'
		,allowBlank:false
		,value: '${recordatorio.fecha}'.split(" ")[0]
	});
			
	
	var aviso1 = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.procuradores.recordatorios.form.campo.aviso1" text="**Aviso días antes" />'				
		, name: 'dias_tarea'
		,allowBlank:false
		, value: '${diasTareaUno}'
		, allowDecimals: false
		, allowNegative: false
		, maxValue: 999
		, hidden: false
	});	
	
	var aviso2 = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.procuradores.recordatorios.form.campo.aviso2" text="**Aviso días antes" />'				
		, name: 'dias_tarea'
		, value: '${diasTareaDos}'
		, allowDecimals: false
		, allowNegative: false
		, maxValue: 999
		, hidden: false
	});
	
	
	var aviso3 = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.procuradores.recordatorios.form.campo.aviso3" text="**Aviso días antes" />'				
		, name: 'dias_tarea'
		, value: '${diasTareaTres}'
		, allowDecimals: false
		, allowNegative: false
		, maxValue: 999
		, hidden: false
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
					items: [ fechaSeny, selectCategorias, tituloRecordatorio, descricpionRecordatorio, aviso1, aviso2, aviso3]
				}]
			}
			
			
		]
		<c:if test="${not empty recordatorio}">
		,bbar : [btnResolver, btnCancelar]
		</c:if>
		<c:if test="${empty recordatorio}">
		,bbar : [btnGuardar, btnCancelar]
		</c:if>
	});	

	
	page.add(panelEdicion);
	
</fwk:page>	