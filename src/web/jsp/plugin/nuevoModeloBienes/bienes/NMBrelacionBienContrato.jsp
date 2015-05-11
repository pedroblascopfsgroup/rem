<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	
	var limit=10;
	var idBien = ${idBien};	
	var idContrato = '${idContrato}';
	var codTipoContratoBien = '${codTipoContratoBien}';
	var edicion = false;
	

	var filtroContrato=new Ext.form.TextField({
        fieldLabel:'<s:message code="menu.contratos.listado.filtro.contrato" text="**Codigo contrato" />'
        ,labelStyle:labelStyle
        ,enableKeyEvents: true
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
        ,listeners : {
            keypress : function(target, e){
                if(e.getKey() == e.ENTER && this.getValue().length > 0) {
                    //buscarFunc();
                }
            }
        }
    });
       
    var contrato = Ext.data.Record.create([
		{name: 'id'},
		{name: 'codigoContrato'},
		{name: 'tipoProducto'},
    	{name: 'tipoProductoComercial'},
    	{name: 'primerTitular'},
    	{name: 'estadoContrato'},
    	{name: 'estadoContratoEntidad'},
    	{name: 'fechaEstadoContrato'}
	]);
	
	
	var contratosCm=new Ext.grid.ColumnModel([
			{header : '<s:message code="menu.contratos.listado.lista.id" text="**id contrato" />', dataIndex : 'id' ,hidden: false,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.codigoContrato" text="**Código contrato" />', dataIndex : 'codigoContrato' ,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.tipoProducto" text="**tipoProducto" />', dataIndex : 'tipoProducto' ,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.tipoProductoComercial" text="**tipoProductoComercial" />', dataIndex : 'tipoProductoComercial' ,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.primerTitular" text="**primerTitular" />', dataIndex : 'primerTitular' ,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.estadoContrato" text="**estadoContrato" />', dataIndex : 'estadoContrato' ,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.estadoContratoEntidad" text="**estadoContratoEntidad" />', dataIndex : 'estadoContratoEntidad' ,sortable:true},
			{header : '<s:message code="menu.contratos.listado.lista.fechaEstadoContrato" text="**fechaEstadoContrato" />', dataIndex : 'fechaEstadoContrato' ,sortable:true}
	]);
	
			
	var contratosStore = page.getStore({
		 limit : limit
		,remoteSort : true
		,loading : false
		,flow:'editbien/getContratosPaginados'
		,reader: new Ext.data.JsonReader({
	    	root : 'contratos'
	    	,totalProperty : 'total'
	    }, contrato)
	});

	
	var pagingBar=fwk.ux.getPaging(contratosStore);
	pagingBar.hide();
	
	var cfg={
		title: '<s:message code="menu.contratos.listado.lista.title" text="**contratos" arguments="0"/>'
		,style:'padding: 10px;'
		,cls:'cursor_pointer'
		,iconCls : 'icon_contrato'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true
		,height:200
		,bbar : [  pagingBar ]
	};
	
	var grid=app.crearGrid(contratosStore,contratosCm,cfg);
    
    
    var getParametros=function(){
		var p = {};
		p.codigoContrato=filtroContrato.getValue();
		return p;
	}
    
    var btnBuscar=app.crearBotonBuscar({
		handler : function(){
			filtroForm.collapse(true);				
			var params= getParametros();
       		params.start=0;
       		params.limit=limit;
			contratosStore.webflow(params);
			pagingBar.show();
			grid.setHeight(300);
			grid.expand(true);
		}
	}); 
	
	
	var filtroForm = new Ext.Panel({
		title : '<s:message code="menu.contratos.listado.filtro.filtrodeContratos" text="**Filtro de contrato" />'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{ layout:'form'
				 ,bodyStyle:'padding:5px;cellspacing:10px'
				 ,items:[filtroContrato]}
			   ]
		,tbar : [btnBuscar]
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
			if (edicion){
				Ext.Ajax.request({
						url : page.resolveUrl('editbien/saveBienContrato'), 
						params : {idContrato : '${idContrato}', idBien : '${idBien}', tipoContratoBien : tipoContratoBien.getValue()},
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
				});
			} else {
				var rec = grid.getSelectionModel().getSelected();
				if(rec){
					var idContrato=rec.get("id");
					Ext.Ajax.request({
						url : page.resolveUrl('editbien/saveBienContrato'), 
						params : {idContrato : idContrato, idBien : idBien, tipoContratoBien : tipoContratoBien.getValue()},
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel.select"/>','<s:message text="**Debe completar todos los campos obligatorios." code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.camposObligatorios"/>');
				}
			}
		}
			
	});	
	
	var tipoContratoBien = app.creaCombo({
			data : <app:dict value="${DDContratoBien}" />
			<app:test id="codTipoContratoBien" addComa="true" />
			,name : 'tipoContratoBien'
			,valueField: 'codigo'
			,displayField: 'descripcion'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionContrato.tipoContratoBien" text="**tipoContratoBien" />'
			,value : codTipoContratoBien
			,labelStyle:labelStyle
			,width: 250
			
		});	
	
	var panelCompleto = new Ext.Panel({
		bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
	    ,items : [
              {
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [filtroForm]
			  }
			  ,{
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [tipoContratoBien]	
				}
			  ,{
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [grid]
			  }
    	]
	    ,autoWidth: 800
		,autoHeight: true
	    ,border: false
	    ,bbar : [btnGuardar,btnCancelar]
    });
    
    	//Modo edicion...
	if (idContrato != ''){
		filtroForm.setVisible(false);
		btnBuscar.setVisible(false);
		grid.setVisible(false);
		edicion = true;
	}
    
	page.add(panelCompleto);
	
</fwk:page>
