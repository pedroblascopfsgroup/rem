<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	var limit=10;

	var filtroCodCli=new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.codigoCliente" text="**Codigo Cliente" />'
		,style : 'margin:0px'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});

    var filtroNif=new Ext.form.TextField({
        fieldLabel:'<s:message code="menu.clientes.listado.filtro.nif" text="**NIF" />'
        ,enableKeyEvents: true
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
        ,listeners : {
            keypress : function(target, e){
                if(e.getKey() == e.ENTER && this.getValue().length > 0) {
                    buscarFunc();
                }
            }
        }
    });
    
    var txtParticipacion = new Ext.form.TextField({
        fieldLabel:'<s:message code="menu.clientes.listado.filtro.nxcif" text="**% Propiedad" />'
        ,enableKeyEvents: true
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
        ,listeners : {
            keypress : function(target, e){
                if(e.getKey() == e.ENTER && this.getValue().length > 0) {
                    buscarFunc();
                }
            }
        }
    });
  /*  
    var nuevosValores = new Ext.form.FieldSet({
			title:'<s:message text="Otros"/>'
			,width:630
			,defaults :  {border : false }
			,bodyStyle : 'padding:0px; margin:0px; padding:0px; '
			,items : [
				 { xtype : 'errorList', id:'errL' }
				,{ layout:'table'
				  ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				  ,bodyStyle : 'padding:0px; margin:0px; padding:0px; '
				  ,items:[
			 	 		 { layout:'table'
			 	 		   ,bodyStyle : 'padding:0px; margin:0px; padding:0px; '
						   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
						   ,items:[ {items:[descripcionTerceros, adherirse]}, {items:[descripcionAnticipado, postura]}]
						 }
			 	   ]}
			]
		});
	*/	
    var getParametros=function(){
		var p = {};
		p.codigoEntidad=filtroCodCli.getValue();
		p.docId=filtroNif.getValue();
		return p;
	}
	
    var btnBuscar=app.crearBotonBuscar({
		handler : function(){
			filtroForm.collapse(true);				
			var params= getParametros();
       		params.start=0;
       		params.limit=limit;
			clientesStore.webflow(params);
			pagingBar.show();
			grid.setHeight(300);
			grid.expand(true);
		}
	}); 
	
	var filtroForm = new Ext.Panel({
		title : '<s:message code="menu.clientes.listado.filtro.filtrodeclientes" text="**Filtro de clientes" />'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{ layout:'form'
				 ,bodyStyle:'padding:5px;cellspacing:10px'
				 ,items:[filtroCodCli]},
				{ layout:'form'
				 ,bodyStyle:'padding:5px;cellspacing:10px'
				 ,items:[filtroNif]}
			   ]
		,tbar : [btnBuscar]
	});

	var cliente = Ext.data.Record.create([
		{name:'id'}
		,{name : 'nombre', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellido1', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellido2', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'segmento', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipo', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'codClienteEntidad', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'direccion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'telefono1', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'docId', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoPersona', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'deudaIrregular',type: 'float', sortType:Ext.data.SortTypes.asFloat}
		,{name : 'totalSaldo',type: 'float', sortType:Ext.data.SortTypes.asFloat}
		,{name : 'diasVencido', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'numContratos'}
		,{name : 'situacion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellidoNombre', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'diasCambioEstado', sortType:Ext.data.SortTypes.asInt}
        ,{name : 'ofiCntPase', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'arquetipo', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'deudaDirecta', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'riesgoDirectoNoVencidoDanyado', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'situacionFinanciera', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'relacionExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'itinerario'}
	]);
	
	var clientesCm=new Ext.grid.ColumnModel([
			{header : '<s:message code="menu.clientes.listado.lista.nombre" text="**Nombre" />', dataIndex : 'nombre' ,sortable:true}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido1" text="**Apellido1" />', dataIndex : 'apellido1' ,sortable:true}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido2" text="**Apellido2" />', dataIndex : 'apellido2',sortable:true}
			,{header : '<s:message code="menu.clientes.listado.lista.codigo" text="**Codigo" />', dataIndex : 'codClienteEntidad',sortable:true,align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.direccion" text="**Direccion" />', dataIndex : 'direccion',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.nif" text="**CIF/NIF" />', dataIndex : 'docId',sortable:true,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.itinerario" text="**Itinerario" />', dataIndex : 'itinerario',sortable:false,align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.segmento" text="**Segmento" />', dataIndex : 'segmento',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.tipo" text="**Tipo" />', dataIndex : 'tipo',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.telefono" text="**Telefono" />', dataIndex : 'telefono1',sortable:true,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.totaldeuda" text="**Total Deuda Irregular" />', dataIndex : 'deudaIrregular',sortable:true,renderer: app.format.moneyRenderer, align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.totalsaldo" text="**Total Saldo" />', dataIndex : 'totalSaldo',sortable:true, renderer: app.format.moneyRenderer, align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.riesgoDirecto" text="**riesgo Directo" />', dataIndex: 'deudaDirecta',sortable:true, renderer: app.format.moneyRenderer,align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.riesgoDirectoDaniado" text="**RDD" />',hidden:true, dataIndex: 'riesgoDirectoNoVencidoDanyado',sortable:true, renderer: app.format.moneyRenderer,align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.nrocontratos" text="**Contratos" />', dataIndex : 'numContratos',sortable:true, align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.posantigua" text="**Posicion antigua" />', dataIndex : 'diasVencido',sortable:false, align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.situacion" text="**Situaci&oacute;n" />', dataIndex : 'situacion',sortable:false}
			,{header : 'id', dataIndex: 'id', hidden:true,fixed:true}
			,{header : 'apellidoNombre', dataIndex: 'apellidoNombre', hidden:true,fixed:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.diaspase" text="**Dias para pase" />', dataIndex: 'diasCambioEstado', sortable:false, fixed:true, align:'right',hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.ofiCntPase" text="**Oficina del contrato de pase" />' , dataIndex: 'ofiCntPase', sortable:false,hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.arquetipo" text="**Arquetipo" />', dataIndex: 'arquetipo', sortable:false, hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.situacionFinanciera" text="**Situacion Financiera" />', dataIndex: 'situacionFinanciera', sortable:false ,hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.relacionExpediente" text="**Relacion Expediente" />', dataIndex: 'relacionExpediente', sortable:false, hidden:true}
		]);
		
	var clientesStore = page.getStore({
		 limit : limit
		,remoteSort : true
		,loading : false
		,flow:'clientes/listadoClientesData'
		,reader: new Ext.data.JsonReader({
	    	root : 'personas'
	    	,totalProperty : 'total'
	    }, cliente)
	});

	var pagingBar=fwk.ux.getPaging(clientesStore);
	pagingBar.hide();
	
	var cfg={
		title: '<s:message code="menu.clientes.listado.lista.title" text="**Clientes" arguments="0"/>'
		,style:'padding: 10px;'
		,cls:'cursor_pointer'
		,iconCls : 'icon_cliente'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true
		,height:200
		,bbar : [  pagingBar ]
	};
	
	var grid=app.crearGrid(clientesStore,clientesCm,cfg);
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
		
	var panelCompleto = new Ext.Panel({
	    items : [
              {
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [filtroForm]
			  },{
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [grid]
			  },{
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [txtParticipacion]
			  }
    	]
	    ,height:450
	    ,border: false
	    ,bbar : [btnCancelar]
    });
    
	page.add(panelCompleto);
	
</fwk:page>
