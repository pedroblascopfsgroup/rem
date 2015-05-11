<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
(function(){
	
	var bienes = {bienes :[
		{codigo:'1',tipobien:'Inmueble',descripcion:'Apartamento Playa',valor:'30000',cargas:'15000',refcatastral:'ERHR634',superficie:'500',poblacion:'Puig',datosregistrales:'5-6-8-4',participacion:'50%',titular:'Juan Garriguez',tipocarga:'Carga1',importe:'4000',letra:'A',demandante:'Entidad'}
		,{participacion:'50%',titular:'Jorge Corona',tipocarga:'Carga2',importe:'146000',letra:'A',demandante:'Entidad'}
		,{codigo:'2',tipobien:'Inmueble',descripcion:'Chalet',valor:'33333000',cargas:'550000',refcatastral:'ERHR634',superficie:'15000',poblacion:'Laferrere',datosregistrales:'1-2-3-500',participacion:'100%',titular:'Lopez Cuerda',tipocarga:'Carga3',importe:'550000',letra:'B',demandante:'Terceros'}
	]};
	
	var bienesStore = new Ext.data.JsonStore({
		data : bienes
		,root : 'bienes'
		,fields : ['codigo','tipobien','descripcion','participacion','valor','cargas','refcatastral','superficie','poblacion','datosregistrales','participacion','titular']
	});
	
	var bienesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="bienes.codigo" text="**Codigo"/>', dataIndex : 'codigo' }
		,{header : '<s:message code="bienes.tipo" text="**Tipo Bien"/>', dataIndex : 'tipobien' }
		,{header : '<s:message code="bienes.descripcion" text="**Bien"/>', dataIndex : 'descripcion' }
		,{header : '<s:message code="bienes.valor" text="**valor"/>', dataIndex : 'valor' ,align:'right'}
		,{header : '<s:message code="bienes.cargas" text="**Cargas"/>', dataIndex : 'cargas',align:'right' }
		,{header : '<s:message code="bienes.refcatastral" text="**Ref. Catastral"/>', dataIndex : 'refcatastral' }
		,{header : '<s:message code="bienes.superficie" text="**Superficie(m2)"/>', dataIndex : 'superficie',align:'right' }
		,{header : '<s:message code="bienes.poblacion" text="**Poblacion"/>', dataIndex : 'poblacion' }
		,{header : '<s:message code="bienes.datosregistrales" text="**Datos Registrales"/>', dataIndex : 'datosregistrales' }
		,{header : '<s:message code="bienes.participacion" text="**Participacion"/>', dataIndex : 'participacion',align:'right' }
		,{header : '<s:message code="bienes.titular" text="**Titular"/>', dataIndex : 'titular' }
	]);
	
	var bienesGrid = app.crearGrid(bienesStore,bienesCm,{
		title:'<s:message code="bienes.title" text="**bienes"/>'
		,style:'padding-right:10px'
		,iconCls:'icon_bienes'
		//,width : 700
		,height : 200
	});
	
	var cargaBienesStore = new Ext.data.JsonStore({
		data : bienes
		,root : 'bienes'
		,fields : ['codigo','tipobien','descripcion','tipocarga','importe','letra','demandante']
	});
	var cargasBienesCm= new Ext.grid.ColumnModel([
		{header : '<s:message code="bienes.codigo" text="**Codigo"/>', dataIndex : 'codigo' }
		,{header : '<s:message code="bienes.tipo" text="**Tipo Bien"/>', dataIndex : 'tipobien' }
		,{header : '<s:message code="bienes.descripcion" text="**Descripcion"/>', dataIndex : 'descripcion' }
		,{header : '<s:message code="bienes.tipocarga" text="**Tipo Carga"/>', dataIndex : 'tipocarga' }
		,{header : '<s:message code="bienes.importe" text="**Importe"/>', dataIndex : 'importe' }
		,{header : '<s:message code="bienes.letra" text="**Letra"/>', dataIndex : 'letra' }
		,{header : '<s:message code="bienes.demandante" text="**Demandante"/>', dataIndex : 'demandante' }
	]);
	var btnAgregarCargas = app.crearBotonAgregar({
		text:'<s:message code="" text="**Agregar Carga" />'
		,title:'<s:message code="" text="**Alta Carga Bienes" />'
		,flow:'fase2/bienes/cargasBienes'
		,closable:true
		,width:400
	});
	var btnEditarCargas = app.crearBotonEditar({
		text:'<s:message code="" text="**Editar Carga" />'
		,title:'<s:message code="" text="**Edicion Carga Bienes" />'
		,flow:'fase2/bienes/cargasBienes'
		,closable:true
		,width:400
	});
	var cargaBienesGrid=new Ext.grid.GridPanel({
		title:'<s:message code="cargabienes.title" text="**Cargas de los Bienes"/>'
		,cm:cargasBienesCm
		,store:cargaBienesStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,style:'padding-top:10px'
		,viewConfig:{forceFit:true}
		,width:500
		,height:150
		,iconCls:'icon_bienes'
		,bbar:[btnAgregarCargas,btnEditarCargas]
	});
	
	var panel = new Ext.Panel({
		title:'<s:message code="bienes.title" text="**Bienes"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[bienesGrid,cargaBienesGrid]
		,nombreTab : 'tabBienesAsunto'
	});
		
	return panel;
})()
