<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:120px'
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'	
	var style='margin-bottom:1px;margin-top:1px';

	var panel=new Ext.Panel({
		title : '<s:message code="acuerdos.titulo" text="**Acuerdos"/>'
		,bodyStyle:'padding:10px'   
        ,autoHeight:true
		,nombreTab : 'acuerdos'
	});
	
	var acuerdoSeleccionado = null;
	var indexAcuerdoSeleccionado = null;

	var acuerdo = Ext.data.Record.create([
          {name : 'idAcuerdo'}
         ,{name : 'fechaPropuesta'}
         ,{name : 'tipoPalanca'}
         ,{name : 'solicitante'}
         ,{name : 'estado'}
         ,{name : 'fechaEstado'}
         ,{name : 'codigoEstado'}
         ,{name : 'quita'}
         ,{name : 'codigoContrato'}
         ,{name : 'observaciones'}
         ,{name : 'conclusionTitulo'}
         ,{name : 'observacionesTitulos'}
         ,{name : 'ddAnalisisCapacidadPago'}
         ,{name : 'aumento'}
         ,{name : 'observacionesCapacidadDePago'}
         ,{name : 'cambioSolvencia'}
         ,{name : 'aumentoSolvencia'}
         ,{name : 'observacionesSolvencia'}
         ,{name : 'contratosString'}
         ,{name : 'importePago'}
         ,{name : 'despachoString'}
      ]);

   var cmAcuerdos = new Ext.grid.ColumnModel([
      {header : '<s:message code="acuerdos.codigo" text="**C&oacute;digo" />', dataIndex : 'idAcuerdo',width: 35}
      ,{header : '<s:message code="acuerdos.fechaPropuesta" text="**Fecha Propuesta" />', dataIndex : 'fechaPropuesta',width: 65}
      ,{header : '<s:message code="acuerdos.tipoAcuerdo" text="**Tipo Acuerdo" />', dataIndex : 'tipoPalanca',width: 100}
      ,{header : '<s:message code="acuerdos.solicitante" text="**Solicitante" />', dataIndex : 'solicitante',width: 75}
      ,{header : '<s:message code="acuerdos.estado" text="**Estado" />', dataIndex : 'estado',width: 75}
      ,{header : '<s:message code="plugin.recobroConfig.agencia.alta.despachoAgencia" text="**Grupo" />', dataIndex : 'despachoString', width: 100}
      ,{dataIndex : 'codigoEstado', hidden:true, fixed:true,width: 75}
      ]);
 
   var acuerdosStore = page.getStore({
        flow: 'expedienterecobro/getAcuerdosExpediente'
        ,storeId : 'acuerdosStore'
        ,reader : new Ext.data.JsonReader(
            {root:'acuerdos'}
            , acuerdo
        )
   });  
   
   var btnAltaAcuerdo = new Ext.Button({
       text:  '<s:message code="app.agregar" text="**Agregar" />'
       <app:test id="AltaAcuerdoBtn" addComa="true" />
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      	       var w = app.openWindow({
		          flow : 'expedienterecobro/abreAltaAcuerdo'
		          ,closable:false
		          ,width : 750
		          ,title : '<s:message code="recobroWeb.acuerdoExpediente.altaAcuerdo" text="**Nuevo acuerdo expediente" />'
		          ,params : {idExpediente:panel.getIdExpediente(), readOnly:"false"}
		       });
		       w.on(app.event.DONE, function(){
		          acuerdosStore.webflow({idExpediente:panel.getIdExpediente()});
		          w.close();
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
     	}
   });
   
    var btnProponerAcuerdo = new Ext.Button({
       text:  '<s:message code="acuerdos.proponer" text="**Proponer" />'
       <app:test id="btnProponerAcuerdo" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,hidden:false
       ,disabled:true
       ,handler:function(){
      	    page.webflow({
      			flow:"expedienterecobro/proponerAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStore.webflow({idExpediente:panel.getIdExpediente()});
           		 	btnProponerAcuerdo.setDisabled(true);
           		}	
	      	});
     	}
   });

    var btnCancelarAcuerdo = new Ext.Button({
       text:  '<s:message code="recobroWeb.acuerdoExpediente.cancelar" text="**Cancelar" />'
       <app:test id="btnCancelarAcuerdo" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,hidden: false
       ,disabled: true
       ,handler:function(){
      	    page.webflow({
      			flow:"expedienterecobro/cancelarAcuerdo"
      			,params:{
      				idAcuerdo:acuerdoSeleccionado
   				}
      			,success: function(){
           		 	acuerdosStore.webflow({idExpediente:panel.getIdExpediente()});
					btnCancelarAcuerdo.setDisabled(true);
           		}	
	      	});	
     	}
   });
   
    var despuesDeEditar = function(){
   		acuerdosGrid.getSelectionModel().selectRow(lineaSeleccionada);
		acuerdosGrid.fireEvent('rowclick', acuerdosGrid, lineaSeleccionada);
		acuerdosStore.on('load',despuesDeEditar);
   }
   
   var btnEditAcuerdo = new Ext.Button({
       text:  '<s:message code="app.editar" text="**Editar" />'
       <app:test id="EditAcuerdoBtn" addComa="true" />
       ,iconCls : 'icon_edit'
       ,cls: 'x-btn-text-icon'
       ,disabled:true
       ,handler:function(){
      	       var w = app.openWindow({
		          flow : 'expedienterecobro/abreEdicionAcuerdo'
		          ,closable:false
		          ,width : 750
		          ,title : '<s:message code="recobroWeb.acuerdoExpediente.altaAcuerdo" text="**Nuevo acuerdo expediente" />'
		          ,params : {idExpediente:panel.getIdExpediente(), idAcuerdo:acuerdoSeleccionado, readOnly:"false"}
		       });
		       w.on(app.event.DONE, function(){
		       	 acuerdosStore.on('load',despuesDeEditar);
		         acuerdosStore.webflow({idExpediente:panel.getIdExpediente()});
		          w.close();
		       });
		       w.on(app.event.CANCEL, function(){ w.close(); });
     	}
   });
   
   
   var acuerdosGrid = app.crearGrid(acuerdosStore,cmAcuerdos,{
         title : '<s:message code="acuerdos.grid.titulo" text="**Acuerdos" />'
         <app:test id="acuerdosGrid" addComa="true" />
         ,style : 'margin-bottom:10px;padding-right:10px'
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [ btnAltaAcuerdo
         		,btnProponerAcuerdo
         		,btnCancelarAcuerdo
	      ]
	});
	
	var lineaSeleccionada='';
	var stringContratos ='';
	
	var seleccionaRowAcuerdo = function(rec, rowIndex, e) {  
	     
		var idAcuerdo = rec.get('idAcuerdo');
		
		acuerdoSeleccionado = idAcuerdo;
		indexAcuerdoSeleccionado = rowIndex;
		tipoAcuerdoCombo.setValue(rec.get('tipoPalanca')); 
		solicitante.setValue(rec.get('solicitante')); 
		estado.setValue(rec.get('estado')); 
		importePago.setValue(rec.get('importePago')); 
		
		quita.setValue(rec.get('quita')); 
		contrato.setValue(rec.get('contratosString'));
		despacho.setValue(rec.get('despachoString')); 
		observacionesConclusion.setValue(rec.get('observaciones'));
		conclusionCombo.setValue(rec.get('conclusionTitulo'));
		observacionesTitulos.setValue(rec.get('observacionesTitulos'));
		cambioCombo.setValue(rec.get('ddAnalisisCapacidadPago'));
		aumento.setValue(rec.get('aumento'));
		obsPago=rec.get('observacionesCapacidadDePago');
		observacionesCapacidadDePago.setValue(rec.get('observacionesCapacidadDePago'));
		cambioSolvenciaCombo.setValue(rec.get('cambioSolvencia'));
		aumentoSolvencia.setValue(rec.get('aumentoSolvencia'));
		obsSolvencia =rec.get('observacionesSolvencia');
		observacionesSolvencia.setValue(rec.get('observacionesSolvencia'));
		lineaSeleccionada=rowIndex;
		
		
		if (acuerdosGrid.getSelectionModel().getSelected()!=''){
			btnEditAnalisis.setDisabled(false);
		} else {
			btnEditAnalisis.setDisabled(true);
		}
		
		//Muestro o no los botones que corresponden
		var codigoEstado = rec.get('codigoEstado');
		if (codigoEstado == app.codigoAcuerdoPropuesto){
        	btnProponerAcuerdo.setDisabled(true);
        	btnCancelarAcuerdo.setDisabled(false);
        	btnEditAcuerdo.setDisabled(false);
        	
		} 
		if (codigoEstado == app.codigoAcuerdoEnConformacion){
			btnProponerAcuerdo.setDisabled(false);
        	btnCancelarAcuerdo.setDisabled(false);
        	btnEditAcuerdo.setDisabled(false);
		}
		/*if (codigoEstado == app.codigoAcuerdoVigente){
			btnProponerAcuerdo.setDisabled(true);
        	btnCancelarAcuerdo.setDisabled(true);
        	btnEditAcuerdo.setDisabled(true);
		}*/
		if (codigoEstado == app.codigoAcuerdoVigente || codigoEstado == app.codigoAcuerdoRechazado || 
			codigoEstado == app.codigoAcuerdoCancelado || codigoEstado == app.codigoAcuerdoFinalizado ||
			codigoEstado == app.codigoAcuerdoEnviado){
			btnProponerAcuerdo.setDisabled(true);
        	btnCancelarAcuerdo.setDisabled(true);
        	btnEditAcuerdo.setDisabled(true);
		}
		
		<%--
		btnEditAcuerdo.setVisible(
			//esSupervisor  && PROPUESTO
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoPropuesto)||
			//esGestor && (PROPUESTO||VIGENTE)
			(panel.esGestor() && (codigoEstado == app.codigoAcuerdoPropuesto || codigoEstado == app.codigoAcuerdoVigente))
		);
				
		
		btnAceptarAcuerdo.setVisible(
			//esSupervisor && PROPUESTO
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoPropuesto)
		);
		
		btnRechazarAcuerdo.setVisible(
			//esSupervisor && (PROPUESTO||VIGENTE)
			(panel.esSupervisor() && (codigoEstado == app.codigoAcuerdoPropuesto || codigoEstado == app.codigoAcuerdoVigente))
		);
		
		btnIncumplirAcuerdo.setVisible(
			//esGestor && EN CONFORMACION
			(codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())||
			//esSupervisor && (VIGENTE)
			(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoVigente)
		);
		if((codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())){
			btnIncumplirAcuerdo.setText('<s:message code="acuerdos.cancelar" text="**Cancelar" />');
		}else if(panel.esSupervisor() && codigoEstado == app.codigoAcuerdoVigente){
			btnIncumplirAcuerdo.setText('<s:message code="acuerdos.incumplido" text="**Incumplido" />');
		}
		
		
		btnProponerAcuerdo.setVisible(
			//esGestor && EN CONFORMACION
			(codigoEstado == app.codigoAcuerdoEnConformacion && panel.esGestor())
		);
		
		btnCerrarAcuerdo.setVisible(
			//esSupervisor && VIGENTE
			(codigoEstado == app.codigoAcuerdoVigente && panel.esSupervisor())
		);
		
		btnCumplimientoAcuerdo.setVisible(
			codigoEstado == app.codigoAcuerdoVigente
		);
	
		 --%>
	};
	
	acuerdosGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		var rec = acuerdosGrid.getStore().getAt(rowIndex);
		seleccionaRowAcuerdo(rec, rowIndex, e);
		acuerdoTabPanel.show();
		
	});
	
	acuerdosGrid.on('rowclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		seleccionaRowAcuerdo(rec, rowIndex, e);
		acuerdoTabPanel.show();
	});
	
	
	
	<%-- pestañas de información adicional del acuerdo --%>
	
	<pfs:textfield name="tipoAcuerdoCombo" labelKey="acuerdo.conclusiones.tipoAcuerdoCombo"
		label="**Tipo Acuerdo" value="" readOnly="true" />
		
	<pfs:textfield name="solicitante" labelKey="acuerdo.conclusiones.solicitanteCombo"
		label="**Solicitante" value="" readOnly="true" />
		
	<pfs:textfield name="estado" labelKey="acuerdo.conclusiones.estadoCombo"
		label="**Estado" value="" readOnly="true" />
	 
	<%-- 
	<pfs:textfield name="contrato" labelKey="recobroWeb.acuerdoExpediente.altaAcuerdo.contrato"
		label="**Contrato" value="" readOnly="true" width="300" />
	--%>
	<pfs:textfield name="despacho" labelKey="plugin.recobroConfig.agencia.alta.despachoAgencia"
		label="**Grupo" value="" readOnly="true" />
		
	var tiposGestor_labelStyle='font-weight:bolder;width:100';
	var contrato = new Ext.ux.form.StaticTextField({
		name: 'contrato'
		,fieldLabel : '<s:message code="recobroWeb.acuerdoExpediente.altaAcuerdo.contratos" text="**Contratos" />'
		,width: 300
		,height: 100
		,labelStyle: tiposGestor_labelStyle
		,readOnly: true
	});	
	
		
	<pfs:textfield name="importePago" labelKey="acuerdo.conclusiones.importePago"
		label="**Importe pago" value="" readOnly="true" />
			
	<pfs:textfield name="quita" labelKey="recobroWeb.acuerdoExpediente.altaAcuerdo.quita"
		label="**Quita" value="" readOnly="true" />
		
	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="acuerdo.conclusiones.observaciones" text="**Observaciones" />'
		//,style:'font-weight:bolder;width:100px'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});
	var observacionesConclusion = new Ext.form.TextArea({
		width:250
		<app:test id="editObservacionesConclusion" addComa="true" />
		,maxLength:2000
		,height:200
		,labelStyle:labelStyle
		,readOnly:true
	});	
	
	var panel1 = new Ext.form.FieldSet({
		style:'padding:10px'
 		,border: false
 		,header: false
 		,headerAsText: false
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,autoWidth:true
		,title:'<s:message code="recobroWeb.acuerdoExpediente.resumenPropuesta" text="**Resumen propuesta"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:400}
		,items :[{items:[tipoAcuerdoCombo, solicitante,estado,importePago,quita,despacho,contrato, btnEditAcuerdo]} 
				,{items : [tituloobservaciones ,{items:observacionesConclusion,border:false,style:'margin-top:5px'}]} ]
	});
	
	
	
	
	<%-- PESTAÑA DE ANÁLISIS --%>
	var comboRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);

	var conclusionCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.conclusionCombo" text="**Conclusión" />'
		,value : ''
		,name : 'conclusion'
		,labelStyle:labelStyle
	});

	var observacionesTitulos = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones"/>'
		,width:250
		,labelStyle:labelStyle
		,readOnly:true
		<app:test id="observacionesTitulos" addComa="true"/>
	});

	var titulosFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.titulos" text="**Titulos"/>'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:10px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[conclusionCombo],width:300}
		 	,{items:[observacionesTitulos],width:400}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	//FIN TITULOS 
	
	
	//CAPACIDAD DE PAGO
	
	var cambioCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.cambio" text="**Cambio" />'
		,value : ''
		,name : 'cambioCombo'
		,labelStyle:labelStyle
	});
	
	var aumento = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.aumento" text="**Aumento" />'
		,value : '${acuerdo.analisisAcuerdo.ddAnalisisCapacidadPago.descripcion}'
		,name : 'aumento'
		,labelStyle:labelStyle
	});

	var observacionesCapacidadDePago = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones"/>'
		,width:250
		,readOnly:true
		,labelStyle:labelStyle
		<app:test id="observacionesCapPago" addComa="true"/>
	});

	var capacidadDePagoFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.capacidadDePago" text="**Capacidad de Pago"/>'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:10px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[cambioCombo, aumento],width:300}
		 	,{items:[observacionesCapacidadDePago],width:400}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	//FIN CAPACIDAD DE PAGO
		
	//SOLVENCIA
		
	var cambioSolvenciaCombo= new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.cambio" text="**Cambio" />'
		,value : ''
		,name : 'cambioSolvenciaCombo'
		,labelStyle:labelStyle
	});
	
	var aumentoSolvencia = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.aumento" text="**Aumento" />'
		,value : ''
		,name : 'aumentoSolvencia'
		,labelStyle:labelStyle
	});
	

	var observacionesSolvencia = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones"/>'
		,width:250
		,readOnly:true
		,labelStyle:labelStyle
		<app:test id="observacionesSolvencia" addComa="true"/>
	});
	
	var btnEditAnalisis = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="btnEditAnalisis" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,disabled: true
	       ,handler:function(){
	      	       var w = app.openWindow({
		              title:'<s:message code="acuerdos.actuaciones.analisis" text="**Analisis"/>'
			          ,flow : 'acuerdos/editaAnalisisAcuerdo'
			          ,closable:false
					  ,width:450
			          ,params : {idAcuerdo:acuerdoSeleccionado, readOnly:"false"}
			       });
			       w.on(app.event.DONE, function(){
			          	acuerdosStore.on('load',despuesDeEditar);
		         		acuerdosStore.webflow({idExpediente:panel.getIdExpediente()});
		          		w.close();          		          
			       });
			       w.on(app.event.CANCEL, function(){ w.close(); });
	     	}
	    });

	var solvenciaFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.solvencia" text="**Solvencia"/>'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:10px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[cambioSolvenciaCombo, aumentoSolvencia, btnEditAnalisis],width:300}
		 	,{items:[observacionesSolvencia],width:400}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	//FIN SOLVENCIA
		
	    
	var analisis = new Ext.form.FieldSet({
		style:'padding:5px'
 		,border: false
 		,header: false
 		,headerAsText: false
		,layout : 'table'
		,layoutConfig:{
			columns:1
		}
		,autoWidth:true
		,title:'<s:message code="acuerdos.actuaciones.analisis" text="**Analisis"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:310}
		,items :[
		 	titulosFieldSet,capacidadDePagoFieldSet, solvenciaFieldSet
		]
	});    
	
	var acuerdoTabPanel = new Ext.TabPanel({
	items:[
		panel1
		,analisis
	]
	,height : 400
	,border: true
  	});
  	acuerdoTabPanel.setActiveTab(panel1);
	panel.add(acuerdosGrid);
	panel.add(acuerdoTabPanel);
	
	

	panel.getData = function(id){
   		var parts = id.split(".");
   		var result=entidad.get("data");
   		for(var i=0;i< parts.length;i++){
    		result=result[parts[i]];
   		}
   		return result;
  	};
  
  	panel.getValue = function(){};
  	panel.setValue = function(){
	    var data = entidad.get("data");
	    acuerdosStore.webflow({idExpediente : data.id });
	    if (data.esSupervisor || data.esAgencia){
	    	btnProponerAcuerdo.setVisible(true);
        	btnCancelarAcuerdo.setVisible(true);
        	btnEditAcuerdo.setVisible(true);
        	btnAltaAcuerdo.setVisible(true);
        	btnEditAnalisis.setVisible(true);
	    } else {
	    	btnProponerAcuerdo.setVisible(false);
        	btnCancelarAcuerdo.setVisible(false);
        	btnEditAcuerdo.setVisible(false);
        	btnAltaAcuerdo.setVisible(false);
        	btnEditAnalisis.setVisible(false);
	    }
	    acuerdoTabPanel.hide();
  	};
  	
	panel.getIdExpediente = function(){
		return entidad.get("data").id;
	}
	
	panel.getEsSupervisor= function(){
		return entidad.get("data").esSupervisor;
	}
	panel.getEsAgencia= function(){
		return entidad.get("data").esAgencia;
	}
	
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente == 'REC';
 	 }
  
	return panel;
})		 
   