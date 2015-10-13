<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	
	var mask;                                                                                                                                          
	var taId = "observacionExp";
	var show=false;                                                                                                                                                      
	var sesion =app.creaLabel('<s:message code="decisioncomite.consulta.sesion" text="**Sesion" />','');                           
	var comite =app.creaLabel('<s:message code="decisioncomite.consulta.comite" text="**Comite" />','');                           
	var fecha  =app.creaLabel('<s:message code="decisioncomite.consulta.fecha" text="**Fecha" />','');
	var plazorestante =app.creaLabel('<s:message code="decisioncomite.consulta.plazo" text="**Plazo Restante" />', '');
	var  CODIGO_ASUNTO_EN_CONFORMACION = "<fwk:const value="es.capgemini.pfs.asunto.model.DDEstadoAsunto.ESTADO_ASUNTO_EN_CONFORMACION" />";

	var fieldSetCabecera=new Ext.form.FieldSet({                                                                                                                    
		title:'<s:message code="decisioncomite.consulta.fieldSetCabecera" text="**Cabecera" />'
		,autoHeight : true                                                                           
		,border:true       
		,layout : 'table'
		,viewConfig:{                                               
			columns:2
		}           
		,style:'padding:0px'
		,defaults : {padding:'0px', xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop', width:375}
		,width:760
		,items:[
			{items:[sesion, comite]}
			,{items:[fecha, plazorestante]}                                                                                                                                                 
		]                                                                                                                                                                
	}); 

	var	txtObservaciones = new Ext.ux.form.StaticTextField({
	   	fieldLabel:'<s:message code="decisioncomite.consulta.observaciones" text="**Observaciones" />'
		,labelStyle:'font-weight:bolder;xtype:"fieldset"'
	});

	var observaciones = new Ext.form.TextArea({
		id:taId
		,hideLabel:true
		,labelSeparator: ''
		,fieldLabel:''
		,width: 530
		,height: 125
		,maxLength: 100
		,maxLengthText:  100
		,readOnly: true
		,labelStyle: ''
		,value:''
		,name: ''
	});
	
	var contrato = Ext.data.Record.create([
		{name : 'idContrato'}
		,{name : 'contrato'}
		,{name : 'tipo'}
		,{name : 'vencido'}
		,{name : 'total'}
		,{name : 'incluido'}
		,{name : 'incluidoBck'}
		,{name : 'nProcedimientos'}
	]);


//LISTADO DE CONTRATOS

	var contratosSinActuacion = new Array();
	var contratosSinActString;

	var armarArrayContratosSinActuacion = function(elArray,valor){
	
		var esta = false;
		var nuevoArray = new Array();
		var j = 0;
		for (var i=0; i < elArray.length; i++){
			if(valor!=elArray[i]){
				//Si es distinto quiere decir que no esta deseleccionando un elemento,
				//por lo tanto lo tengo que pasar al nuevo array. 
				nuevoArray[j++]=elArray[i];
			}else{
				//Si es igual (lo esta deseleccionando), 
				//hay que sacarlo del listado de seleccionados.
				esta = true;
			}
		}
		if (!esta){
			//Si copio todo el array y no estaba lo agrego porque es nuevo.
			nuevoArray[nuevoArray.length] = valor;
		}
		return nuevoArray;
	
	}
	
	var armarString = function(elArray){
		var s = "";
		for (var i=0; i < elArray.length; i++){
			if (s!=""){
				s+="-";
			}
			s+=elArray[i];
		}
		return s;
	}

	var contratosStore = page.getStore({
		event:'listado'
		,flow : 'contratos/listadoContratosExcluirData'
    ,storeId : 'contratosStoreDecisionComite'
		,reader : new Ext.data.JsonReader(
			{root:'contratos'}
			, contrato
		)
	});
	
	var auxCargarArrayInicial = function(record){
		if (record.data["incluido"]){
			contratosSinActuacion = armarArrayContratosSinActuacion(contratosSinActuacion,record.data["idContrato"]);
		}
	}
	
	var cargarArrayInicial = function(){
		contratosStore.each(auxCargarArrayInicial);
		contratosSinActString = armarString(contratosSinActuacion);
		contratosStore.un('load',cargarArrayInicial);
	}

	Ext.grid.CheckColumn = function(config){
	    Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
	    }
	    this.renderer = this.renderer.createDelegate(this);
	};
                                                                                                                                                                     
	Ext.grid.CheckColumn.prototype = {
	    init : function(grid) {
	        this.grid = grid;
	        this.grid.on('render', function(){
	            var view = this.grid.getView();
	            view.mainBody.on('mousedown', this.onMouseDown, this);
	        }, this);
	    },
	    onMouseDown : function(e, t){
	        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	            e.stopEvent();
	            var index = this.grid.getView().findRowIndex(t);
	            var record = this.grid.store.getAt(index);
              if (entidad.getData('decision.estaCongelado')){
	            	
	            	if (!record.data[this.dataIndex] || (record.data[this.dataIndex] && !record.data['incluidoBck']) ){
	            		record.set(this.dataIndex, !record.data[this.dataIndex]);
	            		contratosSinActuacion = armarArrayContratosSinActuacion(contratosSinActuacion,record.data["idContrato"])
	            		contratosSinActString = armarString(contratosSinActuacion);
	            	}else{
	            		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.asuntos.listado.desmarcarSinActuacion"/>')
	            	}
            }
	        }
	    },
	    renderer : function(v, p, record){
	        p.css += ' x-grid3-check-col-td'; 
	        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    }
	};  

	function transform(records) {
	    var str='';
	    var data;
	    for(var i=0; i < records; i++) {
	        data = clientesGrid.getStore().getAt(i).data;
		 	if(data.incluido==true)
		       	str+=data.id;
			if(i!=records-1)	// Si no es el ltimo elemento
				str+=',';
	    }
	    return str;
	};

	var checkColumn = new Ext.grid.CheckColumn({
	    header : '<s:message code="decisioncomite.consulta.gridcontratos.seleccionar" text="**Seleccionar"/>'
	    ,width:100,dataIndex:'incluido'});
	
	var contratosCm = new Ext.grid.ColumnModel([                                                                                                                         
		{header : '<s:message code="decisioncomite.consulta.gridcontratos.codigocontrato" text="**C&oacute;digo contrato" />', width:175, dataIndex : 'contrato'}
		,{header : '<s:message code="decisioncomite.consulta.gridcontratos.tipo" text="**Tipo" />', width:150, dataIndex : 'tipo'}
		,{header : '<s:message code="decisioncomite.consulta.gridcontratos.saldovencido" text="**Saldo vencido" />', width:100, dataIndex : 'vencido',renderer: app.format.moneyRenderer,align:'right'}
		,{header : '<s:message code="decisioncomite.consulta.gridcontratos.saldototal" text="**Saldo total" />', width:100, dataIndex : 'total',renderer: app.format.moneyRenderer,align:'right'}
		,{header : '<s:message code="decisioncomite.consulta.gridcontratos.nActuaciones" text="**N Actuaciones" />', width:100, dataIndex : 'nProcedimientos',align:'right'}
		,{header : '', dataIndex : 'idContrato', hidden:true, fixed:true }
		,checkColumn
	]);                                                                                                                                                                  
	       

	contratosStore.on('load', refrescaCheckBox);

	var btnActuacion = new Ext.Button({
			text: '<s:message code="decisionComite.boton.sinActuacion" text="**Sin Actuación" />'                                                                                              
		   ,iconCls : 'icon_sin_actuacion'                                                                                                                                     
		   ,cls: 'x-btn-text-icon'                                                                                                                                        
		   ,handler:function(){
				if (contratosSinActString!=null && contratosSinActString.length>0){
					Ext.Msg.confirm(
					   "<s:message code="dc.proc.confirmaSinActuacion" text="**Confirmar Marcar sin Actuaci&oacute;n" />" 
	                  ,"<s:message code="dc.proc.confirmaSinActuacionMsg" text="**Est&aacute; seguro de que desea marcar Sin Actuai&oacute;n se perder&aacute;n todos los procedimientos asociados." />"
	                  ,this.evaluateAndSend
	                );
	            }else{
	               	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.contratoNulo"/>')
	            }
		   }
		   ,evaluateAndSend: function(seguir) {
	       		if(seguir== 'yes') {
	        		marcarSinActuacion();
	         	}
				else {
					contratosSinActuacion=new Array();
					contratosSinActString = armarString(contratosSinActuacion);
					contratosStore.webflow({id:entidad.getData("id")});
					asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
					contratosActuacionesStore.webflow({idExpediente:entidad.getData("id")});
				}
	       }
	});
	     

	
	var contratosGrid = new Ext.grid.GridPanel({
		store:contratosStore
		,cm:contratosCm 
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,title : '<s:message code="decisioncomite.consulta.gridcontratos.titulo" text="**Contratos del Expediente" />'
		,cls:'cursor_pointer'
		,iconCls:'icon_contratos'
		,style:'padding-right:10px;'
		,width: 760
		,height : 150 
		,plugins: checkColumn
		,bbar : [ btnActuacion ]
	});

	contratosGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idSeleccionado = rec.get('idContrato');
	});

	var contratosSinActuacion = {};
	
	function refrescaCheckBox(contratosSinActuacion){
		// Destildamos todos los elementos de la lista
		for(i=0; i < contratosGrid.getStore().getTotalCount(); i++) {
			contratosGrid.getStore().getAt(i).data.incluido=false;
		}
		
		// Si ya exista la solicitud de esclusin, dejamos tildados
		// solo los elementos que fueron tildados (seleccionados) anteriormente
		for(i=0; i < contratosSinActuacion.length; i++) {
			for(j=0; j < contratosGrid.getStore().getTotalCount(); j++) {
				if(contratosSinActuacion[i]==contratosGrid.getStore().getAt(j).data.id) {
					contratosGrid.getStore().getAt(j).data.incluido=true;
				}
			}
		}
	}

