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

	var smAdjudicacion = new Ext.grid.CheckboxSelectionModel({
		checkOnly : true
		,singleSelect: false
        ,listeners: {
            selectionchange: function(sel) {
            	var seleccionados = sel.getCount(); 
               	btnAbreAdjudicacion.setDisabled(!seleccionados);               	
            }
         }
		,renderer : function(v,p,record) {
			//if (record.data.codigo == '1') {
				return '<div class="x-grid3-row-checker">&nbsp;</div>';
			//} else {
//				return '';
	//		}
		}
	});
	
	var smPosesion = new Ext.grid.CheckboxSelectionModel({
		checkOnly : true
		,singleSelect: false
        ,listeners: {
            selectionchange: function(sel) {
            	var seleccionados = sel.getCount(); 
               	btnAbrePosesion.setDisabled(!seleccionados);               	
            }
         }
		,renderer : function(v,p,record) {
				return '<div class="x-grid3-row-checker">&nbsp;</div>';
		}
	});
	
	var smSaneamiento = new Ext.grid.CheckboxSelectionModel({
		checkOnly : true
		,singleSelect: false
        ,listeners: {
            selectionchange: function(sel) {
            	var seleccionados = sel.getCount(); 
               	btnAbreSaneamiento.setDisabled(!seleccionados);               	
            }
         }
		,renderer : function(v,p,record) {
				return '<div class="x-grid3-row-checker">&nbsp;</div>';
		}
	});
	
	var smLlaves = new Ext.grid.CheckboxSelectionModel({
		checkOnly : true
		,singleSelect: false
        ,listeners: {
            selectionchange: function(sel) {
            	var seleccionados = sel.getCount(); 
               	btnAbreLlaves.setDisabled(!seleccionados);               	
            }
         }
		,renderer : function(v,p,record) {
				return '<div class="x-grid3-row-checker">&nbsp;</div>';
		}
	});
	
	//INICIO CHECK
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
	        //if (record.data.codigo == "8012787") {
	        //	return '';
	        //} else { 
	        	return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	        // }
	    }
	};  
	
	var checkColumnAdjudicado = new Ext.grid.CheckColumn({
	    header : '<s:message code="subastas.agregarExcluirBien.grid.seleccionar" text="**Seleccionar"/>'
	    ,dataIndex:'incluidoAdjudicado'});

	//FIN CHECK
	var checkColumnPosesion = new Ext.grid.CheckColumn({
	    header : '<s:message code="subastas.agregarExcluirBien.grid.seleccionar" text="**Seleccionar"/>'
	    ,dataIndex:'incluidoPosesion'});
	//CHECK2

	var colorFondo = 'background-color: #473729;';
	var idSubasta;
	var idAsunto;
	var data;
	
	var panel = new Ext.Panel({
		title: '<s:message code="plugin.nuevoModeloBienes.adjudicados.tabTitle" text="**Adjudicados" />'
		,autoHeight: true
		,nombreTab : 'tabAdjudicaciones'			
	});

	panel.getAsuntoId = function(){ return entidad.get("data").id; }
	
	//DICCIONARIOS
