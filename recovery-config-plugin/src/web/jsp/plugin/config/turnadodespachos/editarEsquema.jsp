<%@page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var botonesPantalla = new Array();

	var estadoPendiente = <c:out value="${empty data.id or data.estado.codigo eq 'DEF'}"/>; // estado pendiente
	var estadoVigente = <c:out value="${not empty data.estado and data.estado.codigo eq 'VIG'}"/>; // estado vigente
	var modoConsulta = <c:out value="${modConsulta}"/>; // Usuario diferente o histórico
	if (estadoVigente) {
		modoConsulta = true;
	}
	if(modoConsulta) {
		estadoVigente = estadoPendiente = false;
	};
	
	var txNombreEsquemaTurnado = app.creaText('nombreEsquemaTurnado'
		,'<s:message code="plugin.config.esquematurnado.editar.campo.nombre" text="**Nombre esquema turnado" />'
		,'<c:out value="${data.descripcion}"/>'
		, {
		allowBlank: false
		,readOnly: modoConsulta 
		}
	);
	
	var txLitLimitStockAnual = app.creaNumber('litLimitStockAnual' 
		,'<s:message code="plugin.config.esquematurnado.editar.campo.limiteStockAnualLitigios" text="**Limitacion por stock Anual" />'
		,'<c:out value="${data.limiteStockAnualLitigios}"/>'
		,{xtype: 'numberfield'
			,allowBlank: false
			,minValue: 0
			,maxValue: 100
			,decimalPrecision: 2
			,readOnly: modoConsulta
		});
	txLitLimitStockAnual.maxValue = 100;

	var txConLimitStockAnual = app.creaNumber('conLimitStockAnual'
		,'<s:message code="plugin.config.esquematurnado.editar.campo.limiteStockAnualConcursos" text="**Limitacion por stock Anual" />'
		,'<c:out value="${data.limiteStockAnualConcursos}"/>' 
		,{xtype: 'numberfield'
			,allowBlank: false
			,minValue: 0
			,maxValue: 100
			,decimalPrecision: 2
			,readOnly: modoConsulta
		});
	txConLimitStockAnual.maxValue = 100;

   // DEFINICION TIPOS GRIDs 
	var TipoImporte = Ext.data.Record.create([
	    {name: 'id', type: 'int', mapping:0},
	    {name: 'codigo', tag: 'input', type: 'text', maxlength: '10', autocomplete: 'off', mapping:1},
	    {name: 'desde', type: 'float', mapping:2},
	    {name: 'hasta', type: 'float', mapping:3}
	]);
	var TipoCalidad = Ext.data.Record.create([
	    {name: 'id', type: 'int', mapping:0},
	    {name: 'codigo', mapping:1, maxLength:10, size:"10"},
	    {name: 'porcentaje', type: 'float', mapping:2}
	]);

   // STOREs GRIDs 
    var storeImpCon = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoImporte)
    });
    var storeCalCon = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoCalidad)
    });
    var storeImpLit = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoImporte)
    });
    var storeCalLit = new Ext.data.ArrayStore({
	    reader: new Ext.data.ArrayReader(
	        {idIndex: 0}
	        ,TipoCalidad)
    });

   // DATOS GRIDs
	var newTipoImporteRow = function(id,codigo,desde,hasta) {
		return new TipoImporte({id:id,codigo:codigo,desde:desde,hasta:hasta});
	}
	var newTipoCalidadRow = function(id,codigo,porcentaje) {
		return new TipoCalidad({id:id,codigo:codigo,porcentaje:porcentaje});
	}

	<c:if test="${not empty data.configuracion}">
		<c:forEach var="config" items="${data.configuracion}">
			<c:choose>
				<c:when test="${config.tipo eq 'CI'}">
					storeImpCon.add(newTipoImporteRow(<c:out value="${config.id}"/>,'<c:out value="${config.codigo}"/>',<c:out value="${config.importeDesde}"/>,<c:out value="${config.importeHasta}"/>));
				</c:when> 
				<c:when test="${config.tipo eq 'CC'}">
					storeCalCon.add(newTipoCalidadRow(<c:out value="${config.id}"/>,'<c:out value="${config.codigo}"/>',<c:out value="${config.porcentaje}"/>));
				</c:when> 
				<c:when test="${config.tipo eq 'LI'}">
					storeImpLit.add(newTipoImporteRow(<c:out value="${config.id}"/>,'<c:out value="${config.codigo}"/>',<c:out value="${config.importeDesde}"/>,<c:out value="${config.importeHasta}"/>));
				</c:when> 
				<c:when test="${config.tipo eq 'LC'}">
					storeCalLit.add(newTipoCalidadRow(<c:out value="${config.id}"/>,'<c:out value="${config.codigo}"/>',<c:out value="${config.porcentaje}"/>));
				</c:when> 
			</c:choose>
		</c:forEach>
	</c:if>
	

	// GRID 
	var txtGridEditor = function() {
		return {
			xtype: 'textfield'
			,maxLength: 10
			,allowBlank: false
		};
	};
	var txtCantidadGridEditor = function() {
		return {
			xtype: 'numberfield'
			,allowBlank: false
			,minValue: 0
			,decimalPrecision: 2
		};
	};
	var txtPorcentajeGridEditor = function() {
		return {
			xtype: 'numberfield'
			,allowBlank: false
			,minValue: 0
			,maxValue: 100
			,decimalPrecision: 2
		};
	};

	var addBotoneraGrid = function(grid, newRowFunction) {
		if (modoConsulta || estadoVigente) return;
		grid.getBottomToolbar().addButton({
			grid: grid
			,text : '<s:message code="app.nuevo" text="**Nuevo" />'
			,iconCls : 'icon_mas'
			,handler: function() {
				var row = newRowFunction();
				
				this.grid.rowEditor.stopEditing();
				 
				//add our new record as the first row, select it
				this.grid.store.insert(0, row);
				this.grid.getView().refresh();
				this.grid.getSelectionModel().selectRow(0);

				//start editing our new User
				this.grid.rowEditor.startEditing(0);

			}
		});
		grid.getBottomToolbar().addButton({
			grid: grid
			,text: '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler: function() {
				var storeActual = this.grid.getStore();
				if (!this.grid.getSelectionModel().hasSelection()) {
					return;
				}
				var row = this.grid.getSelectionModel().selections.items[0];
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.config.esquematurnado.editar.boton.borrar.confirm" text="**Va a eliminar esta línea. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
							storeActual.remove(row);
						}
					}, this);
			}
		});
		botonesPantalla.push(grid.getBottomToolbar());
	}

	function renderNumer(value){
		return (value!=null) ? value.toFixed(2) : null;
	}	
	var importeCm = function() {
		var varTxtEditor = null;
		var varTxNumberEditor = null;
		if (estadoPendiente) {
			varTxtEditor = txtGridEditor();
			varTxNumberEditor = txtCantidadGridEditor();
		} else if (estadoVigente) {
			varTxNumberEditor = txtCantidadGridEditor();
		}		
		return new Ext.grid.ColumnModel([
			{header: 'Id', dataIndex: 'id', hidden: true}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.codigo" text="**Codigo"/>', dataIndex: 'codigo', width: 75, editor: varTxtEditor}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.desde" text="**Desde"/>', dataIndex: 'desde', width: 100, renderer: renderNumer, align: 'right', editor: varTxNumberEditor}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.hasta_des" text="**Hasta"/>', dataIndex: 'hasta', width: 100, renderer: renderNumer, align: 'right', editor: varTxNumberEditor}
		]);
	};
 	
	var calidadCm = function() {
		var varTxtEditor = null;
		var varTxNumberEditor = null;
		if (estadoPendiente) {
			varTxtEditor = txtGridEditor();
			varTxNumberEditor = txtPorcentajeGridEditor();
		} else if (estadoVigente) {
			varTxNumberEditor = txtPorcentajeGridEditor();
		}		
		return new Ext.grid.ColumnModel([	    
			{header: 'Id', dataIndex: 'id', hidden: true}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.codigo" text="**Codigo"/>', dataIndex: 'codigo', width: 70, editor: varTxtEditor}
			,{header: '<s:message code="plugin.config.esquematurnado.editar.importe.grid.porcentaje" text="**Porcentaje"/>', dataIndex: 'porcentaje', renderer: renderNumer, align: 'right', width: 100, editor: varTxNumberEditor}
		]);
	};
	
    // RowEditor para editar filas
    var newRowEditor = function(grid) {
	    var rowEditor = new Ext.ux.grid.RowEditor({
	        saveText: 'Guardar'
	        ,cancelText: 'Cancelar'
	        ,modified: false
		    ,listeners: {
		    	beforeedit : function (p, rowIndex) {
					Ext.each(botonesPantalla, function(value) {
						value.setDisabled(true);
					});
		    	}
				,validateedit: function (roweditor, changes, record, rowIndex) {
					var store = roweditor.grid.getStore(),
					value = changes.codigo
					valid = true;
					validPercent = true;
					totalPercent = (changes.porcentaje) ? changes.porcentaje : 0;

					store.each(function (record, index) {
						//validating new title field value with existing title field value
						if (index !== rowIndex && record.data.codigo === value) {
							valid = false;
							return false;
						}

						if (record.data.porcentaje) {
							totalPercent+=record.data.porcentaje;
						}
					});

					if (!valid) {
						Ext.Msg.alert('<s:message code="fwk.constant.alert" text="**Alerta"/>','<s:message code="plugin.config.esquematurnado.editar.grid.error.codigoExistente" text="**Este codigo ya existe, no se creará la línea."/>');
						return false;
					}
					if (totalPercent>100) {
						Ext.Msg.alert('<s:message code="fwk.constant.alert" text="**Alerta"/>','<s:message code="plugin.config.esquematurnado.editar.grid.error.percentSuperado" text="**Las diferentes opciones no pueden superar el 100%"/>');
						return false;
					}
					return valid;
				}
				,hide: function(p) {
					var store = this.grid.getStore();
					if (!p.record.dirty && this.record.data.id==null) { store.remove(store.getAt(p.rowIndex)); }
					//this.modified = false;

					Ext.each(botonesPantalla, function(value) {
						value.setDisabled(false);
					});

				}
				,afteredit: function(editor, changes, r, rowIndex) {
					//this.modified = true;
				}
			}
		});
		return rowEditor;
	}

	
	var importeConcursalGridRE = newRowEditor();
	var importeConcursalGrid = new Ext.grid.EditorGridPanel({
		store: storeImpCon
		,cm: importeCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.importe.grid.titulo" text="**Tipo importe Con"/>'
		,autoExpandColumn: 'common' // column with this id will be expanded
		,stripeRows: true
		//,autoHeight:true
		,enableHdMenu:false 
		,plugins: (modoConsulta) ? null : [importeConcursalGridRE]
		,rowEditor: (modoConsulta) ? null : importeConcursalGridRE
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar: []
	});
	addBotoneraGrid(importeConcursalGrid, newTipoImporteRow);
	
	var calidadConcursalGridRE = newRowEditor();
	var calidadConcursalGrid = new Ext.grid.EditorGridPanel({
		store: storeCalCon
		,cm: calidadCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.calidad.grid.titulo" text="**Tipo calidad Con"/>'
		,stripeRows: true
		//,autoHeight:true
		,enableHdMenu:false 
		,plugins: (modoConsulta) ? null : [calidadConcursalGridRE]
		,rowEditor: (modoConsulta) ? null : calidadConcursalGridRE
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar: []
	});
	addBotoneraGrid(calidadConcursalGrid, newTipoCalidadRow);

	var innerConcursosPanelGrids = new Ext.Panel({
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,layout:'table'
		,border:false
		,layoutConfig:{columns:2}
		,viewConfig : {forceFit : true}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{layout:'form'
					,items: [importeConcursalGrid]}
				,{layout:'form'
					,items: [calidadConcursalGrid]}
				]
	});	

	var turnadoConcursosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelConcursos.titulo" text="**Turnado Concursos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [
		 	{items:[txConLimitStockAnual,innerConcursosPanelGrids]}
		]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(600-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});


	var importeLitigiosGridRE = newRowEditor();
	var importeLitigiosGrid = new Ext.grid.EditorGridPanel({
		store: storeImpLit
		,cm: importeCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.importe.grid.titulo" text="**Tipo importe Lit"/>'
		,stripeRows: true
		//,autoHeight:true
		,enableHdMenu:false 
		,plugins: (modoConsulta) ? null : [importeLitigiosGridRE]
		,rowEditor: (modoConsulta) ? null : importeLitigiosGridRE
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar: []
	});
	addBotoneraGrid(importeLitigiosGrid, newTipoImporteRow);

	var calidadLitigiosGridRE = newRowEditor();
	var calidadLitigiosGrid = new Ext.grid.EditorGridPanel({
		store: storeCalLit
		,cm: calidadCm()
		,title:'<s:message code="plugin.config.esquematurnado.editar.calidad.grid.titulo" text="**Tipo calidad Lit"/>'
		,stripeRows: true
		//,autoHeight:true
		,enableHdMenu:false 
		,plugins: (modoConsulta) ? null : [calidadLitigiosGridRE]
		,rowEditor: (modoConsulta) ? null : calidadLitigiosGridRE
		,height: 150
		,resizable:false
		,collapsible : false
		,titleCollapse : false
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 5px 10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: new Ext.grid.RowSelectionModel()
		,bbar:[]
	});
	addBotoneraGrid(calidadLitigiosGrid, newTipoCalidadRow);

	var innerLitigosPanelGrids = new Ext.Panel({
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,layout:'table'
		,border:false
		,layoutConfig:{columns:2}
		,viewConfig : {forceFit : true}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{layout:'form'
					,items: [importeLitigiosGrid]}
				,{layout:'form'
					,items: [calidadLitigiosGrid]}
				]
	});	

	var turnadoLitigiosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelLitigios.titulo" text="**Turnado Litigos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [
		 	{items:[txLitLimitStockAnual,innerLitigosPanelGrids]}
		]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(600-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});

	var setStoreValues = function(dto, store, tipo, count) {
		// RecorreStores
		for(i=0;i < store.getCount();i++) {
			var rec=store.getAt(i);
			dto["lineasConfiguracion["+count+"].id"] = rec.data.id;
			dto["lineasConfiguracion["+count+"].tipo"] = tipo;
			dto["lineasConfiguracion["+count+"].codigo"] = rec.data.codigo;
			if (rec.data.desde) {
				dto["lineasConfiguracion["+count+"].importeDesde"] = rec.data.desde;
			}
			if (rec.data.hasta) {
				dto["lineasConfiguracion["+count+"].importeHasta"] = rec.data.hasta;
			}
			if (rec.data.porcentaje) {
				dto["lineasConfiguracion["+count+"].porcentaje"] = rec.data.porcentaje;
			}
			count++; 
		}
		return count;
	};
	
	var getParams = function() {
		var dto = {};
		<c:if test="${not empty data.id}">
		dto["id"] = <c:out value="${data.id}"/>
		</c:if>
		dto["descripcion"] = txNombreEsquemaTurnado.getValue();
		dto["limiteStockLitigios"] = txLitLimitStockAnual.getValue();
		dto["limiteStockConcursos"] = txConLimitStockAnual.getValue();
		var count=0;
		count = setStoreValues(dto, storeImpCon, 'CI', count);
		count = setStoreValues(dto, storeCalCon, 'CC', count);
		count = setStoreValues(dto, storeImpLit, 'LI', count);
		count = setStoreValues(dto, storeCalLit, 'LC', count);
		return dto;
	};
	
	var validarCampos = function() {
		// Comprobar que todos los campos se han completado.
		if (txNombreEsquemaTurnado.getValue()=='' ||
			txLitLimitStockAnual.getValue()=='' ||
			txConLimitStockAnual.getValue()=='' ||
			storeImpCon.data.getCount()==0 ||
			storeCalCon.data.getCount()==0 ||
			storeImpLit.data.getCount()==0 ||
			storeCalLit.data.getCount()==0) {
			return '<s:message code="plugin.config.esquematurnado.editar.validacion1" text="**Todos los campos son obligatorios y debe completar todas las tablas del esquema."/>';
		}
		
		if (txLitLimitStockAnual.getValue()<0 || txLitLimitStockAnual.getValue()>100 ||
			txConLimitStockAnual.getValue()<0 || txConLimitStockAnual.getValue()>100) {
			return '<s:message code="plugin.config.esquematurnado.editar.validacion4" text="**El límite de stock debe ser un valor comprendido entre 0 y 100%"/>';
		}
		
		// Comprobar que los tipos de calidad concurso suman 100.0
		var totalPercent = 0.0;
		storeCalCon.each(function (record, index) {
			totalPercent+=record.data.porcentaje;
		});
		if (totalPercent!=100) 
			return '<s:message code="plugin.config.esquematurnado.editar.validacion2" text="**Las opciones de tipo de calidad de concursos no completan el 100% de los casos."/>';

		totalPercent = 0.0;
		storeCalLit.each(function (record, index) {
			totalPercent+=record.data.porcentaje;
		});
		if (totalPercent!=100) 
			return '<s:message code="plugin.config.esquematurnado.editar.validacion3" text="**Las opciones de tipo de calidad de litigios no completan el 100% de los casos."/>';
		
		return null;
	};
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
	    	var res = validarCampos();
	    	if(res == null){
				var params = getParams();
	    		Ext.Ajax.request({
					url : page.resolveUrl('turnadodespachos/guardarEsquema') 
					,params : params 
					,method: 'POST'
					,success: function ( result, request ) {
						page.fireEvent(app.event.DONE);
					}
				});
			}
			else {
				Ext.MessageBox.show({
		           title: 'Guardado'
		           ,msg: res
		           ,width:300
		           ,buttons: Ext.MessageBox.OK
		       });
		    }
		}
	});

	var mainButtonBar = (estadoVigente || estadoPendiente) ? [btnGuardar,btnCancelar] : [btnCancelar];
	var mainPanel = new Ext.Panel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,bbar: mainButtonBar
		,items:[{
			layout:'form'
			,items: [txNombreEsquemaTurnado,turnadoConcursosFieldSet,turnadoLitigiosFieldSet]}
		]
	});	
	botonesPantalla.push(mainPanel.getBottomToolbar());
	
	page.add(mainPanel);
	
</fwk:page>


