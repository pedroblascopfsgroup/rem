<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
(function(){

	var procurador='${asunto.procurador}';

	var labelStyle='font-weight:bolder;width:150px';
	var asunto=app.creaLabel('<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>','<s:message text="${asunto.nombre}" javaScriptEscape="true" />',{labelStyle:labelStyle});
	var codigoAsunto=app.creaLabel('<s:message code="asuntos.listado.codigo" text="**Codigo"/>','${asunto.id}',{labelStyle:labelStyle});
	var fecha=app.creaLabel('<s:message code="asunto.tabcabecera.fechaconformacion" text="**Fecha Conformacion"/>',"<fwk:date value='${asunto.auditoria.fechaCrear}' />",{labelStyle:labelStyle});
	var estado=app.creaLabel('<s:message code="asunto.tabcabecera.estado" text="**Estado"/>','${asunto.estadoAsunto.descripcion}',{labelStyle:labelStyle});
	var despacho=app.creaLabel('<s:message code="asunto.tabcabecera.despacho" text="**Despacho"/>','${asunto.gestor.despachoExterno.despacho}',{labelStyle:labelStyle});
	var gestor=app.creaLabel('<s:message code="asunto.tabcabecera.gestor" text="**Gestor"/>','${asunto.gestor.usuario.apellidoNombre}' ,{labelStyle:labelStyle});
	var supervisor=app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>','${asunto.supervisor.usuario.apellidoNombre}',{labelStyle:labelStyle});
	var procurador=app.creaLabel('<s:message code="asunto.tabcabecera.procurador" text="**procurador"/>','${asunto.procurador.usuario.apellidoNombre}',{labelStyle:labelStyle});
	var expediente = app.creaLabel('<s:message code="expedientes.consulta.titulo" text="**Expediente"/>','<s:message text="${asunto.expediente.descripcionExpediente}" javaScriptEscape="true" />',{labelStyle:labelStyle});
	
	var nombreComite = '';
	<c:if test="${asunto.comite != null}">
		nombreComite = '${asunto.comite.nombre}';
	</c:if>

	var comite = app.creaLabel('<s:message code="comite.edicion.comite" text="**Comite"/>',nombreComite,{labelStyle:labelStyle});
	
		var DatosFieldSet = new Ext.form.FieldSet({
		autoHeight:'false'
		,style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,width:785
		,title:'<s:message code="asunto.tabcabecera.fieldset.titulo" text="**Datos Principales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
				  
				  { items:[ asunto,codigoAsunto,fecha,estado,expediente]}
					,{ items:[ despacho,gestor,supervisor,procurador,comite]}
		 	 
		]
	});	
	 var procedimiento = Ext.data.Record.create([
         'id'
		 ,'nombre'
		 ,'tipoProcedimiento'
		 ,{name:'saldoARecuperar',sortType:Ext.data.SortTypes.asInt}
		 ,'tipoReclamacion'
		 ,'pVencido'
		 ,'pNoVencido'
		 ,'porcRecup'
		 ,'meses'
		 ,'estado'
		 ,'nivel'
		 ,'procedimientoPadre'
		 ,'demandados'
		 ,'descripcionProcedimiento'
		 ,{name:'fechaInicio',type:'date', dateFormat:'d/m/Y'}
		 ,'codProcEnJuzgado'
      ]);

   var procedimientosStore = page.getStore({
      flow:'asuntos/listadoActuacionesAsunto'
      ,reader: new Ext.data.JsonReader({
        root : 'listado'
      } , procedimiento)
     });
     
   procedimientosStore.webflow({id:'${asunto.id}'});
		
	var nivelRenderer=function(val){
		if(!val && val !=0)return;
		var str="";
		for(i=1;i<=val;i++){
			str +='-';
		}
		str +=val!=0?'> ':''; 
		return str + val;
	}


	var procedimientosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="asunto.tabcabecera.grid.numero" text="**Numero" />',dataIndex : 'id' ,width:52}
		,{header : '<s:message code="asunto.tabcabecera.grid.nombre" text="**Nombre"/>', dataIndex : 'nombre' }
		,{header : '<s:message code="asunto.tabcabecera.grid.tipoprocedimiento" text="**tipo procedimiento"/>', dataIndex : 'tipoProcedimiento'}
		,{header : '<s:message code="asunto.tabcabecera.grid.saldoARecuperar" text="**Saldo a recuperar"/>', dataIndex : 'saldoARecuperar',renderer: app.format.moneyRenderer,align:'right',width:82}
		,{header : '<s:message code="asunto.tabcabecera.grid.tiporeclamacion" text="**tipo reclamacion"/>', dataIndex : 'tipoReclamacion',hidden:true }
		,{header : '<s:message code="asunto.tabcabecera.grid.fechainicio" text="**fecha inicio"/>', dataIndex : 'fechaInicio',renderer:app.format.dateRenderer,width:65}
		,{header : '<s:message code="asunto.tabcabecera.grid.saldovencido" text="**P. Vencido"/>', dataIndex : 'pVencido',renderer: app.format.moneyRenderer,align:'right',hidden:true,width:90}
		,{header : '<s:message code="asunto.tabcabecera.grid.saldonovencido" text="**P. No Vencido"/>', dataIndex : 'pNoVencido',renderer: app.format.moneyRenderer,align:'right',hidden:true,width:90}
		,{header : '<s:message code="asunto.tabcabecera.grid.recuperacion" text="**recuperacion %"/>', dataIndex : 'porcRecup',align:'right' ,hidden:true}
		,{header : '<s:message code="asunto.tabcabecera.grid.meses" text="**Meses recuperacion"/>', dataIndex : 'meses',align:'right' ,hidden:true}
		,{header : '<s:message code="asunto.tabcabecera.grid.procedimientoPadre" text="**Procedimiento Padre"/>', dataIndex : 'procedimientoPadre',align:'right',hidden:true }
		,{header : '<s:message code="asunto.tabcabecera.grid.nroprocjuzgado" text="**Nro Proc Juzgado"/>', dataIndex : 'codProcEnJuzgado' ,width:65}
		,{header : '<s:message code="asunto.tabcabecera.grid.estado" text="**Estado"/>', dataIndex : 'estado' ,width:65}
				,{header : '<s:message code="asunto.tabcabecera.grid.demandados" text="**Demandados"/>', dataIndex : 'demandados' ,width:120}
	]);
	
	var procedimientosGrid = app.crearGrid(procedimientosStore,procedimientosCm,{
		title:'<s:message code="asunto.tabcabecera.grid.titulo" text="**Procedimientos"/>'
		<app:test id="procedimientosGrid" addComa="true" />
		,width : 770
		,iconCls:'icon_procedimiento'
		,style:'padding-right: 5px'
		,cls:'cursor_pointer'
		,height : 250
	});
	
	
	
	
	procedimientosGrid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	//var nombre_procedimiento='<s:message text="${asunto.nombre}" javaScriptEscape="true" />'+'-'+rec.get('tipoProcedimiento');
    	var nombre_procedimiento=rec.get('nombre');
    	var id=rec.get('id');
    	if (id != null && id != ''){
    		app.abreProcedimiento(id, nombre_procedimiento);
    	}
    });
	
	var panel = new Ext.Panel({
		title:'<s:message code="asunto.tabcabecera.titulo" text="**Cabecera"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[
				DatosFieldSet
				,procedimientosGrid
			]
		,nombreTab : 'cabeceraAsunto'
	});
	return panel;
})()
