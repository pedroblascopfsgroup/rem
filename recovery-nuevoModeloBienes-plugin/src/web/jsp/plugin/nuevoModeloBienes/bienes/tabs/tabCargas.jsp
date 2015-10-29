<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
	
	var idCargaAnteriorSeleccionado;
	var idCargaPosteriorSeleccionado;
	
	var labelStyle = 'width:185px;font-weight:bolder,width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder,width:375';
	var labelStyleTextArea = 'font-weight:bolder,width:500';
	
	var sinoRender = function (value, meta, record) {
		if(value){
			return 'Si';
		} else {
			return 'No';
		}
	};
	
	var idCarga = '';
	
	<%-- CARGAS ANTERIORES --%>
	
	var cargasAnterioresRecord = Ext.data.Record.create([
	{name:'idCarga'}
    ,{name:'bien'}
	,{name:'tipoCarga'}
    ,{name:'letra'}
    ,{name:'titular'}
    ,{name:'importeRegistral'}
    ,{name:'importeEconomico'}
    ,{name:'registral'}
    ,{name:'situacionCarga'}
    ,{name:'situacionCargaEconomica'}
    ,{name:'fechaPresentacion'}
    ,{name:'fechaInscripcion'}
    ,{name:'fechaCancelacion'}
    ,{name:'economica'}
    ]);

   	var cargasAnterioresStore = page.getStore({
   		flow:'editbien/getCargasAnteriores'
       	,reader: new Ext.data.JsonReader({
        	root: 'cargas'
       	}, cargasAnterioresRecord)
   	});
    
   	cargasAnterioresStore.webflow({id:${NMBbien.id},anteriores : true});    
 

 	var cargasAnterioresCM  = new Ext.grid.ColumnModel([
         {header: '<s:message code="plugin.nuevoModeloBienes.cargas.idCarga" text="**idCarga"/>',width:52, sortable: true, dataIndex: 'idCarga', hidden: true}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.tipoCarga" text="**tipoCarga"/>',width:52, sortable: true, dataIndex: 'tipoCarga', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.letra" text="**letra"/>',width:52, sortable: true, dataIndex: 'letra', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.titular" text="**titular"/>',width:52, sortable: true, dataIndex: 'titular', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.importeRegistral" text="**importeRegistral"/>',width:52,renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeRegistral', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.importeEconomico" text="**importeEconomico"/>',width:52,renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeEconomico', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.registral" text="**registral"/>',width:52, sortable: true, dataIndex: 'registral',renderer: sinoRender, hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.situacionCarga" text="**situacionCarga"/>',width:52, sortable: true, dataIndex: 'situacionCarga', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.situacionCargaEconomica" text="**situacionCargaEconomica"/>',width:52, sortable: true, dataIndex: 'situacionCargaEconomica', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.fechaPresentacion" text="**fechaPresentacion"/>',width:52, sortable: true, dataIndex: 'fechaPresentacion', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.fechaInscripcion" text="**fechaInscripcion"/>',width:52, sortable: true, dataIndex: 'fechaInscripcion', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.fechaCancelacion" text="**fechaCancelacion"/>',width:52, sortable: true, dataIndex: 'fechaCancelacion', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.economica" text="**economica"/>',width:52, sortable: true, dataIndex: 'economica', renderer: sinoRender, hidden: false}
    ]);
    
    	var btnNuevaCargaAnterior = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCarga.btnAgragar" text="**Agregar" />'
		    ,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
			       var allowClose= false;
			       var tipoCarga = "ANTERIORES HIPOTECA";
		      	   var w = app.openWindow({
			          flow : 'editbien/agregarEditarCargas'
			          ,closable:allowClose
					  ,width: 800
					  ,autoHeight: true
					  ,autoScroll:true			          
			          ,title : '<s:message code="plugin.nuevoModeloBienes.cargas.agregar" text="**Agregar carga" />'
	     			  ,params:{
	      				  idBien : ${NMBbien.id},
	      				  idCarga: idCarga,
	      				  tipoCarga : tipoCarga
	      				}
			       });
			       w.on(app.event.DONE, function(){
			          w.close();
					  cargasAnterioresStore.webflow({id:${NMBbien.id},anteriores : true}); 			          
			       });
			       w.on(app.event.CANCEL, function(){ 
			       		w.close();
			       });					  				
	        }
		});
		
		var btnEditarCargaAnterior = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.btnEditar" text="**Editar" />'
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
			       var allowClose= false;
			       var tipoCarga = "ANTERIORES HIPOTECA";
				   if (idCargaAnteriorSeleccionado){
			      	    var w = app.openWindow({
				          flow : 'editbien/agregarEditarCargas'
				          ,closable:allowClose
						  ,width: 800
						  ,autoHeight: true
						  ,autoScroll:true			          
				          ,title : '<s:message code="plugin.nuevoModeloBienes.cargas.editar" text="**Editar carga" />'
		     			  ,params:{
		      				  idBien : ${NMBbien.id},
		      				  idCarga: idCargaAnteriorSeleccionado,
		      				  tipoCarga : tipoCarga
		      				}
				       });
				       w.on(app.event.DONE, function(){
				          w.close();
						  cargasAnterioresStore.webflow({id:${NMBbien.id},anteriores : true});			          
				       });
				       w.on(app.event.CANCEL, function(){ 
				       		w.close();
				       });	
				   }
				   else{
	           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.cargas.sinSeleccion"/>')	
	        	   }					    
	        }
		});
		
		var btnBorrarCargaAnterior = new Ext.Button({
		    text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){
					if (idCargaAnteriorSeleccionado){
					//BORRAR la Carga
					Ext.Msg.confirm('<s:message code="plugin.nuevoModeloBienes.cargas.borrar" text="**Borrar Carga" />', 
	                    	       '<s:message code="plugin.nuevoModeloBienes.cargas.borrar.confirmacion" text="**Est&aacute; seguro de que desea borrar la Carga?" />',
	                    	       this.evaluateAndSend);
					}else{
	           			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.cargas.sinSeleccion"/>')	
	        		}								
			}	
			,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
	            			page.webflow({
								flow: 'editbien/eliminarCarga' 
								//,eventName: 'borrarAsunto'
								,params:{idCarga : idCargaAnteriorSeleccionado}
								,success: function(){
						  			cargasAnterioresStore.webflow({id:${NMBbien.id},anteriores : true}); 
									//btnBorrarTermino.disable();									
								}	 
							});
	         			}
	       	}			
		});

	var btnPropuestaCancelacion = new Ext.Button({
	    text : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.btnPropuestaCancelacion" text="**Prop. de cancelación de cargas" />'
		,iconCls : 'icon_pdf'
		,handler : function(){
			var flow = '/pfs/editbien/generarInformePropCancelacionCargas';
			var params = {id:${NMBbien.id}};
			app.openBrowserWindow(flow, params);
			page.fireEvent(app.event.DONE);
		}
	});
  
    var cargasAnterioresGrid = app.crearGrid(cargasAnterioresStore, cargasAnterioresCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargasAnterioresGrid.titulo" text="**Cargas Anteriores"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_contratos'
        ,height : 220 
        ,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
        			btnNuevaCargaAnterior, btnEditarCargaAnterior, btnBorrarCargaAnterior,btnPropuestaCancelacion
        		</sec:authorize>]		
    });

	cargasAnterioresGrid.on('rowclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idCargaAnteriorSeleccionado = rec.get('idCarga');
	});	
	
	<%-- CARGAS POSTERIORES --%>
	
   	var cargasPosterioresStore = page.getStore({
   		flow:'editbien/getCargasAnteriores'
       	,reader: new Ext.data.JsonReader({
        	root: 'cargas'
       	}, cargasAnterioresRecord)
   	});
    
   	cargasPosterioresStore.webflow({id:${NMBbien.id},anteriores : false});     
 

 	var cargasPosterioresCM  = new Ext.grid.ColumnModel([
          {header: '<s:message code="plugin.nuevoModeloBienes.cargas.idCarga" text="**idCarga"/>',width:52, sortable: true, dataIndex: 'idCarga', hidden: true}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.tipoCarga" text="**tipoCarga"/>',width:52, sortable: true, dataIndex: 'tipoCarga', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.letra" text="**letra"/>',width:52, sortable: true, dataIndex: 'letra', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.titular" text="**titular"/>',width:52, sortable: true, dataIndex: 'titular', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.importeRegistral" text="**importeRegistral"/>',width:52, renderer: app.format.moneyRenderer,sortable: true, dataIndex: 'importeRegistral', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.importeEconomico" text="**importeEconomico"/>',width:52, renderer: app.format.moneyRenderer,sortable: true, dataIndex: 'importeEconomico', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.registral" text="**registral"/>',width:52, sortable: true, dataIndex: 'registral',renderer: sinoRender, hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.situacionCarga" text="**situacionCarga"/>',width:52, sortable: true, dataIndex: 'situacionCarga', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.situacionCargaEconomica" text="**situacionCargaEconomica"/>',width:52, sortable: true, dataIndex: 'situacionCargaEconomica', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.fechaPresentacion" text="**fechaPresentacion"/>',width:52, sortable: true, dataIndex: 'fechaPresentacion', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.fechaInscripcion" text="**fechaInscripcion"/>',width:52, sortable: true, dataIndex: 'fechaInscripcion', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.fechaCancelacion" text="**fechaCancelacion"/>',width:52, sortable: true, dataIndex: 'fechaCancelacion', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.cargas.economica" text="**economica"/>',width:52, sortable: true, dataIndex: 'economica', renderer: sinoRender, hidden: false}
    ]);
    
    	var btnNuevaCargaPosterior = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCarga.btnAgragar" text="**Agregar" />'
		    ,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
		       var allowClose= false;
			       var tipoCarga = "POSTERIORES HIPOTECA";
		      	   var w = app.openWindow({
			          flow : 'editbien/agregarEditarCargas'
			          ,closable:allowClose
					  ,width: 800
					  ,autoHeight: true
					  ,autoScroll:true			          
			          ,title : '<s:message code="plugin.nuevoModeloBienes.cargas.agregar" text="**Agregar carga" />'
	     			  ,params:{
	      				  idBien : ${NMBbien.id},
	      				  idCarga: idCarga,
	      				  tipoCarga : tipoCarga
	      				}
			       });
			       w.on(app.event.DONE, function(){
			          w.close();
					  cargasPosterioresStore.webflow({id:${NMBbien.id},anteriores : false}); 			          
			       });
			       w.on(app.event.CANCEL, function(){ 
			       		w.close();
			       });					  						    
				
	        }
		});
		
		var btnEditarCargaPosterior = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.btnEditar" text="**Editar" />'
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
			       var allowClose= false;
			       var tipoCarga = "POSTERIORES HIPOTECA";
				   if (idCargaPosteriorSeleccionado){
			      	    var w = app.openWindow({
				          flow : 'editbien/agregarEditarCargas'
				          ,closable:allowClose
						  ,width: 800
						  ,autoHeight: true
						  ,autoScroll:true			          
				          ,title : '<s:message code="plugin.nuevoModeloBienes.cargas.editar" text="**Editar carga" />'
		     			  ,params:{
		      				  idBien : ${NMBbien.id},
		      				  idCarga: idCargaPosteriorSeleccionado,
		      				  tipoCarga : tipoCarga
		      				}
				       });
				       w.on(app.event.DONE, function(){
				          w.close();
						  cargasPosterioresStore.webflow({id:${NMBbien.id},anteriores : false});			          
				       });
				       w.on(app.event.CANCEL, function(){ 
				       		w.close();
				       });	
				   }
				   else{
	           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.cargas.sinSeleccion"/>')	
	        	   }					    		    
			    
	        }
		});
		
		var btnBorrarCargaPosterior = new Ext.Button({
		    text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){
					if (idCargaPosteriorSeleccionado){
						//BORRAR la Carga
						Ext.Msg.confirm('<s:message code="plugin.nuevoModeloBienes.cargas.borrar" text="**Borrar Carga" />', 
	                    	       '<s:message code="plugin.nuevoModeloBienes.cargas.borrar.confirmacion" text="**Est&aacute; seguro de que desea borrar la Carga?" />',
	                    	       this.evaluateAndSend);
					}else{
	           			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.cargas.sinSeleccion"/>')	
	        		}								
			}	
			,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
	            			page.webflow({
								flow: 'editbien/eliminarCarga' 
								//,eventName: 'borrarAsunto'
								,params:{idCarga : idCargaPosteriorSeleccionado}
								,success: function(){
						  			cargasPosterioresStore.webflow({id:${NMBbien.id},anteriores : false}); 									
								}	 
							});
	         			}			
			}
		});
 
 
    var cargasPosterioresGrid = app.crearGrid(cargasPosterioresStore, cargasPosterioresCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargasPosterioresGrid.titulo" text="**Cargas Posteriores"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_contratos'
        ,height : 220 
        ,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
        			btnNuevaCargaPosterior, btnEditarCargaPosterior, btnBorrarCargaPosterior
        		</sec:authorize>]		
    });

	cargasPosterioresGrid.on('rowclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idCargaPosteriorSeleccionado = rec.get('idCarga');
	});	
	
	
	<%-- REVISION DE CARGAS --%>
	
	
	var fechaMatricula = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.cargas.fechaRevision" text="**Fecha Revisiï¿½n"/>','<fwk:date value="${NMBbien.adicional.fechaRevision}"/>', {labelStyle:labelStyleAjusteColumnas});

	var sinCargas = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.sinCargas" text="**Sin Cargas"/>'
		,name:'sinCargas'
		,labelStyle:labelStyle
		,disabled:true
	});
	
	if('${NMBbien.adicional.sinCargas}' == 'true'){
		sinCargas.checked = true;
	}
	else{
		sinCargas.checked = false;
	}
	

	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.observaciones" text="**Observaciones" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.observaciones}" />'
		,name:'observaciones'
		,hideLabel: true
		,width:375
		,height: 140
		,readOnly:true
	});
	
	var btnEditarRevisionCarga = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.btnEditar" text="**Editar" />'
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'padding-top:0px'
		    ,handler:function(){
			    var w = app.openWindow({
					flow : 'editbien/editarRevisionCargas'
					,width: 800
					,autoHeight: true
					,autoScroll:true
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabAdjudicacion.titleEditarRevisionCargas" text="**Editar revision cargas" />'
					,params : {idBien:${NMBbien.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});

	var panelRevision = new Ext.form.FieldSet({
		height:290
		,width:400
		,style:'padding:0px; margin-right:20px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.revisionCargas.titulo" text="**Revision de cargas"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:400}
	    ,items : [{items:[fechaMatricula,sinCargas,observaciones<sec:authorize ifNotGranted="SOLO_CONSULTA">,btnEditarRevisionCarga</sec:authorize>]}]
	});

	<%-- PROPUESTA DE CANCELACION DE CARGAS --%>

	var resumen = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.resumen" text="**Resumen" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.cancelacionResumen}" />'
		,name:'resumen'
		,width:270
		,height:105
		,readOnly:true
	});

	var propuesta = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.propuesta" text="**Propuesta" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.cancelacionPropuesta}" />'
		,name:'propuesta'
		,width:270
		,height:105
		,readOnly:true
	});

	var btnEditarPropuestaCancelacionCarga = new Ext.Button({
	    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.btnEditar" text="**Editar" />'
	    ,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,style:';padding-top:0px'
	    ,handler:function(){
		    var w = app.openWindow({
				flow : 'editbien/editarPropuestaCancelacionCargas'
				//,width: 550
				,autoHeight: true
				,autoScroll:true
				,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.titleEditarPropuestaCancelacion" 
				text="**Editar propuesta de cancelacion de cargas" />'
				,params : {idBien:${NMBbien.id}}
			});
			w.on(app.event.DONE, function(){
				w.close();
				app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
        }
	});

	var panelPropuestaCancelacion = new Ext.form.FieldSet({
		height:290
		,width:400
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.propuestaCancelacion.titulo" text="**Propuesta de cancelacion de cargas"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:400}
	    ,items : [{items:[resumen, propuesta<sec:authorize ifNotGranted="SOLO_CONSULTA">,btnEditarPropuestaCancelacionCarga</sec:authorize>]}]
	});
	
	var infoAdicionalCargas = new Ext.Panel({
		layout:'table'
		,id : 'idInfoAdicionalCargas'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{layout:'form', items:[panelRevision]}
			,{layout:'form',items:[panelPropuestaCancelacion]}
		]
		,autoWidth:true
		,autoHeight:true
	});

	var panel = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.titulo" text="**Cargas"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [cargasAnterioresGrid, cargasPosterioresGrid, infoAdicionalCargas]
		,nombreTab : 'tabCargas'
	});

	return panel;
})()