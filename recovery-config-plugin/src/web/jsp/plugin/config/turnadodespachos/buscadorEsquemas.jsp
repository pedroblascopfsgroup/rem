<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto" %>

<fwk:page>

	//VARS ********************************************************************
	
	var limit=25;
	//creamos objeto dto
	
	//PANEL FILTROS ********************************************************************
	
	
	var estadosEsquemaData = <app:dict value="${estadosEsquema}"/>;
	var estadosEsquemaDataStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : estadosEsquemaData
	       ,root: 'diccionario'
	});
	
    var cmbEstado = app.creaCombo({
    	store : estadosEsquemaDataStore
    	,name : 'tipoImporteLit'
    	,fieldLabel : '<s:message code="plugin.config.esquematurnado.letrado.ventana.label.tipoimporte" text="**Tipo estado" />'
		,width : 130
    });
    
    
    	//Creamos el boton buscar
	var btnBuscar=new Ext.Button({
		text:'<s:message code="app.buscar" text="**Buscar" />'
		,iconCls:'icon_busquedas'
		,handler:function(){
			b=getParametrosDto();
			esquemasStore.webflow(b);
			page.fireEvent(app.event.DONE);
		}
	});
	var btnClean=new Ext.Button({
	
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			resetFiltros();
		}
	});
	
	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.buscador.tabFiltros.nombreEsquema"
		label="**Nombre esquema turnado"
		name="txtNombreEsquema"
		value=""
		readOnly="false" />
	<pfsforms:textfield
		labelKey="plugin.config.esquematurnado.buscador.tabFiltros.autor"
		label="**Autor"
		name="txtAutor"
		value=""
		readOnly="false" />

	<pfs:datefield name="dateFechaCreacionEsquema" labelKey="plugin.config.esquematurnado.buscador.tabFiltros.fechaAlta" label="**Fecha alta" width="70"/>;
	<pfs:datefield name="dateFechaVigenteEsquema" labelKey="plugin.config.esquematurnado.buscador.tabFiltros.fechaVigente" label="**Fecha vigente" width="70"/>;
	<pfs:datefield name="dateFechaFinalizadoEsquema" labelKey="plugin.config.esquematurnado.buscador.tabFiltros.fechaFinalizado" label="**Fecha finalizado" width="70"/>;


	var panelFiltros = new Ext.Panel({
		title:'<s:message code="plugin.config.esquematurnado.buscador.tabFiltros.titulo" text="**Buscador de esquemas de turnado" />'
		,collapsible:true
		,collapsed: false
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{
				layout:'form'
				,items: [cmbEstado,txtNombreEsquema,txtAutor]
				},{
				layout:'form'
				,style: 'margin-left:20px;'
				,items: [dateFechaCreacionEsquema,dateFechaVigenteEsquema,dateFechaFinalizadoEsquema]
				}]
		,listeners:{	
			beforeExpand:function(){
				//esquemasGrid.setHeight(125);
			}
			,beforeCollapse:function(){
				//esquemasGrid.setHeight(435);
				//esquemasGrid.expand(true);			
			}
		}
		,tbar : [btnBuscar,btnClean]
	});
	//------------------------------------------------------------------------------------------
	resetFiltros = function(){
		
		//if(tabFiltros){
		//alert("entro a resetear");
			cmbEstado.reset();
			txtNombreEsquema.reset();
			txtAutor.reset();
			dateFechaCreacionEsquema.reset();
			dateFechaVigenteEsquema.reset();
			dateFechaFinalizadoEsquema.reset();
		//}
	}
	var getParametrosDto=function(){
		    var b={};
			b.tipoEstado = cmbEstado.getValue();
			b.nombreEsquemaTurnado=txtNombreEsquema.getValue();
			b.autor=txtAutor.getValue();
			b.fechaAlta=dateFechaCreacionEsquema.getValue();
			b.fechaVigente=dateFechaVigenteEsquema.getValue();
			b.fechaFinalizado=dateFechaFinalizadoEsquema.getValue();
			return b;
	}
	
	//PANEL GRID RESULTADOS ********************************************************************
	
	var ventanaEdicion = function(id) {
		var w = app.openWindow({
			flow : 'turnadodespachos/editarEsquema'
			,width :  600
			,closable: true
			,title : '<s:message code="plugin.config.esquematurnado.nuevo" text="**Nuevo esquema" />'
			,params : {id:id}
		});
		w.on(app.event.DONE, function(){
			w.close();
			esquemasStore.webflow(getParametros());
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};

	var btnNuevo = new Ext.Button({
			text : '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.nuevo" text="**Nuevo" />'
			,iconCls : 'icon_mas'
			,handler : function(){
				ventanaEdicion(null);
			}
	});
	var btnBorrar = new Ext.Button({
			text : '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){ 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.borrar.confirm" text="**Se va a eliminar el esquema seleccionado. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
			      			page.webflow({
				      			flow:'turnadodespachos/copiarEsquema'
				      			,params: {}
				      			,success: function(){
			            		   page.fireEvent(app.event.DONE);
			            		   esquemasStore.webflow(getParametros());
			            		}	
				      		});
						}
					}, this);
			}
	});
	var btnCopiar = new Ext.Button({
			text : '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.copiar" text="**Copiar" />'
			,iconCls : 'icon_copy'
			,handler : function(){ 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.copiar.confirm" text="**La acción copiará el esquema seleccionado. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
			      			page.webflow({
				      			flow:'turnadodespachos/copiarEsquema'
				      			,params: {}
				      			,success: function(){
			            		   page.fireEvent(app.event.DONE);
			            		   esquemasStore.webflow(getParametros());
			            		}	
				      		});
						}
					}, this);
			}
	});
	var btnActivar = new Ext.Button({
			text : '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.activar" text="**Activar" />'
			,iconCls : 'icon_play'
			,handler : function(){ 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.buscador.grid.boton.activar.confirm" text="**La acción activará el esquema seleccionado. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
			      			page.webflow({
				      			flow:'turnadodespachos/copiarEsquema'
				      			,params: {}
				      			,success: function(){
			            		   page.fireEvent(app.event.DONE);
			            		   esquemasStore.webflow(getParametros());
			            		}	
				      		});
						}
					}, this);
			}
	});

