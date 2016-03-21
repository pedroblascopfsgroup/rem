<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>

var crearTerminosAsuntos=function(noPuedeModificar, esPropuesta, noPuedeEditarEstadoGestion){
   var ambito = entidad.id;
   
   var panelTerminos=new Ext.Panel({
		layout:'form'
		,border : false
		,autoScroll:false
<%-- 		,bodyStyle:'padding:5px;margin:5px' --%>
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'terminos'
	});

   var contratosAsuntoRecord = Ext.data.Record.create([
	      {name : 'id' }
		 ,{name : 'incluir' }   
		 ,{name : 'cc'}
		 ,{name : 'tipo'}
		 ,{name : 'saldoIrregular'}
		 ,{name : 'saldoNoVencido'}
		 ,{name : 'diasIrregular'}
		 ,{name : 'otrosint'}
		 ,{name : 'tipointerv'}
		 ,{name : 'estadoFinanciero'}
        ]);
        
  var terminosAcuerdoRecord = Ext.data.Record.create([
	      {name : 'id' }
		 ,{name : 'tipoAcuerdo'}
		 ,{name : 'subTipoAcuerdo'}
<%-- 		 ,{name : 'importe'} --%>
<%-- 		 ,{name : 'comisiones'} --%>
	 	 ,{name : 'idContrato'}
		 ,{name : 'cc'}
		 ,{name : 'tipo'}
		 ,{name : 'estadoFinanciero'}		
		 ,{name : 'estadoGestion'}		
		 ,{name : 'codigoTipoAcuerdo'} 
        ]);        


	var smCheck = new Ext.grid.CheckboxSelectionModel({
		dataIndex : 'incluir'
		,checkOnly : true
		,singleSelect: false
		,listeners: {
            selectionchange: function(sel) {
           		var selModel = contratosAsuntoGrid.getSelectionModel()
            	var selections = selModel.getSelections();
				if(selModel.getCount() > 0) {
					for (i = 0; i <= selModel.getCount()-1; i++) {
						selections[i].data.incluir = true;
					}
				}else{
					var store = panelTerminos.contratosAsuntoGrid.getStore();
					for (var i=0; i < store.data.length; i++) {
						store.data.get(i).data.incluir = false;
					}
				}
            }
         }
	});
	
	var getParametrosEstado = function(codEstado) {
		var selModel = subastasGrid.getSelectionModel()
		var selections = selModel.getSelections();
		var sel = '';							
		var parametros = {
			idLotes : []
			,codEstado : codEstado
		};
		for (i = 0; i <= selModel.getCount()-1; i++) {
			parametros.idLotes.push(selections[i].json.idLote);
		}
		return parametros;
	}	
	
   var contratosAsuntoCM = new Ext.grid.ColumnModel([
  	  {dataIndex: 'id', hidden:true, fixed:true }
      ,smCheck
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.codigo" text="**C&oacute;digo contrato" />', dataIndex : 'cc'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.producto" text="**Producto" />', dataIndex : 'tipo'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.saldoIrregular" text="**Saldo Irregular" />', dataIndex : 'saldoIrregular'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.saldoVivoNoVenc" text="**Sdo Vivo no venc" />', dataIndex : 'saldoNoVencido'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.diasIrregular" text="**Dias Irregular" />', dataIndex : 'diasIrregular'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.otrosIntervinientes" text="**Otros Intervinientes" />', dataIndex : 'otrosint'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.tipoIntervencion" text="**Tipo Intervencion" />', dataIndex : 'tipointerv'}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.estadoFinanciero" text="**Estado Financ" />', dataIndex : 'estadoFinanciero'}
   ]);
   
   var terminosAcuerdoCM = new Ext.grid.ColumnModel([
  	  {dataIndex: 'id', hidden:true, fixed:true }  	  
      
      ,{header : (ambito=='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.tipoTerminoAcuerdo" text="**Tipo Termino" />' : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.tipoTermino" text="**Tipo soluci�n" />' , dataIndex : 'tipoAcuerdo',width: 35}
      ,{header : (ambito=='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.subtipoTerminoAcuerdo" text="**Subtipo Termino" />' : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.subtipoTermino" text="**Subtipo Solucion" />', dataIndex : 'subTipoAcuerdo',width: 35}      
<%--       ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.importe" text="**Importe" />', dataIndex : 'importe',width: 65} --%>
<%--       ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.comisiones" text="**Comisiones" />', dataIndex : 'comisiones',width: 100} --%>
	  ,{dataIndex: 'idContrato', hidden:true, fixed:true }      
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.codigoContrato" text="**C&oacute;digo contrato" />', dataIndex : 'cc',width: 75}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.producto" text="**Producto" />', dataIndex : 'tipo',width: 75}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.estadoFinanciero" text="**Estado Financ" />', dataIndex : 'estadoFinanciero',width: 65}    
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.estadoGestion" text="**Estado de gestion" />', dataIndex : 'estadoGestion',width: 65}    
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.codigoTipoAcuerdo" text="**Codigo Tipo acuerdo" />', dataIndex : 'codigoTipoAcuerdo',hidden:true}      
   ]);      
   
   
   if(esPropuesta){
   
	     var contratosAsuntoStore = page.getStore({
	        flow: 'propuestas/getContratosByExpedienteId'
	        ,storeId : 'contratosAsuntoStore'
	        ,params: {idExpediente:panel.getExpedienteId()}
	        ,reader : new Ext.data.JsonReader(
	            {root:'contratosAsunto'}
	            , contratosAsuntoRecord
	        )
	   	});
   
   }else{
    
	    var contratosAsuntoStore = page.getStore({
	        flow: 'mejacuerdo/obtenerListadoContratosAcuerdoByAsuId'
	        ,storeId : 'contratosAsuntoStore'
	        ,params: {idAsunto:panel.getAsuntoId()}
	        ,reader : new Ext.data.JsonReader(
	            {root:'contratosAsunto'}
	            , contratosAsuntoRecord
	        )
	   	});
	   	
   }

   
  var terminosAcuerdoStore = page.getStore({
        flow: 'mejacuerdo/obtenerListadoTerminosAcuerdoByAcuId'
        ,storeId : 'terminosAcuerdoStore'
        ,params: {idAcuerdo : acuerdoSeleccionado}
        ,reader : new Ext.data.JsonReader(
            {root:'terminosAcuerdo'}
            , terminosAcuerdoRecord
        )
   });      
   
	terminosAcuerdoStore.on('load', function(){  
		countTerminos = terminosAcuerdoStore.getCount();
   });
   
   	contratosAsuntoStore.on('load', function(){  
		panel.el.unmask();
   });

   
   function transformParamInc() {
		var store = panelTerminos.contratosAsuntoGrid.getStore();
		var str = '';
		var datos;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('incluir') == true) {
				if(str!='') str += ',';
	      		str += datos.get('id');
			}
		}
		return str.trim();
	};   
 

   var btnAltaTermino = new Ext.Button({
       	text:  (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.agregar" text="**Agregar Solucion" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.agregarAcuerdo" text="**Agregar Acuerdo" />'
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,hidden : noPuedeModificar
       ,handler:function(){
				var allowClose= false;
				var contratosIncluidos = transformParamInc(); 
				var idAcuerdo = acuerdoSeleccionado;			
				if (contratosIncluidos.length == 0 ) {			
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.warning.contratoNoSelec" text="**No ha seleccionado ningun contrato" />');
				}
				else {
					//var ambito = entidad.id;								
	      	        var w = app.openWindow({
			          flow : 'mejacuerdo/openAltaTermino'
			          ,closable:allowClose
			          ,width: 900
			          ,autoHeight: true
			          	,title : (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.agregar" text="**Agregar Solucion" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.agregarAcuerdo" text="**Agregar Acuerdo" />'
	     			  ,params:{
<%-- 	      				  id:panel.getAsuntoId(), --%>
						  ambito: ambito,
	      				  contratosIncluidos: contratosIncluidos,
	      				  idAcuerdo : idAcuerdo,
	      				  esPropuesta : esPropuesta
	      				}
			       });
			       w.on(app.event.DONE, function(){
			          w.close();
					  terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});			          
			       });
			       w.on(app.event.CANCEL, function(){ 
			       		w.close();
			       });
				}			      
		       
     	}     	
   });  
   
   var btnBorrarTermino = new Ext.Button({
		 text: (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.borrar" text="**Borrar Solucion" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.borrarAcuerdo" text="**Borrar Termino" />',
		iconCls: 'icon_menos',
		hidden : noPuedeModificar,
		handler: function(){
			if (typeof idTerminoSeleccionado != 'undefined'){
				//BORRAR EL ASUNTOS
				Ext.Msg.confirm('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.borrar" text="**Borrar Termino" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning.confirmarBorrado" text="**Est&aacute; seguro de que desea borrar el T&eacutermino?" />',
	                    	       this.evaluateAndSend);
			}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.terminoNoSelec" text="**No ha seleccionado ningún contrato" />');
	        }
		}
		,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
	            			page.webflow({
								flow: 'mejacuerdo/eliminarTerminoAcuerdo' 
								//,eventName: 'borrarAsunto'
								,params:{idTerminoAcuerdo:idTerminoSeleccionado}
								,success: function(){
									terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});
									btnBorrarTermino.disable();									
									//cantidadAsuntos = asuntosStore.getCount();
									//contratosStore.on('load',cargarArrayInicial);
									//contratosStore.webflow({id:${asunto.id}});
									//contratosStore.webflow({id:${asunto.expediente.id}});
								}	 
							});
	         			}
	       			 }
	});   
	
	
	var btnVerTermino = new Ext.Button({
		text: (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.editar" text="**Editar Solucion" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.editarAcuerdo" text="**Editar Termino" />',
		iconCls: 'icon_edit',
		hidden : noPuedeModificar,
		handler: function(){
			var contratosIncluidos = transformParamInc();
			if (typeof idTerminoSeleccionado != 'undefined'){
				//var ambito = entidad.id;
	     	   	var w = app.openWindow({
		          flow : 'mejacuerdo/openDetalleTermino'
		          ,closable:false
		          ,width: 900
		          ,autoHeight: true
	              ,title : (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.editar" text="**Editar Solucion" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.editarAcuerdo" text="**Editar Termino" />'
        		   ,params:{
	    			  	  ambito: ambito,
	     				  id:idTerminoSeleccionado,
	      				  contratosIncluidos: contratosIncluidos,     				  
<%-- 	     				  idAsunto:panel.getAsuntoId(), --%>
	     				  idAcuerdo : idAcuerdo,
	     				  soloConsulta : 'false'     				  
	     				}
		       });
		       w.on(app.event.DONE, function(){
		          w.close();
				  terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});			          
		       });
		       w.on(app.event.CANCEL, function(){ 
		       		w.close();
		       });

			}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.terminoNoSelec" text="**No ha seleccionado ningún contrato" />');
	        }
		}
	}); 
   
	var btnEditarEstado = new Ext.Button({
		text: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.editarEstadoGestion" text="**Editar Estado de Gestion" />',
		iconCls: 'icon_edit',
		hidden : noPuedeModificar || noPuedeEditarEstadoGestion,
		handler: function(){
			if (typeof idTerminoSeleccionado != 'undefined'){
	     	   	var w = app.openWindow({
		          flow : 'mejacuerdo/openEstadoGestion'
		          ,closable:false
		          ,width: 400
		          ,autoHeight: true
		          ,title : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.editarEstadoGestion" text="**Editar Estado de Gestion" />'
	    			  ,params:{
	     				  id:idTerminoSeleccionado,
	     				  idAcuerdo : idAcuerdo,
	     				  soloConsulta : 'false'     				  
	     				}
		       });
		       w.on(app.event.DONE, function(){
		          w.close();
				  terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});			          
		       });
		       w.on(app.event.CANCEL, function(){ 
		       		w.close();
		       });

			}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.termjinos.grid.warning.terminoNoSelec" text="**No ha seleccionado ningún contrato" />');
	        }
		}
	}); 
   
   
   
   terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});    

   var contratosAsuntoGrid = new Ext.grid.EditorGridPanel({
        store: contratosAsuntoStore
        ,cm: contratosAsuntoCM
        ,title : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.contratos.titulo" text="**Contratos/Asunto" />'
        ,style:'padding : 5px'
        ,autoHeight : true
        ,autoWidth:true
        ,cls:'cursor_pointer'
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm:smCheck
		,bbar:[btnAltaTermino]
    });
   
    if(esPropuesta){
    	contratosAsuntoStore.webflow({idExpediente:panel.getExpedienteId()});
    	contratosAsuntoGrid.setTitle('<s:message code="plugin.mejoras.propuestas.tabTerminos.contratos.titulo" text="**Contratos/Expediente" />');
    }else{
    	contratosAsuntoStore.webflow({idAsunto:panel.getAsuntoId()});
    }
   
   
   
   
