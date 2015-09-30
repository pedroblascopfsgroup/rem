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

	
	
	//var idBienes='${idBienes}';
	
	var idBienes=new Array();
	<c:forEach var="id" items="${idBienes}"> 
		    idBienes.push(<c:out value="${id}"/>);
	</c:forEach>
	
	var dataIdContrato;
	
	
	<%-- Panel Add Relacion --%>
 	
 	var btnAddRelacion = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titleNuevaRelacion" text="**Añadir Relación" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,disabled:true
			
	});
	
	
	btnAddRelacion.on('click',function(){		
		bienContratosStore.add(new bienContrato({idContrato:dataIdContrato,codigoContrato: numContrato.getValue(),relacion:tipoRelacion.lastSelectionText,codRelacion:tipoRelacion.getValue(),tipoProducto:tipoProducto.getValue()}));
	
	});
	
	var btnBuscarContrato = new Ext.Button({
			text : '<s:message code="app.buscar" text="**Buscar" />'
			,iconCls : 'icon_busqueda_asuntos'
			,cls: 'x-btn-text-icon'
			
	});
	
	btnBuscarContrato.on('click', function(){         
		Ext.Ajax.request({
						url : page.resolveUrl('subasta/buscaContratoByCodigo'), 
						params : {nroContrato:nroContrato.getValue()},
						method: 'POST',
						success: function ( result, request) {
							
							var jsonData = Ext.util.JSON.decode(result.responseText);
							dataIdContrato=jsonData.contrato.idContrato;
                            dataNumContrato=jsonData.contrato.numContrato;
                            dataGarantia=jsonData.contrato.garantia;
                            dataGarantiaApp=jsonData.contrato.garantiaApp;
                            dataTipoProducto=jsonData.contrato.tipoProducto;
                            
                            numContrato.setVisible(true);
                            numContrato.setValue(dataNumContrato);
                            
                            tipoProducto.setVisible(true);
                            tipoProducto.setValue(dataTipoProducto);
                            
                            tipoRelacion.setDisabled(false);	
                            
                            
						},
					    failure: function(form, action) {
					       Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.camposObligatoriosOOOO" text="**El número de contrato introducido no existe" />');
		
						}
		
		});
	
	});
	
	var codigoTipoRelacion= new Ext.form.TextField({
		name : 'codigoTipoRelacion'
		,id : 'codigoTipoRelacion'
		,hidden:true
	});

	var tipoRelacionDescripcion= new Ext.form.TextField({
		name : 'tipoRelacionDescripcion'
		,id : 'tipoRelacionDescripcion'
		,hidden:true
	});
	
	var nroContrato = new Ext.form.TextField({
		name : 'nroContrato'
		,id : 'nroContrato'
		,fieldLabel : '<s:message code="menu.contratos.listado.filtro.contrato" text="**Codigo contrato" />'
		,allowBlank : false
	});
	
	var numContrato = new Ext.ux.form.StaticTextField({
				fieldLabel:'<s:message code="menu.contratos.listado.filtro.contrato" text="**Codigo contrato"/>'
				,name:'numContrato'
				,hidden:true
	});
	
	var tipoProducto = new Ext.ux.form.StaticTextField({
				fieldLabel:'<s:message code="menu.contratos.listado.lista.tipoProducto" text="**Tipo Producto"/>'
				,name:'tipoProducto'
				,hidden:true
	});
	
	<pfsforms:ddCombo name="tipoRelacion"
		labelKey="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionContrato.tipoContratoBien" 
 		label="**Tipo Relación Contrato" value="" dd="${diccionarioRelaciones}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />
	
	tipoRelacion.setDisabled(true);
	
	tipoRelacion.on('select', function(){
	  if(tipoRelacion.getValue()!= ''){
	   btnAddRelacion.setDisabled(false);
	  }
	});      	
 	
 	
	var panelAddRelacion = new Ext.Panel({
		title:'<s:message code="menu.contratos.listado.filtro.filtrodeContratos" text="**Filtro de Contrato" />'
		,defaults : {cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,border : true
		,height : 120
        ,layout : 'table'
        ,autoWidth : true
		//,width:panelWidth
		,bbar : [btnAddRelacion]
		,tbar : [btnBuscarContrato]
		,items : [
			{   layout:'table'
				,layoutConfig:{columns:3}
				,border:false
				,defaults : {xtype : 'fieldset', height:300, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [nroContrato,tipoRelacion ]}
						,{items: [numContrato]}
						,{items: [tipoProducto]}
						
				]
			},
			{ xtype : 'errorList', id:'errL' }			
		]
	});	
	
	
	<%--Panel relaciones con contratos --%>
	var btnEditarRelacion = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnEditarRelacionContrato" text="**Editar Relación" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			
	});
	
	btnEditarRelacion.on('click',function(){
		 var rec = gridContratos.getSelectionModel().getSelected();
	     if (!rec) return;
	     var idContrato=rec.get("idContrato");
	     var codTipoContratoBien = rec.get("codRelacion");  	            
				
		 var w = app.openWindow({
			flow : 'editbien/editarRelacionBienContratoMultiple'
			,width:700
			,height:500
			,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnEditarRelacionContrato" text="**Editar relación" />'
			,params : {	idContrato : idContrato
						,codTipoContratoBien : codTipoContratoBien
					  }
			});
			w.on(app.event.DONE,function(){
				w.close();
				
			    bienContratosStore.remove(gridContratos.getSelectionModel().getSelected());
			    bienContratosStore.add(new bienContrato({idContrato:dataIdContrato,codigoContrato: numContrato.getValue(),relacion:tipoRelacionDescripcion.getValue(),codRelacion:codigoTipoRelacion.getValue(),tipoProducto:tipoProducto.getValue()}));
			     
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
	
	});
	

	
	var btnBorrarRelacion = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_cancel'
			,cls: 'x-btn-text-icon'
			
	});
	
	btnBorrarRelacion.on('click',function(){
		
		bienContratosStore.remove(gridContratos.getSelectionModel().getSelected());
		
		
	});
	
	var bienContrato = Ext.data.Record.create([
		  {name:'idContratoBien'}
		 ,{name:'idBien'}
		 ,{name:'idContrato'}
		 ,{name:'importeGarantizado'}
		 ,{name:'importeGarantizadoAprov'}
		 ,{name:'codRelacion'}
		 ,{name:'relacion'}
		 ,{name:'estado'}
		 ,{name:'codigoContrato'}
		 ,{name:'tipoProducto'}
		 ,{name:'diasIrregular'}
		 ,{name:'riesgo'}
		 ,{name:'titular'}
		 ,{name:'saldoVencido'}
		 ,{name:'estadoFinanciero'}
		 ,{name:'tipoProducto'}
		 ,{name:'situacion'}
		 ,{name:'usuarioExterno'}
    ]);

   	var bienContratosStore = page.getStore({
   		flow:'plugin/nuevoModeloBienes/bienes/NMBBienContratos'
       	,reader: new Ext.data.JsonReader({
        	root: 'contratosBien'
       	}, bienContrato)
   	});
    
   	//bienContratosStore.webflow({idBien:3});
   	
   	var BienContratosCM  = new Ext.grid.ColumnModel([
         {header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idContratoBien" text="**idContratoBien"/>',width:52, sortable: true, dataIndex: 'idContratoBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idBien" text="**idBien"/>', sortable: true, dataIndex: 'idBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idContrato" text="**idContrato"/>', sortable: true, dataIndex: 'idContrato', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.numContrato" text="**Num. contrato"/>', sortable: true, dataIndex: 'codigoContrato'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.codRelacion" text="**cod relacion"/>', sortable: true, dataIndex: 'codRelacion', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.relacion" text="**relacion"/>', sortable: true, dataIndex: 'relacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.importeGarantizado" text="**importeGarantizado"/>', align:'right', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeGarantizado'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.importeGarantizadoAprov" text="**importeGarantizadoAprov"/>', align:'right', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeGarantizadoAprov'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.estado" text="**estado"/>', sortable: true, dataIndex: 'estado', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.producto" text="**Producto"/>', sortable: true, dataIndex: 'tipoProducto'}
    ]);    
	
	var gridContratos = app.crearGrid(bienContratosStore, BienContratosCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.gridContratos.titulo" text="**Relación con Contratos"/>'
        ,style:'padding: 5px;'
		,cls:'cursor_pointer'
		,iconCls : 'icon_contrato'
		,collapsible : true
		,collapsed: false
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true
		,width:800
		,height:200
        ,bbar : [btnEditarRelacion,btnBorrarRelacion]
       
    });
	
	<%-- --%>			
	
	var btnGuardar = new Ext.Button({
       text:  '<s:message code="app.guardar" text="**Guardar" />'
       ,iconCls : 'icon_ok'
    });
    
    btnGuardar.on('click',function(){
		
		var nroContratoTipoBienContrato=new Array();
		
		for(i=0;i < bienContratosStore.data.length;i++){
			nroContratoTipoBienContrato.push(bienContratosStore.data.items[i].data.codigoContrato+','+bienContratosStore.data.items[i].data.codRelacion);
		}
		
		Ext.Ajax.request({
						url : page.resolveUrl('subasta/guardarRelacionesContratoBienes'), 
						params : {nroContratoTipoBienContrato:nroContratoTipoBienContrato,idBienes:idBienes},
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						},
					    failure: function(form, action) {
					    	
						}
		
		});	
		
		
		
	});
    

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	}); 	
 	
 	
	
 
 	var panelContenedor = new Ext.form.FormPanel({
         defaults : {layout:'form',border: false,bodyStyle:'padding-top:10px'} 
		 ,items : [
              {
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [panelAddRelacion]
			  }
			  ,{
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [tipoRelacion]	
				}
			  ,{
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [gridContratos]
			  }
    	]
    	,autoWidth: 800
		,autoHeight: true
	    ,border: false
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	


	page.add(panelContenedor);
	
</fwk:page>