// ................................................
// Mover a ficha de letrado
// ................................................

	var btnEditarTurnadoLetrado = new Ext.Button({
			text : '<s:message code="plugin.config.esquematurnado.letrado.boton.editar" text="**Editar letrado" />'
			,iconCls : 'icon_edit'
			,handler : function(){ 
				var w = app.openWindow({
					flow : 'turnadodespachos/ventanaEditarLetrado'
					,width :  600
					,closable: true
					,title : '<s:message code="plugin.config.esquematurnado.letrado.ventana.titulo" text="**Turnado de letrado" />'
					,params : {id:id}
				});
				w.on(app.event.DONE, function(){
					w.close();
					esquemasStore.webflow(getParametros());
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
	});
// ................................................

	
	btnBorrar.setDisabled(true);
	btnCopiar.setDisabled(true);
	btnActivar.setDisabled(true);
	
	var esquema = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'descripcion'}
		 ,{name:'estado_cod'}
		 ,{name:'estado_des'}
		 ,{name:'usuario'}
		 ,{name:'fechaalta'}
		 ,{name:'fechainivig'}
		 ,{name:'fechafinvig'}
	]);				
	
	var esquemasStore = page.getStore({
		 flow: 'turnadodespachos/buscarEsquemas' 
		,limit: limit
		,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'esquemas'
	    	,totalProperty : 'total'
	     }, esquema)
	});	
	
	var pagingBar=fwk.ux.getPaging(esquemasStore);
	
	var esquemasCm = new Ext.grid.ColumnModel([	    
		{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.id" text="**idEsquema"/>', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.descripcion" text="**Descripcion"/>', dataIndex: 'descripcion', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.estado_cod" text="**Cod Estado"/>', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.estado_des" text="**Estado"/>', dataIndex: 'estado_des', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.fechaSolicitud" text="F.Alta"/>', dataIndex: 'fechaalta', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.usuario" text="**Usuario"/>', dataIndex: 'usuario', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.fechainivig" text="**F.Inicio Vigencia"/>', dataIndex: 'fechainivig', sortable: true}
		,{header: '<s:message code="plugin.config.esquematurnado.buscador.grid.fechafinvig" text="**F.Fin Vigencia"/>', dataIndex: 'fechaalta', sortable: true}
	]);
	
	var esquemasGrid = new Ext.grid.EditorGridPanel({
		store: esquemasStore
		,cm: esquemasCm
		,title:'<s:message code="plugin.config.esquematurnado.buscador.tituloGrid" text="**Esquemas encontrados"/>'
		,stripeRows: true
		,autoHeight:true
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar : [pagingBar,btnNuevo,btnEditarTurnadoLetrado,btnCopiar,btnBorrar,btnActivar]
	});
	
	esquemasGrid.on('rowdblclick', function(grid, rowIndex, e) {
	   	var rec = grid.getStore().getAt(rowIndex);
	   	var id=rec.get('id');
	   	if (id!=null){
			ventanaEdicion(id);
	   	}
	});
	
	//PANEL PRINCIPAL ********************************************************************
	var mainPanel = new Ext.Panel({
		items : [panelFiltros,esquemasGrid]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
	   });
	   
	
	
	esquemasStore.webflow({});
	page.add(mainPanel);

</fwk:page>


