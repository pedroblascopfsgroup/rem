<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){
	
	var limit = 20;
	var labelStyle = 'width:150px;font-weight:bolder';
	
	Ext.grid.CheckColumn = function(config){
    	Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
			}
	    this.renderer = this.renderer.createDelegate(this);
	};	

	Ext.grid.CheckColumn.prototype ={
    	init : function(grid){
        	this.grid = grid;
        	this.grid.on('render', function(){
        	    var view = this.grid.getView();
        	}, this);
    	},
    	
	    renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
	       	return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'"> </div>';
	   	}
	};	
	
	
	
	// *********************************** //
	// * Definimos el fieldset superior  * //
	// *********************************** //
	

	var codigoCE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE" />';
	var codigoRE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE" />';
	var codigoDC = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_DECISION_COMIT" />';
			
	var estadoExpediente = '${expediente.estadoItinerario.codigo}';
	var estadoActualString = '';
	var estadoSiguienteString = '';
	
	if (estadoExpediente == codigoCE)
	{
		estadoActualString = 'Completar Expediente';
		estadoSiguienteString = 'Revisar Expediente';
	}
	else if (estadoExpediente == codigoRE)
	{
		estadoActualString = 'Revisar Expediente';
		estadoSiguienteString = 'Decisión de Comité';
	}
	else if (estadoExpediente == codigoDC)
	{
		estadoActualString = 'Decisión de Comité';
	}
	

	var estadoActual = app.creaLabel('<s:message code="expediente.nivelCumplimiento.estadoActual" text="**Estado Actual"/>',estadoActualString,{labelStyle:labelStyle});
	var estadoSiguiente = app.creaLabel('<s:message code="expediente.nivelCumplimiento.estadoSiguiente" text="**Estado Siguiente"/>',estadoSiguienteString,{labelStyle:labelStyle});
	var fechaPase = app.creaLabel('<s:message code="expediente.nivelCumplimiento.fechaPase" text="**Fecha Pase"/>',"<fwk:date value='${expediente.fechaVencimiento}'/>",{labelStyle:labelStyle});
	var preparadoPase = app.creaLabel('<s:message code="expediente.nivelCumplimiento.preparadoPase" text="**¿Preparado para Pase?"/>','No',{labelStyle:labelStyle});
	
	
	var btnRefrescar = new Ext.Button({
           	text: '<s:message code="app.refrezcar" text="**Refrescar" />'
           	,style:'margin-left:250px;'
           	,border:false
           	,iconCls : 'icon_refresh'
			,cls: 'x-btn-text-icon'
           	,handler:function(){
				nivelCumplimientoStore.webflow({idExpediente:${expediente.id}});
         }
	});	
	
	
	
	var fieldsetEstado = new Ext.form.FieldSet({
		title:'<s:message code="expediente.nivelCumplimiento.estadoParaPase" text="**Estado para pase"/>'
		,border : true
		,hideBorders:false
		//,height:95
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
				,{items:[estadoSiguiente, preparadoPase, btnRefrescar], bodyStyle : 'padding-left:15px', width:390}]
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
    
    nivelCumplimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
    	var rec = grid.getStore().getAt(rowIndex);
    	console.log(rec.get('descripcionRegla'));
    	if(rec.get('descripcionRegla')=='Seleccionar propuesta de actuación'){
    		console.log('dentro');
    		console.log(getIdExpediente());
    		console.log(entidad.get("data").cabecera.descripcion);
    		app.abreExpedienteTab(getIdExpediente(), entidad.get("data").cabecera.descripcion, 'acuerdos');
		}
    });


	nivelCumplimientoStore.webflow({idExpediente:${expediente.id}});
	
	nivelCumplimientoGrid.on('rowclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var idNivelCumplimiento = rec.get('idNivelCumplimiento');
		personasContratoStore.webflow({idReglaElevacion:idNivelCumplimiento,idExpediente:${expediente.id}});
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
		//checkColumnNivelCumplimientoEntidad
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
    		app.abreClienteTab(id, nombre_cliente, 'politicaPanel');	
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

	return panel;
})()
