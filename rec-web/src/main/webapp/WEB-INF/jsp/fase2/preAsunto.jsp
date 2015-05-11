<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
	var taId = "observacionExp"+"${expediente.id}";
	var show=false;                                                                                                                                                      
	var sesion =app.creaLabel('<s:message code="decisioncomite.consulta.sesion" text="**Sesion" />','${expediente.comite.ultimaSesion.id}');                           
	var fecha  =app.creaLabel('<s:message code="decisioncomite.consulta.fecha" text="**Fecha" />','<fwk:date value="${expediente.comite.ultimaSesion.fechaInicio}"/>');
	var plazorestante =app.creaLabel('<s:message code="decisioncomite.consulta.plazo" text="**Plazo Restante" />',app.format.ifNullRenderer('${tarea.plazo}','Vencido')); 
	var observaciones =app.crearTextArea(
		'',
		'<s:message text="${expediente.decisionComite.observaciones}" javaScriptEscape="true" />',
		true,
		''
		,''
		,{id:taId}
	);                                                                       
	                                                                                                                                                                     
	   
	
	var refrescarProcedimientos=function(){
		
	};
	
	var idSeleccionado;
	var idProcedimiento;
	
	var btnAltaProcedimiento= new Ext.Button({
           text:  '<s:message code="app.agregar" text="**Agregar" />'
           ,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
           ,handler:function(){
			if (idSeleccionado){
				var w = app.openWindow({
					flow : 'expedientes/editaProcedimiento'
					,closable:false
					,width : 750
					,title : '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />' 
					,params : {idExpediente:${expediente.id},idContrato:idSeleccionado, idProcedimiento:0}  
				});
				w.on(app.event.DONE, function(){
					contratosStore.webflow({id:${expediente.id}});     
					w.close();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	          
           }else{
           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.contratoNulo"/>')	
           }
         }  
	});
	
	
	var btnBorraProcedimiento= new Ext.Button({
	           text:  '<s:message code="app.borrar" text="**Borrar" />'
	           ,iconCls : 'icon_menos'
			   ,cls: 'x-btn-text-icon'
	           ,handler:function(){ 
					 	if (idProcedimiento){
					 		Ext.Msg.confirm("<s:message code="dc.proc.borrarProcedimiento" text="**BorrarProcedimiento" />", 
	                    	       "<s:message code="dc.proc.confirmaBorraProcedimiento" text="**Est&aacute; seguro de que desea borrar el procedimiento?" />",
	                    	       this.evaluateAndSend); 					                                                                                                                                                             
		        	 	}else{
			           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.procedimientoNulo"/>')	
			            }      
		        	 }
		        	 ,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {            
	            			page.webflow({
					      		flow: 'expedientes/borrarProcedimiento', 
					      		eventName: 'borrar',
					      		params:{id:idProcedimiento}
					      		,success: function(){contratosStore.webflow({id:${expediente.id}});  }
					   		});
	         			}
	       			 }       
		    });                  
	
	<c:if test="${expediente.estadoExpediente==2}">                                                                                                                                 
		<sec:authorize ifAllGranted="ROLE_COMITE">                                                                                                                  
			var btnEditarObs= new Ext.Button({                                                                                                                                 
		           	text: '<s:message code="app.editar" text="**Editar" />'                                                                                                
		           	,iconCls : 'icon_edit'                                                                                                                                 
					,cls: 'x-btn-text-icon'                                                                                                                                      
					,style:'margin-left:210px;'                                                                                                                                  
		           	,handler:function(){                                                                                                                                   
						var w = app.openWindow({                                                                                                                                   
							flow : 'expedientes/editaDecisionComite'
							,eventName: 'editar'                                                                                                                 
							,width:400                                                                                                                                               
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
	</c:if>                                                                                                                                                     
	var fieldSetObservaciones=new Ext.form.FieldSet({                                                                                                                    
		title:'<s:message code="decisioncomite.consulta.observaciones" text="Observaciones" />'                                                                            
		,buttonAlign:'right'                                                                                                                                               
		,border:true                                                                                                                                                       
		,layout:'fit'                                                                                                                                                      
		,autoHeight:true                                                                                                                                                   
		,width:300                                                                                                                                                         
		,items:[                                                                                                                                                           
			observaciones                                                                                                                                                    
			<c:if test="${expediente.estadoExpediente==2}">      
				<sec:authorize ifAllGranted="ROLE_COMITE">                                                                                                              
					,btnEditarObs                                                                                                                                                  
				</sec:authorize>	                         
			</c:if>                                                                                                                      
			]                                                                                                                                                                
	});        
	
	<c:if test="${expediente.estadoExpediente==2}">      
		var cerrarDecision = function(){
			page.webflow({
	      		flow: 'expediente/cerrarSesion', 
	      		eventName: 'cerrarSesion',
	      		params: {idExpediente:${expediente.id}, observaciones:observaciones.getValue()}
	      		,success: recargarTab()
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
	            			cerrarDecision();
	         			}
	       			}                                                                                                                                                                
		});                                                                                                                                                                  
		</sec:authorize>	                                                                                                                                                   
	    
	    
	    var marcarSinActuacion = function(){
			page.webflow({
	      		flow: 'expediente/sinActuacion', 
	      		eventName: 'sinActuacion',
	      		params: {id: idSeleccionado,idExpediente:${expediente.id}}
	      		,success: function(){contratosStore.webflow({id:${expediente.id}});}
	   		 });
		}
	                                                                                                                                                                       
		var btnActuacion=new Ext.Button({                                                                                                                                    
			text: '<s:message code="dc.proc.sinActuacion" text="**Sin Actuación" />'                                                                                              
		           	//,iconCls : 'icon_comite_cerrar'                                                                                                                                     
					,cls: 'x-btn-text-icon'                                                                                                                                        
		           	,handler:function(){                                                                                                                                     
						if (idSeleccionado && idSeleccionado!=null){
							Ext.Msg.confirm("<s:message code="dc.proc.confirmaSinActuacion" text="**Confirmar Marcar sin Actuaci&oacute;n" />", 
	                           "<s:message code="dc.proc.confirmaSinActuacionMsg" text="**Est&aacute; seguro de que desea marcar Sin Actuai&oacute;n se perder&aacute;n todos los procedimientos asociados." />",
	                           this.evaluateAndSend);               
	                    }else{
	                    	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.contratoNulo"/>')
	                    }                            
	                                                                                                                                              
		         	}
		         	,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {            
	            			marcarSinActuacion();
	         			}
	       			}                                                                                                                                                                  
			});
			
			
			                                                                                                                                                                  
		<sec:authorize ifAllGranted="EDITAR_PROCEDIMIENTO">                                                                                                                  
	
		var btnEditProcedimiento = new Ext.Button({
	           text:  '<s:message code="app.editar" text="**Editar" />'
	           ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
	           ,handler:function(){
				if (idProcedimiento){
					var w = app.openWindow({
						flow : 'expedientes/editaProcedimiento'
						,closable:false
						,width : 750
						,title : '<s:message code="app.editar" text="**Nuevo registro" />' 
						,params : {idExpediente:${expediente.id},idContrato:idSeleccionado, idProcedimiento:idProcedimiento}  
					});
					w.on(app.event.DONE, function(){
						contratosStore.webflow({id:${expediente.id}});   
						w.close();
						  
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
	           }else{
	           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.proc.procedimientoNulo"/>')	
	           }                        
		     }
		    });                                                                                                                                                                   
		</sec:authorize>                                                                                                                                                     
	</c:if>
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
	                                                                                                                                                                     
	
	                                                                                                                                                                     
	var contratosStore = page.getStore({                                                                                                                                 
		event:'listado'
		,flow : 'expedientes/procedimientosExpediente'                                                                                                                          
		,reader : new Ext.data.JsonReader(
			{root:'contratosProcedimientos'}
			, contrato
		)                                                                                                  
	});                                                                                                                                                                  
	                                                                                                                                                                     
	contratosStore.webflow({id:${expediente.id}});                                                                                                                       
	
	                                                                                                                                                                     
	var cmContratos = new Ext.grid.ColumnModel([                                                                                                                         
	{header : '<s:message code="decisioncomite.consulta.gridcontratos.codigocontrato" text="**C&oacute;digo contrato" />', dataIndex : 'contrato'}                       
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.saldovencido" text="**Saldo vencido" />', dataIndex : 'vencido'}                                  
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.saldototal" text="**Saldo total" />', dataIndex : 'total'}                                        
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.codigoasunto" text="**C&oacute;digo asunto" />', dataIndex : 'asunto'}                            
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.tipoactuacion" text="**Tipo actuaci&oacute;n" />', dataIndex : 'actuacion'}                       
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.tipoprocedimiento" text="**Tipo procedimiento" />', dataIndex : 'procedimiento'}                  
	,{header : '<s:message code="decisioncomite.consulta.gridcontratos.tiporeclamacion" text="**Tipo Reclamacion" />', dataIndex : 'reclamacion'}                        
	,{header : '<s:message code="procedimientos.consulta.gridcontratos.saldorecuperacion" text="**Saldo Recuperacion"/>', dataIndex : 'saldoRecuperacion' }              
	,{header : '<s:message code="procedimientos.consulta.gridcontratos.recuperacion" text="**% Recuperacion"/>', dataIndex : 'porcRecuperacion' }                            
	,{header : '<s:message code="procedimientos.consulta.gridcontratos.mesesrecuperacion" text="**Meses Recuperacion"/>', dataIndex : 'mesesRecuperacion' }
	,{header : '', dataIndex : 'idContrato', hidden:true, fixed:true } 
	,{header : '', dataIndex : 'idProcedimiento', hidden:true, fixed:true }              
	]);                                                                                                                                                                  
	                                                                                                                                                                     
	var contratosGrid = app.crearGrid(contratosStore,cmContratos,{                                                                                 
		title : '<s:message code="decisioncomite.consulta.gridcontratos.titulo" text="**Contratos expediente" />'                                                          
		//,store : contratosStore                                                                                                                                            
		//,width : 700                                                                                                                                                     
		//,autoWidth:true  
		,style:'padding-right:10px'                                                                                                                                                  
		,autoHeight : true 
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})                                                                                                                                                
		//,viewConfig : { forceFit : true, autoFill:true }                                                                                                                   
		//,cm : cmContratos                                                                                                                                                  
		,bbar : [                                                                                                                                                          
		<c:if test="${expediente.estadoExpediente==2}"> 
			<sec:authorize ifAllGranted="EDITAR_PROCEDIMIENTO">                                                                                                                
				btnAltaProcedimiento,btnEditProcedimiento,btnBorraProcedimiento,btnActuacion                                                                                                                                
			</sec:authorize>                      
		</c:if>                                                                                                                           
		]                                                                                                                                                                  
	});                                                                                                                                                                  
                                                                                                                                                                       
	contratosGrid.on('rowclick', function(grid, rowIndex, e){                                                                                                         
		var rec = grid.getStore().getAt(rowIndex);
		idSeleccionado = rec.get('idContrato');  
		idProcedimiento = rec.get('idProcedimiento');
	});                                                                                                                                                                  
                                                                                                                                                                       
		                                                                                                                                                                     
	var panel = new Ext.Panel({                                                                                                                                          
		title:'<s:message code="decisionComite.titulo" text="**Decisi&oacute;n comit&eacute;"/>'                                                                           
		,style:'padding: 10px'                                                                                                                                             
		//,layout:'form'                                                                                                                                                   
		,defaults:{                                                                                                                                                        
			style:'margin-top:10px'                                                                                                                                          
		}                                                                                                                                                                  
		,autoHeight:true                                                                                                                                                   
		,items:[                                                                                                                                                           
			{                                                                                                                                                                
				layout:'column'                                                                                                                                                
				,border:false                                                                                                                                                  
				,viewConfig:{                                                                                                                                                  
					columns:2                                                                                                                                                    
				}                                                                                                                                                
				,defaults:{                                                                                                                                                    
					xtype:'fieldset'                                                                                                                                            
					,autoHeight:true                                                                                                                                          
				}                                                                                                                                                              
				,items:[                                                                                                                                                       
					{items:[sesion,fecha,plazorestante],style:'margin-right:20px',border:false,width:200}                                                                                     
					,listadoAsuntos                                                                                                                                              
				]                                                                                                                                                              
			}                                                                                                                                                                
			,contratosGrid                                                                                                                                                   
			,fieldSetObservaciones 
			<c:if test="${expediente.estadoExpediente==2}">                                                                                                                                          
				<sec:authorize ifAllGranted="CERRAR_DECISION">                                                                                                                   
				,{                                                                                                                                                               
					autoHeight:true                                                                                                                                                
					,style:'margin-left:550px;'                                                                                                                                    
					,border:false                                                                                                                                                  
					,items:btnCerrarDecision                                                                                                                                       
				}                                                                                                                                                                
				</sec:authorize>
			</c:if>                                                                                                                                                  
		]                                                                                                                                                                  
		,listeners:{                                                                                                                                                       
			show:function(){                                                                                                                                                 
				if(!show){                                                                                                                                                     
					show=true;                                                                                                                                                   
					//contratosStore.webflow();                                                                                                                                  
				}                                                                                                                                                              
				                                                                                                                                                               
			}                                                                                                                                                                
		}                                                                                                                                                                  
		                                                                                                                                                                   
	});
	page.add(panel);                                                                                                                                                        
                                                                                                                                                                       

</fwk:page>