<%-- 	
	var diccionarioRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'descripcion'}
	]);

	var sinoStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'sinoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	sinoStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo' });
	 
	var fondoStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'fondoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	fondoStore.webflow({diccionario: 'es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo' });
	
	var origenStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'origenStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	origenStore.webflow({diccionario: 'es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien' });
	
	
	var entidadStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'entidadStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	entidadStore.webflow({diccionario: 'es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria' });
	
	var resolucionStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'resolucionStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	resolucionStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDFavorable' });
	
	var situacionStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'situacionStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	situacionStore.webflow({diccionario: 'es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionTitulo' });
	
	
	var Gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	
	var optionsGestoresStore =  page.getStore({
	       flow: 'editbien/getListUsuariosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, Gestor)	       
	});
	
	var gestoresCombo = new Ext.form.ComboBox( {
                            typeAhead : true,
                            triggerAction : 'all',
                            listClass : 'x-combo-list-small',
                            mode: 'local',
                            store: optionsGestoresStore,
                            displayField: 'username',
                            valueField: 'id'
                        })
	
	optionsGestoresStore.webflow();
	--%>
	//RENDERERS

	var OK_KO_Render = function (value, meta, record) {
		if (value) {
			return '<img src="/pfs/css/true.gif" height="16" width="16" alt=""/>';
		} else {
			return '<img src="/pfs/css/false.gif" height="16" width="16" alt=""/>';
		}
	};
	
	var SI_NO_Render = function (value, meta, record) {
		if (value=='Sí' ) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		} 
		if (value=='NO' ) {
			return '<s:message code="label.no" text="**No;" />';
		}
		if (value=='1' ) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		} if (value=='2' ) {
			return '<s:message code="label.no" text="**No;" />';
		}
		if (value=='01' ) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		} if (value=='02' ) {
			return '<s:message code="label.no" text="**No;" />';
		}if (value==true ) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		}
		if (Ext.isEmpty(value)){
			return '<s:message code="" text="--" />';
		}
		else {
			return '<s:message code="label.no" text="**No" />';
		}
		
	};

	var marcadoBienesRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'numeroActivo'}
		,{name : 'origen'}
		,{name : 'descripcion'}
		,{name : 'habitual'}
		,{name : 'adjudicacion'}
		,{name : 'saneamiento'}
		,{name : 'posesion'}
		,{name : 'llaves'}
		,{name : 'tareaActivaAdjudicacion'}
		,{name : 'tareaActivaSaneamiento'}
		,{name : 'tareaActivaPosesion'}
		,{name : 'tareaActivaLlaves'}
		,{name : 'numFinca'}
	]);

	var marcadoBienesStore = page.getStore({
		flow : 'adjudicados/getBienesAsuntoApremio'
		,storeId : 'marcadoBienesStore'
		,reader : new Ext.data.JsonReader({
			root : 'bienes'
		},marcadoBienesRecord)
	}); 


  	var marcadoBienesCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.id" text="**Id"/>', dataIndex : 'id', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.codigo" text="**Codigo"/>', dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.numeroActivo" text="**Numero Activo"/>', dataIndex : 'numeroActivo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.numeroFinca" text="**N&uacute;mero finca"/>', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.habitual" text="**Vivienda habitual"/>', dataIndex : 'habitual', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.tareaActivaAdjudicacion" text="**tareaActivaAdjudicacion"/>', dataIndex : 'tareaActivaAdjudicacion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.tareaActivaSaneamiento" text="**tareaActivaSaneamiento"/>', dataIndex : 'tareaActivaSaneamiento'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.tareaActivaPosesion" text="**tareaActivaPosesion"/>', dataIndex : 'tareaActivaPosesion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.tareaActivaLlaves" text="**tareaActivaLlaves"/>', dataIndex : 'tareaActivaLlaves'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.adjudicacion" text="**Adjudicacion"/>', dataIndex : 'adjudicacion', renderer: OK_KO_Render}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.saneamiento" text="**Saneamiento"/>', dataIndex : 'saneamiento', renderer: OK_KO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.posesion" text="**Posesion"/>', dataIndex : 'posesion', renderer: OK_KO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.llaves" text="**LLaves"/>', dataIndex : 'llaves', renderer: OK_KO_Render }
	]);

	var marcadoBienesGrid = app.crearGrid(marcadoBienesStore, marcadoBienesCM, {
		title : '<s:message code="plugin.nuevoModeloBienes.adjudicados.marcadoBienesGrid.title" text="**Marcado de bienes" />'
		,height: 180
		,collapsible:false
		,autoWidth: true
		,style:'padding:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar: []
	});

	marcadoBienesGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		var rec = marcadoBienesGrid.getStore().getAt(rowIndex);
		idBien = rec.get('id');
		
	});

	entidad.cacheStore(marcadoBienesStore);

    