//FIN LISTADO DE CONTRATOS


	var Asunto = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
		,{name:'idProcedimiento'}
		,{name:'tipoActuacion'}
		,{name:'actuacion'}
		,{name:'fcreacion',type:'date', dateFormat:'d/m/Y'}
		,{name:'gestor'}
		,{name:'estado'}
		,{name:'supervisor'}
		,{name:'principal'}
		//,{name:'despacho'}	
	]);

	var idAsuntoSeleccionado = 0;
	var idProcSeleccionado = 0;

	var asuntosStore = page.getStore({
		eventName : 'listado'
		,flow:'expedientes/listadoAsuntosExpedienteData'
    ,storeId : 'decisionComiteAsuntosStore'
		,reader: new Ext.data.JsonReader({
			root: 'asuntos'
		}, Asunto)
	});

	var ContratosActuaciones = Ext.data.Record.create([
		{name:'contrato'}
		,{name : 'tipo'}
		,{name : 'procedimiento'}
		,{name : 'tipoActuacion'}
		,{name : 'actuacion'}
		,{name : 'fechaCreacionProcedimiento'}
	]);

	var contratosActuacionesStore = page.getStore({
		eventName : 'listado'
		,flow:'expedientes/listadoContratosActuacionesData'
		,storeId : 'decisionComiteContratosActuaciones'
		,reader: new Ext.data.JsonReader({
			root: 'contratosActuaciones'
		}, ContratosActuaciones)
	});


	
	var contratosActuacionesCm = new Ext.grid.ColumnModel([                                                                                                                         
	{header : '<s:message code="decisioncomite.consulta.gridcontratos.codigocontrato" text="**C&oacute;digo contrato" />', width:150, dataIndex : 'contrato', sortable: false}
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.tipo" text="**Tipo" />', width:150, dataIndex : 'tipo', sortable: false}
	,{header : '<s:message code="asuntos.listado.procedimiento" text="**Cdigo Actuacin" />', width:100, dataIndex : 'procedimiento', sortable: false}
	,{header : '<s:message code="asuntos.listado.tipoActuacion" text="**Tipo actuacin" />', width: 75, dataIndex : 'tipoActuacion', sortable: false}
	,{header : '<s:message code="asuntos.listado.actuacion" text="**Actuacin" />', width:150, dataIndex : 'actuacion', sortable: false}
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.fechaCreacion" text="**Fecha creacin" />', width: 100, dataIndex : 'fechaCreacionProcedimiento', sortable: false}
	]);  
	                                                                                                                                                                     
	var contratosActuacionesGrid = new Ext.grid.GridPanel({
		store : contratosActuacionesStore
		,cm : contratosActuacionesCm
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,title : '<s:message code="decisioncomite.consulta.gridcontratos.contratosActuaciones" text="**Contratos - Actuaciones" />'
		,cls:'cursor_pointer'
		,iconCls:'icon_procedimiento'		
		,style:'padding-right:10px;width:650px'
		,width:650
		,height: 125
	});


	var asuntosCm = new Ext.grid.ColumnModel([
    {
		header: '<s:message code="asuntos.listado.asunto" text="**Asunto"/>',
		width:150, dataIndex: 'nombre', sortable:false
	},{
		header: '<s:message code="asuntos.listado.estado" text="**Estado"/>',
		width:100, dataIndex: 'estado',sortable:false
	}, {
		header: '<s:message code="asuntos.listado.procedimiento" text="**Cdigo actuacin"/>',
		width:100, dataIndex: 'idProcedimiento'
		,sortable:false
	}, {
		header: '<s:message code="asuntos.listado.tipoActuacion" text="**Tipo Actuacin"/>',
		width:100, dataIndex: 'tipoActuacion',sortable:false
	}, {
		header: '<s:message code="asuntos.listado.actuacion" text="**Actuacin"/>',
		width:175, dataIndex: 'actuacion',sortable:false
	},{
		header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>',
		hidden:true, dataIndex: 'fcreacion'
		,renderer:app.format.dateRenderer,sortable:false
	},{
		header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>',
		hidden:true, dataIndex: 'gestor',sortable:false
	},{
		hidden:true, dataIndex: 'despacho',sortable:false
	},{
		header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>',
		hidden:true, dataIndex: 'supervisor',sortable:false
	},{
		header: '<s:message code="asuntos.listado.principal" text="**Principal"/>',
		width:100, dataIndex: 'principal',sortable:false, renderer: app.format.moneyRendererNull,align:'right'
	},{
		hidden:true, dataIndex: 'id', fixed:true
	}]);


	var btnNuevo = new Ext.Button({
		text : '<s:message code="decisionComite.boton.nuevoAsunto" text="**Nuevo Asunto" />'
		,iconCls : 'icon_mas'
		,handler : function(){
		//	page.fireEvent(app.event.DONE);
			win = app.openWindow(
				{
					flow:'asuntos/altaAsuntos', 
					title : '<s:message code="decisionComite.asuntos" text="**Alta Asuntos" />',
					params: {idExpediente:entidad.getData("id"), codigoEstadoAsunto: CODIGO_ASUNTO_EN_CONFORMACION},
					width: 870
				}
			);
			win.on(app.event.CANCEL,function(){win.close();});
			win.on(app.event.DONE,
					function(){
						win.close();
						asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
						cantidadAsuntos = asuntosStore.getCount();
					}
			);
		}
	});
	
	var btnEditar = new Ext.Button({
		text: '<s:message code="decisionComite.boton.editarAsunto" text="**Editar Asunto" />',
		iconCls: 'icon_edit',
		handler: function(){
			if (idAsuntoSeleccionado){
				var win = app.openWindow({
					flow: 'expedientes/editaAsuntos'
					,title: '<s:message code="decisionComite.asuntos.editar" text="**Datos del asunto" />'
					,closable:true
					,params:{idExpediente:entidad.getData("id"),idAsunto:idAsuntoSeleccionado}
					,width: 870
				});
				win.on(app.event.CANCEL,function(){win.close();});
				win.on(app.event.DONE,
					function(){
						win.close();
						asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
						cantidadAsuntos = asuntosStore.getCount();
					}
				);
			}else{
	           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.asuntos.listado.sinSeleccion"/>')	
	        }
		}
	});
	
	var btnBorrar = new Ext.Button({
		text: '<s:message code="asuntos.boton.borrar" text="**Borrar Asunto" />',
		iconCls: 'icon_menos',
		handler: function(){
			if (idAsuntoSeleccionado){
				//BORRAR EL ASUNTOS
				Ext.Msg.confirm('<s:message code="dc.asuntos.listado.borrar" text="**Borrar Asunto" />', 
	                    	       '<s:message code="dc.asuntos.listado.borrarMsg" text="**Est&aacute; seguro de que desea borrar el Asunto?" />',
	                    	       this.evaluateAndSend);
			}else{
	           	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.asuntos.listado.sinSeleccion"/>')	
	        }
		}
		,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
	            			page.webflow({
								flow: 'asuntos/borraAsunto' 
								,eventName: 'borrarAsunto'
								,params:{idAsunto:idAsuntoSeleccionado}
								,success: function(){
									asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
									cantidadAsuntos = asuntosStore.getCount();
									contratosStore.on('load',cargarArrayInicial);
									contratosStore.webflow({id:entidad.getData("id")});
								}	 
							});
	         			}
	       			 }
	});
	
		
	var refrescarProcedimientos=function(){
		
	};
	
	<%-- <sec:authorize ifAllGranted="EDITAR_PROCEDIMIENTO"> --%>
	
	var btnAltaProcedimiento= new Ext.Button({
	    text:  '<s:message code="decisionComite.boton.nuevoProcedimiento" text="**Agregar Procedimiento" />'
        ,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
        ,handler:function(){
			if (asuntosGrid.store.data.length && asuntosGrid.store.data.length>0){
				if (idAsuntoSeleccionado){
					var w = app.openWindow({
						flow : 'expedientes/editaProcedimiento'
						,closable:false
							,width : 900
						,title : '<s:message code="procedimientos.edicion.titulo" text="**Nuevo registro" />' 
							,params : {idExpediente:entidad.getData("id"),idAsunto:idAsuntoSeleccionado, idProcedimiento:0}
					});
					w.on(app.event.DONE, function(){
							w.close();

							contratosStore.webflow({id:entidad.getData("id")});
							asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
							contratosActuacionesStore.webflow({idExpediente:entidad.getData("id")});
							cantidadAsuntos = asuntosStore.getCount();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.asuntoNulo"/>')	
				}
			}else{
           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.noHayAsuntos" text="**No hay Asuntos"/>')	
			}
           
         }  
	});
	
	
	var btnBorraProcedimiento= new Ext.Button({
		           text:  '<s:message code="decisionComite.boton.borrarProcedimiento" text="**Borrar Procedimiento" />'
	           ,iconCls : 'icon_menos'
			   ,cls: 'x-btn-text-icon'
	           ,handler:function(){ 
						 	if (idProcSeleccionado){
					 		Ext.Msg.confirm("<s:message code="dc.proc.borrarProcedimiento" text="**BorrarProcedimiento" />", 
	                    	       "<s:message code="dc.proc.confirmaBorraProcedimiento" text="**Est&aacute; seguro de que desea borrar el procedimiento?" />",
	                    	       this.evaluateAndSend); 					                                                                                                                                                             
		        	 	}else{
			           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.procedimientoNulo"/>');	
			            }      
		        	 }
		        	 ,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {            
	            			page.webflow({
					      		flow: 'expedientes/borrarProcedimiento', 
					      		eventName: 'borrar',
						      		params:{id:idProcSeleccionado}
						      		,success: function(){
											asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
											cantidadAsuntos = asuntosStore.getCount();
											contratosActuacionesStore.webflow({idExpediente:entidad.getData("id")});
											contratosStore.on('load',cargarArrayInicial);
											contratosStore.webflow({id:entidad.getData("id")});
										}
						   		});
						   		asuntosGrid.refrescar();
		         			}
		       			 }
			    });

			

			var btnEditProcedimiento = new Ext.Button({
		           text:  '<s:message code="decisionComite.boton.editarProcedimiento" text="**Editar Procedimiento" />'
		           ,iconCls : 'icon_edit'
				,cls: 'x-btn-text-icon'
		           ,handler:function(){
					if (asuntosGrid.store.data.length && asuntosGrid.store.data.length>0){
						if (idProcSeleccionado){
							var w = app.openWindow({
								flow : 'expedientes/editaProcedimiento'
								,closable:false
								,width : 900
								,title : '<s:message code="app.editar" text="**Nuevo registro" />' 
								,params : {idExpediente:entidad.getData("id"),idProcedimiento:idProcSeleccionado,idAsunto:idAsuntoSeleccionado}
							});
							w.on(app.event.DONE, function(){
								w.close();
								contratosStore.webflow({id:entidad.getData("id")});
								asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
								contratosActuacionesStore.webflow({idExpediente:entidad.getData("id")});
								cantidadAsuntos = asuntosStore.getCount();
					   		});
							w.on(app.event.CANCEL, function(){ w.close(); });
			           }else{
			           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.procedimientoNulo"/>')	
			           }
		           }else{
		           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.noHayAsuntos" text="**No hay Asuntos"/>')	
	         			}
	       			 }       
		    });                  
	
	<%-- </sec:authorize> --%>


	var asuntosGrid = new Ext.grid.GridPanel({
		title: '<s:message code="asuntos.listado.titulo" text="**Asuntos - Actuaciones" />',
		iconCls:'icon_asuntos',		
		store: asuntosStore,
		loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"},
		cm: asuntosCm,
		width: asuntosCm.getTotalWidth(),
		height: 125,
		bbar: [
				btnNuevo,btnEditar,btnBorrar
				<%--  <sec:authorize ifAllGranted="EDITAR_PROCEDIMIENTO"> --%>
					,btnAltaProcedimiento,btnEditProcedimiento,btnBorraProcedimiento//,btnActuacion
				<%-- </sec:authorize> --%>
		]
	});

	asuntosGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idAsuntoSeleccionado = rec.get('id');
		idProcSeleccionado = rec.get('idProcedimiento');
		if(idAsuntoSeleccionado!='') {
			btnEditar.enable();
			btnBorrar.enable();
			btnAltaProcedimiento.enable();
			btnEditProcedimiento.disable();
			btnBorraProcedimiento.disable();
		} else {
			btnEditProcedimiento.enable();
			btnBorraProcedimiento.enable();
			btnEditar.disable();
			btnBorrar.disable();
			btnAltaProcedimiento.disable();
		}
	});

	asuntosGrid.refrescar = function(){
		asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData("decision.ultimaSesion")});
	}

	<sec:authorize ifAllGranted="ROLE_COMITE">
		var btnEditarObs= new Ext.Button({
            text: '<s:message code="app.editar" text="**Editar" />'
            ,iconCls : 'icon_edit'
            ,cls: 'x-btn-text-icon'
            ,handler:function(){
                var w = app.openWindow({
					flow : 'expedientes/editaDecisionComite'
					,eventName: 'editar'
					,width:600
					,title : '<s:message code="dc.obs.editar" text="***Editar Observaciones" />'
					,params : {id:taId, content:(observaciones.getValue()!=''?observaciones.getValue():'<s:message code="dc.obs.editar" text="***Editar Observaciones" />')}
                });
                w.on(app.event.DONE, function(){
					w.close();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });
		    }
		});
  	</sec:authorize>
	

		var cerrarDecision = function(){
			page.webflow({
	      		flow: 'expediente/cerrarSesion', 
	      		eventName: 'cerrarSesion',
	      		params: {idExpediente:entidad.getData("id"), observaciones:observaciones.getValue()}
	      		,success: function(){
					mask.hide();
	      		   app.abreExpediente(entidad.getData("id"),entidad.getData("decision.descripcionExpediente"));
	      	    	
				}
				,error:function(){
						mask.hide();
				}
	   		 });
		}
		                                                                                                                                                   
		<sec:authorize ifAllGranted="CERRAR_DECISION">                                                                                                                       
		var btnCerrarDecision= new Ext.Button({            
      text: '<s:message code="" text="Cerrar Decision Comite" />'
      ,iconCls : 'icon_comite_cerrar'
    	,cls: 'x-btn-text-icon'
     	,handler:function(){ 
						Ext.Msg.confirm("<s:message code="dc.proc.cerrarDecision" text="**Cerrar Decisi&oacute;n" />", 
	                           "<s:message code="dc.proc.confirmaCerrarDecision" text="**Est&aacute; seguro de que desea cerrar la decisi&oacute;n?" />",
	                           this.evaluateAndSend); 					                                                                                                                                                             
		        	 }
		  ,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
							mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
							mask.show();  
							//new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'}).show();
	            			cerrarDecision();
	         			}
	    }                                                                                                                                                                
		});                                                                                                                                                                  
		</sec:authorize>	                                                                                                                                                   
	    
	    
	    var marcarSinActuacion = function(){
			page.webflow({
	      		flow: 'expediente/sinActuacion' 
	      		,params:{idContratos:contratosSinActString,idExpediente:entidad.getData('id')}
	      		,success: function(){
					contratosSinActuacion=new Array();
					contratosSinActString = armarString(contratosSinActuacion);
					contratosStore.webflow({id:entidad.getData('id')});
					asuntosStore.webflow({id:entidad.getData('id'), idSesion:entidad.getData('decision.ultimaSesion')});
					contratosActuacionesStore.webflow({idExpediente:entidad.getData("id")});
				}
				,error:function()
				{
					contratosSinActuacion=new Array();
					contratosSinActString = armarString(contratosSinActuacion);
					contratosStore.webflow({id:entidad.getData("id")});
					asuntosStore.webflow({id:entidad.getData("id"), idSesion:entidad.getData('decision.ultimaSesion')});
					contratosActuacionesStore.webflow({idExpediente:entidad.getData("id")});
				}			
			});
		           }
	           
	var contrato = Ext.data.Record.create([                                                                                                                              
		{name : 'contrato'}                                                                                                                                                
		,{name : 'vencido'}                                                                                                                                                
		,{name : 'total'}                                                                                                                                                  
		,{name : 'asunto'}                                                                                                                                                 
		,{name : 'estado'}                                                                                                                                                 
		,{name : 'actuacion'}                                                                                                                                              
		,{name : 'procedimiento'}                                                                                                                                          
		,{name : 'reclamacion'}
		,{name : 'saldoRecuperacion'}
		,{name : 'porcRecuperacion'} 
		,{name : 'mesesRecuperacion'}           
		,{name : 'idContrato'} 
		,{name : 'idProcedimiento'}                                                                                                                                 
	]);                                                                                                                                                                  
	                                                                                                                                                                     
	var actuacionesTabPanel = new Ext.TabPanel({
		items:[
			asuntosGrid
			,contratosActuacionesGrid
		]
		,height : 150 
		,width: 760
		,border: true
	});                                                                                                                                                                  

	actuacionesTabPanel.setActiveTab(asuntosGrid);
	
	var panel = new Ext.Panel({
		title : '<s:message code="decisionComite.titulo" text="**Decisi&oacute;n comit&eacute;"/>'
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'tabDecisionComite'
		,defaults:{
			style:'margin-top:10px'
		}          
		,items:[                                                                                                                                                           
			fieldSetCabecera                                                                                                                                                             
			,actuacionesTabPanel
			,contratosGrid
			,{
				autoHeight:true
				,layout : 'table'
				,border : false
				,layoutConfig:{
					columns:2
				}
				,style:'margin-top:10px'        
				,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
				,items:[
					{
						items:[txtObservaciones,observaciones]
					},{
						autoHeight:true
						,width: 220
						,layout : 'table'
						,border : false
						,layoutConfig:{
							columns:1
						}
						,style:'margin-top:10px'        
						,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
						,items:[
							{								
								style:'margin-top:10px;'
								<sec:authorize ifAllGranted="ROLE_COMITE">
									,items:[btnEditarObs]
								</sec:authorize>	                         
							},{
								style:'margin-top:25px;margin-bottom:25px'
							},{
								style:'margin-left:35px'
								<sec:authorize ifAllGranted="CERRAR_DECISION">
									,items:[btnCerrarDecision]
								</sec:authorize> 
							}]
	 				}                                                                                                                                                   
				]
			}                                                                                                                                                   
		]                                                                                                                                                                  
		,listeners:{
			show:function(){
				if(!show){     
					show=true;
				}
			}
		}
	});                                                                                                                                                                  
                                                                                                                                                                       
	panel.getValue = function(){};
	panel.setValue = function(){
		sesion.setValue(entidad.getData("decision.ultimaSesion")); 
		comite.setValue(entidad.getData("decision.comite")); 
		fecha.setValue(entidad.getData("decision.fechaUltimaSesion")); 
		observaciones.setValue(entidad.getData("decision.observaciones")); 
		if (entidad.getData("decision.plazoRestante") != '') {
			plazorestante.setValue(entidad.getData("decision.plazoRestante"));
		} else {
			plazorestante.setValue('Vencido');
		}
		
		entidad.cacheOrLoad(entidad.getData(), contratosStore, {id : entidad.getData("id") });
		entidad.cacheOrLoad(entidad.getData(), contratosActuacionesStore, {idExpediente : entidad.getData("id") });
		entidad.cacheOrLoad(entidad.getData(), asuntosStore, {id : entidad.getData("id"), idSesion : entidad.getData("decision.ultimaSesion") });

    var congelado = entidad.getData("decision.estaCongelado");
    var visible = [
      [btnActuacion, congelado ]
		,[btnNuevo, congelado]
        ,[btnEditar, congelado]
        ,[btnBorrar, congelado]
        ,[btnAltaProcedimiento, congelado]
        ,[btnEditProcedimiento, congelado]
        ,[btnBorraProcedimiento, congelado]
        <sec:authorize ifAllGranted="CERRAR_DECISION">
        ,[btnCerrarDecision, congelado]
        </sec:authorize>
        ,[btnEditarObs, congelado]
    ]

    entidad.setVisible(visible);

    var contratosSinActuacion = entidad.getData("decision.contratosSinActuacion");
		refrescaCheckBox(contratosSinActuacion);
	};
	
	panel.setVisibleTab = function(data){
		return data.toolbar.puedeMostrarSolapaDecisionComite;
	}
	
	entidad.cacheStore(contratosStore);
	entidad.cacheStore(contratosActuacionesStore);
	entidad.cacheStore(asuntosStore);
	
	return panel;                                                                                                                                                        
})                                                                                                                                                                      
