<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

var crearTerminosAsuntos=function(){

   var panelTerminos=new Ext.Panel({
		layout:'form'
		,border : false
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'terminos'
	});

   var checkColumn = new Ext.grid.CheckColumn({ 
        header : '<s:message code="listadoContratos.listado.incluir" text="**Incluir" />'
        ,dataIndex : 'incluir', width: 40});

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
		 ,{name : 'importe'}
		 ,{name : 'comisiones'}
	 	 ,{name : 'idContrato'}
		 ,{name : 'cc'}
		 ,{name : 'tipo'}
		 ,{name : 'estadoFinanciero'}		 
        ]);        

   var contratosAsuntoCM = new Ext.grid.ColumnModel([
  	  {dataIndex: 'id', hidden:true, fixed:true }
      ,checkColumn
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.codigo" text="**C&oacute;digo contrato" />', dataIndex : 'cc',width: 35}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.producto" text="**Producto" />', dataIndex : 'tipo',width: 65}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.saldoIrregular" text="**Saldo Irregular" />', dataIndex : 'saldoIrregular',width: 100}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.saldoVivoNoVenc" text="**Sdo Vivo no venc" />', dataIndex : 'saldoNoVencido',width: 75}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.diasIrregular" text="**Dias Irregular" />', dataIndex : 'diasIrregular',width: 75}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.otrosIntervinientes" text="**Otros Intervinientes" />', dataIndex : 'otrosint',width: 65}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.tipoIntervencion" text="**Tipo Intervencion" />', dataIndex : 'tipointerv',width: 65}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.estadoFinanciero" text="**Estado Financ" />', dataIndex : 'estadoFinanciero',width: 65}
   ]);
   
   var terminosAcuerdoCM = new Ext.grid.ColumnModel([
  	  {dataIndex: 'id', hidden:true, fixed:true }
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.tipoAcuerdo" text="**Tipo Acuerdo" />', dataIndex : 'tipoAcuerdo',width: 35}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.importe" text="**Importe" />', dataIndex : 'importe',width: 65}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.comisiones" text="**Comisiones" />', dataIndex : 'comisiones',width: 100}
	  ,{dataIndex: 'idContrato', hidden:true, fixed:true }      
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.codigoContrato" text="**C&oacute;digo contrato" />', dataIndex : 'cc',width: 75}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.producto" text="**Producto" />', dataIndex : 'tipo',width: 75}
      ,{header : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.grid.estadoFinanciero" text="**Estado Financ" />', dataIndex : 'estadoFinanciero',width: 65}          
   ]);      
   
   var contratosAsuntoStore = page.getStore({
        flow: 'mejacuerdo/obtenerListadoContratosAcuerdoByAsuId'
        ,storeId : 'contratosAsuntoStore'
        ,params: {idAsunto:panel.getAsuntoId()}
        ,reader : new Ext.data.JsonReader(
            {root:'contratosAsunto'}
            , contratosAsuntoRecord
        )
   });
   
  var terminosAcuerdoStore = page.getStore({
        flow: 'mejacuerdo/obtenerListadoTerminosAcuerdoByAcuId'
        ,storeId : 'terminosAcuerdoStore'
        ,params: {idAcuerdo : acuerdoSeleccionado}
        ,reader : new Ext.data.JsonReader(
            {root:'terminosAcuerdo'}
            , terminosAcuerdoRecord
        )
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
       text:  '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.agregar" text="**Agregar termino" />'
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
				var allowClose= false;
				var contratosIncluidos = transformParamInc(); 
				var idAcuerdo = acuerdoSeleccionado;			
				if (contratosIncluidos.length == 0 ) {			
					Ext.Msg.alert('<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.warning" text="**Aviso" />', 
	                    	       '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.contratos.grid.warning.contratoNoSelec" text="**No ha seleccionado ningún contrato" />');
				}
				else {								
	      	        var w = app.openWindow({
			          flow : 'mejacuerdo/openAltaTermino'
			          ,closable:allowClose
			          ,width: 900
			          ,autoHeight: true
			          ,title : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.agregar" text="**Agregar Termino" />'
	     			  ,params:{
	      				  id:panel.getAsuntoId(),
	      				  contratosIncluidos: contratosIncluidos,
	      				  idAcuerdo : idAcuerdo
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
		text: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.boton.borrar" text="**Borrar Termino" />',
		iconCls: 'icon_menos',
		handler: function(){
			if (idTerminoSeleccionado){
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
   
   
   contratosAsuntoStore.webflow({idAsunto:panel.getAsuntoId()});
   terminosAcuerdoStore.webflow({idAcuerdo : acuerdoSeleccionado});    
   
   var contratosAsuntoGrid = app.crearGrid(contratosAsuntoStore,contratosAsuntoCM,{
         title : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.contratos.titulo" text="**Contratos/Asunto" />'
         ,style:'padding : 5px'
         ,autoHeight : true
         ,autoWidth:true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,plugins:checkColumn
         ,bbar : [
	        btnAltaTermino
	      ]         
   });
   
   var terminosAcuerdoGrid = app.crearGrid(terminosAcuerdoStore,terminosAcuerdoCM,{
         title : '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.titulo" text="**Terminos/Acuerdo" />'
         ,style:'padding : 5px'
         ,autoHeight : true
         ,autoWidth:true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [
	        btnBorrarTermino
	      ]                  
   }); 
   
   terminosAcuerdoGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idTerminoSeleccionado = rec.get('id');

		if(idTerminoSeleccionado!='') {
			btnBorrarTermino.enable();
		} else {
			btnBorrarTermino.disable();
		}
	});
   
   panelTerminos.add(terminosAcuerdoGrid);
   panelTerminos.terminosAcuerdoGrid=terminosAcuerdoGrid;
   
   panelTerminos.add(contratosAsuntoGrid);
   panelTerminos.contratosAsuntoGrid=contratosAsuntoGrid;      

   return panelTerminos;

  

 
}