//FIN PANEL BIENES

	
	var bienAdjudicacionRecord = Ext.data.Record.create([
		{name : 'idBien'}
		,{name : 'codigo'}
		,{name : 'numeroActivo'}
		,{name : 'origen'}
		,{name : 'descripcion'}
		,{name : 'habitual'}
		,{name : 'idAdjudicacion'}
		,{name : 'tareaId'}		
		,{name : 'tareaCodigo'}
		,{name : 'tareaDescripcion'}
		,{name : 'notificacion'}
		,{name : 'ocupado'}
		,{name : 'posiblePosesion'}
		,{name : 'nombreArrendatario'}
		,{name : 'entidadAdjudicataria'}
		,{name : 'situacionTitulo'}
		,{name : 'numFinca'}
	]);
	
	var bienAdjudicacionesStore = page.getStore({
		flow : 'adjudicados/getBienesTipoProcedimientoNombre'
		,storeId : 'bienAdjudicacionesStore'
		,reader : new Ext.data.JsonReader({
			root : 'bienes'
		},bienAdjudicacionRecord)
	}); 
	
	var bienSaneamientoStore = page.getStore({
		flow : 'adjudicados/getBienesTipoProcedimientoNombre'
		,storeId : 'bienSaneamientoStore'
		,reader : new Ext.data.JsonReader({
			root : 'bienes'
		},bienAdjudicacionRecord)
	});
	
	var bienPosesionesStore = page.getStore({
		flow : 'adjudicados/getBienesTipoProcedimientoNombre'
		,storeId : 'bienPosesionesStore'
		,reader : new Ext.data.JsonReader({
			root : 'bienes'
		},bienAdjudicacionRecord)
	});
	
	var bienLLavesStore = page.getStore({
		flow : 'adjudicados/getBienesTipoProcedimientoNombre'
		,storeId : 'bienLLavesStore'
		,reader : new Ext.data.JsonReader({
			root : 'bienes'
		},bienAdjudicacionRecord)
	});
	
    //CMs
	
	var adjudicacionCM = new Ext.grid.ColumnModel([
		smAdjudicacion
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.idBien" text="**Id"/>', dataIndex : 'idBien', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.codigo" text="**Codigo"/>', dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroActivo" text="**Numero Activo"/>', dataIndex : 'numeroActivo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroFinca" text="**N&uacute;mero finca"/>', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaId" text="**Id. tarea"/>', dataIndex : 'tareaId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaCodigo" text="**Código tarea"/>', dataIndex : 'tareaCodigo', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaDescripcion" text="**Tarea"/>', dataIndex : 'tareaDescripcion'}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.habitual" text="**Vivienda habitual"/>', dataIndex : 'habitual', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.notificacion" text="**notificacion"/>', dataIndex : 'notificacion', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.gestoriaAdjudicataria" text="**gestoriaAdjudicataria"/>', dataIndex : 'gestoriaAdjudicataria'}
	]);
	
	var saneamientoCM = new Ext.grid.ColumnModel([
		smSaneamiento
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.idBien" text="**Id"/>', dataIndex : 'idBien', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.codigo" text="**Codigo"/>', dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroActivo" text="**Numero Activo"/>', dataIndex : 'numeroActivo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroFinca" text="**N&uacute;mero finca"/>', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaId" text="**Id. tarea"/>', dataIndex : 'tareaId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.toolbaradjudicados.adjudicacionGrid.tareaCodigo" text="**Código tarea"/>', dataIndex : 'tareaCodigo', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaDescripcion" text="**Tarea"/>', dataIndex : 'tareaDescripcion'}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.habitual" text="**Vivienda habitual"/>', dataIndex : 'habitual', renderer: SI_NO_Render}
		]);
	
	var posesionCM = new Ext.grid.ColumnModel([
		smPosesion
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.idBien" text="**Id"/>', dataIndex : 'idBien', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.codigo" text="**Codigo"/>', dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroActivo" text="**Numero Activo"/>', dataIndex : 'numeroActivo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroFinca" text="**N&uacute;mero finca"/>', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaId" text="**Id. tarea"/>', dataIndex : 'tareaId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaCodigo" text="**Código tarea"/>', dataIndex : 'tareaCodigo', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaDescripcion" text="**Tarea"/>', dataIndex : 'tareaDescripcion'}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.habitual" text="**Vivienda habitual"/>', dataIndex : 'habitual', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.ocupado" text="**ocupado"/>', dataIndex : 'ocupado', renderer: SI_NO_Render}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.posiblePosesion" text="**posiblePosesion"/>', dataIndex : 'posiblePosesion', renderer: SI_NO_Render}
	]);
	
	
	var llavesCM = new Ext.grid.ColumnModel([
		smLlaves
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.idBien" text="**Id"/>', dataIndex : 'idBien', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.codigo" text="**Codigo"/>', dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroActivo" text="**Numero Activo"/>', dataIndex : 'numeroActivo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.numeroFinca" text="**N&uacute;mero finca"/>', dataIndex : 'numFinca'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaId" text="**Id. tarea"/>', dataIndex : 'tareaId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.toolbaradjudicados.adjudicacionGrid.tareaCodigo" text="**Código tarea"/>', dataIndex : 'tareaCodigo', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.tareaDescripcion" text="**Tarea"/>', dataIndex : 'tareaDescripcion'}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.habitual" text="**Vivienda habitual"/>', dataIndex : 'habitual', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.llavesNecesarias" text="**llavesNecesarias"/>', dataIndex : 'llavesNecesarias', renderer: SI_NO_Render}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.nombreArrendatario" text="**nombreArrendatario"/>', dataIndex : 'nombreArrendatario'}
	]);
	
	function getArrayParam(store){
		var storeValues=[];
		var allRecords = store.getRange();
		for (i=0;i < allRecords.length;i++){
			var rec = allRecords[i];
			storeValues[i] = rec.data;
		}
		var myArrayParam = new MyArrayParam();
		myArrayParam.arrayItems = storeValues;
		return Ext.encode(myArrayParam);
	} 


	MyArrayParam = function() {
		var arrayItems;
	}
	
	var comprobarSiHayFilSeleccionada=function(grid){		
		return grid.selModel.getCount();
	}
	
	
	var getParams = function(grid, nombreTipoProcedimiento) {
		
		var objParams = {};
		
		var strIds = '';
		var datos;
		var codTarea = '';
		var descTarea = '';
		
		var records = grid.selModel.getSelections();
		for(var i=0;i< records.length; i++) {
			if(strIds!='') {
				strIds += ',';
			}
      		strIds += records[i].data.tareaId;	
      		if (codTarea=='') {
      			codTarea = records[i].data.tareaCodigo;
      			descTarea = records[i].data.tareaDescripcion;
      		}
      		if (codTarea != records[i].data.tareaCodigo) {
      			return null;
      		}
		}

		objParams = {
			idAsunto:idAsunto,
			idsTareas:strIds,
			nombreTipoProcedimiento:nombreTipoProcedimiento,
			tarea:descTarea
		}
		
		return objParams;
	};
	
       
	var btnAbreAdjudicacion = new Ext.Button({
	    text: '<s:message code="plugin.nuevoModeloBienes.adjudicados.botonEditar" text="**Abrir tarea" />'
	    ,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,style:'margin-left:2px;padding-top:0px'
		,disabled: true
	    ,handler:function(){
	    	var parametros =  getParams(adjudicacionGrid,'ADJUDICACION');
	    	if (parametros == null) {
    			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.adjudicados.hitosNoIguales" text="**No están todos los bienes en el mismo hito"/>');	      	
	    	} else {
				if (comprobarSiHayFilSeleccionada(adjudicacionGrid)>=1){
					var titulo = '(Avance automático) - '+parametros.tarea;
					
					w = app.openWindow({
							flow : 'adjudicados/openGenericFormCustom'
							,params: parametros
							,closable: true 
							,autoWidth:true
							,title : titulo
					});
					w.on(app.event.DONE, function(){
			          refresh();
			          w.close();
			       });
			       w.on(app.event.CANCEL, function(){ w.close(); });			
				
				} else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="subastas.agregarExcluirBien.excluir.faltanDatos" text="**Debe seleccionar algún bien"/>');
	      		}
	      	}
		}
	});
		
	var btnAbrePosesion = new Ext.Button({
	    text: '<s:message code="plugin.nuevoModeloBienes.adjudicados.botonEditar" text="**Abrir tarea" />'
	    ,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,style:'margin-left:2px;padding-top:0px'
		,disabled:true
	    ,handler:function(){
	    	var parametros =  getParams(posesionGrid,'POSESION');
	    	if (parametros == null) {
    			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.adjudicados.hitosNoIguales" text="**No están todos los bienes en el mismo hito"/>');	      	
	    	} else {
				if (comprobarSiHayFilSeleccionada(posesionGrid)>=1){
					var titulo = '(Avance automático) - '+parametros.tarea;
					w = app.openWindow({
							flow : 'adjudicados/openGenericFormCustom'
							,params: parametros
							,closable: true 
							,autoWidth:true
							,title : titulo
					});
					w.on(app.event.DONE, function(){
			          refresh();
			          w.close();
			       });
			       w.on(app.event.CANCEL, function(){ w.close(); });
				} else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="subastas.agregarExcluirBien.excluir.faltanDatos" text="**Debe seleccionar algún bien"/>');
	      		}
	      	}
		}
	});
	
	var btnAbreSaneamiento = new Ext.Button({
	    text: '<s:message code="plugin.nuevoModeloBienes.adjudicados.botonEditar" text="**Abrir tarea" />'
	    ,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,style:'margin-left:2px;padding-top:0px'
		,disabled:true
	    ,handler:function(){
			var parametros =  getParams(saneamientoGrid,'SANEAMIENTO');
	    	if (parametros == null) {
    			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.adjudicados.hitosNoIguales" text="**No están todos los bienes en el mismo hito"/>');	      	
	    	} else {
					if (comprobarSiHayFilSeleccionada(saneamientoGrid)>=1){
						var titulo = '(Avance automático) - '+parametros.tarea;
						w = app.openWindow({
								flow : 'adjudicados/openGenericFormCustom'
								,params: parametros
								,closable: true 
								,autoWidth:true
								,title : titulo
						});
						w.on(app.event.DONE, function(){
				          refresh();
				          w.close();
				       });
				       w.on(app.event.CANCEL, function(){ w.close(); });
				} else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="subastas.agregarExcluirBien.excluir.faltanDatos" text="**Debe seleccionar algún bien"/>');
	      		}
			}
		}
	});
	
	var btnAbreLlaves = new Ext.Button({
	    text: '<s:message code="plugin.nuevoModeloBienes.adjudicados.botonEditar" text="**Abrir tarea" />'
	    ,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,style:'margin-left:2px;padding-top:0px'
		,disabled:true
	    ,handler:function(){
			var parametros =  getParams(llavesGrid,'LLAVES');
	    	if (parametros == null) {
    			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.nuevoModeloBienes.adjudicados.hitosNoIguales" text="**No están todos los bienes en el mismo hito"/>');	      	
	    	} else {
				if (comprobarSiHayFilSeleccionada(llavesGrid)>=1){
					var titulo = '(Avance automático) - '+parametros.tarea;
					
					w = app.openWindow({
							flow : 'adjudicados/openGenericFormCustom'
							,params: parametros
							,closable: true 
							,autoWidth:true
							,title : titulo
					});
					w.on(app.event.DONE, function(){
			          refresh();
			          w.close();
			       });
			       w.on(app.event.CANCEL, function(){ w.close(); });
				} else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="subastas.agregarExcluirBien.excluir.faltanDatos" text="**Debe seleccionar algún bien"/>');
	      		}
	      	}
		}
	});
	
		
			
	var adjudicacionGrid = new Ext.grid.EditorGridPanel({
        store: bienAdjudicacionesStore
        ,cm: adjudicacionCM
        ,title : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.title.adjudicacion" text="**Bienes con adjudicación" />'
        ,stripeRows: true
        ,height: 400
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: smAdjudicacion
		,bbar:[btnAbreAdjudicacion]
    });
    
    var saneamientoGrid = new Ext.grid.EditorGridPanel({
        store: bienSaneamientoStore
        ,cm: saneamientoCM
        ,title : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.title.saneamiento" text="**Bienes con saneamiento" />'
        ,stripeRows: true
        ,height: 400
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: smSaneamiento
		,bbar:[btnAbreSaneamiento]
    });
    
   		
	var posesionGrid = new Ext.grid.EditorGridPanel({
        store: bienPosesionesStore
        ,cm: posesionCM
		,title : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.title.posesion" text="**Bienes con posesión" />'
		,stripeRows: true
        ,height: 400
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: smPosesion
		,bbar:[btnAbrePosesion]
	});
	
	var llavesGrid = new Ext.grid.EditorGridPanel({
		title : '<s:message code="plugin.nuevoModeloBienes.adjudicados.adjudicacionGrid.title.llaves" text="**Bienes con gestión llaves" />'
		,store: bienLLavesStore
        ,cm: llavesCM
		,stripeRows: true
        ,height: 400
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: smLlaves
		,bbar:[btnAbreLlaves]
	});
 
	var procedimientosPanel = new Ext.TabPanel({
		items:[
			adjudicacionGrid, saneamientoGrid, posesionGrid, llavesGrid
		]
		,bbar: []
		,height: 250
		,autoWidth: true
		,style:'padding-right:30px; padding-left:10px;'
	  });                                                                                                                                                                  
    procedimientosPanel.setActiveTab(adjudicacionGrid);
	
	panel.getValue = function() {
		data = entidad.get("data");
		idAsunto = panel.getAsuntoId();
		entidad.cacheOrLoad(data, marcadoBienesStore, {idAsunto : panel.getAsuntoId()} );
	}
	panel.setValue = function(){
		data = entidad.get("data");
		idAsunto = panel.getAsuntoId();
		entidad.cacheOrLoad(data, marcadoBienesStore, {idAsunto : panel.getAsuntoId()} ); 
		refresh();
	}
	
	function refresh(){
		procedimientosPanel.el.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>','x-mask-loading');
		marcadoBienesStore.webflow({idAsunto: panel.getAsuntoId() });
		bienAdjudicacionesStore.webflow({idAsunto: panel.getAsuntoId() , nombreTipoProcedimiento : 'ADJUDICACION' });
		bienSaneamientoStore.webflow({idAsunto: panel.getAsuntoId() , nombreTipoProcedimiento : 'SANEAMIENTO' }); 
		bienPosesionesStore.webflow({idAsunto: panel.getAsuntoId() , nombreTipoProcedimiento : 'POSESION' }); 
		bienLLavesStore.webflow({idAsunto: panel.getAsuntoId() , nombreTipoProcedimiento : 'GESTION-LLAVES' }); 
	};
	
	bienAdjudicacionesStore.on('load',function(){
		procedimientosPanel.el.unmask();
	});
	
	panel.add(marcadoBienesGrid);
	panel.add(procedimientosPanel);
	
	panel.setVisibleTab = function(data){
		return data.toolbar.puedeVerTabAdjudicados;
	}
	
	return panel;
})




