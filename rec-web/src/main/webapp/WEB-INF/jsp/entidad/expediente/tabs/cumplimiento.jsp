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
	
	var limit = 20;
	var labelStyle = 'width:150px;font-weight:bolder';
	
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
	            record.set(this.dataIndex, !record.data[this.dataIndex]);
	        }
	    },
	    renderer : function(v, p, record){
	        p.css += ' x-grid3-check-col-td'; 
	        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    }
	};

	// *********************************** //
	// * Definimos el fieldset superior  * //
	// *********************************** //
	
	var estadoActualString = '';
	var estadoSiguienteString = '';
	
	function label(id,text){
		return app.creaLabel(text,"",  {id:'entidad-expediente-'+id});
	}
	 
	 var fechaPase		 = label('fechaPase', '<s:message code="expediente.nivelCumplimiento.fechaPase" text="**Fecha Pase"/>',{labelStyle:labelStyle});
	 var estadoActual	 = label('estadoActual', '<s:message code="expediente.nivelCumplimiento.estadoActual" text="**Estado Actual"/>',{labelStyle:labelStyle});
	 var estadoSiguiente = label('estadoSiguiente', '<s:message code="expediente.nivelCumplimiento.estadoSiguiente" text="**Estado Siguiente"/>',{labelStyle:labelStyle});
	 var preparadoPase   = label('preparadoPase', '<s:message code="expediente.nivelCumplimiento.preparadoPase" text="**¿Preparado para Pase?"/>',{labelStyle:labelStyle});

	var btnRefrescar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrescar" />'
		,style:'margin-left:250px;'
		,border:false
		,iconCls : 'icon_refresh'
		,cls: 'x-btn-text-icon'
		,handler:function(){
			entidad.refrescar();
		}
	});	
	
	var fieldsetEstado = new Ext.form.FieldSet({
		title:'<s:message code="expediente.nivelCumplimiento.estadoParaPase" text="**Estado para pase"/>'
		,border : true
		,hideBorders:false
		,autoHeight:true
		,width:780
		,items:[{
			layout : 'table'
			,border : false
			,layoutConfig:{
				columns:2				
			}
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px;'}		
			,items:[
				{items:[estadoActual,fechaPase,{html:'&nbsp;',border:false,height:20}], width:390}
				,{items:[estadoSiguiente, preparadoPase, btnRefrescar], bodyStyle : 'padding-left:15px', width:390}
				] 
		}]
	});

	// *********************************** //
	// * Definimos tabla general         * //
	// *********************************** //
	
	var NivelCumplimiento = Ext.data.Record.create([
        {name:'idNivelCumplimiento'}
		,{name:'bCumple'}
        ,{name:'descripcionRegla'}
        ,{name:'descripcionAmbito'}
    ]);
	
    var nivelCumplimientoStore = page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,flow:'expedientes/listadoNivelCumplimiento'
		,storeId: 'StoreIdNivelCumplimientoStore'
        ,reader: new Ext.data.JsonReader({
            root: 'nivelCumplimiento'
            ,totalProperty : 'total'
        }, NivelCumplimiento)
    });
	
	var nivelCumplimientoCM = new Ext.grid.ColumnModel([
		{header:'<s:message code="expediente.nivelCumplimiento.nivelCumplimientoGrid.cumple" text="**Cumple" />', width:50, dataIndex :'bCumple', renderer : app.format.trueFalseRenderer} 
	    ,{header: '<s:message code="expediente.nivelCumplimiento.nivelCumplimientoGrid.regla" text="**Regla" />', width: 200, sortable: true, dataIndex: 'descripcionRegla'}
	    ,{header: '<s:message code="expediente.nivelCumplimiento.nivelCumplimientoGrid.ambito" text="**Ámbito" />', width: 300, sortable: true, dataIndex: 'descripcionAmbito',hidden:true}
	]);

    var nivelCumplimientoGrid=app.crearGrid(nivelCumplimientoStore,nivelCumplimientoCM,{
        title:'<s:message code="expediente.nivelCumplimiento.nivelCumplimientoGrid.titulo" text="**Nivel de Cumplimiento"/>'
        <app:test id="nivelCumplimientoGrid" addComa="true" />
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,height : 140
        ,cls:'cursor_pointer'
    });	
    
	nivelCumplimientoGrid.on('rowclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var idNivelCumplimiento = rec.get('idNivelCumplimiento');
		
		personasContratoStore.webflow({idReglaElevacion:idNivelCumplimiento,idExpediente:getIdExpediente()});
	});	
	
	
	//Cada vez que cargue se revisa si cumple todas las reglas o no
	nivelCumplimientoStore.on('load', function(){
		var resultado = true;
		
		for (var i=0; i < nivelCumplimientoStore.getCount(); i++)
		{
			var rec = nivelCumplimientoStore.getAt(i);
			var cumple = rec.get('bCumple');
			if (cumple == false || cumple == 'false') 
			{
				resultado = false;
				break;
			}
		}
		
		if (resultado) preparadoPase.setValue('Si');
		else preparadoPase.setValue('No');
	});
	
	// *********************************** //
	// * Definimos tabla específica      * //
	// *********************************** //

	var PersonasContrato = Ext.data.Record.create([
        {name:'bCumple'}
		,{name:'nombre'}
		,{name:'idPersona'}
		,{name:'apellidoNombre'}
        ,{name:'tipo'}
        ,{name:'bPase'}
        ,{name:'idContrato'}
        ,{name:'tipoObjetoEntidad'}
    ]);
	
    var personasContratoStore = page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,flow:'expedientes/listadoNivelCumplimientoEspecifico'
		,storeId: 'StoreIdPersonasContratoStore'
        ,reader: new Ext.data.JsonReader({
            root: 'personasContrato'
            ,totalProperty : 'total'
        }, PersonasContrato)
    });

	var checkColumnNivelCumplimientoEntidad = new Ext.grid.CheckColumn({
		header : '<s:message code="expediente.nivelCumplimiento.personasContratoGrid.cumple" text="**Cumple" />'
		,width: 50
		,dataIndex : 'bCumple'
	});

	var personasContratoCM = new Ext.grid.ColumnModel([
		{header:'<s:message code="expediente.nivelCumplimiento.personasContratoGrid.cumple" text="**Cumple" />', width:50, dataIndex :'bCumple', renderer : app.format.trueFalseRenderer}
	    ,{header: '<s:message code="expediente.nivelCumplimiento.personasContratoGrid.nombre" text="**Persona/Contrato" />', width: 300, sortable: true, dataIndex: 'nombre'}
	    ,{header: '<s:message code="expediente.nivelCumplimiento.personasContratoGrid.tipo" text="**Tipo" />', width: 200, sortable: true, dataIndex: 'tipo'}
	    ,{header: '<s:message code="expediente.nivelCumplimiento.personasContratoGrid.pase" text="**Pase" />', dataIndex : 'bPase', id: 'bPase'}
	]);

    var personasContratoGrid=app.crearGrid(personasContratoStore,personasContratoCM,{
        title:'<s:message code="expediente.nivelCumplimiento.personasContratoGrid.titulo" text="**Personas/Contratos de la regla que deben cumplirlo"/>'
        <app:test id="nivelCumplimientoGrid" addComa="true" />
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,height : 140
        ,cls:'cursor_pointer'
    });	

	personasContratoGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		if(rec.get('tipoObjetoEntidad')=='<fwk:const value="es.capgemini.pfs.expediente.ObjetoEntidadRegla.TIPO_PERSONA" />'){
			//es una persona
			var id = rec.get('idPersona');
    		var nombre_cliente=rec.get('apellidoNombre');
    		app.abreCliente(id, nombre_cliente);	
		}
		if(rec.get('tipoObjetoEntidad')=='<fwk:const value="es.capgemini.pfs.expediente.ObjetoEntidadRegla.TIPO_CONTRATO" />'){
			//es un contrato
			var id = rec.get('idContrato');
    		var nombre_contrato=rec.get('nombre');
    		app.abreContrato(id, nombre_contrato);	
		}	
	});

	// *********************************** //
	// * Definimos el panel              * //
	// *********************************** //

	var panel = new Ext.Panel({
		title : '<s:message code="expediente.nivelCumplimiento.tituloTab" text="**Criterios para Pase" />'
		,autoHeight: true
		,items : [
				{items:[fieldsetEstado],border:false,style:'padding:5px;margin-top: 7px; margin-left:5px'}
				,{items:[nivelCumplimientoGrid],border:false,style:'padding:5px;margin-left:5px'}
				,{items:[personasContratoGrid],border:false,style:'padding:5px;padding-top:1px;padding-bottom:1px;margin-left:5px'}
			] 
		,nombreTab : 'nivelCumplimiento'
	});

	function getCodEstadoItinerario () {return entidad.get("data").gestion.estadoItinerario}	
	
	function getIdExpediente () {return entidad.get("data").id;}	
	
	function getEstadoActualString () {
		var codigoCE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE" />';
		var codigoRE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE" />';
		var codigoDC = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_DECISION_COMIT" />';
		var codigoENSAN = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION" />';
		var codigoSANC = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO" />';
		var estadoExpediente = entidad.get("data").gestion.estadoItinerario;
		if (estadoExpediente == codigoCE){
			return ('Completar Expediente');
		}else if (estadoExpediente == codigoRE)	{
			return ('Revisar Expediente');
		}else if (estadoExpediente == codigoDC)	{
			return ('Decisión de Comité');
		}else if (estadoExpediente == codigoENSAN)	{
			return ('En Sanción');
		}else if (estadoExpediente == codigoSANC)	{
			return ('Sancionado');
		}
		return estadoExpediente;
	}
	
	function getEstadoSiguienteString () {
		var codigoCE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE" />';
		var codigoRE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE" />';
		var codigoDC = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_DECISION_COMIT" />';
		var codigoFP = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA" />';
		var codigoENSAN = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION" />';
		var estadoExpediente = entidad.get("data").gestion.estadoItinerario;
		if (estadoExpediente == codigoCE){
			return ('Revisar Expediente');
		}else if (estadoExpediente == codigoRE)	{
			if(entidad.get("data").toolbar.tipoExpediente == 'GESDEU'){
				return ('En Sanción');
			}else{
				return ('Decisión de Comité');
			}
		}else if (estadoExpediente == codigoDC){
			return ('Formalizar Propuesta');
		}else if (estadoExpediente == codigoFP){
			return ('Decisión de Comité');
		}else if (estadoExpediente == codigoENSAN)	{
			return ('Sancionado');
		}
		return '';
	}

	panel.getValue = function(){ 
		var estado = entidad.get("nivelCumplimiento");
		rowsSelected = nivelCumplimientoGrid.getSelectionModel().getSelections();
		if (rowsSelected != ''){
			return { 
				idNivelCumplimiento : rowsSelected[0].get('idNivelCumplimiento')
			}
		} else {
			if (estado){
				return { 
					idNivelCumplimiento : estado.idNivelCumplimiento
				}
			}
		}
	}
	
	panel.setValue = function(){

		var data= entidad.get("data");

		entidad.setLabel('fechaPase', data.toolbar.fechaVencimiento);
		entidad.setLabel('estadoActual', getEstadoActualString());
		entidad.setLabel('estadoSiguiente', getEstadoSiguienteString());
		
		entidad.cacheOrLoad(data, nivelCumplimientoStore, {idExpediente:entidad.get("data").id});
		
		var estado = entidad.get("nivelCumplimiento");
		if (estado){
			entidad.cacheOrLoad(data, personasContratoStore, {idReglaElevacion:estado.idNivelCumplimiento, idExpediente:entidad.get("data").id});	
		} else {
			// vaciar el grid
			personasContratoGrid.store.removeAll();
		}
		
		//Cada vez que cargue se revisa si cumple todas las reglas o no
		if(nivelCumplimientoStore.getCount() > 0){
			var resultado = true;
			for (var i=0; i < nivelCumplimientoStore.getCount(); i++){
				var rec = nivelCumplimientoStore.getAt(i);
				var cumple = rec.get('bCumple');
				if (cumple == false || cumple == 'false') {
					resultado = false;
					break;
				}
			}
			if (resultado) entidad.setLabel('preparadoPase', 'Si');
			else entidad.setLabel('preparadoPase', 'No');
		}

	}
	
	entidad.cacheStore(nivelCumplimientoStore);
	entidad.cacheStore(personasContratoStore);

	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
    }
    	
	return panel;

})