<%--   
	var contratosAsuntoGrid=new Ext.grid.GridPanel({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.contratos.titulo" text="**Contratos/Asunto" />'
		,cm:contratosAsuntoCM
		,store:contratosAsuntoStore
        ,style:'padding : 5px'
        ,autoHeight : true
        ,autoWidth:true
        ,cls:'cursor_pointer'		
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,plugins:checkColumn		
		,bbar:[btnAltaTermino]
	});   
   --%>
   
   var terminosAcuerdoGrid = app.crearGrid(terminosAcuerdoStore,terminosAcuerdoCM,{
         title : (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.titulo" text="**Solucion/Propuestas" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.tituloAcuerdo" text="**Terminos/Acuerdo" />'
         ,style:'padding : 5px'
         ,autoHeight : true
         ,autoWidth:true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [
	        btnBorrarTermino, btnVerTermino, btnEditarEstado
	      ]   
   }); 
   
   terminosAcuerdoGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idTerminoSeleccionado = rec.get('id');

		if(idTerminoSeleccionado!='') {
			btnBorrarTermino.enable();
			btnVerTermino.enable();
			btnEditarEstado.enable();
		} else {
			btnBorrarTermino.disable();
			btnVerTermino.disable();
			btnEditarEstado.disable();
		}
	});
	
	terminosAcuerdoGrid.on('rowdblclick', function(grid, rowIndex, e){
		var contratosIncluidos = transformParamInc();
		var rec = grid.getStore().getAt(rowIndex);
		idTerminoSeleccionado = rec.get('id');
			//var ambito = entidad.id;
     	   	var w = app.openWindow({
	          flow : 'mejacuerdo/openDetalleTermino'
	          ,closable:false
	          ,width: 900
	          ,autoHeight: true
	          ,title : (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.ver" text="**Ver Solucion" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.verAcuerdo" text="**Ver Termino" />'
    		  ,params:{
    			  	  ambito: ambito,
     				  id:idTerminoSeleccionado,
<%--      				  idAsunto:panel.getAsuntoId(), --%>
					  idAcuerdo : idAcuerdo,
					  soloConsulta : 'true',   				  
      				  contratosIncluidos: contratosIncluidos
<%--      				  idAcuerdo : idAcuerdo --%>
     				}
	       });
	       w.on(app.event.DONE, function(){
	          w.close();
			  terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});			          
	       });
	       w.on(app.event.CANCEL, function(){ 
	       		w.close();
	       });
		
	});
	
   panelTerminos.add(terminosAcuerdoGrid);
   panelTerminos.terminosAcuerdoGrid=terminosAcuerdoGrid;
   
   panelTerminos.add(contratosAsuntoGrid);
   panelTerminos.contratosAsuntoGrid=contratosAsuntoGrid;      

   return panelTerminos;

  

 
}
